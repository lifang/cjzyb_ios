//
//  ReadingTaskViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ReadingTaskViewController.h"

#import "DRSentenceSpellMatch.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeworkContainerController.h"
#import "ParseAnswerJsonFileTool.h"
#import "ParseQuestionJsonFileTool.h"
#import "RecognizerFactory.h"//语音
#import "PreReadingTaskViewController.h"



#define parentVC ((HomeworkContainerController *)[self parentViewController])
#define minRecoginCount 4
#define minRecoginLevel 0.5
static BOOL isCanUpLoad = NO;  //是否应该上传JSON
@interface ReadingTaskViewController ()
///预听界面
@property (nonatomic,strong) PreReadingTaskViewController *preReadingController;
@property (nonatomic,strong) AVAudioPlayer *avPlayer;
///当前读句子下标
@property (nonatomic,assign) int currentSentenceIndex;
///当前所做大题下标
@property (nonatomic,assign) int currentHomeworkIndex;
///读匹配次数
@property (nonatomic,assign) int readingCount;


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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    if ([DataService sharedService].isHistory) {
        [self.tipBackView setHidden:NO];
        [self.readingButton setHidden:YES];
        TaskObj *task = [DataService sharedService].taskObj;
        __weak ReadingTaskViewController *weakSelf = self;
        
        [ParseAnswerJsonFileTool parseAnswerJsonFileWithUserId:[DataService sharedService].user.userId withTask:task withReadingHistoryArray:^(NSArray *readingQuestionArr, int currentQuestionIndex, int currentQuestionItemIndex, int status, NSString *updateTime, NSString *userTime, int specifyTime,float ratio) {
            ReadingTaskViewController *tempSelf = weakSelf;
            if (tempSelf) {
                parentVC.timeLabel.text = [NSString stringWithFormat:@"用时：%@",[Utility  formateDateStringWithSecond:userTime.intValue]];
                parentVC.rotioLabel.text = [NSString stringWithFormat:@"正确率：%0.0f",ratio];
                tempSelf.readingHomeworksArr = readingQuestionArr;
                [tempSelf updateFirstSentence];
            }
        } withParseError:^(NSError *error) {
            [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
        }];
    }else{
        [self.tipBackView setHidden:YES];
        [self.readingButton setHidden:NO];
        int timeCount = [DataService sharedService].number_reduceTime;
        if (timeCount <= 0) {
            [parentVC.reduceTimeButton setEnabled:NO];
        }else{
            [parentVC.reduceTimeButton setEnabled:YES];
        }
        
        if (self.isPrePlay) {
            [parentVC.checkHomeworkButton setTitle:@"开始" forState:UIControlStateNormal];
            [parentVC stopTimer];
            [parentVC.reduceTimeButton setEnabled:NO];
        }else{
            
        }
    }
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 创建识别对象
    _iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
    _popUpView = [[PopupView alloc]initWithFrame:CGRectMake(100, 100, 0, 0)];
    _popUpView.ParentView = self.view;
    
    
    if ([DataService sharedService].isHistory) {
        
    }else{
        self.preReadingController = [[PreReadingTaskViewController alloc] initWithNibName:@"PreReadingTaskViewController" bundle:nil];
        [self appearPrePlayControllerWithAnimation:YES];
        [self updateFirstSentence];
        [self.preReadingController startPreListeningHomeworkSentence:self.currentHomework withPlayFinished:^(BOOL isSuccess) {
            
        }];
    }


    [self.listeningButton setImage:[UIImage imageNamed:@"listening_start.png"] forState:UIControlStateNormal];
    [self.listeningButton setImage:[UIImage imageNamed:@"listening_stop.png"] forState:UIControlStateDisabled];
    
    self.isReading = NO;
    self.isListening = NO;
}

#pragma mark exchange homework切换题目
///
-(void)setCurrentSentence:(ReadingSentenceObj *)currentSentence withAnimation:(BOOL)ani{
    if (!currentSentence) {
        return;
    }
    self.currentSentence = currentSentence;
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
    [self setCurrentSentence:[self.currentHomework.readingHomeworkSentenceObjArray objectAtIndex:self.currentSentenceIndex] withAnimation:YES];
    if (self.currentSentence) {
        
    }else{//当前大题中没有句子
        
    }
}

