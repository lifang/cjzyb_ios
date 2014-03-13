//
//  TenSecChallengeViewController.m
//  cjzyb_ios
//
//  Created by apple on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TenSecChallengeViewController.h"
#import "LHLTestInterface.h"

@interface TenSecChallengeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton; //返回键
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;     //顶部时间
@property (weak, nonatomic) IBOutlet UILabel *upperOptionLabel;  //上选项
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;  //问题
@property (weak, nonatomic) IBOutlet UILabel *lowerOptionLabel;  //下选项
@property (weak, nonatomic) IBOutlet UIImageView *countDownImageView;  //题目序号
@property (weak, nonatomic) IBOutlet UIButton *upperButton;
@property (weak, nonatomic) IBOutlet UIButton *lowerButton;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UILabel *historyYourChoiceLabel;
@property (assign,nonatomic) double timeCount; //计时时间(单位为秒)
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) NSInteger currentNO;//当前正在做的题目序号,如超过问题数量代表答题完毕
@property (strong,nonatomic) TenSecChallengeObject *currentQuestion; //当前题目
@property (assign,nonatomic) BOOL isLastQuestion; //是否最后一题
@property (strong,nonatomic) NSArray *questionNumberImages; //题号图片数组
@property (strong,nonatomic) NSMutableArray *answerArray; //选择的答案
@property (strong,nonatomic) NSString *homeworkFinishTime; //今日作业提交时间期限
@property (strong,nonatomic) NSDictionary *answerJSONDic; //从文件中读取的answerJSON字典
@property (assign,nonatomic) NSInteger lastTimeCurrentNO;  //文件中记载的答题记录
@property (strong,nonatomic) NSString *answerStatus;    //文件中记载的完成状态
@property (assign,nonatomic) BOOL isReDoingChallenge; //是否为重新挑战
@end

@implementation TenSecChallengeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isViewingHistory = NO;
        self.isReDoingChallenge = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    
    //载入question文件
    self.questionArray = [NSMutableArray arrayWithArray:[TenSecChallengeObject parseTenSecQuestionsFromFile]];
    
    //载入answer文件
    [self parseAnswerJSON];
    
    [self startChallenge];//到时此方法由外部调用
    
    //获取今日作业截止时间
    [self fetchHomeworkFinishTime];
}

- (void)setupViews{  //控件初始设置
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.upperOptionLabel.layer.cornerRadius = 8.0;
    
    [self.upperButton addTarget:self action:@selector(upperClicked:) forControlEvents:UIControlEventTouchDown];
    
    self.lowerOptionLabel.layer.cornerRadius = 8.0;
    
    [self.lowerButton addTarget:self action:@selector(lowerClicked:) forControlEvents:UIControlEventTouchDown];
    
    self.historyView.hidden = YES;
}

