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
@property (strong,nonatomic) NSMutableArray *replyNotificationArray;  //回复通知数组

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
        CGSize size = [Utility getTextSizeWithString:noti.notiContent withFont:[UIFont systemFontOfSize:17.0] withWidth:510];
        if (size.height + 50 + 20 + 10 > 192) { //上沿坐标,textView高度加值,下方高度
            return size.height + 50 + 20 + 10;
        }
        return 192;
    }else if (self.displayCategory == NotificationDisplayCategoryReply){
        ReplyNotificationObject *reply = self.replyNotificationArray[indexPath.row];
        CGSize size = [Utility getTextSizeWithString:reply.replyContent withFont:[UIFont systemFontOfSize:17.0] withWidth:510];
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

#pragma mark -- LHLNotificationCellDelegate
-(void)cell:(LHLNotificationCell *)cell deleteButtonClicked:(id)sender{
    [self.notificationArray removeObjectAtIndex:cell.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

-(void)refreshHeightForCell:(LHLNotificationCell *)cell{
    
}

#pragma mark -- LHLReplyNotificationCellDelegate
-(void) replyCell:(LHLReplyNotificationCell *)cell replyButtonClicked:(id)sender{
    
}

-(void) replyCell:(LHLReplyNotificationCell *)cell deleteButtonClicked:(id)sender{
    [self.replyNotificationArray removeObjectAtIndex:cell.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

#pragma mark -- LHLNotificationHeaderDelegate
//点击header按钮后触发
-(void)header:(LHLNotificationHeader *)header didSelectedDisplayCategory:(NotificationDisplayCategory)category{
    if (self.displayCategory != category) {
        self.displayCategory = category;
        [self.tableView reloadData];
    }
}

@end
