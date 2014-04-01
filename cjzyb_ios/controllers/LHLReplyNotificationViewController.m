//
//  LHLReplyNotificationViewController.m
//  cjzyb_ios
//
//  Created by apple on 14-3-31.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLReplyNotificationViewController.h"
#import "DRLeftTabBarViewController.h"

#define leftBarVC ((DRLeftTabBarViewController *)self.parentVC)

@interface LHLReplyNotificationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UIView *replyInputBgView;//回复消息时,输入框的背景
@property (strong,nonatomic) UITextView *replyInputTextView;  //回复消息时,输入框
@property (strong,nonatomic) UILabel *characterCountLabel; //显示输入字数的label

@property (strong,nonatomic) NSMutableArray *replyNotificationArray;  //回复通知数组
@property (assign,nonatomic) NSInteger pageOfReplyNotification; //回复通知页码(分页加载)
@property (strong,nonatomic) NSIndexPath *deletingIndexPath;  //正在被删除的cell的indexPath(在请求接口的过程中有效)
@property (strong,nonatomic) NSIndexPath *replyingIndexPath; //正在编辑回复的cell的indexPath
@property (assign,nonatomic) BOOL isRefreshing; //YES刷新,NO分页加载
@property (strong,nonatomic) UIActivityIndicatorView *indicView;

@property (strong,nonatomic) NSIndexPath *editingReplyCellIndexPath;//存储正在编辑状态的格子位置
@property (assign,nonatomic) BOOL isLoading ;//正在加载某个接口
@property (strong,nonatomic) id parentVC; //找到DRLeftTabBarVC
@end

