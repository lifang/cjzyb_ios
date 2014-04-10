//
//  TenSecChallengeViewController.m
//  cjzyb_ios
//
//  Created by apple on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TenSecChallengeViewController.h"
#import "LHLTestInterface.h"
#import "HomeworkContainerController.h"

#define parentVC ((HomeworkContainerController *)[self parentViewController])

@interface TenSecChallengeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *upperOptionLabel;  //上选项
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;  //问题
@property (weak, nonatomic) IBOutlet UILabel *lowerOptionLabel;  //下选项
@property (weak, nonatomic) IBOutlet UIImageView *countDownImageView;  //题目序号
@property (weak, nonatomic) IBOutlet UIButton *upperButton;
@property (weak, nonatomic) IBOutlet UIButton *lowerButton;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UILabel *historyYourChoiceLabel;


@property (assign,nonatomic) NSInteger currentNO;//当前正在做的题目序号,如超过问题数量代表答题完毕
@property (strong,nonatomic) TenSecChallengeObject *currentQuestion; //当前题目
@property (assign,nonatomic) BOOL isLastQuestion; //是否最后一题
@property (strong,nonatomic) NSArray *questionNumberImages; //题号图片数组
@property (strong,nonatomic) NSMutableArray *answerArray; //选择的答案
@property (strong,nonatomic) NSDictionary *answerJSONDic; //从文件中读取的answerJSON字典
@property (assign,nonatomic) NSInteger lastTimeCurrentNO;  //文件中记载的答题记录
@property (strong,nonatomic) NSString *answerStatus;    //文件中记载的完成状态
@property (assign,nonatomic) BOOL isReDoingChallenge; //是否为重新挑战
@property (assign,nonatomic) BOOL shouldUploadJSON;  //是否需要上传JSON  (于保存answerJSON时置真)
@property (assign,nonatomic) BOOL haveUploadedJSON; //是否已上传JSON
//@property (assign,nonatomic) BOOL runningWithoutAnswer; //进入未做过的历史题时,标记的状态
@property (strong,nonatomic) NSUserDefaults *userDefaults;
@end

@implementation TenSecChallengeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isViewingHistory = NO;
        self.isReDoingChallenge = NO;
        self.shouldUploadJSON = NO;
        self.haveUploadedJSON = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    
    [self setupData];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

///控件初始设置
- (void)setupViews{
    self.upperOptionLabel.layer.cornerRadius = 8.0;
    
    [self.upperButton addTarget:self action:@selector(upperClicked:) forControlEvents:UIControlEventTouchDown];
    
    self.lowerOptionLabel.layer.cornerRadius = 8.0;
    
    [self.lowerButton addTarget:self action:@selector(lowerClicked:) forControlEvents:UIControlEventTouchDown];
    
    self.historyView.hidden = YES;
    
    self.upperOptionLabel.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
    
    self.lowerOptionLabel.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
}

///准备数据
- (void)setupData{
    //载入question文件
    self.questionArray = [NSMutableArray arrayWithArray:[TenSecChallengeObject parseTenSecQuestionsFromFile]];
    
    //载入answer文件
    [self parseAnswerDic:[Utility returnAnswerDictionaryWithName:@"time_limit" andDate:[DataService sharedService].taskObj.taskStartDate]];
    if ([DataService sharedService].taskObj.isExpire) {
        self.answerStatus = @"1";
    }
    
    
    //重新挑战次数
    if (![self.userDefaults stringForKey:@"reChallengeTimesLeft"]) {
        [self.userDefaults setObject:@"3" forKey:@"reChallengeTimesLeft"];
    }
}

