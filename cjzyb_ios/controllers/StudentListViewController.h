//
//  StudentListViewController.h
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudentTableViewCell;
@class StudentSummaryCell;
@protocol StudentListViewControllerDelegate;
/** StudentListViewController
 *
 * 老师和学生列表
 */
@interface StudentListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic) id<StudentListViewControllerDelegate> delegate;
- (IBAction)backButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
///存放学生信息
@property (strong,nonatomic) NSMutableArray *studentArray;

///和老师信息列表
@property (strong,nonatomic) NSMutableArray *teacherArray;

@end

@protocol StudentListViewControllerDelegate <NSObject>

-(void)studentListViewController:(StudentListViewController*)controller backButtonClicked:(UIButton*)button;

@end