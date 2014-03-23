//
//  SelectingChallengeViewController.m
//  cjzyb_ios
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SelectingChallengeViewController.h"
#import "HomeworkContainerController.h"

#define parentVC ((HomeworkContainerController *)[self parentViewController])

@interface SelectingChallengeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;  //退出按钮
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

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

@property (assign,nonatomic) BOOL checked; //本小题是否已经按过"检查"按钮
@property (assign,nonatomic) BOOL isReDoingChallenge;  //是否是重新做题,重新挑战
@property (assign,nonatomic) SelectingType selectingType;  //当前题目类型 填空/看图/听力
@property (assign,nonatomic) NSTimeInterval timeCount;//计时 (秒)
@property (strong,nonatomic) NSString *timeCountString; //计时的分秒显示格式
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) NSInteger currentNO;//当前正在做的题目序号,如超过问题数量代表答题完毕
@property (strong,nonatomic) SelectingChallengeObject *currentQuestion; //当前问题
@property (strong,nonatomic) NSData *currentAudioData; //如果当前为听力题,则读取入此data
@property (assign,nonatomic) BOOL isLastQuestion; //是否最后一题

@property (strong,nonatomic) NSArray *questionArray;  //问题
@property (strong,nonatomic) NSMutableArray *answerArray;   //选择的答案
@property (strong,nonatomic) NSMutableArray *propsArray;//道具
//@property (strong,nonatomic) NSDictionary *answerJSONDic; //从文件中读取的answerJSON字典
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
    [self parseAnswerDic:[Utility returnAnswerDictionaryWithName:@"selecting"]];
    self.propsArray = [Utility returnAnswerProps];
    
    [self.optionTable registerClass:[SelectingChallengeOptionCell class] forCellReuseIdentifier:@"cell"];
    self.isReDoingChallenge = NO;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self getStart];
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
//- (void)parseAnswer{
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    //把path拼成真实文件路径
//    
//    path = [[NSBundle mainBundle] pathForResource:@"answer-1" ofType:@"js"]; //测试
//    
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    if (!data) {
//        [Utility errorAlert:@"获取answer文件失败!"];
//    }else{
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        if (!dic) {
//            [Utility errorAlert:@"文件格式错误!"];
//            return;
//        }
//        self.answerJSONDic = dic;
//        NSDictionary *dicc = [dic objectForKey:@"selecting"];
//        if (!dicc) { //判断是否已有选择挑战数据
//            [Utility errorAlert:@"尚没有选择挑战内容"];
//        }else{
//            self.answerStatus = [dicc objectForKey:@"status"];  //只要解析状态,已答题时间,题号  其余的不解析
//            self.timeCount = [[dicc objectForKey:@"use_time"] doubleValue];
//            parentVC.spendSecond = self.timeCount;
//            self.lastTimeCurrentNO = [(NSString *)[dicc objectForKey:@"questions_item"] integerValue];
//            
//            NSArray *questions = [dicc objectForKey:@"questions"];
//            if ([questions firstObject]) {
//                [self.answerArray removeAllObjects];  //此处清空answerArray,注意
//                for (NSInteger i = 0; i < questions.count; i ++) {
//                    NSDictionary *questionDic = [questions objectAtIndex:i];
//                    if ([questionDic objectForKey:@"branch_questions"]) {
//                        NSArray *branches = [questionDic objectForKey:@"branch_questions"];
//                        for (int k = 0; k < branches.count; k ++) {
//                            NSDictionary *branch = branches[k];
//                            OrdinaryAnswerObject *answer = [[OrdinaryAnswerObject alloc] init];
//                            answer.answerID = [branch objectForKey:@"id"];
//                            answer.answerAnswer = [branch objectForKey:@"answer"];
//                            answer.answerRatio = [branch objectForKey:@"ratio"];
//                            [self.answerArray addObject:answer];
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

-(void)parseAnswerDic:(NSMutableDictionary *)dicc{
    self.answerStatus = [dicc objectForKey:@"status"];  //只要解析状态,已答题时间,题号  其余的不解析
    self.timeCount = [[dicc objectForKey:@"use_time"] doubleValue];
    parentVC.spendSecond = self.timeCount;
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

//开始,根据答题状态决定.
- (void)getStart{
    if (self.isViewingHistory) {
        [self viewHistory];
    }else{
        if ([self.answerStatus isEqualToString:@"1"]) {
            [self reDoingChallenge];
        }else{
            [self continueChallenge];
        }
        
    }
}

// (重新做题不计成绩,调用此方法)
- (void)reDoingChallenge{
    self.isViewingHistory = NO;
    self.isReDoingChallenge = YES;
    //改变按钮样式,及顶栏目样式
    self.propOfReduceTime.enabled = YES;
    self.propOfShowingAnswer.enabled = YES;
    [self.nextButton setImage:[UIImage imageNamed:@"选择_07.png"] forState:UIControlStateNormal];
    [parentVC.checkHomeworkButton setTitle:@"检查" forState:UIControlStateNormal];
    parentVC.appearCorrectButton.enabled = NO;
    parentVC.reduceTimeButton.enabled = NO;
    self.historyView.hidden = YES;
    
    self.currentNO = 0;
    self.timeCount = 0;
    parentVC.spendSecond = self.timeCount;
    self.answerArray = [NSMutableArray array];
    
    [self loadNextQuestion];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [parentVC startTimer];
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
        parentVC.rotioLabel.text = [NSString stringWithFormat:@"%d%@",self.totalRatio,@"%"];
    }else{
        [Utility errorAlert:@"历史答案与题目不符!"];
        return;
    }
    parentVC.timeLabel.text = [NSString stringWithFormat:@"%@\"",self.timeCountString];
    
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
    
    parentVC.appearCorrectButton.enabled = NO;
    parentVC.reduceTimeButton.enabled = NO;
    [self.nextButton setImage:nil forState:UIControlStateNormal];
    [parentVC.checkHomeworkButton setTitle:@"下一个" forState:UIControlStateNormal];
    self.historyView.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:191.0/255.0 alpha:1.0];
    self.historyView.hidden = NO;
    
    [self loadNextQuestion];

}

//继续做题   --初始化界面
- (void)continueChallenge{
    self.isViewingHistory = NO;
    //改变按钮样式,及顶栏目样式
    parentVC.appearCorrectButton.enabled = YES;
    parentVC.reduceTimeButton.enabled = YES;
    [self.nextButton setImage:[UIImage imageNamed:@"选择_07.png"] forState:UIControlStateNormal];
    [parentVC.checkHomeworkButton setTitle:@"检查" forState:UIControlStateNormal];
    self.historyView.hidden = YES;
    
    if (self.lastTimeCurrentNO > 0) {
        self.currentNO = self.lastTimeCurrentNO;
    }
    self.timeCount = self.timeCount > 0 ? self.timeCount : 0;
    parentVC.spendSecond = self.timeCount;
    
    [self loadNextQuestion];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [parentVC startTimer];
}

//读取下一题,开始时触发,点击下一个时触发
- (void)loadNextQuestion{
    if (self.currentNO < self.questionArray.count) {
        self.currentNO ++;
        if (self.currentNO == self.questionArray.count) {//最后一题
            self.isLastQuestion = YES;
            [parentVC.checkHomeworkButton setTitle:@"完成" forState:UIControlStateNormal];
        }
        self.checked = NO;
        self.currentQuestion = self.questionArray[self.currentNO - 1];
        self.currentSelectedOptions = [NSMutableArray array]; //清除选择数组
        self.selectingType = self.currentQuestion.seType;
        if (self.currentQuestion.seType == SelectingTypeListening) {
            _currentAudioData = nil;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self currentAudioData];//先缓冲
            });
        }
        [self createQuestionView];//更新本题内容
        if (self.isViewingHistory) {
            [self refreshHistoryView];
        }else if (!self.isReDoingChallenge){
            //刷新道具按钮
            if([DataService sharedService].number_correctAnswer > 0){
                parentVC.appearCorrectButton.enabled = YES;
            }
            if ([DataService sharedService].number_reduceTime > 0) {
                parentVC.reduceTimeButton.enabled = YES;
            }
        }
        //动画效果,第一题不需要
        if (self.currentNO > 1) {
            [self showNextQuestionWithAnimation];
        }
    }else{
        self.currentNO = self.questionArray.count + 1; //标志最后一题已经完成
        [self endChallenge];
    }
}

