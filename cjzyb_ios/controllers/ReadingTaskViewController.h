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
@class HomeworkContainerController;
/** ReadingTaskViewController
 *
 * 朗读任务
 */
@interface ReadingTaskViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate,ISSpeechRecognitionDelegate>
///每道大题需要时间秒数（包含多个句子）
@property (assign,nonatomic) int specifiedSecond;
///当前正在做的题目
@property (strong,nonatomic) ReadingHomeworkObj *currentHomework;
///存放大题的数组
@property (strong,nonatomic) NSArray *readingHomeworksArr;
///当前正在听的句子
@property (strong,nonatomic) ReadingSentenceObj *currentSentence;

///切换到下一句
-(void)updateNextSentence;
@end
