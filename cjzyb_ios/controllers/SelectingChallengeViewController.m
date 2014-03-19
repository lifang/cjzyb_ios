//
//  SelectingChallengeViewController.m
//  cjzyb_ios
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SelectingChallengeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SelectingChallengeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;  //退出按钮
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *topBarView;  //顶栏
@property (weak, nonatomic) IBOutlet UIView *contentBgView;  //正文背景
@property (weak, nonatomic) IBOutlet UIView *itemsView;   //道具背景

@property (weak, nonatomic) IBOutlet UIButton *questionPlayButton;  //声音按钮
- (IBAction)questionPlayButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *questionImageWebView;   //图片
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;          //问题题面
@property (weak, nonatomic) IBOutlet UITableView *optionTable;  //选项table
@property (weak, nonatomic) IBOutlet UIButton *nextButton;  //下一个/检查 按钮
- (IBAction)nextButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *currentNOLabel;  //当前题号  2/5
@property (weak, nonatomic) IBOutlet UIView *historyView;    //浏览历史时下方的view
@property (weak, nonatomic) IBOutlet UILabel *historyYourChoiceLabel;  //显示"你的选择:"
@property (strong,nonatomic) TenSecChallengeResultView *resultView; //结果界面
@property (strong,nonatomic) UIButton *propOfShowingAnswer; //显示答案道具
@property (strong,nonatomic) UIButton *propOfReduceTime; //时间-5道具

@property (assign,nonatomic) BOOL isViewingHistory; //当前行为类型:查看历史/做题
@property (assign,nonatomic) BOOL isReDoingChallenge;  //是否是重新做题,重新挑战
@property (assign,nonatomic) SelectingType selectingType;  //当前题目类型 填空/看图/听力
@property (assign,nonatomic) NSTimeInterval timeCount;//计时 (秒)
@property (strong,nonatomic) NSString *timeCountString; //计时的分秒显示格式
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) NSInteger currentNO;//当前正在做的题目序号,如超过问题数量代表答题完毕
@property (strong,nonatomic) SelectingChallengeObject *currentQuestion; //当前问题
@property (assign,nonatomic) BOOL isLastQuestion; //是否最后一题

@property (strong,nonatomic) NSArray *questionArray;  //问题
@property (strong,nonatomic) NSMutableArray *answerArray;   //选择的答案
@property (strong,nonatomic) NSString *homeworkFinishTime; //今日作业提交时间期限
@property (strong,nonatomic) NSDictionary *answerJSONDic; //从文件中读取的answerJSON字典
@property (assign,nonatomic) NSInteger lastTimeCurrentNO;  //文件中记载的答题记录
@property (strong,nonatomic) NSString *answerStatus;    //文件中记载的完成状态

@property (strong,nonatomic) NSMutableArray *currentSelectedOptions; //当前问题被选中的选项 (为字符串,indexPath的row数字)

@property (assign,nonatomic) NSInteger totalRatio; //正确率

@property (strong,nonatomic) AVAudioPlayer *audioPlayer; //音频播放器
@end

@implementation SelectingChallengeViewController

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
    if (!self.questionArray) {
        [Utility errorAlert:@"无法读取问题资料!"];
    }
    [self parseAnswer];
    [self getStart];
    
    [self.optionTable registerClass:[SelectingChallengeOptionCell class] forCellReuseIdentifier:@"cell"];
    self.isReDoingChallenge = NO;
    
}

#pragma mark -- 选择挑战的生命周期
/*读取answer,判断完成与否
  a,如果查看做题记录,则从第一题开始. 只支持"下一个"和"播放声音"
    查看到最后一题,可退出本界面
  b,如果做题,则从第1/第n题开始,开始计时
    点击"检查"切换到下一题
    做题结束,提交answer
*/

