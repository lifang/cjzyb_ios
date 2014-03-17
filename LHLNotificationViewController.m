//
//  LHLNotificationViewController.m
//  cjzyb_ios
//
//  Created by apple on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLNotificationViewController.h"

@interface LHLNotificationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet LHLNotificationHeader *topBar;

@property (strong,nonatomic) LHLNotificationCell *tempCell;
@property (assign,nonatomic) NotificationDisplayCategory displayCategory;//当前页面显示的通知类型
@property (strong,nonatomic) NSMutableArray *notificationArray; //系统通知数组
@property (assign,nonatomic) NSInteger pageOfNotification; //系统通知页码(分页加载)
@property (strong,nonatomic) NSMutableArray *replyNotificationArray;  //回复通知数组
@property (assign,nonatomic) NSInteger pageOfReplyNotification; //回复通知页码(分页加载)
@property (strong,nonatomic) NSIndexPath *deletingIndexPath;  //正在被删除的cell的indexPath(在请求接口的过程中有效)
@property (strong,nonatomic) LHLGetMyNoticeInterface *getMyNoticeInterface;
@property (strong,nonatomic) LHLGetSysNoticeInterface *getSysNoticeInterface;
@property (strong,nonatomic) LHLDeleteMyNoticeInterface *deleteMyNoticeInterface;
@property (strong,nonatomic) LHLDeleteSysNoticeInterface *deleteSysNoticeInterface;
@property (strong,nonatomic) MJRefreshHeaderView *refreshHeaderView; //下拉刷新
@property (strong,nonatomic) MJRefreshFooterView *refreshFooterView; //下拉加载
@property (assign,nonatomic) BOOL isRefreshing; //YES刷新,NO分页加载

//临时学生数据
@property (strong,nonatomic) NSString *userID;
@property (strong,nonatomic) NSString *classID;
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
    
    self.displayCategory = NotificationDisplayCategoryDefault;
    
    UINib *nib = [UINib nibWithNibName:@"LHLNotificationCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LHLNotificationCell"];
//    [self.tableView registerClass:[LHLNotificationHeader class] forHeaderFooterViewReuseIdentifier:@"LHLNotificationHeader"];
    [self.topBar initHeader];
    self.topBar.delegate = self;
    [self.tableView registerClass:[LHLReplyNotificationCell class] forCellReuseIdentifier:@"LHLReplyNotificationCell"];
    
    [self refreshFooterView];
    [self refreshHeaderView];
    
    [self initData];
}

//获取数据
- (void)initData{
    self.notificationArray = [NSMutableArray array];
    self.pageOfNotification = 1;
    self.replyNotificationArray = [NSMutableArray array];
    self.pageOfReplyNotification = 1;
    
    self.userID = @"115";
    self.classID = @"83";
    self.isRefreshing = YES;
    
    [self requestSysNoticeWithStudentID:self.userID andClassID:self.classID andPage:@"1"];
    [self requestMyNoticeWithStudentID:self.userID andClassID:self.classID andPage:@"1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --

#pragma mark -- UITableViewDatasource


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.displayCategory == NotificationDisplayCategoryDefault) {
        return self.notificationArray.count;
    }else if (self.displayCategory == NotificationDisplayCategoryReply){
        return self.replyNotificationArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayCategory == NotificationDisplayCategoryDefault) {
        NotificationObject *noti = self.notificationArray[indexPath.row];
        CGSize size = [Utility getTextSizeWithString:noti.notiContent withFont:[UIFont systemFontOfSize:21.0] withWidth:510];
        if (size.height + 50 + 20 + 10 > 192) { //上沿坐标,textView高度加值,下方高度
            return size.height + 50 + 20 + 10;
        }
        return 192;
    }else if (self.displayCategory == NotificationDisplayCategoryReply){
        ReplyNotificationObject *reply = self.replyNotificationArray[indexPath.row];
        CGSize size = [Utility getTextSizeWithString:reply.replyContent withFont:[UIFont systemFontOfSize:21.0] withWidth:510];
        if (size.height + 51 + 20 + 10  > 192) {  //上沿坐标,textView高度加值,下方高度
            return size.height + 51 + 20 + 10;
        }
        return 192;
    }
    return 192;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayCategory == NotificationDisplayCategoryDefault) {
        LHLNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHLNotificationCell"];
        [cell initCell];
        [cell setNotificationObject:self.notificationArray[indexPath.row]];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }else{
        LHLReplyNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHLReplyNotificationCell"];
        [cell setInfomations:self.replyNotificationArray[indexPath.row]];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
}

