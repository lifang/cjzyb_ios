//
//  HomeworkRankingViewController.h
//  cjzyb_ios
//
//  Created by david on 14-3-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkRankingTableViewCell.h"
#import "HomeworkDaoInterface.h"


@interface HomeworkRankingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
///参与排名的列表
@property (strong,nonatomic) NSArray *rankingUserArray;
- (IBAction)exitButtonClicked:(id)sender;

///重新加载数据
-(void)reloadDataWithTaskId:(NSString*)taskId withHomeworkType:(HomeworkType)homeworkType;
@end