//解析answerJSON并保存dic,获取有用信息
- (void)parseAnswer{
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
        NSDictionary *dicc = [dic objectForKey:@"selecting"];
        if (!dicc) { //判断是否已有选择挑战数据
            [Utility errorAlert:@"尚没有选择挑战内容"];
        }else{
            self.answerStatus = [dicc objectForKey:@"status"];  //只要解析状态,已答题时间,题号  其余的不解析
            self.timeCount = [[dicc objectForKey:@"use_time"] doubleValue];
            self.lastTimeCurrentNO = [(NSString *)[dicc objectForKey:@"questions_item"] integerValue];
            
            NSArray *questions = [dicc objectForKey:@"questions"];
            if ([questions firstObject]) {
                [self.answerArray removeAllObjects];  //此处清空answerArray,注意
                for (NSInteger i = 0; i < questions.count; i ++) {
                    NSDictionary *questionDic = [questions objectAtIndex:i];
                    if ([questionDic objectForKey:@"branch_questions"]) {
                        NSArray *branches = [questionDic objectForKey:@"branch_questions"];
                        for (int k = 0; k < branches.count; k ++) {
                            NSDictionary *branch = branches[k];
                            OrdinaryAnswerObject *answer = [[OrdinaryAnswerObject alloc] init];
                            answer.answerID = [branch objectForKey:@"id"];
                            answer.answerAnswer = [branch objectForKey:@"answer"];
                            answer.answerRatio = [branch objectForKey:@"ratio"];
                            [self.answerArray addObject:answer];
                        }
                    }
                }
            }
        }
    }
}

//开始,根据答题状态决定.   (浏览历史,第一次做题,调用此方法)
- (void)getStart{
    if ([self.answerStatus isEqualToString:@"1"]) {
        [self viewHistory];
    }else{
        [self continueChallenge];
    }
}

// (重新做题不计成绩,调用此方法)
- (void)reDoingChallenge{
    self.isViewingHistory = NO;
    //改变按钮样式,及顶栏目样式
    self.propOfReduceTime.enabled = YES;
    self.propOfShowingAnswer.enabled = YES;
    [self.nextButton setImage:[UIImage imageNamed:@"选择_07.png"] forState:UIControlStateNormal];
    self.nextButton.titleLabel.text = @"检查";
    self.historyView.hidden = YES;
    
    self.currentNO = 0;
    self.timeCount = 0;
    self.answerArray = [NSMutableArray array];
    
    [self loadNextQuestion];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

//查看历史  ---初始化界面,获取数据
- (void)viewHistory{
    self.isViewingHistory = YES;
    self.currentNO = 0;
    //计算正确率
    if (self.answerArray.count > 0 && self.answerArray.count == self.questionArray.count) {
        CGFloat numberOfRightAnswers = 0;
        for (NSInteger i = 0; i < self.answerArray.count; i ++) {
            OrdinaryAnswerObject *answer = self.answerArray[i];
            if (answer.answerRatio.integerValue > 0) {
                numberOfRightAnswers ++;
            }
        }
        self.totalRatio = 100 * numberOfRightAnswers / self.answerArray.count;
    }else{
        [Utility errorAlert:@"历史答案与题目不符!"];
        return;
    }
    
    [self.propOfReduceTime setBackgroundColor:[UIColor lightGrayColor]];
    [self.propOfShowingAnswer setBackgroundColor:[UIColor lightGrayColor]];
    ////改变按钮样式,顶栏等,添加正确率+时间label
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:self.topBarView.backgroundColor];
    [bgView setFrame:(CGRect){0,0,self.topBarView.frame.size.width / 2,self.topBarView.frame.size.height}];
    bgView.center = self.topBarView.center ;
    [self.topBarView addSubview:bgView];
    UILabel *ratioAndTimeLabel = [[UILabel alloc] init];
    NSString *ratioAndTimeString = [NSString stringWithFormat:@"         %d%@          %@",self.totalRatio,@"%",self.timeCountString];
    ratioAndTimeLabel.text = ratioAndTimeString;
    ratioAndTimeLabel.font = [UIFont systemFontOfSize:30.0];
    ratioAndTimeLabel.textColor = [UIColor whiteColor];
    ratioAndTimeLabel.backgroundColor = [UIColor clearColor];
    ratioAndTimeLabel.frame = (CGRect){0,0,350,75};
    ratioAndTimeLabel.center = (CGPoint){bgView.frame.size.width / 2,bgView.frame.size.height / 2};
    [bgView addSubview:ratioAndTimeLabel];
    
    UILabel *ratioAndTimeLabel_ = [[UILabel alloc] init];
    ratioAndTimeLabel_.text = @"正确率:                用时:";
    ratioAndTimeLabel_.font = [UIFont systemFontOfSize:20.0];
    ratioAndTimeLabel_.textColor = [UIColor whiteColor];
    ratioAndTimeLabel_.backgroundColor = [UIColor clearColor];
    ratioAndTimeLabel_.frame = (CGRect){0,0,350,75};
    ratioAndTimeLabel_.center = ratioAndTimeLabel.center;
    [bgView addSubview:ratioAndTimeLabel_];
    
    self.propOfReduceTime.enabled = NO;
    self.propOfShowingAnswer.enabled = NO;
    [self.nextButton setImage:nil forState:UIControlStateNormal];
    self.nextButton.titleLabel.text = @"下一个";
    self.historyView.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:191.0/255.0 alpha:1.0];
    self.historyView.hidden = NO;
    
    [self loadNextQuestion];

}

