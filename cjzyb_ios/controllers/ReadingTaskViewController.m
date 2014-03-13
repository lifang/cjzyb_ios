//
//  ReadingTaskViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ReadingTaskViewController.h"

#import "GoogleTTSAPI.h"
#import "DRSentenceSpellMatch.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeworkContainerController.h"
@interface ReadingTaskViewController ()
///当前读句子下标
@property (nonatomic,assign) int currentSentenceIndex;
///当前所做大题下标
@property (nonatomic,assign) int currentHomeworkIndex;

@property (nonatomic,strong) NSString  *recorderTempPath;
@property (nonatomic,strong) AVAudioRecorder *avRecorder;
@property (nonatomic,strong) AVAudioPlayer *avPlayer;
///是否在读内容
@property (nonatomic,assign) BOOL isReading;
///是否在听
@property (nonatomic,assign) BOOL isListening;
@property (weak, nonatomic) IBOutlet UIView *tipBackView;
@property (weak, nonatomic) IBOutlet UITextView *tipTextView;
///要读的文字内容
@property (weak, nonatomic) IBOutlet UITextView *readingTextView;
/// 点击开始录音按钮
@property (weak, nonatomic) IBOutlet UIButton *readingButton;
///点击开始听内容按钮
@property (weak, nonatomic) IBOutlet UIButton *listeningButton;

/// 点击开始录音
- (IBAction)readingButtonClicked:(id)sender;

///点击开始听内容
- (IBAction)listeningButtonClicked:(id)sender;
@end

@implementation ReadingTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.readingTextView.text = @"Sure,Where are you flying today?";
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //设置录音临时存放路径
    self.recorderTempPath =  [NSString stringWithFormat:@"%@recorder.aac",NSTemporaryDirectory()];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:self.recorderTempPath]) {
//        [fileManager createFileAtPath:self.recorderTempPath contents:nil attributes:nil];
//    }
    //设置录音对象
    
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSError *recorderError = nil;
    self.avRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.recorderTempPath] settings:recordSetting error:&recorderError];
    self.avRecorder.meteringEnabled = NO;
    self.avRecorder.delegate = self;
    


    [self.listeningButton setImage:[UIImage imageNamed:@"listening_start.png"] forState:UIControlStateNormal];
    [self.listeningButton setImage:[UIImage imageNamed:@"listening_stop.png"] forState:UIControlStateDisabled];
    
    self.isReading = NO;
    self.isListening = NO;

    // Do any additional setup after loading the view from its nib.
}

#pragma mark exchange homework切换题目
///
-(void)setCurrentSentence:(ReadingSentenceObj *)currentSentence withAnimation:(BOOL)ani{
    if (!currentSentence) {
        return;
    }
    self.currentSentence = currentSentence;
    [self updateAllFrame];
    if (ani) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setDuration:0.5];
        [animation setRemovedOnCompletion:YES];
        [animation setDelegate:self];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.view.layer addAnimation:animation forKey:@"PushLeft"];
    }
}

///切换到第一句
-(void)updateFirstSentence{
    if (!self.currentSentence) {
        [self updateFirstHomework];
    }
    [self setCurrentSentence:[self.currentHomework.readingHomeworkSentenceObjArray firstObject] withAnimation:YES];
    self.currentSentenceIndex = 0;
    if (self.currentSentence) {
        
    }else{//当前大题中没有句子
        
    }
}
///切换到下一句
-(void)updateNextSentence{
    if (!self.currentSentence) {
        [self updateFirstSentence];
    }
    if (self.currentSentence) {
        if (self.currentSentenceIndex+1 < self.currentHomework.readingHomeworkSentenceObjArray.count) {
            self.currentSentenceIndex++;
            [self setCurrentSentence:[self.currentHomework.readingHomeworkSentenceObjArray objectAtIndex:self.currentSentenceIndex] withAnimation:YES];
        }else{//已经是最后一个句子
        
        }
    }else{//当前大题中没有句子
    
    }
    
}
///切换到第一大题
-(void)updateFirstHomework{
    if (!self.readingHomeworksArr || self.readingHomeworksArr.count <= 0) {
        [self loadHomeworkFromFile];
    }
    if (self.readingHomeworksArr && self.readingHomeworksArr.count > 0) {
        self.currentHomework = [self.readingHomeworksArr firstObject];
    }else{//json文件中没有朗读的题目
        
    }
    self.currentHomeworkIndex = 0;
}

