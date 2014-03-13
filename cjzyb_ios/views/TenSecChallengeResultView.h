//
//  TenSecChallengeResultView.h
//  cjzyb_ios
//
//  Created by apple on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//



#import <UIKit/UIKit.h>
@protocol TenSecChallengeResultViewDelegate;

@interface TenSecChallengeResultView : UIView
@property (weak, nonatomic) IBOutlet UIView *resultBgView;   //绿色view
@property (weak, nonatomic) IBOutlet UILabel *correctPersent;  //正确率
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;    //用时
@property (weak, nonatomic) IBOutlet UIButton *commitButton;  //确认
@property (weak, nonatomic) IBOutlet UIButton *restartButton;  //重新开始
@property (weak, nonatomic) IBOutlet UILabel *accuracyAchievementLabel;  //准确率成就
@property (weak, nonatomic) IBOutlet UILabel *fastAchievementLabel;    //迅速成就
@property (weak, nonatomic) IBOutlet UILabel *earlyAchievementLabel;     //捷足成就

@property (strong,nonatomic) id<TenSecChallengeResultViewDelegate> delegate;
//以下为界面需传入的参数
@property (assign,nonatomic) NSInteger ratio; //正确率0-100
@property (assign,nonatomic) NSInteger timeCount; //用时(秒)
@property (assign,nonatomic) NSInteger timeLimit; //时限(秒)
@property (assign,nonatomic) BOOL isEarly;   //是否提前两小时完成挑战

- (void) initView;  //赋予所有参数之后调用

- (IBAction)commitButtonClicked:(id)sender;
- (IBAction)restartButtonClicked:(id)sender;

@end

@protocol TenSecChallengeResultViewDelegate <NSObject>
@required
-(void)resultViewCommitButtonClicked;  //确认完成
-(void)resultViewRestartButtonClicked;   //再次挑战

@end