//继续做题   --初始化界面
- (void)continueChallenge{
    self.isViewingHistory = NO;
    //改变按钮样式,及顶栏目样式
    self.propOfReduceTime.enabled = YES;
    self.propOfShowingAnswer.enabled = YES;
    [self.nextButton setImage:[UIImage imageNamed:@"选择_07.png"] forState:UIControlStateNormal];
    self.nextButton.titleLabel.text = @"检查";
    self.historyView.hidden = YES;
    
    if (self.lastTimeCurrentNO > 0) {
        self.currentNO = self.lastTimeCurrentNO - 1; //先减一 再加载下一题即可
    }
    self.timeCount = self.timeCount > 0 ? self.timeCount : 0;
    
    [self loadNextQuestion];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

//读取下一题,开始时触发,点击下一个时触发
- (void)loadNextQuestion{
    if (self.currentNO < self.questionArray.count) {
        self.currentNO ++;
        if (self.currentNO == self.questionArray.count) {
            self.isLastQuestion = YES;
        }
        self.currentQuestion = self.questionArray[self.currentNO - 1];
        self.selectingType = self.currentQuestion.seType;
        [self createQuestionView];
        if (self.isViewingHistory) {
            [self refreshHistoryView];
        }
    }else{
        self.currentNO = self.questionArray.count + 1; //标志最后一题已经完成
        [self endChallenge];
    }
}

//被中断/中途退出时的方法
- (void)pauseChallenge{
    [self.timer invalidate];
}

- (void)endChallenge{
    if (self.isViewingHistory) {
        //退出本界面
    }else{
        [self.timer invalidate];
        [self showResultView];
    }
}

//显示结果界面
- (void)showResultView{
    [self.view addSubview:self.resultView];
    //准确率,耗时,提交时间  判断精准/迅速/捷足成就
    NSInteger numberOfRightAnswers = 0;
    if (self.answerArray.count == self.questionArray.count) {
        for (int i = 0; i < self.answerArray.count; i ++) {
            OrdinaryAnswerObject *answer = self.answerArray[i];
            if ([answer.answerRatio isEqualToString:@"100"]) {
                numberOfRightAnswers ++;
            }
        }
        NSInteger percentOfRightAnswers = ((CGFloat)numberOfRightAnswers) / self.answerArray.count * 100.0; //正确率
        self.resultView.ratio = percentOfRightAnswers;
        
        self.resultView.timeCount = self.timeCount;
        
        SelectingChallengeObject *question = [self.questionArray firstObject];
        
        self.resultView.timeLimit = question.seTimeLimit.integerValue;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *homeworkFinishTime = [formatter dateFromString:self.homeworkFinishTime];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger unitFlag = NSSecondCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlag fromDate:[NSDate date] toDate:homeworkFinishTime options:0];
        NSInteger seconds = [comps second];
        
        if (seconds >= 7200) {
            self.resultView.isEarly = YES;
        }else{
            self.resultView.isEarly = NO;
        }
        
        [self.resultView initView];
//        self.resultView.correctPersent.text = [NSString stringWithFormat:@"正确率: %i%@",percentOfRightAnswers,@"%"];
//        self.resultView.timeLabel.text = [NSString stringWithFormat:@"用时: %@",self.timeLabel.text];
//        
//        if (percentOfRightAnswers < 100) {
//            self.resultView.accuracyAchievementLabel.text = [NSString stringWithFormat:@"好可惜没有全对哦,不能拿到精准得分哦!"];
//        }else{
//            self.resultView.accuracyAchievementLabel.text = [NSString stringWithFormat:@"所有题目全部正确!<精准>成就加10分!"];
//        }
//        
//        SelectingChallengeObject *question = [self.questionArray firstObject];
//        if (self.timeCount <= [question.seTimeLimit floatValue]) {
//            //迅速成就
//            self.resultView.fastAchievementLabel.text = [NSString stringWithFormat:@"恭喜你的用时在%@秒内,<迅速>成就加10分!",question.seTimeLimit];
//        }else{
//            self.resultView.fastAchievementLabel.text = [NSString stringWithFormat:@"你的用时超过了%@秒,不能拿到迅速得分哦!",question.seTimeLimit];
//        }
//        
//        //捷足成就
//        if ([self compareNowWithTime:self.homeworkFinishTime]) {
//            self.resultView.earlyAchievementLabel.text = [NSString stringWithFormat:@"恭喜你在截止时间提前两小时完成作业,<捷足>成就加10分!"];
//        }else{
//            self.resultView.earlyAchievementLabel.text = [NSString stringWithFormat:@"未能在截止时间提前两小时完成作业,不能拿到捷足得分哦!"];
//        }
    }else{
        [Utility errorAlert:@"题目与答案不匹配!"];
    }
}