@implementation LHLReplyNotificationViewController

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

    [self.tableView registerClass:[LHLReplyNotificationCell class] forCellReuseIdentifier:@"LHLReplyNotificationCell"];
    
    [self initData];
    
    [self requestMyNoticeWithUserID:[DataService sharedService].user.userId andClassID:[DataService sharedService].theClass.classId andPage:@"1"];
    
    [self addNotificationOb];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    //下拉刷新
    __block LHLReplyNotificationViewController *replyVC = self;
    __block UITableView *tableView = self.tableView;
    [_tableView addPullToRefreshWithActionHandler:^{
        replyVC.isRefreshing = YES;
        [replyVC requestMyNoticeWithUserID:[DataService sharedService].user.userId andClassID:[DataService sharedService].theClass.classId andPage:@"1"];
        [tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
}

//获取数据
- (void)initData{
    self.replyNotificationArray = [NSMutableArray array];
    self.pageOfReplyNotification = 1;
    self.isRefreshing = YES;
}

- (void)addNotificationOb{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWillChangeFrame:)
    //                                                 name:UIKeyboardWillChangeFrameNotification
    //                                               object:nil];
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
    return self.replyNotificationArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyNotificationObject *reply = self.replyNotificationArray[indexPath.row];
    CGSize size = [Utility getTextSizeWithString:reply.replyContent withFont:[UIFont systemFontOfSize:20.0] withWidth:510];
    if (size.height + 51 + 20 + 10  > 192) {  //上沿坐标,textView高度加值,下方高度
        return size.height + 51 + 20 + 10;
    }
    return 192;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LHLReplyNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHLReplyNotificationCell"];
    cell.delegate = self;
    ReplyNotificationObject *obj = self.replyNotificationArray[indexPath.row];
    [cell setInfomations:obj];
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
    [self.replyInputTextView resignFirstResponder];
    if (!leftBarVC.isHiddleLeftTabBar) {
        [leftBarVC navigationLeftItemClicked];
    }
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (self.tableView.contentOffset.y > self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.frame.size.height) {
//        //到达底部,分页加载
//        self.isRefreshing = NO;
//        if (self.displayCategory == NotificationDisplayCategoryDefault) {
//            [self requestSysNoticeWithStudentID:[DataService sharedService].user.studentId andClassID:[DataService sharedService].theClass.classId andPage:[NSString stringWithFormat:@"%d",self.pageOfNotification + 1]];
//        }else{
//            [self requestMyNoticeWithUserID:[DataService sharedService].user.userId andClassID:[DataService sharedService].theClass.classId andPage:[NSString stringWithFormat:@"%d",self.pageOfReplyNotification + 1]];
//        }
//    }
//
//}

//
//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 90;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (self.header) {  //防止被reload
//        return self.header;
//    }
//    LHLNotificationHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LHLNotificationHeader"];
//    header.delegate = self;
//    self.header = header;
//    return header;
//}

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

//-(void)dragMethod:(BOOL) toLeft{
//    if (toLeft) {
//        //手指向左划
//        if (self.displayCategory == NotificationDisplayCategoryReply) {
//            [self.topBar noticeButtonClicked:self.topBar.noticeButton];
//        }
//    }else{
//        if (self.displayCategory == NotificationDisplayCategoryDefault) {
//            [self.topBar replyButtonClicked:self.topBar.replyButton];
//        }
//    }
//}

-(void)initFooterView {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 50)];
    header.backgroundColor = [UIColor clearColor];
    [header addSubview:self.indicView];
    UILabel *loadLab = [[UILabel alloc]initWithFrame:CGRectMake(self.indicView.frame.origin.x+30, 10, 200, 30)];
    loadLab.text = @"正在努力加载中...";
    [header addSubview:loadLab];
    self.tableView.tableFooterView = header;
}

//-(void)initHeaderView {
//    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 50)];
//    header.backgroundColor = [UIColor clearColor];
//    [header addSubview:self.indicView];
//    UILabel *loadLab = [[UILabel alloc]initWithFrame:CGRectMake(self.indicView.frame.origin.x+30, 10, 200, 30)];
//    loadLab.text = @"正在刷新中...";
//    [header addSubview:loadLab];
//    self.tableView.tableHeaderView = header;
//}

#pragma mark -- 请求接口

//请求接口,获取回复通知
-(void)requestMyNoticeWithUserID:(NSString *)userID andClassID:(NSString *)classID andPage:(NSString *)page{
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            //请求回复通知
            //            NSString *str1 = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/get_messages?user_id=%@&school_class_id=%@&page=%@",userID,classID,page];
            NSString *str1 = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/get_messages?user_id=%@&school_class_id=%@&page=%@",@"115",@"83",page];
            NSURL *url1 = [NSURL URLWithString:str1];
            NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
            if (page.integerValue == 1) {
                //只有在刷新时才有菊花
                [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
            }
            self.isLoading = YES;
            [Utility requestDataWithRequest:request1 withSuccess:^(NSDictionary *dicData) {
                self.isLoading = NO;
                self.appDel.isReceiveNotificationReply = NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loadByNotification" object:nil];
                if (self.isRefreshing) {
                    self.replyNotificationArray = [NSMutableArray array];
                    self.pageOfReplyNotification = 1;
                }else{
                    self.pageOfReplyNotification ++;
                }
                NSArray *notices = [dicData objectForKey:@"messages"];
                for (NSInteger i = 0; i < notices.count; i ++) {
                    //从content字符串中拆分出被回复者的name,和content
                    NSDictionary *noticeDic = notices[i];
                    NSString *content = [noticeDic objectForKey:@"content"];
                    NSArray *ary = [content componentsSeparatedByString:@"]]"];
                    if (ary.count >= 2) {
                        content = ary[1];
                    }
                    NSRange range = [content rangeOfString:@"："];
                    NSString *name = [content substringToIndex:range.location];
                    range = [content rangeOfString:@";||;"];
                    NSString *realContent = [content substringFromIndex:range.location + range.length];
                    
                    ReplyNotificationObject *obj = [ReplyNotificationObject new];
                    obj.replyId = [noticeDic objectForKey:@"id"];
                    obj.replyTime = [self handleApiResponseTimeString:[noticeDic objectForKey:@"created_at"]];
                    obj.replyContent = realContent;
                    obj.replyMicropostId = [noticeDic objectForKey:@"micropost_id"];
                    obj.replyReciverID = [noticeDic objectForKey:@"reciver_id"];
                    obj.replyReciverType = [noticeDic objectForKey:@"reciver_types"];
                    obj.replyerImageAddress = [noticeDic objectForKey:@"sender_avatar_url"];
                    obj.replyerName = [noticeDic objectForKey:@"sender_name"];
                    obj.replyTargetName = name;
                    
                    
                    [self.replyNotificationArray addObject:obj];
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


//请求接口,删除回复通知
-(void)deleteMyNoticeWithUserID:(NSString *)studentID andClassID:(NSString *)classID andNoticeID:(NSString *)noticeID{
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            //请求系统通知
            NSString *str = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/delete_message?user_id=%@&school_class_id=%@&message_id=%@",studentID,classID,noticeID];
            NSURL *url = [NSURL URLWithString:str];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
            self.isLoading = YES;
            [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
                self.isLoading = NO;
                self.editingReplyCellIndexPath = nil;
                [self.replyNotificationArray removeObjectAtIndex:self.deletingIndexPath.row];
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

//回复信息
-(void)replyMessageWithSenderID:(NSString *)senderID andSenderType:(NSString *)senderType andContent:(NSString *)content andClassID:(NSString *)classID andMicropostID:(NSString *)microPostID andReciverID:(NSString *)reciverID andReciverType:(NSString *)reciverType{
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            //转码
            NSString *originString = [NSString stringWithString:content];
            originString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                     (CFStringRef)originString,
                                                                                     NULL,
                                                                                     NULL,
                                                                                     kCFStringEncodingUTF8));
            //请求系统通知
            NSString *str = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/reply_message?sender_id=%@&sender_types=%@&content=%@&school_class_id=%@&micropost_id=%@&reciver_id=%@&reciver_types=%@",senderID,senderType,originString,classID,microPostID,reciverID,reciverType];
            NSURL *url = [NSURL URLWithString:str];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            
            [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
            [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                    [self replyInputCancelButtonClicked:nil];
                    [Utility errorAlert:@"回复成功!"];
                });
            } withFailure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                });
                NSString *errorMsg = [error.userInfo objectForKey:@"msg"];
                [Utility errorAlert:errorMsg];
            }];
        }
    }];
}