//动画切换效果
- (void) showNextQuestionWithAnimation{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.5];
    [animation setRemovedOnCompletion:YES];
    [animation setDelegate:self];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:animation forKey:@"PushLeft"];
}

//被中断/中途退出时的方法
- (void)pauseChallenge{
    [self.timer invalidate];
    [parentVC stopTimer];
}

- (void)endChallenge{
    if (self.isViewingHistory) {
        //退出本界面
    }else{
        self.answerStatus = @"1";
        [self.timer invalidate];
        [parentVC stopTimer];
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
        
        if ([Utility compareTime]) {
            self.resultView.isEarly = YES;
        }else{
            self.resultView.isEarly = NO;
        }
        
        [self.resultView initView];
        
        if (self.isReDoingChallenge) {
            self.resultView.noneArchiveView.hidden = NO;
            self.resultView.resultBgView.hidden = YES;
        }else{
            self.resultView.noneArchiveView.hidden = YES;
            self.resultView.resultBgView.hidden = NO;
        }
    }else{
        [Utility errorAlert:@"题目与答案不匹配!"];
    }
}

- (NSDictionary *)makeAnswerJSON{
    //按照answer.js的格式制作一个字典.  可能在未完成时调用
    NSMutableDictionary *answerDic = [[NSMutableDictionary alloc] init];
    
    [answerDic setObject:(self.isLastQuestion ? @"1" : @"0") forKey:@"status"];//完成情况
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowDate = [dateFormatter stringFromDate:[NSDate date]];
    [answerDic setObject:nowDate forKey:@"update_time"];
    
    [answerDic setObject:[NSString stringWithFormat:@"%d",self.currentNO] forKey:@"questions_item"];//大题索引,即当前正在做的题号
    
    [answerDic setObject:@"1" forKey:@"branch_item"];  //小题索引
    
    [answerDic setObject:[NSString stringWithFormat:@"%d",(NSInteger)self.timeCount] forKey:@"use_time"];   //用时
    
    NSMutableArray *questions = [NSMutableArray array];
    for (NSInteger i = 0; i < self.answerArray.count; i ++) {
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
    
    [Utility returnAnswerPathWithDictionary:[NSDictionary dictionaryWithDictionary:answerDic] andName:@"selecting"];
    
    return [NSDictionary dictionaryWithDictionary:answerDic];
}

#pragma mark property
//在改变checked属性时,改变按钮的文字
- (void)setChecked:(BOOL)checked{
    _checked = checked;
    if (!self.isViewingHistory) {
        if (!checked) {
            [parentVC.checkHomeworkButton setTitle:@"检查" forState:UIControlStateNormal];
        }else{
            if (self.isLastQuestion) {
                [parentVC.checkHomeworkButton setTitle:@"完成" forState:UIControlStateNormal];
            }else{
                [parentVC.checkHomeworkButton setTitle:@"下一题" forState:UIControlStateNormal];
            }
        }
    }
}

- (NSData *)currentAudioData{
    if (!_currentAudioData) {
        _currentAudioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentQuestion.seContentAttachment]];
    }
    return _currentAudioData;
}

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
//                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.comdosoft.com/images/ad.jpg"]];
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentQuestion.seContentAttachment]];
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
                SelectingChallengeOptionCell *cell = (SelectingChallengeOptionCell *)[self.optionTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.optionSelected = YES;
                break;
            }
        }
    }
    self.historyYourChoiceLabel.text = yourChoiceString;
}