- (NSDictionary *)makeAnswerJSON{
    //按照answer.js的格式制作一个字典.  可能在未完成时调用
    NSMutableDictionary *answerDic = [[NSMutableDictionary alloc] init];
    
    [answerDic setObject:(self.currentNO > self.questionArray.count ? @"1" : @"0") forKey:@"status"];//完成情况
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    [answerDic setObject:nowDate forKey:@"update_time"];
    
    [answerDic setObject:[NSString stringWithFormat:@"%d",self.currentNO] forKey:@"questions_item"];//大题索引,即当前正在做的题号
    
    [answerDic setObject:@"1" forKey:@"branch_item"];  //小题索引
    
    [answerDic setObject:[NSString stringWithFormat:@"%d",(NSInteger)self.timeCount] forKey:@"use_time"];   //用时
    
    NSMutableArray *questions = [NSMutableArray array];
    for (NSInteger i = 0; i < self.questionArray.count; i ++) {
        NSMutableDictionary *questionDic = [[NSMutableDictionary alloc] init];
        SelectingChallengeObject *anyQuestion = [self.questionArray objectAtIndex:i];
        [questionDic setObject:anyQuestion.seBigID forKey:@"id"];  //大题号
        
        NSMutableArray *branches = [NSMutableArray array];
        NSMutableDictionary *branchDic = [[NSMutableDictionary alloc] init];
        OrdinaryAnswerObject *answerObj = self.answerArray[i];
        [branchDic setObject:answerObj.answerID forKey:@"id"];
        [branchDic setObject:answerObj.answerAnswer forKey:@"answer"];
        [branchDic setObject:answerObj.answerRatio forKey:@"ratio"]; //正确:对-100  错-0
        [branches addObject:branchDic];
        [questionDic setObject:branches forKey:@"branch_questions"];
        
        [questions addObject:questionDic];
    }
    
    [answerDic setObject:questions forKey:@"questions"];
    
    return [NSDictionary dictionaryWithDictionary:answerDic];
}

#pragma mark property
- (TenSecChallengeResultView *)resultView{
    if (!_resultView) {
        _resultView = [[[NSBundle mainBundle]loadNibNamed:@"TenSecChallengeResultView" owner:self options:nil] lastObject];
        _resultView.delegate = self;
    }
    return _resultView;
}

-(NSArray *)questionArray{
    if (!_questionArray) {
        _questionArray = [NSArray arrayWithArray:[SelectingChallengeObject parseSelectingChallengeFromQuestion]];
    }
    return _questionArray;
}

-(NSMutableArray *)answerArray{
    if (!_answerArray) {
        _answerArray = [NSMutableArray array];
    }
    return _answerArray;
}

-(UIButton *)propOfReduceTime{
    if (!_propOfReduceTime) {
        _propOfReduceTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [_propOfReduceTime setImage:[UIImage imageNamed:@"propOfTime.png"] forState:UIControlStateNormal];
        [_propOfReduceTime addTarget:self action:@selector(propOfReduceTimeClicked:) forControlEvents:UIControlEventTouchUpInside];
        _propOfReduceTime.frame = (CGRect){146,10,50.5,50.5};
        [self.itemsView addSubview:_propOfReduceTime];
    }
    return _propOfReduceTime;
}