#pragma mark -- property
-(void)setIsLoading:(BOOL)isLoading{
    //停止请求接口时,隐藏header和footer
    if (isLoading == NO) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.tableHeaderView = nil;
            self.tableView.tableFooterView = nil;
        });
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

-(UIView *)replyInputBgView{
    if (!_replyInputBgView) {
        _replyInputBgView = [[UIView alloc] initWithFrame:(CGRect){0,self.view.bounds.size.height + 1,768,50}];
        _replyInputBgView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
        [self.view addSubview:_replyInputBgView];
        if (!_characterCountLabel) {
            _characterCountLabel = [[UILabel alloc] initWithFrame:(CGRect){710,4,50,40}];
            _characterCountLabel.textColor = [UIColor grayColor];
            _characterCountLabel.textAlignment = NSTextAlignmentRight;
            _characterCountLabel.text = @"0/60";
            _characterCountLabel.font = [UIFont systemFontOfSize:18.0];
            [_replyInputBgView addSubview:_characterCountLabel];
        }
    }
    return _replyInputBgView;
}

-(UITextView *)replyInputTextView{
    if (!_replyInputTextView) {
        _replyInputTextView = [[UITextView alloc] initWithFrame:(CGRect){20,4,688,40}];
        _replyInputTextView.font = [UIFont systemFontOfSize:25.0];
        _replyInputTextView.layer.cornerRadius = 6.0;
        _replyInputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _replyInputTextView.layer.borderWidth = 1.0;
        _replyInputTextView.returnKeyType = UIReturnKeySend;
        _replyInputTextView.delegate = self;
        [self.replyInputBgView addSubview:_replyInputTextView];
    }
    return _replyInputTextView;
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
        [self requestMyNoticeWithUserID:[DataService sharedService].user.userId andClassID:[DataService sharedService].theClass.classId andPage:[NSString stringWithFormat:@"%d",self.pageOfReplyNotification + 1]];
        [self initFooterView];
    }
}