#pragma mark --

#pragma mark -- UITableViewDelegate
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
//请求接口,获取系统通知
-(void)requestSysNoticeWithStudentID:(NSString *)studentID andClassID:(NSString *)classID andPage:(NSString *)page{
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            //请求系统通知
            NSString *str = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/get_sys_message?student_id=%@&school_class_id=%@&page=%@",studentID,classID,page];
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
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
                    if (self.displayCategory == NotificationDisplayCategoryDefault) {
                        [self.tableView reloadData];
                        [self.refreshFooterView endRefreshing];
                        [self.refreshHeaderView endRefreshing];
                    }
                });
            } withFailure:^(NSError *error) {
                [self.refreshFooterView endRefreshing];
                [self.refreshHeaderView endRefreshing];
                if (self.displayCategory == NotificationDisplayCategoryDefault) {
                    NSString *errorMsg = [error.userInfo objectForKey:@"msg"];
                    [Utility errorAlert:errorMsg];
                }
            }];
        }
    }];
}

//请求接口,获取回复通知
-(void)requestMyNoticeWithStudentID:(NSString *)studentID andClassID:(NSString *)classID andPage:(NSString *)page{
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            //请求回复通知
            NSString *str1 = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/get_messages?user_id=%@&school_class_id=%@&page=%@",studentID,classID,page];
            NSURL *url1 = [NSURL URLWithString:str1];
            NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
            [Utility requestDataWithRequest:request1 withSuccess:^(NSDictionary *dicData) {
                if (self.isRefreshing) {
                    self.replyNotificationArray = [NSMutableArray array];
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
                    if (self.displayCategory == NotificationDisplayCategoryReply) {
                        [self.tableView reloadData];
                        [self.refreshFooterView endRefreshing];
                        [self.refreshHeaderView endRefreshing];
                    }
                });
            } withFailure:^(NSError *error) {
                [self.refreshFooterView endRefreshing];
                [self.refreshHeaderView endRefreshing];
                if (self.displayCategory == NotificationDisplayCategoryReply) {
                    NSString *errorMsg = [error.userInfo objectForKey:@"msg"];
                    [Utility errorAlert:errorMsg];
                }
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
            [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
                [self.notificationArray removeObjectAtIndex:self.deletingIndexPath.row];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView deleteRowsAtIndexPaths:@[self.deletingIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.frame = self.tableView.frame.origin.y == 0 ? (CGRect){0,1,self.tableView.frame.size} : (CGRect){0,0,self.tableView.frame.size};
                    } completion:^(BOOL finished) {
                        [self.tableView reloadData];
                    }];
                    self.deletingIndexPath = nil;
                    [Utility errorAlert:@"删除成功!"];
                });
            } withFailure:^(NSError *error) {
                NSString *errorMsg = [error.userInfo objectForKey:@"msg"];
                [Utility errorAlert:errorMsg];
                self.deletingIndexPath = nil;
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
            [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
                [self.replyNotificationArray removeObjectAtIndex:self.deletingIndexPath.row];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView deleteRowsAtIndexPaths:@[self.deletingIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.frame = self.tableView.frame.origin.y == 0 ? (CGRect){0,1,self.tableView.frame.size} : (CGRect){0,0,self.tableView.frame.size};
                    } completion:^(BOOL finished) {
                        [self.tableView reloadData];
                    }];
                    self.deletingIndexPath = nil;
                    [Utility errorAlert:@"删除成功!"];
                });
            } withFailure:^(NSError *error) {
                NSString *errorMsg = [error.userInfo objectForKey:@"msg"];
                [Utility errorAlert:errorMsg];
                self.deletingIndexPath = nil;
            }];
        }
    }];
}