#pragma mark 被调方法
//被timer触发
-(void) timerFired:(NSTimer *)timer{
    self.timeCount = parentVC.spendSecond;
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
    for (NSString *optionIndex in selectedOptions) {
        NSString *option = self.currentQuestion.seOptionsArray[optionIndex.integerValue];
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
        for(NSString *optionIndex in selectedOptions){
            NSString *option = self.currentQuestion.seOptionsArray[optionIndex.integerValue];
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
-(void)checkChoice{
    OrdinaryAnswerObject *answer = [[OrdinaryAnswerObject alloc] init];
    answer.answerID = self.currentQuestion.seID;
    NSMutableArray *selectedOptions = [NSMutableArray array];
    for (NSInteger i = 0; i < self.currentQuestion.seOptionsArray.count; i ++) {
        for (NSString *str in self.currentSelectedOptions) {
            if (str.integerValue == i) {
//                [selectedOptions addObject:self.currentQuestion.seOptionsArray[i]];
                [selectedOptions addObject:[NSString stringWithFormat:@"%c",'A' + i]];
            }
        }
    }
    answer.answerAnswer = [selectedOptions componentsJoinedByString:@";||;"];
    BOOL answerRatio = [self judgeAnswer:self.currentSelectedOptions];
    answer.answerRatio = answerRatio ? @"100" : @"0";
    [self.answerArray addObject:answer];
    
    [self showCheckResult];
    [self makeAnswerJSON];
    
    //播放声音
    if (answerRatio) {
        [AppDelegate shareIntance].avPlayer = nil;
        [AppDelegate shareIntance].avPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"right_sound" ofType:@"mp3"]] error:nil];
        [AppDelegate shareIntance].avPlayer.volume = 1;
        if([[AppDelegate shareIntance].avPlayer prepareToPlay]){
            [[AppDelegate shareIntance].avPlayer play];
        }
    }else{
        [AppDelegate shareIntance].avPlayer = nil;
        [AppDelegate shareIntance].avPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"right_sound" ofType:@"mp3"]] error:nil];
        [AppDelegate shareIntance].avPlayer.volume = 1;
        if([[AppDelegate shareIntance].avPlayer prepareToPlay]){
            [[AppDelegate shareIntance].avPlayer play];
        }
    }
    
    self.checked = YES;
}