#pragma mark -- 挑战的生命周期
///判断本界面的行为方式,并做初始化
- (void)startChallenge{
    if (self.isViewingHistory) {  //浏览历史
        self.currentNO = 0;
        self.historyView.hidden = NO;
        self.historyView.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
        [self handleAnyView:self.upperButton];
        [self handleAnyView:self.lowerButton];
        [self handleAnyView:self.upperOptionLabel];
        [self handleAnyView:self.lowerOptionLabel];
        [self handleAnyView:self.questionLabel];
        
        NSInteger ratio = 0;
        for (int i = 0; i < self.answerArray.count; i ++) {
            OrdinaryAnswerObject *answer = self.answerArray[i];
            if ([answer.answerRatio isEqualToString:@"100"]) {
                ratio += 10;
            }
        }
        parentVC.rotioLabel.text = [NSString stringWithFormat:@"%d%@",ratio,@"%"];
        
        NSInteger second = (NSInteger)parentVC.spendSecond;
        NSInteger minite = second / 60;
        second = second % 60;
        parentVC.timeLabel.text = [NSString stringWithFormat:@"%d'%d\"",minite,second];
    }else{
        if ([self.answerStatus isEqualToString:@"1"]) { //重新做题  ,此时应判断是否有重新做题的剩余次数
            self.isReDoingChallenge = YES;
            NSString * timesLeft = [self.userDefaults stringForKey:@"reChallengeTimesLeft"];
            if (timesLeft.integerValue < 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"今日挑战次数已经用完" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil];
                dispatch_async(dispatch_get_main_queue(),^{
                    [alert show];
                });
                self.upperButton.enabled = NO;
                self.lowerButton.enabled = NO;
                [parentVC stopTimer];
                return;
            }else{
                [self.userDefaults setObject:[NSString stringWithFormat:@"%d",timesLeft.integerValue - 1] forKey:@"reChallengeTimesLeft"];
                [self.userDefaults synchronize];
            }
            parentVC.spendSecond = 0;
            self.currentNO = 0;
            self.answerArray = [NSMutableArray array];
        }else{ //继续做题(第一遍做题)
            [self.userDefaults setObject:@"3" forKey:@"reChallengeTimesLeft"];
            [self.userDefaults synchronize];
            if (self.lastTimeCurrentNO > 1) {
                self.currentNO = self.lastTimeCurrentNO;
            }
        }
        [parentVC startTimer];
    }
    self.isLastQuestion = NO;
    [self showNextQuestion];
}

- (void)pauseChallenge{
    [parentVC stopTimer];
}

- (void)finishChallenge{
    //显示结果界面
    [self.view addSubview:self.resultView];
    if (self.isReDoingChallenge) {
        self.resultView.resultBgView.hidden = YES;
        self.resultView.noneArchiveView.hidden = NO;
    }else{
        self.resultView.resultBgView.hidden = NO;
        self.resultView.noneArchiveView.hidden = YES;
    }
    [self makeResult];
    
    self.answerStatus = @"1";
}

- (void)makeResult{
    //向系统标志本题完成
    for (HomeworkTypeObj *type in [DataService sharedService].taskObj.taskHomeworkTypeArray) {
        if (type.homeworkType == parentVC.homeworkType) {
            type.homeworkTypeIsFinished = YES;
        }
    }
    //准确率,耗时,提交时间  判断精准/迅速/捷足成就  显示结果界面
    NSInteger numberOfRightAnswers = 0;
    if (self.answerArray.count == self.questionArray.count) {
        for (int i = 0; i < self.answerArray.count; i ++) {
            OrdinaryAnswerObject *answer = self.answerArray[i];
            if ([answer.answerRatio isEqualToString:@"100"]) {
                numberOfRightAnswers ++;
            }
        }
        NSInteger percentOfRightAnswers = numberOfRightAnswers * 10; //正确率
        self.resultView.ratio = percentOfRightAnswers;
        
        self.resultView.timeCount = (NSInteger)(parentVC.spendSecond);
        
        TenSecChallengeObject *question = [self.questionArray firstObject];
        
        self.resultView.timeLimit = question.tenTimeLimit.integerValue;
        
        if ([Utility compareTime]) {
            self.resultView.isEarly = YES;
        }else{
            self.resultView.isEarly = NO;
        }
        
        self.resultView.challengeTimesLeft = [NSString stringWithFormat:@"%@",[self.userDefaults stringForKey:@"reChallengeTimesLeft"]];
        
        [self.resultView initView];
    }else{
        [Utility errorAlert:@"题目与答案不匹配!"];
    }
}

