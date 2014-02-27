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
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.loaded) {
        CGFloat height = self.tempCell.cellHeight;
        return height > 150 ? height : 150;
    }
    return 150;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.loaded) {
        self.loaded = NO;
        return self.tempCell;
    }
    
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
        return cell;
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

//实现此方法可启用滑动删除特性,此方法在点击删除后调用
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    //code
//}

#pragma mark --

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LHLNotificationCell *cell = (LHLNotificationCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell makeSideButtons];
    [UIView animateWithDuration:0.25 animations:^{
        cell.scrollView.contentOffset = CGPointMake(80, 0);
    } completion:^(BOOL finished) {
        [cell.scrollView setUserInteractionEnabled:YES];
    }];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    LHLNotificationCell *cell = (LHLNotificationCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.scrollView setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.25 animations:^{
        cell.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

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
-(void)refreshHeightForCell:(LHLNotificationCell *)cell{
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.tempCell = cell;
    self.loaded = YES;
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
