//
//  ReadingTaskViewController.h
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ISpeechSDK.h"
#import "ParseQuestionJsonFileTool.h"
#import "TenSecChallengeResultView.h"
@class HomeworkContainerController;
/** ReadingTaskViewController
 *
 * 朗读任务
 */
@interface ReadingTaskViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate,ISSpeechRecognitionDelegate,TenSecChallengeResultViewDelegate>
///每道大题需要时间秒数（包含多个句子）
@property (assign,nonatomic) int specifiedSecond;
///当前正在做的题目
@property (strong,nonatomic) ReadingHomeworkObj *currentHomework;
///存放大题的数组
@property (strong,nonatomic) NSArray *readingHomeworksArr;
///当前正在听的句子
@property (strong,nonatomic) ReadingSentenceObj *currentSentence;

///是否是预听
@property (nonatomic,assign) BOOL isPrePlay;

///显示结果view
@property (nonatomic, strong) TenSecChallengeResultView *resultView;


///是否是第一次做题
@property (nonatomic,assign) BOOL isFirst;

///开始做题
-(void)startBeginninghomework;

///退出作业界面
-(void)exithomeworkUI;

///减时间道具
-(void)reduceTimeProBtClicked;
@end
