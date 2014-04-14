//
//  PreReadingTaskViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "PreReadingTaskViewController.h"

@interface PreReadingTaskViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startListeningBt;
@property (weak, nonatomic) IBOutlet UITextView *sentenceTextView;

@property (assign,nonatomic) BOOL isPreListening;//是否开始预听
@property (assign,nonatomic) BOOL ttsIsReady; //TTS转换是否完成

///放置所有的要读的句子，每句用换行分割
@property (nonatomic,strong) NSMutableAttributedString *allAttriSentenceString;

@property (nonatomic,strong) void (^finishedBlock)(BOOL isSuccess);

- (IBAction)startListeningBtClicked:(id)sender;
@end

@implementation PreReadingTaskViewController

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
     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
     self.sentenceTextView.attributedText = self.allAttriSentenceString;
    
    self.isPreListening = NO;
    // Do any additional setup after loading the view from its nib.
}


-(void)startPreListeningHomeworkSentence:(ReadingHomeworkObj*)homework withPlayFinished:(void (^)(BOOL isSuccess))finished{
    self.finishedBlock = finished;
    self.currentHomework = homework;
    self.ttsIsReady = NO;  //更新homework后需要重新加载TTS
    
    self.sentenceTextView.attributedText = self.allAttriSentenceString;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSURL*) fileURLWithFileName: (NSString*) fileName {
    
    NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentDirectory URLByAppendingPathComponent:fileName];
}

-(NSRange)getSentenceRange:(ReadingSentenceObj*)sentence withHomework:(ReadingHomeworkObj*)homework{
    int startIndex = 0;
    int lenght = 0;
    for (ReadingSentenceObj *sen in homework.readingHomeworkSentenceObjArray) {
        if (sen == sentence) {
            lenght = sen.readingSentenceContent.length;
            break;
        }else{
            startIndex += sen.readingSentenceContent.length+1;
        }
    }
    
    return NSMakeRange(startIndex, lenght);
}

//TODO:听下一句
-(void)listeningNextListening:(ReadingSentenceObj*)sentence andIndex:(NSInteger )index{
    if (self.avPlayer.isPlaying) {
        [self.avPlayer stop];
    }
    self.currentSentence = sentence;
    [self.allAttriSentenceString  addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1] range:[self getSentenceRange:self.currentSentence withHomework:self.currentHomework]];
    self.sentenceTextView.attributedText = self.allAttriSentenceString;
    
    if (self.currentSentence.readingSentenceLocalFileURL) {
        if (self.avPlayer.isPlaying) {
            [self.avPlayer stop];
        }
        NSError *playerError = nil;
        //此处为全路径
        self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.currentSentence.readingSentenceLocalFileURL] error:&playerError];
        self.avPlayer.delegate = self;
        if (!playerError && [self.avPlayer prepareToPlay]) {
            [self.avPlayer play];
        }else{
            [Utility errorAlert:@"播放文件不存在或者格式错误"];
        }
    }else{
        NSLog(@"即将朗读:%@ --%d",self.currentSentence.readingSentenceContent,index);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //TTS播放
            if (self.avPlayer.isPlaying) {
                [self.avPlayer stop];
            }
            NSError *error = nil;
            NSString *fileName = [NSString stringWithFormat:@"converted_%d.mp3",index];
            NSURL *audioFileURL = [self fileURLWithFileName:fileName];
            self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
            self.avPlayer.delegate = self;
            if (error) {
                [Utility errorAlert:@"播放文件不存在或者格式错误"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.startListeningBt setEnabled:YES];
                [self.startListeningBt setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
                return;
            }
            
            if ([self.avPlayer prepareToPlay]) {
                [self.avPlayer play];
                [self.startListeningBt setImage:[UIImage imageNamed:@"ios-stop.png"] forState:UIControlStateNormal];
            }else{
                [self.startListeningBt setEnabled:YES];
                [self.startListeningBt setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
            }
        });
    }
}