//TODO:减时间道具
-(void)reduceTimeProBtClicked{
    int timeCount = [DataService sharedService].number_reduceTime;
    if (timeCount <= 1) {
        [parentVC.reduceTimeButton setEnabled:NO];
    }
    [DataService sharedService].number_reduceTime--;
    __weak ReadingTaskViewController *weakSelf = self;
    TaskObj *task = [DataService sharedService].taskObj;
    NSString *path = [NSString stringWithFormat:@"%@/%@/answer_%@.json",[Utility returnPath],task.taskStartDate,[DataService sharedService].user.userId?:@""];
    [ParseAnswerJsonFileTool writePropsToJsonFile:path withQuestionId:[NSString stringWithFormat:@"%d",self.currentSentenceIndex] withPropsType:@"1" withSuccess:^{
        ReadingTaskViewController *tempSelf = weakSelf ;
        if (tempSelf) {
        
        }
    } withFailure:^(NSError *error) {
        ReadingTaskViewController *tempSelf = weakSelf ;
        if (tempSelf) {
            [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
        }
    }];
}

//TODO:退出作业界面
-(void)exithomeworkUI{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确认退出挑战?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

-(void)quitNow{
    if (!self.isPrePlay && ![DataService sharedService].isHistory && self.isFirst && isCanUpLoad) {
        __weak ReadingTaskViewController *weakSelf = self;
        TaskObj *task = [DataService sharedService].taskObj;
        NSString *path = [NSString stringWithFormat:@"%@/%@/answer_%@.json",[Utility returnPath],task.taskStartDate,[DataService sharedService].user.userId?:@""];
        [ParseAnswerJsonFileTool writeReadingHomeworkToJsonFile:path withUseTime:[NSString stringWithFormat:@"%llu",parentVC.spendSecond] withQuestionIndex:self.currentHomeworkIndex withQuestionItemIndex:self.currentSentenceIndex withReadingHomworkArr:self.readingHomeworksArr withSuccess:^{
            ReadingTaskViewController *tempSelf = weakSelf ;
            if (tempSelf) {
                
            }
        } withFailure:^(NSError *error) {
            ReadingTaskViewController *tempSelf = weakSelf ;
            if (tempSelf) {
                [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
            }
        }];
        
        [self uploadJSON];
    }else{
        [parentVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

//TODO:开始做题(点击"下一个"时也触发)
-(void)startBeginninghomework{
    if ([DataService sharedService].isHistory==YES) {
        [self updateNextSentence];
    }else{
        if (self.isPrePlay) {
            [self hiddlePrePlayControllerWithAnimation:YES];
        }else{
            //切换到下一题
            if (self.currentSentence.readingSentenceRatio.floatValue >= minRecoginLevel || self.readingCount >= minRecoginCount) {
                self.readingCount = 0;
                [self.tipBackView setHidden:YES];
                if (self.currentSentenceIndex+1 < self.currentHomework.readingHomeworkSentenceObjArray.count) {
                    [ self updateNextSentence];
                }else{//已经是最后一个句子
                    if (self.currentHomeworkIndex+1 < self.readingHomeworksArr.count) {
                        [self updateNextHomework];
                        [self.preReadingController startPreListeningHomeworkSentence:self.currentHomework withPlayFinished:^(BOOL isSuccess) {
                            [parentVC startTimer];
                        }];
                        [self appearPrePlayControllerWithAnimation:YES];
                    }else{//TODO:挑战结束
                        [parentVC stopTimer];
                        if (self.isFirst && ![DataService sharedService].isHistory) {
                            [self uploadJSON];
                        }else{
                            [self showResultView];
                        }
                    }
                }
            }else{
                MBProgressHUD *alert = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                alert.labelText = @"读不够好哦，再试一次吧";
                [alert hide:YES afterDelay:1];
            }
        }
    }
}

///切换到下一句
-(void)updateNextSentence{
    if (self.currentSentence) {
        if (self.currentSentenceIndex+1 < self.currentHomework.readingHomeworkSentenceObjArray.count) {
            self.currentSentenceIndex++;
            self.currentSentence.isFinished = YES;
            [self setCurrentSentence:[self.currentHomework.readingHomeworkSentenceObjArray objectAtIndex:self.currentSentenceIndex] withAnimation:YES];
        }else{//已经是最后一个句子
            
        }
    }else{//当前大题中没有句子
        [self updateFirstSentence];
    }
    
}
///切换到第一大题
-(void)updateFirstHomework{
    if (!self.readingHomeworksArr || self.readingHomeworksArr.count <= 0) {
        if (![DataService sharedService].isHistory) {
            [self loadHomeworkFromFile];
        }
    }
    if (self.readingHomeworksArr && self.readingHomeworksArr.count > 0) {
        self.currentHomework = [self.readingHomeworksArr objectAtIndex:self.currentHomeworkIndex];
    }else{//json文件中没有朗读的题目
        
    }
}

///切换到下一题
-(void)updateNextHomework{
    if (!self.currentHomework) {
        [self updateFirstHomework];
    }
    if (self.currentHomework) {
        if (self.currentHomeworkIndex+1 < self.readingHomeworksArr.count) {
            self.currentHomeworkIndex++;
            self.currentHomework.isFinished = YES;
            self.currentHomework = [self.readingHomeworksArr objectAtIndex:self.currentHomeworkIndex];
        }else{//已经是最后一个大题
        
        }
    }else{//json文件中没有朗读的题目
    
    }
}

//TODO:从json文件中加载题目数据
-(void)loadHomeworkFromFile{
    TaskObj *task = [DataService sharedService].taskObj;
    __weak ReadingTaskViewController *weakSelf = self;
    [ParseAnswerJsonFileTool parseAnswerJsonFileWithUserId:[DataService sharedService].user.userId withTask:task withReadingHistoryArray:^(NSArray *readingQuestionArr, int currentQuestionIndex, int currentQuestionItemIndex, int status, NSString *updateTime, NSString *userTime, int specifyTime,float ratio){
        ReadingTaskViewController *tempSelf = weakSelf;
        if (tempSelf) {
            HomeworkContainerController *container = (HomeworkContainerController*)tempSelf.parentViewController;
            container.spendSecond = userTime?userTime.intValue:0;
            tempSelf.currentHomeworkIndex = currentQuestionIndex < 0 ?0:currentQuestionIndex;
            tempSelf.currentSentenceIndex = currentQuestionItemIndex < 0 ?0:currentQuestionItemIndex;
            tempSelf.readingHomeworksArr = readingQuestionArr;
            tempSelf.specifiedSecond = specifyTime;
        }
    } withParseError:^(NSError *error) {
        [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
    }];
}

//TODO:上传JSON文件
- (void)uploadJSON{
    TaskObj *task = [DataService sharedService].taskObj;
    NSString *path = [NSString stringWithFormat:@"%@/%@/answer_%@.json",[Utility returnPath],task.taskStartDate,[DataService sharedService].user.userId?:@""];
    [parentVC  uploadAnswerJsonFileWithPath:path withSuccess:^(NSString *success) {
        //退出或显示成绩界面
        if (self.currentHomeworkIndex+1 >= self.readingHomeworksArr.count && self.currentSentenceIndex+1 >= self.currentHomework.readingHomeworkSentenceObjArray.count) {
            [self showResultView];
        }else{
            [parentVC dismissViewControllerAnimated:YES completion:nil];
        }
    } withFailure:^(NSString *error) {
        [Utility errorAlert:error];
        [Utility uploadFaild];
        //退出或显示成绩界面
        if (self.currentHomeworkIndex+1 >= self.readingHomeworksArr.count && self.currentSentenceIndex+1 >= self.currentHomework.readingHomeworkSentenceObjArray.count) {
            [self showResultView];
        }else{
            [parentVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}
#pragma mark --

#pragma mark 开始预听界面切换
-(void)appearPrePlayControllerWithAnimation:(BOOL)animation{
    [self.preReadingController willMoveToParentViewController:self];
    self.preReadingController.view.frame = self.view.bounds;
    [self.view addSubview:self.preReadingController.view];
    [self addChildViewController:self.preReadingController];
    [self.preReadingController didMoveToParentViewController:self];
    [parentVC.checkHomeworkButton setTitle:@"开始" forState:UIControlStateNormal];
    self.isPrePlay = YES;
    [parentVC stopTimer];
    [parentVC.reduceTimeButton setEnabled:NO];
    [self.tipBackView setHidden:YES];
}

-(void)hiddlePrePlayControllerWithAnimation:(BOOL)animation{
    [self.preReadingController willMoveToParentViewController:nil];
    [self.preReadingController.view removeFromSuperview];
    [self.preReadingController removeFromParentViewController];
    [self.preReadingController didMoveToParentViewController:nil];
    [self.preReadingController.avPlayer stop];
    [parentVC.checkHomeworkButton setTitle:@"下一题" forState:UIControlStateNormal];
    self.isPrePlay = NO;
    
    [parentVC startTimer];
    if ([DataService sharedService].number_reduceTime > 0) {
        [parentVC.reduceTimeButton setEnabled:YES];
    }
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


//TODO:显示通关界面
-(void)showResultView {
    TaskObj *task = [DataService sharedService].taskObj;
    for (HomeworkTypeObj *type in task.taskHomeworkTypeArray) {
        if (type.homeworkType == parentVC.homeworkType) {
            type.homeworkTypeIsFinished = YES;
        }
    }
    int count = 0;
    float radio = 0.0 ;
    for (ReadingHomeworkObj *homework in self.readingHomeworksArr) {
        for (ReadingSentenceObj *sentence in homework.readingHomeworkSentenceObjArray) {
            count++;
            radio += sentence.readingSentenceRatio.floatValue;
        }
    }
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"TenSecChallengeResultView" owner:self options:nil];
    self.resultView = (TenSecChallengeResultView *)[viewArray objectAtIndex:0];
    self.resultView.delegate = self;
    self.resultView.timeCount = parentVC.spendSecond;
    self.resultView.ratio = radio/count*100;
    if (self.isFirst == YES) {
        self.resultView.resultBgView.hidden=NO;
        self.resultView.noneArchiveView.hidden=YES;
        
        self.resultView.timeLimit = self.specifiedSecond;
        self.resultView.isEarly = [Utility compareTime];
    }else {
        self.resultView.noneArchiveView.hidden=NO;
        self.resultView.resultBgView.hidden=YES;
    }
    
    [self.resultView initView];
    
    [self.view addSubview: self.resultView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:开始识别语音
- (IBAction)readingButtonClicked:(id)sender {
    
    bool ret = [_iFlySpeechRecognizer startListening];
    if (ret) {
        NSLog(@"111");
    }else {
        [_popUpView setText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束
        [self.view addSubview:_popUpView];
    }
    //////
    if (self.isReading) {

        [self.readingButton setEnabled:YES];
        self.isReading = NO;
        [self.listeningButton setUserInteractionEnabled:YES];
        
    }else{
        self.isReading = NO;
        [self.listeningButton setUserInteractionEnabled:YES];
    }
}


//TODO:开始播放音频，如果没有就tts
- (IBAction)listeningButtonClicked:(id)sender {
    if (self.isListening) {
        if (self.avPlayer.isPlaying) {
            [self.avPlayer stop];
        }
    }else{
        if (self.currentSentence.readingSentenceLocalFileURL) {
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
//TODO:更新所有的位置
-(void)updateAllFrame{
    NSAttributedString *attributeString = self.readingTextView.attributedText;
    NSAttributedString *attributeTip = self.tipTextView.attributedText;
    if (!attributeString) {
        return ;
    }
    CGRect textRect = [attributeString boundingRectWithSize:(CGSize){CGRectGetWidth(self.readingTextView.frame),self.view.frame.size.height-350} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading context:nil];
    self.readingTextView.frame = (CGRect){self.readingTextView.frame.origin,CGRectGetWidth(self.readingTextView.frame),textRect.size.height};
    
    float maxTipHeight = (self.view.frame.size.height-CGRectGetMaxY(self.readingTextView.frame)-30);
    CGRect tipRect = [attributeTip boundingRectWithSize:(CGSize){CGRectGetWidth(self.tipBackView.frame), maxTipHeight<100 ?100:maxTipHeight} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading context:nil];
    
    self.readingButton.frame = (CGRect){CGRectGetMinX(self.readingButton.frame),CGRectGetMaxY(self.readingButton.frame)+20,self.readingButton.frame.size};
    
    self.tipBackView.frame = (CGRect){CGRectGetMinX(self.tipBackView.frame),CGRectGetMaxY(self.readingButton.frame) +30,self.tipBackView.frame.size.width,tipRect.size.height+40};
}

///标记颜色
-(void)markErrorColorRangeForArr:(NSArray*)rangeArray{

}

#pragma mark --

#pragma mark TenSecChallengeResultViewDelegate显示结果代理
-(void)resultViewCommitButtonClicked {//确认完成
    [self.resultView removeFromSuperview];
    [parentVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)resultViewRestartButtonClicked {//再次挑战
    [self.resultView removeFromSuperview];
    
    parentVC.checkHomeworkButton.enabled=YES;
    parentVC.spendSecond = 0;
    self.currentHomework = nil;
    self.currentSentence = nil;
    self.currentSentenceIndex = 0;
    self.currentHomeworkIndex = 0;
    self.readingHomeworksArr = nil;
    [self updateFirstSentence];
    self.isFirst = NO;
    [self appearPrePlayControllerWithAnimation:YES];
}
#pragma mark --

#pragma mark AVAudioPlayerDelegate 播放代理
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    self.isListening = NO;
    [self.readingButton setUserInteractionEnabled:YES];
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{}
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{}
#pragma mark --

#pragma mark property

-(void)setIsPrePlay:(BOOL)isPrePlay{
    _isPrePlay = isPrePlay;
    if (isPrePlay) {
        [parentVC.reduceTimeButton setEnabled:NO];
    }else{
        int timeCount = [DataService sharedService].number_reduceTime;
        if (timeCount <= 0) {
            [parentVC.reduceTimeButton setEnabled:NO];
        }else{
            [parentVC.reduceTimeButton setEnabled:YES];
        }
    }
}

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

//TODO:载入新句子
-(void)setCurrentSentence:(ReadingSentenceObj *)currentSentence{
    _currentSentence = currentSentence;
    if (currentSentence) {
        if ([DataService sharedService].isHistory) {
            NSMutableString *content = [NSMutableString stringWithFormat:@"需要多读的词"];
            for (NSString *errorWord in currentSentence.readingErrorWordArray) {
                [content appendString:@"\n"];
                [content appendString:errorWord];
            }
            NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:content];
            [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, content.length)];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.alignment = NSTextAlignmentCenter;
            [attriString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
            self.tipTextView.attributedText = attriString;
        }
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:currentSentence.readingSentenceContent];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, attri.length)];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, attri.length)];
        self.readingTextView.attributedText = attri;
         [self updateAllFrame];
    }
   
}

#pragma mark -- UIAlert Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *choice = [alertView buttonTitleAtIndex:buttonIndex];
    if ([choice isEqualToString:@"退出"]) {
        [self quitNow];
    }else if ([choice isEqualToString:@"取消"]){
        
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate: nil];
}
#pragma mark --
#pragma mark - IFlySpeechRecognizerDelegate
/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @see
 */
- (void) onVolumeChanged: (int)volume
{
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    [_popUpView setText: vol];
    [self.view addSubview:_popUpView];
}

/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *) error
{
    
    [parentVC stopTimer];
    NSString *text ;
    if (error.errorCode ==0 ) {
        text = @"识别成功";
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
    }
    [_popUpView setText: text];
    [self.view addSubview:_popUpView];
}

/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results
{
    [parentVC stopTimer];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [results objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSLog(@"听写结果：%@",result);
    [_iFlySpeechRecognizer cancel];
    [parentVC stopTimer];
    TaskObj *task = [DataService sharedService].taskObj;
    NSString *path = [NSString stringWithFormat:@"%@/%@/answer_%@.json",[Utility returnPath],task.taskStartDate,[DataService sharedService].user.userId?:@""];
    [DRSentenceSpellMatch checkSentence:self.currentSentence.readingSentenceContent withSpellMatchSentence:result andSpellMatchAttributeString:^(NSAttributedString *spellAttriString,float matchScore,NSArray *errorWordArray) {
        self.readingTextView.attributedText = nil;
        self.readingTextView.attributedText = spellAttriString;
        self.readingCount++;
        self.currentSentence.readingErrorWordArray = [NSMutableArray arrayWithArray:errorWordArray];
        self.currentSentence.readingSentenceRatio = [NSString stringWithFormat:@"%0.2f",matchScore];
        [self.tipBackView setHidden:NO];
        NSString *tip = @"";
        if (matchScore >= 0.5) {
            tip = @"你的发音真的很不错哦,让我们再来读读其它的句子吧！";
        }else
        {
            tip = @"看到红色的这些词了吗,你的发音还不够标准哦,在来试试吧！";
        }
        if (self.readingCount <= 1 && self.isFirst) {//计入成绩
            __weak ReadingTaskViewController *weakSelf = self;
            self.currentSentence.isFinished = YES;
            if (self.currentSentenceIndex == self.currentHomework.readingHomeworkSentenceObjArray.count-1) {
                self.currentHomework.isFinished = YES;
            }
            [ParseAnswerJsonFileTool writeReadingHomeworkToJsonFile:path withUseTime:[NSString stringWithFormat:@"%llu",parentVC.spendSecond] withQuestionIndex:self.currentHomeworkIndex withQuestionItemIndex:self.currentSentenceIndex withReadingHomworkArr:self.readingHomeworksArr withSuccess:^{
                ReadingTaskViewController *tempSelf = weakSelf ;
                if (tempSelf) {
                    isCanUpLoad = YES;
                }
            } withFailure:^(NSError *error) {
                ReadingTaskViewController *tempSelf = weakSelf ;
                if (tempSelf) {
                    [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
                }
            }];
        }
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:tip];
        [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0,tip.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        [attriString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,tip.length)];
        self.tipTextView.attributedText = attriString;
        [self updateAllFrame];
        [parentVC startTimer];
    } orSpellMatchFailure:^(NSError *error) {
        [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
        [parentVC startTimer];
    }];
}


@end