#pragma mark -- keyBoard相关  ,通知回调等
-(void)keyboardWillShow:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    NSValue *frameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect frame = [frameValue CGRectValue];
    NSTimeInterval duration;
    [durationValue getValue:&duration];
    [UIView animateWithDuration:duration animations:^{
        self.replyInputBgView.center = (CGPoint){self.replyInputBgView.center.x,frame.origin.y - self.replyInputBgView.frame.size.height / 2 - 67}; //67为本VC的view在屏幕的偏移量
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    NSValue *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration;
    [durationValue getValue:&duration];
    [UIView animateWithDuration:duration animations:^{
        self.replyInputBgView.center = (CGPoint){self.replyInputBgView.center.x,self.view.bounds.size.height + 1 + self.replyInputBgView.frame.size.height / 2};
    }];
}

-(void)replyInputCancelButtonClicked:(id)sender{
    self.replyInputTextView.text = @"";
    [self.replyInputTextView resignFirstResponder];
    self.replyingIndexPath = nil;
}


-(void)replyInputCommitButtonClicked:(id)sender{
    if (self.replyInputTextView.text.length < 1) {
        [Utility errorAlert:@"回复内容不能为空"];
        return;
    }else if(self.replyInputTextView.text.length > 60){
        [Utility errorAlert:@"回复内容不能超过60个字符"];
        return;
    }
    ReplyNotificationObject *notice = self.replyNotificationArray[self.replyingIndexPath.row];
    [self replyMessageWithSenderID:[DataService sharedService].user.studentId andSenderType:@"1" andContent:self.replyInputTextView.text andClassID:[DataService sharedService].theClass.classId andMicropostID:notice.replyMicropostId andReciverID:notice.replyReciverID andReciverType:notice.replyReciverType];
}

//-(void)replyInputCommitButtonClicked:(id)sender{
//    if (self.replyInputTextView.text.length < 1) {
//        [Utility errorAlert:@"回复内容不能为空"];
//        return;
//    }else if(self.replyInputTextView.text.length > 500){
//        [Utility errorAlert:@"回复内容不能超过500个字符"];
//        return;
//    }
//    ReplyNotificationObject *notice = self.replyNotificationArray[self.replyingIndexPath.row];
//    [self replyMessageWithSenderID:[DataService sharedService].user.studentId andSenderType:@"1" andContent:self.replyInputTextView.text andClassID:[DataService sharedService].theClass.classId andMicropostID:notice.replyMicropostId andReciverID:notice.replyReciverID andReciverType:notice.replyReciverType];
//}



#pragma mark -- LHLReplyNotificationCellDelegate
//-(UIImage *)replyCell:(LHLReplyNotificationCell *)cell bufferedImageForAddress:(NSString *)address{
//    NSData *imgData = [self.bufferedImageDic objectForKey:address];
//    if (imgData == nil) {
//        NSString *urlString = [NSString stringWithFormat:@"http://58.240.210.42:3004%@",address];
//        NSURL *url = [NSURL URLWithString:urlString];
//        imgData = [NSData dataWithContentsOfURL:url];
//        if (imgData == nil) {
//            [self.bufferedImageDic setObject:[NSNull null] forKey:address];
//        }else{
//            [self.bufferedImageDic setObject:imgData forKey:address];
//        }
//    }
//    if (!imgData || [imgData isKindOfClass:[NSNull class]]) {
//        return [UIImage imageNamed:@"systemMessage.png"];
//    }
//    return [UIImage imageWithData:imgData];
//}

-(void) replyCell:(LHLReplyNotificationCell *)cell replyButtonClicked:(id)sender{
    if ([self.replyInputTextView isFirstResponder]) {
        [self.replyInputTextView resignFirstResponder];
        self.replyingIndexPath = nil;
    }else{
        [self.replyInputTextView becomeFirstResponder];
        self.replyingIndexPath = cell.indexPath;
    }
}

-(void) replyCell:(LHLReplyNotificationCell *)cell setIsEditing:(BOOL)editing{
    [self replyInputCancelButtonClicked:nil];
    ReplyNotificationObject *obj = self.replyNotificationArray[cell.indexPath.row];
    obj.isEditing = editing;
    
    if (editing) {
        if (self.editingReplyCellIndexPath) {
            LHLReplyNotificationCell *editingCell = (LHLReplyNotificationCell *)[self.tableView cellForRowAtIndexPath:self.editingReplyCellIndexPath];
            if (editingCell) {
                [editingCell coverButtonClicked:nil];
            }else{
                ReplyNotificationObject *editingObj = [self.replyNotificationArray objectAtIndex:self.editingReplyCellIndexPath.row];
                editingObj.isEditing = NO;
            }
        }
        self.editingReplyCellIndexPath = cell.indexPath;
    }else{
        self.editingReplyCellIndexPath = nil;
    }
}

-(void) replyCell:(LHLReplyNotificationCell *)cell deleteButtonClicked:(id)sender{
    //请求接口
    ReplyNotificationObject *notice = self.replyNotificationArray[cell.indexPath.row];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            [self deleteMyNoticeWithUserID:[DataService sharedService].user.userId andClassID:[DataService sharedService].theClass.classId andNoticeID:notice.replyId];
        }
    }];
    self.deletingIndexPath = cell.indexPath;
}

//-(void) replyCell:(LHLReplyNotificationCell *)cell dragToLeft:(BOOL)toLeft{
//    [self dragMethod:toLeft];
//}

#pragma mark -- uitextView Delegate
-(void)textViewDidChange:(UITextView *)textView{
    [self calculateTextLength];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (self.replyInputTextView.text.length < 1) {
            [Utility errorAlert:@"回复内容不能为空"];
            return NO;
        }else if([self textLength:self.replyInputTextView.text] > 60){
            [Utility errorAlert:@"回复内容不能超过60个字符"];
            return NO;
        }
        ReplyNotificationObject *notice = self.replyNotificationArray[self.replyingIndexPath.row];
        [self replyMessageWithSenderID:[DataService sharedService].user.studentId andSenderType:@"1" andContent:self.replyInputTextView.text andClassID:[DataService sharedService].theClass.classId andMicropostID:notice.replyMicropostId andReciverID:notice.replyReciverID andReciverType:notice.replyReciverType];
        return NO;
    }
    return YES;
}

#pragma mark ---- 计算文本的字数
- (int)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

- (void)calculateTextLength
{
    NSString *string = self.replyInputTextView.text;
    int wordcount = [self textLength:string];
    
	NSInteger count  = 60 - wordcount;
    if (count<0) {
        [self.characterCountLabel setText:[NSString stringWithFormat:@"%i/60",60]];
    }else {
        [self.characterCountLabel setText:[NSString stringWithFormat:@"%i/60",wordcount]];
    }
}

@end