- (void)showCheckResult{
    for (NSInteger i = 0; i < self.currentQuestion.seOptionsArray.count; i ++) {
        NSString *option = self.currentQuestion.seOptionsArray[i];
        BOOL optionIsRightAnswer = NO;
        for(NSString *rightAnswer in self.currentQuestion.seRightAnswers){
            if ([option isEqualToString:rightAnswer]) {
                //标注正确答案
                optionIsRightAnswer = YES;
                SelectingChallengeOptionCell *cell = (SelectingChallengeOptionCell *)[self.optionTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.optionBackgroundView.backgroundColor = [UIColor greenColor];
            }
        }
        if (!optionIsRightAnswer) {
            //错误答案是否是被选中的
            for(NSString *selectedOptionIndex in self.currentSelectedOptions){
                if (i == selectedOptionIndex.integerValue) {
                    SelectingChallengeOptionCell *cell = (SelectingChallengeOptionCell *)[self.optionTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    cell.optionBackgroundView.backgroundColor = [UIColor redColor];
                }
            }
        }
    }
}

#pragma mark 界面交互

- (IBAction)questionPlayButtonClicked:(id)sender {
    [AppDelegate shareIntance].avPlayer = nil;
    NSError *error;
    [AppDelegate shareIntance].avPlayer = [[AVAudioPlayer alloc] initWithData:self.currentAudioData error:&error];
    [AppDelegate shareIntance].avPlayer.delegate = self;
    [AppDelegate shareIntance].avPlayer.volume = 1;
    if([[AppDelegate shareIntance].avPlayer prepareToPlay]){
        [[AppDelegate shareIntance].avPlayer play];
        self.questionPlayButton.enabled = NO;
    }
}

//道具2
-(void)propOfReduceTimeClicked:(id)sender{
    if (self.timeCount < 5.0) {
        self.timeCount = 0;
    }else{
        self.timeCount -= 5.0;
    }
    parentVC.spendSecond = self.timeCount;
    if ((-- [DataService sharedService].number_reduceTime) < 1) {
        parentVC.reduceTimeButton.enabled = NO;
    }
    
    //存储道具记录JSON
    NSMutableDictionary *timePropDic = [NSMutableDictionary dictionaryWithDictionary:[self.propsArray lastObject]];
    NSMutableArray *branchOfPropArray = [NSMutableArray arrayWithArray:[timePropDic objectForKey:@"branch_id"]];
    [branchOfPropArray addObject:[NSNumber numberWithInteger:self.currentQuestion.seID.integerValue]];
    [timePropDic setObject:branchOfPropArray forKey:@"branch_id"];
    [self.propsArray replaceObjectAtIndex:1 withObject:timePropDic];
    [Utility returnAnswerPathWithProps:self.propsArray];
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
    [DataService sharedService].number_correctAnswer --;
    parentVC.appearCorrectButton.enabled = NO;
    
    //存储道具记录JSON
    NSMutableDictionary *rightAnswerPropDic = [NSMutableDictionary dictionaryWithDictionary:[self.propsArray firstObject]];
    NSMutableArray *branchOfPropArray = [NSMutableArray arrayWithArray:[rightAnswerPropDic objectForKey:@"branch_id"]];
    [branchOfPropArray addObject:[NSNumber numberWithInteger:self.currentQuestion.seID.integerValue]];
    [rightAnswerPropDic setObject:branchOfPropArray forKey:@"branch_id"];
    [self.propsArray replaceObjectAtIndex:0 withObject:rightAnswerPropDic];
    [Utility returnAnswerPathWithProps:self.propsArray];
}

- (IBAction)nextButtonClicked:(id)sender {
    ///防止乱点
    if (self.currentNO > self.questionArray.count) {
        return;
    }
    if (!self.isViewingHistory) {
        if (self.currentSelectedOptions.count < 1) {
            [Utility errorAlert:@"请先答本题"];
            return;
        }
        if (!self.checked) {
            //先检查
            [self checkChoice];
        }else{
            [self loadNextQuestion];
        }
    }else{
        [self loadNextQuestion];
    }
    
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
    cell.optionBackgroundView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < self.currentQuestion.seOptionsArray.count; i ++) {
        NSString *option = self.currentQuestion.seOptionsArray[i];
        CGFloat width = [Utility getTextSizeWithString:option withFont:[UIFont systemFontOfSize:40.0]].width;
        if (cell.maxLabelWidth <=  width) {
            cell.maxLabelWidth = width;
        }
    }
    
    cell.optionSelected = NO;
    if (self.isViewingHistory) {
        cell.optionButton.enabled = NO;
        for(NSString *rightAnswer in self.currentQuestion.seRightAnswers){
            if ([rightAnswer isEqualToString:cell.optionString]) {
                cell.optionSelected = YES;
                break;
            }
        }
    }
    
    return cell;
}

#pragma mark TableViewDelegate

#pragma mark cell Delegate
-(void)selectingCell:(SelectingChallengeOptionCell *)cell clickedForSelecting:(BOOL)selected{
    cell.optionSelected = selected;
    if (selected) {
        NSString *index = [NSString stringWithFormat:@"%d",cell.indexPath.row];
        if (![self.currentSelectedOptions containsObject:index]) {
            [self.currentSelectedOptions addObject:index];
        }
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

#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        self.questionPlayButton.enabled = YES;
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