//TODO:开始预听
- (IBAction)startListeningBtClicked:(id)sender {
    if (self.currentHomework.readingHomeworkSentenceObjArray.count <= 0) {
        return;
    }
    if (self.isPreListening == NO) {
        if (self.ttsIsReady) {
            [self beginToPlayTTS];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.shouldInterrupt = NO;
            [self makeTTSFileFromString:((ReadingSentenceObj *)[self.currentHomework.readingHomeworkSentenceObjArray firstObject]).readingSentenceContent andStringIndex:0];
        }
        
    }else{
        if (self.avPlayer.isPlaying) {
            [self.avPlayer pause];
            [self.startListeningBt setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
        }else{
            [self.avPlayer play];
            [self.startListeningBt setImage:[UIImage imageNamed:@"ios-stop"] forState:UIControlStateNormal];
        }
    }
}

//TODO:点击右上角按钮结束预听
-(void)endPrePlay{
    if (self.avPlayer.isPlaying) {
        [self.avPlayer stop];
    }
    if (self.finishedBlock) {
        self.finishedBlock(YES);
    }
}

#pragma mark AVAudioPlayerDelegate 播放代理
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"audioPlayerDidFinishPlaying:%@",flag?@"YES":@"NO");
    if (flag && self.avPlayer == player) {
        int index = [self.currentHomework.readingHomeworkSentenceObjArray indexOfObject:self.currentSentence];
        if (index+1 < self.currentHomework.readingHomeworkSentenceObjArray.count) {
            [self listeningNextListening:[self.currentHomework.readingHomeworkSentenceObjArray objectAtIndex:index+1] andIndex:index + 1];
        }else{
            self.isPreListening = NO;
            [self.startListeningBt setEnabled:YES];
            [self.startListeningBt setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
//            if (self.finishedBlock) {
//                self.finishedBlock(YES);
//            }
        }
    }else{
        [self.startListeningBt setEnabled:YES];
        [self.startListeningBt setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
    }
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"audioPlayerDecodeErrorDidOccur");
    [self.startListeningBt setEnabled:YES];
    [self.startListeningBt setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"audioPlayerBeginInterruption");
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    NSLog(@"audioPlayerEndInterruption:%@",flags?@"YES":@"NO");
}
#pragma mark --

#pragma mark property
-(void)setCurrentHomework:(ReadingHomeworkObj *)currentHomework{
    _currentHomework = currentHomework;
    //初始化文本
    if (currentHomework && currentHomework.readingHomeworkSentenceObjArray.count > 0) {
        NSMutableString *sentenceStr = [NSMutableString string];
        for (ReadingSentenceObj *sentence in currentHomework.readingHomeworkSentenceObjArray) {
            [sentenceStr appendString:sentence.readingSentenceContent];
            [sentenceStr appendString:@"\n"];
        }
        NSMutableParagraphStyle  *style = [[NSMutableParagraphStyle alloc]init];
        style.alignment = NSTextAlignmentCenter;
        self.allAttriSentenceString = [[NSMutableAttributedString alloc] initWithString:sentenceStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor lightGrayColor],NSParagraphStyleAttributeName:style}];
    }else{
        self.allAttriSentenceString = nil;
    }
}
#pragma mark --

#pragma mark TTS 相关

- (void)beginToPlayTTS{
    if (self.shouldInterrupt) {
        return;
    }
    //开始播放音频
    self.currentSentence = [self.currentHomework.readingHomeworkSentenceObjArray firstObject];
    [self.startListeningBt setImage:[UIImage imageNamed:@"ios-playing"] forState:UIControlStateNormal];
    self.currentHomework = self.currentHomework;
    [self listeningNextListening:self.currentSentence andIndex:0];
    self.isPreListening = YES;
}

//把一个文本转换为语音,本地保存  --- currentHomework转化完之后自动播放
- (void)makeTTSFileFromString:(NSString *)sentence andStringIndex:(NSInteger)index{
    if (self.shouldInterrupt) {
        return;
    }
    [GoogleTTSAPI checkGoogleTTSAPIAvailabilityWithCompletionBlock:^(BOOL available) {
        if (available) {
            [GoogleTTSAPI textToSpeechWithText:sentence
                                   andLanguage:@"en"
                                       success:^(NSData *data) {
                //保存文件
                NSString *fileName = [NSString stringWithFormat:@"converted_%d.mp3",index];
                //删除原文件
                NSFileManager *manager = [NSFileManager defaultManager];
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                NSString *filePath = [path stringByAppendingPathComponent:fileName];
                if ([manager fileExistsAtPath:filePath]) {
                    [manager removeItemAtPath:filePath error:nil];
                }
                [data writeToFile:filePath atomically:NO];
                
                //递归调用
                if (index + 1 < self.currentHomework.readingHomeworkSentenceObjArray.count) {
                    ReadingSentenceObj *sentence = self.currentHomework.readingHomeworkSentenceObjArray[index + 1];
                    [self makeTTSFileFromString:sentence.readingSentenceContent andStringIndex:index + 1];
                }else if (index + 1 == self.currentHomework.readingHomeworkSentenceObjArray.count){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //播放
                        self.ttsIsReady = YES;
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [self beginToPlayTTS];
                    });
                }
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [Utility errorAlert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                    [Utility errorAlert:@"无法转换语音!"];
                });
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [Utility errorAlert:@"当前无网络"];
            });
        }
    }];
}

@end
