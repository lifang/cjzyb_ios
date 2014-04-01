//
//  ListenWriteViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-12.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkContainerController.h"
#import "TenSecChallengeResultView.h"
#import "BasePostInterface.h"
#import <AVFoundation/AVFoundation.h> 
#import "CardFullInterface.h"
/**
 *  听写
 */
@interface ListenWriteViewController : UIViewController<UITextFieldDelegate,TenSecChallengeResultViewDelegate,PostDelegate,AVAudioPlayerDelegate,CardFullInterfaceDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *listenMusicView;
@property (nonatomic, strong) IBOutlet UIButton *listenBtn;
@property (nonatomic, strong) IBOutlet UIButton *branch_listenBtn;

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
@property (nonatomic, strong) NSArray *metaphoneArray;
@property (nonatomic, strong) NSMutableArray *tmpArray;
@property (nonatomic, strong) NSDictionary *resultDic;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) int specified_time;//规定时间
@property (nonatomic, assign) CGFloat branchScore;
@property (nonatomic, assign) CGFloat scoreRadio;//正确率

@property (nonatomic, strong) HomeworkContainerController *homeControl;
@property (strong, nonatomic) UIButton *checkHomeworkButton;
@property (nonatomic, strong) NSMutableDictionary *answerDic;


@property (nonatomic, strong) NSMutableArray *urlArray;//存放预听界面播放的url
@property (nonatomic, assign) NSInteger playMusicModel;
-(void)listenViewReduceTimeButtonClicked;
//道具
@property (nonatomic, strong) NSMutableArray *propsArray;


//提醒－－－
@property (nonatomic, strong) IBOutlet UIView *remindView;
@property (nonatomic, strong) IBOutlet UILabel *remindLabel;
@property (strong, nonatomic) IBOutlet UILabel *remindLab;

///历史
@property (nonatomic, strong) IBOutlet UIView *historyView;
@property (nonatomic, strong) IBOutlet UILabel *historyAnswer;

@property (nonatomic, strong) NSMutableArray *history_questionArray;
@property (nonatomic, strong) NSDictionary *history_questionDic;
@property (nonatomic, strong) NSMutableArray *history_branchQuestionArray;
@property (nonatomic, strong) NSDictionary *history_branchQuestionDic;

-(void)exitListenView;
@property (nonatomic, assign) NSInteger postNumber;
@end