#pragma mark -- 挑战的生命周期
//判断本界面的行为方式,并做初始化
- (void)startChallenge{
    if (self.isViewingHistory) {  //浏览历史
        self.currentNO = 0;
        self.historyView.hidden = NO;
        //上方动作条添加"下一个"按钮
    }else{
        if ([self.answerStatus isEqualToString:@"1"]) { //重新做题
            self.timeCount = 0;
            self.isReDoingChallenge = YES;
            self.currentNO = 0;
            self.answerArray = [NSMutableArray array];
        }else{ //继续做题
            self.currentNO = self.lastTimeCurrentNO - 1;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
    self.isLastQuestion = NO;
    [self showNextQuestion];
}

- (void)pauseChallenge{
    [self.timer invalidate];
}

- (void)finishChallenge{
    //终止计时
    [self.timer invalidate];
    //计算成绩
    //保存挑战数据
    //显示结果界面
    [self.view addSubview:self.resultView];
    [self makeResult];
    self.answerStatus = @"1";
}

- (void)makeResult{
    //准确率,耗时,提交时间  判断精准/迅速/捷足成就
    NSInteger numberOfRightAnswers = 0;
    if (self.answerArray.count == self.questionArray.count) {
        for (int i = 0; i < self.answerArray.count; i ++) {
            OrdinaryAnswerObject *answer = self.answerArray[i];
            if ([answer.answerRatio isEqualToString:@"100"]) {
                numberOfRightAnswers ++;
            }
        }
        NSInteger percentOfRightAnswers = numberOfRightAnswers * 10; //正确率
        self.resultView.correctPersent.text = [NSString stringWithFormat:@"正确率: %i%@",percentOfRightAnswers,@"%"];
        self.resultView.timeLabel.text = [NSString stringWithFormat:@"用时: %@",self.timeLabel.text];
        
        if (percentOfRightAnswers < 100) {
            self.resultView.accuracyAchievementLabel.text = [NSString stringWithFormat:@"好可惜没有全对哦,不能拿到精准得分哦!"];
        }else{
            self.resultView.accuracyAchievementLabel.text = [NSString stringWithFormat:@"所有题目全部正确!<精准>成就加10分!"];
        }
        
        TenSecChallengeObject *question = [self.questionArray firstObject];
        if (self.timeCount <= [question.tenTimeLimit floatValue]) {
            //迅速成就
            self.resultView.fastAchievementLabel.text = [NSString stringWithFormat:@"恭喜你的用时在%@秒内,<迅速>成就加10分!",question.tenTimeLimit];
        }else{
            self.resultView.fastAchievementLabel.text = [NSString stringWithFormat:@"你的用时超过了%@秒,不能拿到迅速得分哦!",question.tenTimeLimit];
        }
        
        //捷足成就
        if ([self compareNowWithTime:self.homeworkFinishTime]) {
            self.resultView.earlyAchievementLabel.text = [NSString stringWithFormat:@"恭喜你在截止时间提前两小时完成作业,<捷足>成就加10分!"];
        }else{
            self.resultView.earlyAchievementLabel.text = [NSString stringWithFormat:@"未能在截止时间提前两小时完成作业,不能拿到捷足得分哦!"];
        }
    }else{
        [Utility errorAlert:@"题目与答案不匹配!"];
    }
}

- (NSDictionary *)makeAnswerJSON{
    //按照answer.js的格式制作一个字典
    NSMutableDictionary *answerDic = [[NSMutableDictionary alloc] init];
    [answerDic setObject:(self.currentNO > self.questionArray.count ? @"1" : @"0") forKey:@"status"];//完成情况
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    [answerDic setObject:nowDate forKey:@"update_time"];
    [answerDic setObject:@"1" forKey:@"questions_item"];//大题索引  ,在十速挑战中无用,暂用来存答题开始时间
    [answerDic setObject:[NSString stringWithFormat:@"%d",self.currentNO] forKey:@"branch_item"];  //小题索引,即当前做的题
    
    [answerDic setObject:[NSString stringWithFormat:@"%d",(NSInteger)self.timeCount] forKey:@"use_time"];   //用时
        NSMutableArray *questions = [NSMutableArray array];
        NSMutableDictionary *questionDic = [[NSMutableDictionary alloc] init];
        TenSecChallengeObject *anyQuestion = [self.questionArray firstObject];
        [questionDic setObject:anyQuestion.tenBigID forKey:@"id"];  //每个question中都含有大题号
            NSMutableArray *branches = [NSMutableArray array];
            for (int i = 0; i < self.answerArray.count; i ++) {
//                TenSecChallengeObject *question = self.questionArray[i];
                OrdinaryAnswerObject *answer = self.answerArray[i];
                NSMutableDictionary *branchDic = [[NSMutableDictionary alloc] init];
                [branchDic setObject:answer.answerID forKey:@"id"];
                [branchDic setObject:answer.answerAnswer forKey:@"answer"];
                [branchDic setObject:answer.answerRatio forKey:@"ratio"]; //正确:对-100  错-0
                [branches addObject:branchDic];
            }
    
        [questionDic setObject:branches forKey:@"branch_questions"];
        [questions addObject:questionDic];
    [answerDic setObject:questions forKey:@"questions"];
    
    return [NSDictionary dictionaryWithDictionary:answerDic];
}

#pragma mark --按钮响应
- (void)cancelButtonClicked:(id)sender{
    
}

- (void)upperClicked:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.answerArray.count < self.questionArray.count) {
            OrdinaryAnswerObject *answer = [[OrdinaryAnswerObject alloc] init];
            answer.answerID = self.currentQuestion.tenID;
            answer.answerAnswer = self.upperOptionLabel.text;
            answer.answerRatio = [self.upperOptionLabel.text isEqualToString:self.currentQuestion.tenRightAnswer] ? @"100" : @"0";
            [self.answerArray addObject:answer];
        }
        self.upperOptionLabel.backgroundColor = [UIColor greenColor];
        self.upperButton.enabled = NO;
        self.lowerButton.enabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.upperButton.alpha = self.upperButton.alpha > 0.5 ? 0.5 : 1;
        } completion:^(BOOL finished) {
            self.upperOptionLabel.backgroundColor = [UIColor blackColor];
            self.lowerOptionLabel.backgroundColor = [UIColor blackColor];
            if (self.isLastQuestion) {
                [self finishChallenge];
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
        }
        self.lowerOptionLabel.backgroundColor = [UIColor greenColor];
        self.upperButton.enabled = NO;
        self.lowerButton.enabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.upperButton.alpha = self.upperButton.alpha > 0.5 ? 0.5 : 1;
        } completion:^(BOOL finished) {
            self.upperOptionLabel.backgroundColor = [UIColor blackColor];
            self.lowerOptionLabel.backgroundColor = [UIColor blackColor];
            if (self.isLastQuestion) {
                [self finishChallenge];
                self.currentNO = self.questionArray.count + 1; //标志答题结束
            }else{
                [self showNextQuestion];
            }
        }];
    });
}