-(UIButton *)propOfShowingAnswer{
    if (!_propOfShowingAnswer) {
        _propOfShowingAnswer = [UIButton buttonWithType:UIButtonTypeCustom];
        [_propOfShowingAnswer setImage:[UIImage imageNamed:@"propOfAnswer.png"] forState:UIControlStateNormal];
        [_propOfShowingAnswer addTarget:self action:@selector(propOfShowingAnswerClicked:) forControlEvents:UIControlEventTouchUpInside];
        _propOfShowingAnswer.frame = (CGRect){90,10,50.5,50.5};
        [self.itemsView addSubview:_propOfShowingAnswer];
    }
    return _propOfShowingAnswer;
}

-(NSString *)timeCountString{
    NSString *str;
    NSInteger i = (NSInteger)self.timeCount;
    NSInteger seconds = i % 60;
    NSInteger minites = i / 60;
    if (minites > 0) {
        str = [NSString stringWithFormat:@"%d'%d",minites,seconds];
    }else{
        str = [NSString stringWithFormat:@"%d",seconds];
    }
    return str;
}

-(void)setCurrentNO:(NSInteger)currentNO{
    if (currentNO <= self.questionArray.count) {
        self.currentNOLabel.text = [NSString stringWithFormat:@"%d/%d",currentNO,self.questionArray.count];
    }
    _currentNO = currentNO;
}

#pragma mark action

#pragma mark 被调方法
//创建问题显示
-(void)createQuestionView{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (self.selectingType) {
            case SelectingTypeDefault:
            {
                self.questionImageWebView.hidden = YES;
                self.questionPlayButton.hidden = YES;
                self.questionTextView.hidden = NO;
                
                self.questionTextView.frame = (CGRect){38,17,650,100};
                self.optionTable.frame = (CGRect){38,117,650,400};
                
                self.questionTextView.text = self.currentQuestion.seContent;
            }
                break;
                
            case SelectingTypeListening:
            {
                self.questionImageWebView.hidden = YES;
                self.questionPlayButton.hidden = NO;
                self.questionTextView.hidden = YES;
                
                self.questionPlayButton.frame = (CGRect){38,17,65,65};
                self.optionTable.frame = (CGRect){118,17,550,400};
            }
                break;
                
            case SelectingTypeWatching:
            {
                self.questionImageWebView.hidden = NO;
                self.questionPlayButton.hidden = YES;
                self.questionTextView.hidden = NO;
                
                self.questionImageWebView.frame = (CGRect){38,17,250,265};
                self.questionTextView.frame = (CGRect){290,17,430,265};
                self.optionTable.frame = (CGRect){38,317,650,400};
                
                self.questionTextView.text = self.currentQuestion.seContent;
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.comdosoft.com/images/ad.jpg"]];
                [self.questionImageWebView loadRequest:request];
            
            }
                break;
                
            default:
                break;
        }
        [self.optionTable reloadData];
        [self.view setNeedsDisplay];
    });
}

//<<<<<<< HEAD
////检查正确与否
//-(void) checkAnswer{
//    
//=======
//加载本题的历史回答情况
-(void)refreshHistoryView{
    //1,下方显示
    //2,选中选项
    NSMutableString *yourChoiceString = [NSMutableString stringWithFormat:@"你的选择:"];
    OrdinaryAnswerObject *currentAnswer = self.answerArray[self.currentNO - 1];
    NSArray *myAnswers = [currentAnswer.answerAnswer componentsSeparatedByString:@";||;"];
    for (NSInteger i = 0; i < self.currentQuestion.seOptionsArray.count; i ++) {
        NSString *option = self.currentQuestion.seOptionsArray[i];
        for (NSString *answer in myAnswers) {
            if ([answer isEqualToString:option]) {
                [yourChoiceString appendFormat:@"%c",'A' + i];
                break;
            }
        }
        
        for(NSString *rightAnswer in self.currentQuestion.seRightAnswers){
            if ([rightAnswer isEqualToString:option]) {
                //选中该option
                break;
            }
        }
    }
    self.historyYourChoiceLabel.text = yourChoiceString;
}

#pragma mark 被调方法
//被timer触发
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

//根据已选择的选项,检查当前答案是否正确
-(BOOL)judgeAnswer:(NSMutableArray *)selectedOptions{
    //判断不选
    if (selectedOptions.count < 1) {
        return NO;
    }
    
    //判断多选
    for (NSString *option in selectedOptions) {
        BOOL tooMuch = YES;
        for(NSString *answer in self.currentQuestion.seRightAnswers){
            if ([answer isEqualToString:option]) {
                tooMuch = NO;
                break;
            }
        }
        if (tooMuch) {
            return NO;
        }
    }
    
    //判断漏选
    for (NSString *answer in self.currentQuestion.seRightAnswers) {
        BOOL notEnough = YES;
        for(NSString *option in selectedOptions){
            if ([answer isEqualToString:option]) {
                notEnough = NO;
                break;
            }
        }
        if (notEnough) {
            return NO;
        }
    }
    return YES;
}

