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
    // Do any additional setup after loading the view from its nib.
}


-(void)startPreListeningHomeworkSentence:(ReadingHomeworkObj*)homework withPlayFinished:(void (^)(BOOL isSuccess))finished{
    self.finishedBlock = finished;
    self.currentHomework = homework;
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
-(void)listeningNextListening:(ReadingSentenceObj*)sentence{
    if (self.avPlayer.isPlaying) {
        [self.avPlayer stop];
    }
    self.currentSentence = sentence;
    [self.allAttriSentenceString  addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[self getSentenceRange:self.currentSentence withHomework:self.currentHomework]];
    self.sentenceTextView.attributedText = self.allAttriSentenceString;
    if (self.currentSentence.readingSentenceLocalFileURL) {
        if (self.avPlayer.isPlaying) {
            [self.avPlayer stop];
        }
        NSError *playerError = nil;
        self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.currentSentence.readingSentenceLocalFileURL] error:&playerError];
        self.avPlayer.delegate = self;
        if (!playerError && [self.avPlayer prepareToPlay]) {
            [self.avPlayer play];
        }else{
             [Utility errorAlert:@"播放文件不存在或者格式错误"];
        }
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [GoogleTTSAPI checkGoogleTTSAPIAvailabilityWithCompletionBlock:^(BOOL available) {
            if (available) {
                [GoogleTTSAPI textToSpeechWithText:self.currentSentence.readingSentenceContent andLanguage:@"en" success:^(NSData *data) {
                    NSURL *audioFileURL = [self fileURLWithFileName:@"converted.mp3"];
                    [data writeToURL:audioFileURL atomically:NO];
                    if (self.avPlayer.isPlaying) {
                        [self.avPlayer stop];
                    }
                    NSError *error = nil;
                    self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
                    self.avPlayer.delegate = self;
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utility errorAlert:@"播放文件不存在或者格式错误"];
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [self.startListeningBt setEnabled:YES];
                        });
                        return;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.avPlayer prepareToPlay]) {
                            [self.avPlayer play];
                           [self.startListeningBt setEnabled:NO];
                        }else{
                            [self.startListeningBt setEnabled:YES];
                        }
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                } failure:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.startListeningBt setEnabled:YES];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [Utility errorAlert:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
                    });
                }];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.startListeningBt setEnabled:YES];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [Utility errorAlert:@"当前无网络"];
                });
            }
        }];
    }
}

//TODO:开始预听
- (IBAction)startListeningBtClicked:(id)sender {
    if (self.currentHomework.readingHomeworkSentenceObjArray.count <= 0) {
        return;
    }
    self.currentSentence = [self.currentHomework.readingHomeworkSentenceObjArray firstObject];
     [self.startListeningBt setEnabled:NO];
    self.currentHomework = self.currentHomework;
    [self listeningNextListening:self.currentSentence];
   
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
            [self listeningNextListening:[self.currentHomework.readingHomeworkSentenceObjArray objectAtIndex:index+1]];
        }else{
            [self.startListeningBt setEnabled:YES];
//            if (self.finishedBlock) {
//                self.finishedBlock(YES);
//            }
        }
    }else{
        [self.startListeningBt setEnabled:YES];
    }
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"audioPlayerDecodeErrorDidOccur");
    [self.startListeningBt setEnabled:YES];
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
@end