#pragma mark -- action
//从answer.js中解析有用信息,并保存JSONDic
-(void)parseAnswerJSON{
    self.answerArray = [NSMutableArray array];
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //把path拼成真实文件路径
    
    path = [[NSBundle mainBundle] pathForResource:@"answer-1" ofType:@"js"]; //测试
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        [Utility errorAlert:@"获取answer文件失败!"];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (!dic) {
            [Utility errorAlert:@"文件格式错误!"];
            return;
        }
        self.answerJSONDic = dic;
        NSDictionary *dicc = [dic objectForKey:@"time_limit"];
        if (!dicc) { //判断是否已有十速挑战数据
            
        }else{
            self.answerStatus = [dicc objectForKey:@"status"];  //解析状态,已答题时间,题号,答案
            self.timeCount = [[dicc objectForKey:@"use_time"] doubleValue];
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
    }
}

//获取作业完成期限
-(void)fetchHomeworkFinishTime{
//    LHLTestInterface *inter = [[LHLTestInterface alloc] init];
//    inter.delegate = self;
//    
//    [inter getLHLTestDelegateWithClassId:@"1" andUserId:@"8"];
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
        self.historyYourChoiceLabel.text = answer.answerAnswer;
    }else{
        [Utility errorAlert:@"历史答案错误!"];
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

//选择了一个答案
- (void) didMadeAChoice:(NSString *)answer{
    //1,保存本次选择的结果
    //2,跳转到下一题
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
        }
        
    }else{
        [Utility errorAlert:@"未成功获取题目!"];
    }
}

//调整某个label的字体,使其适合长度
- (void)handleLabelFont:(UILabel *)label{
    UIFont *font = label.font;
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

//被计时器触发
-(void) timerFired:(NSTimer *)timer{
    self.timeCount += 0.1;
    [self refreshClock];
}

-(void)refreshClock{//跳秒
    NSInteger second = self.timeCount;
    NSInteger minite = second / 60;
    second = second % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%i'%i",(minite > 0 ? minite : 0),second];
}

#pragma mark -- property
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
        [self handleLabelFont:self.upperOptionLabel];
        self.lowerOptionLabel.text = currentQuestion.tenAnswerTwo;
        [self handleLabelFont:self.lowerOptionLabel];
        self.questionLabel.text = currentQuestion.tenQuestionContent;
        [self handleLabelFont:self.questionLabel];
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
        [_resultView initView];
    }
    return _resultView;
}

#pragma mark ResultView Delegate
- (void)resultViewCommitButtonClicked{
    [self.resultView removeFromSuperview];
    self.resultView = nil;
}

- (void)resultViewRestartButtonClicked{
    [self startChallenge];
    [self.resultView removeFromSuperview];
    self.resultView = nil;
}

#pragma mark LHLTestInterfaceDelegate
-(void) getLHLInfoDidFinished:(NSDictionary *)result{
    id tasks = [result objectForKey:@"Tasks"];
    if ([tasks isKindOfClass:[NSDictionary class]]) {
        NSString *endTime = [(NSDictionary *)tasks objectForKey:@"end_time"];
        if (endTime != nil && endTime.length > 0) {
            self.homeworkFinishTime = endTime;
        }
    }
}

-(void) getLHLInfoDidFailed:(NSString *)errorMsg{
    [Utility errorAlert:errorMsg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
