//
//  SortViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkContainerController.h"
#import "BasePostInterface.h"
#import "CardFullInterface.h"
/**
 *  排序
 */
@interface SortViewController : UIViewController<TenSecChallengeResultViewDelegate,PostDelegate,CardFullInterfaceDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic, strong) BasePostInterface *postInter;
@property (nonatomic, strong) CardFullInterface *cardFullInter;

@property (nonatomic, strong) UIView *wordsContainerView;
@property (nonatomic, assign) NSInteger number;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *questionArray;
@property (nonatomic, strong) NSDictionary *questionDic;


@property (nonatomic, assign) NSInteger branchNumber;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *branchQuestionArray;
@property (nonatomic, strong) NSDictionary *branchQuestionDic;

@property (nonatomic, strong) NSArray *orgArray;
@property (nonatomic, assign) NSInteger currentWordIndex;// 当前应该填字的位置：1 2 3 4
@property (strong, nonatomic) NSMutableDictionary *maps;//标记第几个
@property (nonatomic, strong) NSMutableArray *actionArray;//记录操作
@property (nonatomic, assign) NSInteger isRestart;//判断是否可以重新开始

@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIButton *restartBtn;

@property (nonatomic, assign) int specified_time;//规定时间

@property (nonatomic, strong) HomeworkContainerController *homeControl;
@property (strong, nonatomic) UIButton *checkHomeworkButton;
@property (nonatomic, strong) NSMutableDictionary *answerDic;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) NSInteger branchScore;

-(void)showSortCorrectAnswer;
- (void)sortViewReduceTimeButtonClicked;
//道具
@property (nonatomic, strong) NSMutableArray *propsArray;



///历史
@property (nonatomic, strong) IBOutlet UIView *historyView;
@property (nonatomic, strong) IBOutlet UILabel *historyAnswer;

@property (nonatomic, strong) NSMutableArray *history_questionArray;
@property (nonatomic, strong) NSDictionary *history_questionDic;
@property (nonatomic, strong) NSMutableArray *history_branchQuestionArray;
@property (nonatomic, strong) NSDictionary *history_branchQuestionDic;

-(void)exitSortView;
@property (nonatomic, assign) NSInteger postNumber;
@end