///切换到下一题
-(void)updateNextHomework{
    if (!self.currentHomework) {
        [self updateFirstHomework];
    }
    if (self.currentHomework) {
        if (self.currentHomeworkIndex+1 < self.readingHomeworksArr.count) {
            self.currentHomeworkIndex++;
            self.currentHomework = [self.readingHomeworksArr objectAtIndex:self.currentHomeworkIndex];
        }else{//已经是最后一个大题
        
        }
    }else{//json文件中没有朗读的题目
    
    }
}

///从json文件中加载题目数据
-(void)loadHomeworkFromFile{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"question.geojson" ofType:nil];
    [ParseQuestionJsonFileTool parseQuestionJsonFile:filePath withReadingQuestionArray:^(NSArray *readingQuestionArr, NSInteger specifiedTime) {
        NSLog(@"%@,time:%d",readingQuestionArr,specifiedTime);
        self.readingHomeworksArr = readingQuestionArr;
        self.specifiedSecond = specifiedTime;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withParseError:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error:%@",error);
    }];
}
#pragma mark --

#pragma mark 界面过度动画代理
-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"start aninatiom");
    [self.view setUserInteractionEnabled:NO];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"finished");
    [self.view setUserInteractionEnabled:YES];
}
#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)readingButtonClicked:(id)sender {
    ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];
	
	NSError *err;
	
	[recognition setDelegate:self];
	
	if(![recognition listen:&err]) {
		NSLog(@"ERROR: %@", err);
	}
    
    return;
    //////
    if (self.isReading) {
        [self.readingButton setEnabled:NO];
        if (self.avRecorder.isRecording) {
            [self.avRecorder stop];
        }else{
            [self.readingButton setEnabled:YES];
            self.isReading = NO;
            [self.listeningButton setUserInteractionEnabled:YES];
        }
    }else{
        [self.avRecorder deleteRecording];
        if ([self.avRecorder prepareToRecord]) {
            self.isReading = YES;
            [self.listeningButton setUserInteractionEnabled:NO];
            [self.avRecorder recordForDuration:60*60];
//            [self.avRecorder record];
        }else{
            self.isReading = NO;
            [self.listeningButton setUserInteractionEnabled:YES];
        }
    }
}

- (IBAction)listeningButtonClicked:(id)sender {
    if (self.isListening) {
        if (self.avPlayer.isPlaying) {
            [self.avPlayer stop];
        }
    }else{
        if (self.currentSentence.readingSentenceResourceURL) {
            if (self.avPlayer.isPlaying) {
                [self.avPlayer stop];
            }
            NSError *playerError = nil;
            self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.currentSentence.readingSentenceLocalFileURL] error:&playerError];
            self.avPlayer.delegate = self;
            if (!playerError && [self.avPlayer prepareToPlay]) {
                [self.avPlayer play];
                self.isListening = YES;
                [self.readingButton setUserInteractionEnabled:NO];
            }else{
                self.isListening = NO;
                [self.readingButton setUserInteractionEnabled:YES];
            }
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [GoogleTTSAPI checkGoogleTTSAPIAvailabilityWithCompletionBlock:^(BOOL available) {
                if (available) {
                    [GoogleTTSAPI textToSpeechWithText:self.readingTextView.text andLanguage:@"en" success:^(NSData *data) {
                        NSURL *audioFileURL = [self fileURLWithFileName:@"converted.mp3"];
                        [data writeToURL:audioFileURL atomically:NO];
                        if (self.avPlayer.isPlaying) {
                            [self.avPlayer stop];
                        }
                        NSError *error = nil;
                        self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
                        self.avPlayer.delegate = self;
                        if (error) {
                            [Utility errorAlert:@"播放文件不存在或者格式错误"];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            return;
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if ([self.avPlayer prepareToPlay]) {
                                [self.avPlayer play];
                                self.isListening = YES;
                                [self.readingButton setUserInteractionEnabled:NO];
                            }else{
                                self.isListening = NO;
                                [self.readingButton setUserInteractionEnabled:YES];
                            }
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        });
                    } failure:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.isListening = NO;
                            [self.readingButton setUserInteractionEnabled:YES];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [Utility errorAlert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                        });
                    }];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.isListening = NO;
                        [self.readingButton setUserInteractionEnabled:YES];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [Utility errorAlert:@"当前无网络"];
                    });
                }
            }];
        }
    }
}