//处理服务器返回的时间字符串 ("2014-03-25T15:23:13+08:00")
-(NSString *)handleApiResponseTimeString:(NSString *)str{
    NSArray *array = [str componentsSeparatedByString:@"T"];
    NSString *date = [array firstObject];
    NSString *time = [array lastObject];
    if ([time rangeOfString:@"+08:00"].length > 0) {
        time = [time stringByReplacingCharactersInRange:NSMakeRange(time.length - @"+08:00".length, @"+08:00".length) withString:@""];
    }
    return [NSString stringWithFormat:@"%@ %@",date,time];
}

#pragma mark -- property
-(MJRefreshHeaderView *)refreshHeaderView{
    if (!_refreshHeaderView) {
        _refreshHeaderView = [MJRefreshHeaderView header];
        _refreshHeaderView.scrollView = self.tableView;
        _refreshHeaderView.delegate = self;
    }
    return _refreshHeaderView;
}

-(MJRefreshFooterView *)refreshFooterView{
    if (!_refreshFooterView) {
        _refreshFooterView = [MJRefreshFooterView footer];
        _refreshFooterView.scrollView = self.tableView;
        _refreshFooterView.delegate = self;
    }
    return _refreshFooterView;
}

-(LHLGetSysNoticeInterface *)getSysNoticeInterface{
    if (!_getSysNoticeInterface) {
        _getSysNoticeInterface = [LHLGetSysNoticeInterface new];
        _getSysNoticeInterface.delegate = self;
    }
    return _getSysNoticeInterface;
}

-(LHLGetMyNoticeInterface *)getMyNoticeInterface{
    if (!_getMyNoticeInterface) {
        _getMyNoticeInterface = [LHLGetMyNoticeInterface new];
        _getMyNoticeInterface.delegate = self;
    }
    return _getMyNoticeInterface;
}

-(LHLDeleteSysNoticeInterface *)deleteSysNoticeInterface{
    if (!_deleteSysNoticeInterface) {
        _deleteSysNoticeInterface = [LHLDeleteSysNoticeInterface new];
        _deleteSysNoticeInterface.delegate = self;
    }
    return _deleteSysNoticeInterface;
}

-(LHLDeleteMyNoticeInterface *)deleteMyNoticeInterface{
    if (!_deleteMyNoticeInterface) {
        _deleteMyNoticeInterface = [LHLDeleteMyNoticeInterface new];
        _deleteMyNoticeInterface.delegate = self;
    }
    return _deleteMyNoticeInterface;
}

#pragma mark -- LHLNotificationCellDelegate
-(void)cell:(LHLNotificationCell *)cell deleteButtonClicked:(id)sender{
    //请求接口
    NotificationObject *notice = self.notificationArray[cell.indexPath.row];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            [self deleteSysNoticeWithUserID:@"1" andClassID:@"1" andNoticeID:notice.notiID];
        }
    }];
    self.deletingIndexPath = cell.indexPath;
}

-(void)refreshHeightForCell:(LHLNotificationCell *)cell{
    
}

-(void)cell:(LHLNotificationCell *)cell setIsEditing:(BOOL)editing{
    NotificationObject *obj = self.notificationArray[cell.indexPath.row];
    obj.isEditing = editing;
}

#pragma mark -- LHLReplyNotificationCellDelegate
-(void) replyCell:(LHLReplyNotificationCell *)cell replyButtonClicked:(id)sender{
    
}

-(void) replyCell:(LHLReplyNotificationCell *)cell setIsEditing:(BOOL)editing{
    ReplyNotificationObject *obj = self.replyNotificationArray[cell.indexPath.row];
    obj.isEditing = editing;
}

-(void) replyCell:(LHLReplyNotificationCell *)cell deleteButtonClicked:(id)sender{
    //请求接口
    ReplyNotificationObject *notice = self.replyNotificationArray[cell.indexPath.row];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            [self deleteMyNoticeWithUserID:@"115" andClassID:@"83" andNoticeID:notice.replyId];
        }
    }];
    self.deletingIndexPath = cell.indexPath;
}

