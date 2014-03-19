//
//  HomeworkContainerController.h
//  cjzyb_ios
//
//  Created by david on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkTypeObj.h"
#import "LiningHomeworkViewController.h"
#import "ReadingTaskViewController.h"
#import "ListenWriteViewController.h"//听写
#import "SortViewController.h"//排序
#import "SelectedViewController.h"//完形填空
#import "SelectingChallengeViewController.h"//选择挑战
#import "TenSecChallengeViewController.h" //十速挑战
/** HomeworkContainerController
 *
 * 所有题目类型的container，子类放置是每个题型的controller
 */
@interface HomeworkContainerController : UIViewController
///作业类型
@property (assign,nonatomic) HomeworkType homeworkType;
@property (strong, nonatomic) IBOutlet UIView *djView;

///退出按钮
@property (weak, nonatomic) IBOutlet UIButton *quitHomeworkButton;
///检查按钮
@property (weak, nonatomic) IBOutlet UIButton *checkHomeworkButton;
///检查按钮的背景
@property (weak, nonatomic) IBOutlet UIView *checkBgView;
///计时器label
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
///显示正确答案button
@property (weak, nonatomic) IBOutlet UIButton *appearCorrectButton;
///减少做题时间button
@property (weak, nonatomic) IBOutlet UIButton *reduceTimeButton;
///容器内容view，所有子类view放到里面
@property (weak, nonatomic) IBOutlet UIView *contentView;

///记录的秒数
@property (assign,nonatomic) long long spendSecond;
///开始计时
-(void)startTimer;

///停止计时
-(void)stopTimer;


@property (strong, nonatomic) IBOutlet UIImageView *timeImg;



/**
 *  历史
 */
@property (nonatomic, strong) IBOutlet UILabel *label1,*label2;
@property (nonatomic, strong) IBOutlet UILabel *rotioLabel,*timeLabel;
@end