///保存挑战数据(上传JSON) ,成功则显示结果
- (void)uploadJSON{
    NSString *answerJSONPath = [[DataService sharedService].taskObj.taskFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"answer_%@.json",[DataService sharedService].user.userId]];
    [parentVC uploadAnswerJsonFileWithPath:answerJSONPath withSuccess:^(NSString *success) {
        self.haveUploadedJSON = YES;
        //如果已完成就显示结果
        if (self.answerArray.count == self.questionArray.count) {
            [self finishChallenge];
        }else{
            [self quitNow:nil];
        }
    } withFailure:^(NSString *error) {
        [Utility errorAlert:error];
        [Utility uploadFaild];
        //如果已完成就显示结果
        if (self.answerArray.count == self.questionArray.count) {
            [self finishChallenge];
        }else{
            [self quitNow:nil];
        }
    }];
}

- (NSDictionary *)makeAnswerJSON{
    //按照answer.js的格式制作一个字典,并保存
    NSMutableDictionary *answerDic = [[NSMutableDictionary alloc] init];
    [answerDic setObject:(self.currentNO >= self.questionArray.count ? @"1" : @"0") forKey:@"status"];//完成情况
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    [answerDic setObject:nowDate forKey:@"update_time"];
    [answerDic setObject:@"1" forKey:@"questions_item"];
    [answerDic setObject:[NSString stringWithFormat:@"%d",self.currentNO] forKey:@"branch_item"];  //小题索引,即当前已完成的题
    
    [answerDic setObject:[NSString stringWithFormat:@"%d",(NSInteger)parentVC.spendSecond] forKey:@"use_time"];   //用时
        NSMutableArray *questions = [NSMutableArray array];
        NSMutableDictionary *questionDic = [[NSMutableDictionary alloc] init];
        TenSecChallengeObject *anyQuestion = [self.questionArray firstObject];
        [questionDic setObject:anyQuestion.tenBigID forKey:@"id"];  //每个question中都含有大题号
            NSMutableArray *branches = [NSMutableArray array];
            for (int i = 0; i < self.answerArray.count; i ++) {
                OrdinaryAnswerObject *answer = self.answerArray[i];
                NSMutableDictionary *branchDic = [[NSMutableDictionary alloc] init];
                [branchDic setObject:answer.answerID forKey:@"id"];
                [branchDic setObject:answer.answerAnswer forKey:@"answer"];
                [branchDic setObject:answer.answerRatio forKey:@"ratio"]; //正确:对-100  错-0
                if ([answer.answerRatio isEqualToString:@"0"]) {
                    [DataService sharedService].cardsCount ++;
                }
                [branches addObject:branchDic];
            }
    
        [questionDic setObject:branches forKey:@"branch_questions"];
        [questions addObject:questionDic];
    [answerDic setObject:questions forKey:@"questions"];
    
    //保存JSON
    [Utility returnAnswerPathWithDictionary:[NSDictionary dictionaryWithDictionary:answerDic] andName:@"time_limit" andDate:[DataService sharedService].taskObj.taskStartDate];
    self.shouldUploadJSON = YES;

    return [NSDictionary dictionaryWithDictionary:answerDic];
}

#pragma mark --按钮响应
- (void)upperClicked:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.answerArray.count < self.questionArray.count) {
            OrdinaryAnswerObject *answer = [[OrdinaryAnswerObject alloc] init];
            answer.answerID = self.currentQuestion.tenID;
            answer.answerAnswer = self.upperOptionLabel.text;
            answer.answerRatio = [self.upperOptionLabel.text isEqualToString:self.currentQuestion.tenRightAnswer] ? @"100" : @"0";
            [self.answerArray addObject:answer];
            if (!self.isReDoingChallenge) {
                [self makeAnswerJSON];
            }
        }
        self.upperOptionLabel.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:207.0/255.0 blue:143.0/255.0 alpha:1.0];
        self.upperButton.enabled = NO;
        self.lowerButton.enabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.upperButton.alpha = self.upperButton.alpha > 0.5 ? 0.5 : 1;
        } completion:^(BOOL finished) {
            self.upperOptionLabel.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
            self.lowerOptionLabel.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
            if (self.isLastQuestion) {
                //终止计时
                [parentVC stopTimer];
                
                if (self.isReDoingChallenge) {
                    [self finishChallenge];
                }else{
                    [self uploadJSON];
                }
                
                self.currentNO = self.questionArray.count + 1; //标志答题结束
            }else{
                [self showNextQuestion];
            }
        }];
    });
}

