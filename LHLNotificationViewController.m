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

@property (assign,nonatomic) BOOL loaded;
@property (strong,nonatomic) LHLNotificationHeader *header;
@property (strong,nonatomic) LHLNotificationCell *tempCell;
@property (assign,nonatomic) NotificationDisplayCategory displayCategory;//当前页面显示的通知类型
@property (assign,nonatomic) NSInteger number;
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
    self.number = 6;
    
    self.displayCategory = NotificationDisplayCategoryDefault;
    
    self.loaded = NO;
    
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
    return self.number;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.loaded) {
        CGFloat height = self.tempCell.cellHeight;
        return height > 150 ? height : 150;
    }
    return 150;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.loaded) {
//        self.loaded = NO;
//        return self.tempCell;
//    }
    
    if (self.displayCategory == NotificationDisplayCategoryDefault) {
        LHLNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHLNotificationCell"];
        [cell initCell];
        cell.delegate = self;
        cell.indexPath = indexPath;
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = cell.textView.frame.size.height + 28 + 20;
        if (cellFrame.size.height < 150) {
            cellFrame.size.height = 150;
        }
        return cell;
    }else{
        LHLReplyNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHLReplyNotificationCell"];
        [cell setInfomations];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
}

#pragma mark --

#pragma mark -- UITableViewDelegate

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
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
    self.number --;
    [self.tableView deleteRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

-(void)refreshHeightForCell:(LHLNotificationCell *)cell{
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.tempCell = cell;
    self.loaded = YES;
}

#pragma mark -- LHLReplyNotificationCellDelegate
-(void) replyCell:(LHLReplyNotificationCell *)cell replyButtonClicked:(id)sender{
    
}

-(void) replyCell:(LHLReplyNotificationCell *)cell deleteButtonClicked:(id)sender{
    self.number --;
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
