//
//  HomeworkViewController.h
//  cjzyb_ios
//
//  Created by david on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkDailyCollectionViewController.h"
#import "HomeworkTypeObj.h"
#import "CalendarViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "TaskObj.h"//提包对象
#import "BasePostInterface.h"
#import "AlertViewController.h"
/** HomeworkViewController
 *
 * 管理作业界面
 */
@interface HomeworkViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,HomeworkDailyCollectionViewControllerDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,PostDelegate,AlertViewDelegate>

@property (nonatomic, strong) AlertViewController *alertViewControl;
@property (nonatomic, strong) BasePostInterface *postInter;
///显示历史任务
@property (nonatomic,assign) BOOL isShowHistory;
/// 当前作业类型
@property (strong,nonatomic) TaskObj *taskObj;

@property (strong,nonatomic) NSMutableArray *currentDayTaskArray;
///所有历史任务，存放TaskObj
@property (strong,nonatomic) NSMutableArray *allHistoryTaskArray;
@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic,retain) ASINetworkQueue *networkQueue;

@property (weak, nonatomic) IBOutlet UIButton * refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton * historyBtn;
@end