#pragma mark -- LHLNotificationHeaderDelegate
//点击header按钮后触发
-(void)header:(LHLNotificationHeader *)header didSelectedDisplayCategory:(NotificationDisplayCategory)category{
    if (self.displayCategory != category) {
        self.displayCategory = category;
        [self.tableView reloadData];
    }
}

#pragma mark -- MJRefreshDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (self.refreshHeaderView == refreshView) { //刷新
        self.isRefreshing = YES;
        if (self.displayCategory == NotificationDisplayCategoryDefault) {
            [self requestSysNoticeWithStudentID:self.userID andClassID:self.classID andPage:@"1"];
            self.pageOfNotification = 1;
        }else{
            [self requestMyNoticeWithStudentID:self.userID andClassID:self.classID andPage:@"1"];
            self.pageOfReplyNotification = 1;
        }
    }else{   //分页加载
        self.isRefreshing = NO;
        if (self.displayCategory == NotificationDisplayCategoryDefault) {
            [self requestSysNoticeWithStudentID:self.userID andClassID:self.classID andPage:[NSString stringWithFormat:@"%d",self.pageOfNotification + 1]];
        }else{
            [self requestMyNoticeWithStudentID:self.userID andClassID:self.classID andPage:[NSString stringWithFormat:@"%d",self.pageOfReplyNotification + 1]];
        }
    }
}

#pragma mark -- getSysNoti Delegate
-(void)getSysNoticeDidFinished:(NSDictionary *)result{
    NSArray *notices = [result objectForKey:@"sysmessage"];
    for (NSInteger i = 0; i < notices.count; i ++) {
        NSDictionary *noticeDic = notices[i];
        NotificationObject *obj = [[NotificationObject alloc] init];
        obj.notiID = [noticeDic objectForKey:@"id"];
        obj.notiSchoolClassID = [noticeDic objectForKey:@"school_class_id"];
        obj.notiStudentID = [noticeDic objectForKey:@"student_id"];
        obj.notiContent = [noticeDic objectForKey:@"content"];
        obj.notiTime = [noticeDic objectForKey:@"created_at"];
        [self.notificationArray addObject:obj];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)getSysNoticeDidFailed:(NSString *)errorMsg{
    [Utility errorAlert:errorMsg];
}

#pragma mark -- getMyNoti Delegate
-(void)getMyNoticeDidFinished:(NSDictionary *)result{
    NSArray *notices = [result objectForKey:@"messages"];
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
        obj.replyTime = [noticeDic objectForKey:@"created_at"];
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
        [self.tableView reloadData];
    });
}

-(void)getMyNoticeDidFailed:(NSString *)errorMsg{
    [Utility errorAlert:errorMsg];
}

#pragma mark -- deleteSysNoti Delegate
-(void)deleteSysNoticeDidFinished:(NSDictionary *)result{
    [self.notificationArray removeObjectAtIndex:self.deletingIndexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView deleteRowsAtIndexPaths:@[self.deletingIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = self.tableView.frame.origin.y == 0 ? (CGRect){0,1,self.tableView.frame.size} : (CGRect){0,0,self.tableView.frame.size};
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
        }];
        self.deletingIndexPath = nil;
    });
    [Utility errorAlert:@"删除成功!"];
}

-(void)deleteSysNoticeDidFailed:(NSString *)errorMsg{
    [Utility errorAlert:errorMsg];
    self.deletingIndexPath = nil;
}

#pragma mark -- deleteMyNoti Delegate
-(void)deleteMyNoticeDidFinished:(NSDictionary *)result{
    [self.replyNotificationArray removeObjectAtIndex:self.deletingIndexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView deleteRowsAtIndexPaths:@[self.deletingIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = self.tableView.frame.origin.y == 0 ? (CGRect){0,1,self.tableView.frame.size} : (CGRect){0,0,self.tableView.frame.size};
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
        }];
        self.deletingIndexPath = nil;
    });
    [Utility errorAlert:@"删除成功!"];
}

-(void)deleteMyNoticeDidFailed:(NSString *)errorMsg{
    [Utility errorAlert:errorMsg];
    self.deletingIndexPath = nil;
}

@end
