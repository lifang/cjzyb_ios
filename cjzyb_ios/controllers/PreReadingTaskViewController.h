//
//  PreReadingTaskViewController.h
//  cjzyb_ios
//
//  Created by david on 14-3-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadingHomeworkObj.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "GoogleTTSAPI.h"
/** PreReadingTaskViewController
 *
 * 朗读预听界面
 */
@interface PreReadingTaskViewController : UIViewController<AVAudioPlayerDelegate>
///当前正在做的题目
@property (strong,nonatomic) ReadingHomeworkObj *currentHomework;
///当前正在听的句子
@property (strong,nonatomic) ReadingSentenceObj *currentSentence;
///播放音频界面
@property (nonatomic,strong) AVAudioPlayer *avPlayer;

///开始预听
-(void)startPreListeningHomeworkSentence:(ReadingHomeworkObj*)homework withPlayFinished:(void (^)(BOOL isSuccess))finished;

///点击右上角按钮结束预听
-(void)endPrePlay;
@end
