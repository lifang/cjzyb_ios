//
//  SelectedViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClozeView.h"
#import "UnderLineLabel.h"
#import "HomeworkContainerController.h"
#import "BasePostInterface.h"

/**
 *  完形填空
 */
@interface SelectedViewController : UIViewController<ClozeViewDelegate,TenSecChallengeResultViewDelegate,PostDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic, strong) BasePostInterface *postInter;

@property (nonatomic, strong) ClozeView *clozeVV;
@property (nonatomic, strong) IBOutlet UIScrollView *myScroll;

@property (nonatomic, strong) NSDictionary *clozeDic;//整个题目－－－－代表完形填空
@property (nonatomic, assign) NSInteger number;//记录第几题--大题
@property (nonatomic, strong) NSMutableArray *questionArray;
@property (nonatomic, strong) NSDictionary *questionDic;


@property (nonatomic, strong) NSMutableArray *answerArray;



@property (nonatomic, assign) NSInteger tmpTag;

@property (nonatomic, assign) int specified_time;//规定时间

@property (strong, nonatomic) UIButton *checkHomeworkButton;

@property (nonatomic, assign) NSInteger branchScore;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) HomeworkContainerController *homeControl;
@property (nonatomic, strong) NSMutableDictionary *answerDic;


-(void)showClozeCorrectAnswer;
- (void)clozeViewReduceTimeButtonClicked;
//道具
@property (nonatomic, strong) NSMutableArray *propsArray;

///再次挑战
@property (nonatomic, assign) CGFloat again_radio;



///历史
@property (nonatomic, strong) IBOutlet UIView *historyView;
@property (nonatomic, strong) IBOutlet UILabel *historyAnswer;

@property (nonatomic, strong) NSMutableArray *history_questionArray;
@property (nonatomic, strong) NSDictionary *history_questionDic;

-(void)exitClozeView;
@property (nonatomic, assign) NSInteger postNumber;



@end
