//
//  LHLNotificationViewController.m
//  cjzyb_ios
//
//  Created by apple on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLNotificationViewController.h"
#import "DRLeftTabBarViewController.h"

#define leftBarVC ((DRLeftTabBarViewController *)self.parentVC)

@interface LHLNotificationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UILabel *characterCountLabel; //显示输入字数的label

@property (strong,nonatomic) LHLNotificationCell *tempCell;
@property (strong,nonatomic) NSMutableArray *notificationArray; //系统通知数组
@property (assign,nonatomic) NSInteger pageOfNotification; //系统通知页码(分页加载)
@property (strong,nonatomic) NSIndexPath *deletingIndexPath;  //正在被删除的cell的indexPath(在请求接口的过程中有效)
@property (strong,nonatomic) NSIndexPath *replyingIndexPath; //正在编辑回复的cell的indexPath
@property (assign,nonatomic) BOOL isRefreshing; //YES刷新,NO分页加载
@property (strong,nonatomic) UIActivityIndicatorView *indicView;

@property (strong,nonatomic) NSIndexPath *editingNotiCellIndexPath;
@property (assign,nonatomic) BOOL isLoading ;//正在加载某个接口
@property (strong,nonatomic) id parentVC; //找到DRLeftTabBarVC
@end

@implementation LHLNotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"LHLNotificationCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LHLNotificationCell"];
    
    [self initData];
    
    [self requestSysNoticeWithStudentID:[DataService sharedService].user.studentId andClassID:[DataService sharedService].theClass.classId andPage:@"1"];
        
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

//获取数据
- (void)initData{
    self.notificationArray = [NSMutableArray array];
    self.pageOfNotification = 1;
    self.isRefreshing = YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --

#pragma mark -- UITableViewDatasource


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notificationArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationObject *noti = self.notificationArray[indexPath.row];
    CGSize size = [Utility getTextSizeWithString:noti.notiContent withFont:[UIFont systemFontOfSize:20.0] withWidth:510];
    if (size.height + 50 + 20 + 10 > 192) { //上沿坐标,textView高度加值,下方高度
        return size.height + 50 + 20 + 10;
    }
    return 192;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LHLNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHLNotificationCell"];
    cell.delegate = self;
    [cell initCell];
    NotificationObject *obj = self.notificationArray[indexPath.row];
    [cell setNotificationObject:obj];
    cell.indexPath = indexPath;
    if (indexPath.row % 2 == 1) {
        cell.contentBgView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
    }else{
        cell.contentBgView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

#pragma mark --

#pragma mark -- UITableViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!leftBarVC.isHiddleLeftTabBar) {
        [leftBarVC navigationLeftItemClicked];
    }
}

#pragma mark -- action

//TODO: 此格式会不会改?  处理服务器返回的时间字符串 ("2014-03-25T15:23:13+08:00")
-(NSString *)handleApiResponseTimeString:(NSString *)str{
    if (![str isKindOfClass:[NSString class]]) {
        return @"";
    }
    NSArray *array = [str componentsSeparatedByString:@"T"];
    NSString *date = [array firstObject];
    NSString *time = [array lastObject];
    if ([time rangeOfString:@"+08:00"].length > 0) {
        time = [time stringByReplacingCharactersInRange:NSMakeRange(time.length - @"+08:00".length, @"+08:00".length) withString:@""];
    }
    return [NSString stringWithFormat:@"%@ %@",date,time];
}

-(void)initFooterView {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 50)];
    header.backgroundColor = [UIColor clearColor];
    [header addSubview:self.indicView];
    UILabel *loadLab = [[UILabel alloc]initWithFrame:CGRectMake(self.indicView.frame.origin.x+30, 10, 200, 30)];
    loadLab.text = @"正在努力加载中...";
    [header addSubview:loadLab];
    self.tableView.tableFooterView = header;
}

-(void)initHeaderView {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 50)];
    header.backgroundColor = [UIColor clearColor];
    [header addSubview:self.indicView];
    UILabel *loadLab = [[UILabel alloc]initWithFrame:CGRectMake(self.indicView.frame.origin.x+30, 10, 200, 30)];
    loadLab.text = @"正在刷新中...";
    [header addSubview:loadLab];
    self.tableView.tableHeaderView = header;
}

#pragma mark -- 请求接口
//请求接口,获取系统通知
-(void)requestSysNoticeWithStudentID:(NSString *)studentID andClassID:(NSString *)classID andPage:(NSString *)page{
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            //请求系统通知
//            NSString *str = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/get_sys_message?student_id=%@&school_class_id=%@&page=%@",studentID,classID,page];
            NSString *str = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/get_sys_message?student_id=%@&school_class_id=%@&page=%@",@"1",@"1",page];
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
            self.isLoading = YES;
            [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
                self.isLoading = NO;
                self.appDel.isReceiveNotificationSystem = NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loadByNotification" object:nil];
                if (self.isRefreshing) {
                    self.notificationArray = [NSMutableArray array];
                }else{
                    self.pageOfNotification ++;
                }
                NSArray *notices = [dicData objectForKey:@"sysmessage"];
                for (NSInteger i = 0; i < notices.count; i ++) {
                    NSDictionary *noticeDic = notices[i];
                    NotificationObject *obj = [[NotificationObject alloc] init];
                    obj.notiID = [noticeDic objectForKey:@"id"];
                    obj.notiSchoolClassID = [noticeDic objectForKey:@"school_class_id"];
                    obj.notiStudentID = [noticeDic objectForKey:@"student_id"];
                    obj.notiContent = [noticeDic objectForKey:@"content"];
                    obj.notiTime = [self handleApiResponseTimeString:[noticeDic objectForKey:@"created_at"]];
                    [self.notificationArray addObject:obj];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                    [self.tableView reloadData];
                });
            } withFailure:^(NSError *error) {
                self.isLoading = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                });
                NSString *errorMsg = [error.userInfo objectForKey:@"msg"];
                [Utility errorAlert:errorMsg];
            }];
        }
    }];
}