//点击"检查"后,把当前答案存放入答案数组中,播放音效
-(void)addAnswer{
    OrdinaryAnswerObject *answer = [[OrdinaryAnswerObject alloc] init];
    answer.answerID = self.currentQuestion.seID;
    NSMutableArray *selectedOptions = [NSMutableArray array];
    for (NSInteger i = 0; i < self.currentQuestion.seOptionsArray.count; i ++) {
        for (NSString *str in self.currentSelectedOptions) {
            if (str.integerValue == i) {
                [selectedOptions addObject:self.currentQuestion.seOptionsArray[i]];
            }
        }
    }
    answer.answerAnswer = [selectedOptions componentsJoinedByString:@";||;"];
    BOOL answerRatio = [self judgeAnswer:selectedOptions];
    answer.answerRatio = answerRatio ? @"100" : @"0";
    [self.answerArray addObject:answer];
        
    if (answerRatio) {
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"right_sound" ofType:@"mp3"]] error:nil];
        if([player prepareToPlay]){
            [player play];
        }
        
    }else{
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wrong_sound" ofType:@"mp3"]] error:nil];
        if([player prepareToPlay]){
            [player play];
        }
    }
}

#pragma mark 界面交互

- (IBAction)questionPlayButtonClicked:(id)sender {
    
}

//道具2
-(void)propOfReduceTimeClicked:(id)sender{
    if (self.timeCount < 5.0) {
        self.timeCount = 0;
    }else{
        self.timeCount -= 5.0;
    }
}

//道具1
-(void)propOfShowingAnswerClicked:(id)sender{
    for (NSString *rightOption in self.currentQuestion.seRightAnswers) {
        for (NSInteger i = 0; i < self.currentQuestion.seOptionsArray.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            SelectingChallengeOptionCell *cell = (SelectingChallengeOptionCell *)[self.optionTable cellForRowAtIndexPath:indexPath];
            if ([rightOption isEqualToString:cell.optionString]) {
                //调用cell代理方法,选中之
                [self selectingCell:cell clickedForSelecting:YES];
            }
        }
    }
}

- (IBAction)nextButtonClicked:(id)sender {
    if (!self.isViewingHistory) {
        [self addAnswer];
    }
    [self loadNextQuestion];
}

#pragma mark TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentQuestion.seOptionsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectingChallengeOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.indexPath = indexPath;
    cell.optionString = self.currentQuestion.seOptionsArray[indexPath.row];
    cell.delegate = self;
    cell.maxLabelWidth = 0;
    for (int i = 0; i < self.currentQuestion.seOptionsArray.count; i ++) {
        NSString *option = self.currentQuestion.seOptionsArray[i];
        CGFloat width = [Utility getTextSizeWithString:option withFont:[UIFont systemFontOfSize:40.0]].width;
        if (cell.maxLabelWidth <=  width) {
            cell.maxLabelWidth = width;
        }
    }
    
    cell.optionSelected = NO;
    
    return cell;
}

#pragma mark TableViewDelegate

#pragma mark cell Delegate
-(void)selectingCell:(SelectingChallengeOptionCell *)cell clickedForSelecting:(BOOL)selected{
    cell.optionSelected = selected;
    if (selected) {
        [self.currentSelectedOptions addObject:[NSString stringWithFormat:@"%d",cell.indexPath.row]];
    }else{
        NSInteger index = 0;
        for (NSInteger i = 0; i < self.currentSelectedOptions.count; i++) {
            NSString *str = self.currentSelectedOptions[i];
            if ([str isEqualToString:[NSString stringWithFormat:@"%d",cell.indexPath.row]]) {
                index = i;
                break;
            }
        }
        [self.currentSelectedOptions removeObjectAtIndex:index];
    }
}
#pragma mark TenSecChallengeResultViewDelegate
-(void)resultViewCommitButtonClicked{
    [self.resultView removeFromSuperview];
}

-(void)resultViewRestartButtonClicked{
    [self.resultView removeFromSuperview];
    [self reDoingChallenge];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
