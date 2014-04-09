//
//  LininggViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-19.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkContainerController.h"
#import "BasePostInterface.h"

#import "LiningDrawLinesView.h"
#import "LineObj.h"

/**
*  连线
*/

@interface LininggViewController : UIViewController<TenSecChallengeResultViewDelegate,PostDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic, strong) BasePostInterface *postInter;

@property (nonatomic, strong) LiningDrawLinesView *wordsContainerView;

@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;
@property (nonatomic, strong) NSMutableArray *tmpLeftArray;
@property (nonatomic, strong) NSMutableArray *tmpRightArray;
@property (nonatomic, strong) NSMutableArray *cancelTmpLeftArray;
@property (nonatomic, strong) NSMutableArray *cancelTmpRightArray;

@property (nonatomic, assign) NSInteger number;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *questionArray;
@property (nonatomic, strong) NSDictionary *questionDic;


@property (nonatomic, assign) NSInteger branchNumber;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *branchQuestionArray;
@property (nonatomic, strong) NSDictionary *branchQuestionDic;

@property (nonatomic, assign) int specified_time;//规定时间

@property (nonatomic, strong) HomeworkContainerController *homeControl;
@property (strong, nonatomic) UIButton *checkHomeworkButton;

@property (nonatomic, strong) NSMutableDictionary *answerDic;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) NSInteger branchScore;

//道具
@property (nonatomic, strong) NSMutableArray *propsArray;

-(void)showLiningCorrectAnswer;
-(void)liningViewReduceTimeButtonClicked;

///历史
@property (nonatomic, strong) IBOutlet UIView *historyView;
@property (nonatomic, strong) IBOutlet UILabel *historyAnswer;

@property (nonatomic, strong) NSMutableArray *history_questionArray;
@property (nonatomic, strong) NSDictionary *history_questionDic;
@property (nonatomic, strong) NSMutableArray *history_branchQuestionArray;
@property (nonatomic, strong) NSDictionary *history_branchQuestionDic;

-(void)exitLiningView;
@property (nonatomic, assign) NSInteger postNumber;

///再次挑战
@property (nonatomic, assign) NSInteger right_number;
@property (nonatomic, assign) NSInteger count_number;
@end