- (NSURL*) fileURLWithFileName: (NSString*) fileName {
    NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentDirectory URLByAppendingPathComponent:fileName];
}
///更新所有的位置
-(void)updateAllFrame{
    NSAttributedString *attributeString = self.readingTextView.attributedText;
    if (!attributeString) {
        return ;
    }
    CGRect textRect = [attributeString boundingRectWithSize:(CGSize){CGRectGetWidth(self.readingTextView.frame),1024-350} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading context:nil];
    self.readingTextView.frame = (CGRect){self.readingTextView.frame.origin,CGRectGetWidth(self.readingTextView.frame),textRect.size.height};
    
    self.readingButton.frame = (CGRect){CGRectGetMinX(self.readingButton.frame),CGRectGetMaxY(self.readingButton.frame)+20,self.readingButton.frame.size};
    
    self.tipBackView.frame = (CGRect){CGRectGetMinX(self.tipBackView.frame),CGRectGetMaxY(self.readingButton.frame) +30,self.tipBackView.frame.size};
    
}

///标记颜色
-(void)markErrorColorRangeForArr:(NSArray*)rangeArray{

}

#pragma mark AVAudioRecorderDelegate录音代理
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [self.readingButton setEnabled:YES];
    self.isReading = NO;
    [self.listeningButton setUserInteractionEnabled:YES];
    NSLog(@"audioRecorderDidFinishRecording:%@",flag?@"YES":@"NO");
}

-(void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"audioRecorderBeginInterruption");
}

-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    NSLog(@"audioRecorderEndInterruption");
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur:%@",error.userInfo);
}
#pragma mark --

#pragma mark AVAudioPlayerDelegate 播放代理
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"audioPlayerDidFinishPlaying:%@",flag?@"YES":@"NO");
    self.isListening = NO;
    [self.readingButton setUserInteractionEnabled:YES];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"audioPlayerDecodeErrorDidOccur");
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"audioPlayerBeginInterruption");
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    NSLog(@"audioPlayerEndInterruption:%@",flags?@"YES":@"NO");
}
#pragma mark --


#pragma mark ISSpeechRecognitionDelegate
- (void)recognition:(ISSpeechRecognition *)speechRecognition didGetRecognitionResult:(ISSpeechRecognitionResult *)result {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
	NSLog(@"Result: %@", result.text);
    [DRSentenceSpellMatch checkSentence:@"hello,hello" withSpellMatchSentence:result.text andSpellMatchAttributeString:^(NSAttributedString *spellAttriString, float matchScore) {
        self.readingTextView.attributedText = nil;
        self.readingTextView.attributedText = spellAttriString;
    } orSpellMatchFailure:^(NSError *error) {
        [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
    }];
	self.readingTextView.text = result.text;
}

- (void)recognition:(ISSpeechRecognition *)speechRecognition didFailWithError:(NSError *)error {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
	NSLog(@"Error: %@", error);
}

- (void)recognitionCancelledByUser:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

- (void)recognitionDidBeginRecording:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

- (void)recognitionDidFinishRecording:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}
#pragma mark --

#pragma mark property
-(void)setIsReading:(BOOL)isReading{
    _isReading = isReading;
    if (!isReading) {
        [self.readingButton setImage:[UIImage imageNamed:@"reading_start.png"] forState:UIControlStateNormal];
        
    }else{
        [self.readingButton setImage:[UIImage imageNamed:@"reading_stop.png"] forState:UIControlStateNormal];
    }
}
-(void)setIsListening:(BOOL)isListening{
    _isListening = isListening;
    [self.listeningButton setEnabled:!isListening];
}

-(void)setCurrentSentence:(ReadingSentenceObj *)currentSentence{
    _currentSentence = currentSentence;
    if (currentSentence) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:currentSentence.readingSentenceContent];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, attri.length)];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, attri.length)];
        self.readingTextView.attributedText = attri;
    }
}
#pragma mark --
@end
