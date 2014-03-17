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

@property (strong,nonatomic) LHLNotificationHeader *header;
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
    [self.tableView registerClass:[LHLNotificationHeader class] forHeaderFooterViewReuseIdentifier:@"LHLNotificationHeader"];
    [self.tableView registerClass:[LHLReplyNotificationCell class] forCellReuseIdentifier:@"LHLReplyNotificationCell"];
    
    [self initData];
}

//获取数据
- (void)initData{
    self.notificationArray = [NSMutableArray array];
    self.pageOfNotification = 1;
    self.replyNotificationArray = [NSMutableArray array];
    self.pageOfReplyNotification = 1;
    
    [self requestDateWithStudentID:@"1" andClassID:@"1" andPage:@"1"];
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
//        [cell setInfomations:self.replyNotificationArray[indexPath.row]];
        ReplyNotificationObject *reply = [[ReplyNotificationObject alloc] init];
        reply.replyerName = @"卡斯特罗";
        reply.replyContent = @"好男人就是我,我就是曾小贤,好男人就是我,我就是曾小贤,好男人就是我,我就是曾小贤,好男人就是我,我就是曾小贤,好男人就是我,我就是曾小贤,好男人就是我,我就是曾小贤,好男人就是我,我就是曾小贤";
        reply.replyTime = @"2014-2-15 18:08:08";
        [cell setInfomations:reply];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
}

#pragma mark --

#pragma mark -- UITableViewDelegate

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 90;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.header) {  //防止被reload
        return self.header;
    }
    LHLNotificationHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LHLNotificationHeader"];
    header.delegate = self;
    self.header = header;
    return header;
}

#pragma mark -- action
//请求接口
-(void)requestDateWithStudentID:(NSString *)studentID andClassID:(NSString *)classID andPage:(NSString *)page{
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            //            [self.getMyNoticeInterface getMyNoticeWithUserID:@"1" andSchoolClassID:@"1" andPage:[NSString stringWithFormat:@"%d",self.pageOfReplyNotification]];
            //            [self.getSysNoticeInterface getSysNoticeWithUserID:@"1" andSchoolClassID:@"1" andPage:[NSString stringWithFormat:@"%d",self.pageOfNotification]];
            NSString *str = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/get_sys_message?student_id=%@&school_class_id=%@&page=%@",studentID,classID,page];
            NSURL *url = [NSURL URLWithString:str];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
                NSArray *notices = [dicData objectForKey:@"sysmessage"];
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
            } withFailure:^(NSError *error) {
                
            }];
        }
    }];
}

#pragma mark -- property
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
            [self.deleteSysNoticeInterface deleteSysNoticeWithUserID:@"1" andClassID:@"1" andSysNoticeID:notice.notiID];
        }
    }];
    self.deletingIndexPath = cell.indexPath;
}

-(void)refreshHeightForCell:(LHLNotificationCell *)cell{
    
}

#pragma mark -- LHLReplyNotificationCellDelegate
-(void) replyCell:(LHLReplyNotificationCell *)cell replyButtonClicked:(id)sender{
    
}

-(void) replyCell:(LHLReplyNotificationCell *)cell deleteButtonClicked:(id)sender{
    //请求接口
    ReplyNotificationObject *notice = self.replyNotificationArray[cell.indexPath.row];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if (![@"NotReachable" isEqualToString:networkStatus]) {
            [self.deleteMyNoticeInterface deleteMyNoticeWithUserID:@"1" andClassID:@"1" andNoticeID:notice.replyId];
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