//请求接口,删除系统通知
-(void)deleteSysNoticeWithUserID:(NSString *)studentID andClassID:(NSString *)classID andNoticeID:(NSString *)noticeID{
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            //请求系统通知
            NSString *str = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/delete_sys_message?user_id=%@&school_class_id=%@&sys_message_id=%@",studentID,classID,noticeID];
            NSURL *url = [NSURL URLWithString:str];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
            self.isLoading = YES;
            [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
                self.isLoading = NO;
                self.editingNotiCellIndexPath = nil;
                [self.notificationArray removeObjectAtIndex:self.deletingIndexPath.row];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                    [self.tableView deleteRowsAtIndexPaths:@[self.deletingIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [UIView animateWithDuration:0.3 animations:^{
//                        self.tableView.frame = self.tableView.frame.origin.y == 0 ? (CGRect){0,1,self.tableView.frame.size} : (CGRect){0,0,self.tableView.frame.size};
                        self.tableView.alpha = self.tableView.alpha == 1.0 ? 0.99 : 1.0;
                    } completion:^(BOOL finished) {
                        [self.tableView reloadData];
                    }];
                    self.deletingIndexPath = nil;
                    [Utility errorAlert:@"删除成功!"];
                });
            } withFailure:^(NSError *error) {
                self.isLoading = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                });
                NSString *errorMsg = [error.userInfo objectForKey:@"msg"];
                [Utility errorAlert:errorMsg];
                self.deletingIndexPath = nil;
            }];
        }
    }];
}

#pragma mark -- property
-(void)setIsLoading:(BOOL)isLoading{
    //停止请求接口时,隐藏header和footer
    if (isLoading == NO) {
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = nil;
    }
    _isLoading = isLoading;
}

-(UIActivityIndicatorView *)indicView {
    if (!_indicView) {
        _indicView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(269, 10, 30, 30)];
        _indicView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_indicView startAnimating];
    }
    return _indicView;
}

-(id)parentVC{
    if (!_parentVC) {
        _parentVC = [self parentViewController];
        for (int i = 0; i < 5; i ++) {
            if ([_parentVC isKindOfClass:[DRLeftTabBarViewController class]]) {
                return _parentVC;
            }
            _parentVC = [_parentVC parentViewController];
        }
        _parentVC = nil;
    }
    return _parentVC;
}

-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (self.isLoading) {
        return;
    }
    NSValue *contentOffsetValue = [change objectForKey:@"new"];
    CGPoint contentOffset;
    [contentOffsetValue getValue:&contentOffset];
    if (self.tableView.contentOffset.y >80 && self.tableView.contentOffset.y > self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.frame.size.height + 80) {
        //开始分页加载
        self.isRefreshing = NO;
        [self requestSysNoticeWithStudentID:[DataService sharedService].user.studentId andClassID:[DataService sharedService].theClass.classId andPage:[NSString stringWithFormat:@"%d",self.pageOfNotification + 1]];
        [self initFooterView];
    }
}

#pragma mark -- LHLNotificationCellDelegate
-(void)cell:(LHLNotificationCell *)cell deleteButtonClicked:(id)sender{
    //请求接口
    NotificationObject *notice = self.notificationArray[cell.indexPath.row];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            [self deleteSysNoticeWithUserID:[DataService sharedService].user.userId andClassID:[DataService sharedService].theClass.classId andNoticeID:notice.notiID];
        }
    }];
    self.deletingIndexPath = cell.indexPath;
}

-(void)refreshHeightForCell:(LHLNotificationCell *)cell{
    
}

-(void)cell:(LHLNotificationCell *)cell setIsEditing:(BOOL)editing{
    NotificationObject *obj = self.notificationArray[cell.indexPath.row];
    obj.isEditing = editing;
    
    if (editing) {
        if (self.editingNotiCellIndexPath) {
            LHLNotificationCell *editingCell = (LHLNotificationCell *)[self.tableView cellForRowAtIndexPath:self.editingNotiCellIndexPath];
            if (editingCell) {
                [editingCell coverButtonClicked:nil];
            }else{
                NotificationObject *editingObj = [self.notificationArray objectAtIndex:self.editingNotiCellIndexPath.row];
                editingObj.isEditing = NO;
            }
        }
        self.editingNotiCellIndexPath = cell.indexPath;
    }else{
        self.editingNotiCellIndexPath = nil;
    }
}

@end