- (void)lowerClicked:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.answerArray.count < self.questionArray.count) {
            OrdinaryAnswerObject *answer = [[OrdinaryAnswerObject alloc] init];
            answer.answerID = self.currentQuestion.tenID;
            answer.answerAnswer = self.lowerOptionLabel.text;
            answer.answerRatio = [self.lowerOptionLabel.text isEqualToString:self.currentQuestion.tenRightAnswer] ? @"100" : @"0";
            [self.answerArray addObject:answer];
            if (!self.isReDoingChallenge) {
                [self makeAnswerJSON];
            }
        }
        self.lowerOptionLabel.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:207.0/255.0 blue:143.0/255.0 alpha:1.0];
        self.upperButton.enabled = NO;
        self.lowerButton.enabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.upperButton.alpha = self.upperButton.alpha > 0.5 ? 0.5 : 1;
        } completion:^(BOOL finished) {
            self.upperOptionLabel.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
            self.lowerOptionLabel.backgroundColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
            if (self.isLastQuestion) {
                //终止计时
                [parentVC stopTimer];
                
                if (self.isReDoingChallenge) {
                    [self finishChallenge];
                }else{
                    [self uploadJSON];
                }
                self.currentNO = self.questionArray.count + 1; //标志答题结束
            }else{
                [self showNextQuestion];
            }
        }];
    });
}

///点击parentVC的退出按钮触发
-(void)tenQuitButtonClicked:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确认退出挑战?" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"取消", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

-(void)quitNow:(id)sender{
    if (self.haveUploadedJSON || self.isReDoingChallenge || self.isViewingHistory || !self.shouldUploadJSON) {
        [parentVC dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self uploadJSON];
    }
}

#pragma mark -- action

-(void)parseAnswerDic:(NSMutableDictionary *)dicc{
    self.answerArray = [NSMutableArray array];
    if (!dicc || ![dicc objectForKey:@"status"]) {
        return;
    }
    self.answerStatus = [dicc objectForKey:@"status"];  //解析状态,已答题时间,题号,答案
    parentVC.spendSecond = [(NSString *)[dicc objectForKey:@"use_time"] longLongValue];
    self.lastTimeCurrentNO = [(NSString *)[dicc objectForKey:@"branch_item"] integerValue];
    NSArray *questionsArray = [dicc objectForKey:@"questions"];
    NSDictionary *bigQuestion = [questionsArray firstObject];
    if (bigQuestion) {
        NSArray *branchQuestionsArray = [bigQuestion objectForKey:@"branch_questions"];
        for (NSInteger i = 0; i < branchQuestionsArray.count; i ++) {
            NSDictionary *branchQuestionDic = branchQuestionsArray[i];
            OrdinaryAnswerObject *answer = [[OrdinaryAnswerObject alloc] init];
            answer.answerID = [branchQuestionDic objectForKey:@"id"];
            answer.answerAnswer = [branchQuestionDic objectForKey:@"answer"];
            answer.answerRatio = [branchQuestionDic objectForKey:@"ratio"];
            
            [self.answerArray addObject:answer];
        }
    }
}

//显示当前题目的正确答案,使用道具/浏览历史时调用
-(void)showRightAnswer{
    if([_currentQuestion.tenRightAnswer isEqualToString:self.upperOptionLabel.text]){
        self.upperOptionLabel.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:200.0/255.0 blue:124.0/255.0 alpha:1.0];
        self.lowerOptionLabel.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:55.0/255.0 blue:65.0/255.0 alpha:1.0];
    }else{
        self.upperOptionLabel.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:55.0/255.0 blue:65.0/255.0 alpha:1.0];
        self.lowerOptionLabel.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:200.0/255.0 blue:124.0/255.0 alpha:1.0];
    }
}

//显示当前题目的历史答案,浏览历史时调用
-(void)showHistoryAnswer{
    if (self.currentNO < self.answerArray.count) {
        OrdinaryAnswerObject *answer = self.answerArray[self.currentNO];
        self.historyYourChoiceLabel.text = [NSString stringWithFormat:@"你的答案:%@",answer.answerAnswer];
    }else{
//        [Utility errorAlert:@"历史答案错误!"];
        self.historyYourChoiceLabel.text = @"未完成本小题";
    }
}

//比对当前时间是否早于给定时间
-(BOOL)compareNowWithTime:(NSString *) time{
    //获取当前时间
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:time];
    if (now == [now earlierDate:timeDate]) {
        return YES;
    }
    return NO;
}

//每调用一次,读取下一道题目
- (void) showNextQuestion{
    if (self.questionArray.count > 0) {
        if (self.currentNO < self.questionArray.count) {
            self.upperButton.enabled = YES;
            self.lowerButton.enabled = YES;
            self.currentQuestion = self.questionArray[self.currentNO];
            if (self.currentNO < self.questionNumberImages.count) {
                self.countDownImageView.image = self.questionNumberImages[self.currentNO];
            }
            self.currentNO ++;
        }
        
        if (self.currentNO == self.questionArray.count) {
            self.isLastQuestion = YES;
            [parentVC.checkHomeworkButton setTitle:@"完成" forState:UIControlStateNormal];
            [parentVC.checkHomeworkButton addTarget:self action:@selector(resultViewCommitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        [Utility errorAlert:@"未成功获取题目!"];
    }
}

//调整某个label的字体,使其适合长度
- (void)handleLabelFont:(UILabel *)label withBeginningSize:(CGFloat)size{
    UIFont *font = [UIFont systemFontOfSize:size];
    label.numberOfLines = 0;
    for (CGFloat fontSize = font.pointSize; fontSize > 14; fontSize -- ) {
        CGSize size = [Utility getTextSizeWithString:label.text withFont:[UIFont systemFontOfSize:fontSize]];
        if (size.width < label.frame.size.width - 8) {
            label.font = [UIFont systemFontOfSize:fontSize];
            break;
        }
        if (fontSize <= 15) {
            label.font = [UIFont systemFontOfSize:fontSize];
        }
    }
}

///把某个view向上移动97
- (void)handleAnyView:(UIView *)view{
    view.center = (CGPoint){view.center.x,view.center.y - 97};
}

#pragma mark -- property
- (NSUserDefaults *)userDefaults{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (NSArray *)questionNumberImages{
    if (!_questionNumberImages || _questionNumberImages.count < 1) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 1; i <= 9; i ++) {
            NSString *docName = [NSString stringWithFormat:@"10_0%i",i];
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",docName]];
            [array addObject:img];
        }
        UIImage *img = [UIImage imageNamed:@"10_10.png"];
        [array addObject:img];
        
        _questionNumberImages = [NSArray arrayWithArray:array];
    }
    return _questionNumberImages;
}

//界面上显示题目的时机在此
- (void)setCurrentQuestion:(TenSecChallengeObject *)currentQuestion{
    if (currentQuestion) {
        _currentQuestion = currentQuestion;
        self.upperOptionLabel.text = currentQuestion.tenAnswerOne;
        [self handleLabelFont:self.upperOptionLabel withBeginningSize:80.];
        self.lowerOptionLabel.text = currentQuestion.tenAnswerTwo;
        [self handleLabelFont:self.lowerOptionLabel withBeginningSize:80.];
        self.questionLabel.text = currentQuestion.tenQuestionContent;
        [self handleLabelFont:self.questionLabel withBeginningSize:38.];
        
        //显示历史数据
        if (self.isViewingHistory) {
            self.upperButton.enabled = NO;
            self.lowerButton.enabled = NO;
            [self showRightAnswer];
            [self showHistoryAnswer];
        }
    }
}

- (TenSecChallengeResultView *)resultView{
    if (!_resultView) {
        _resultView = [[[NSBundle mainBundle]loadNibNamed:@"TenSecChallengeResultView" owner:self options:nil] lastObject];
        _resultView.delegate = self;
    }
    return _resultView;
}

#pragma mark ResultView Delegate
- (void)resultViewCommitButtonClicked{
    [self.resultView removeFromSuperview];
    self.resultView = nil;
    [self quitNow:nil];
}

- (void)resultViewRestartButtonClicked{
    [self startChallenge];
    [self.resultView removeFromSuperview];
    self.resultView = nil;
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"抱歉"]) {
        //挑战次数用完
        [parentVC dismissViewControllerAnimated:YES completion:nil];
    }else if ([alertView.title isEqualToString:@"警告"]){
        //退出警告
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"退出"]) {
            [self quitNow:nil];
            return;
        }
        if ([title isEqualToString:@"取消"]) {
            return;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
