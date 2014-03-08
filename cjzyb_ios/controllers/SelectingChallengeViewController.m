//
//  SelectingChallengeViewController.m
//  cjzyb_ios
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SelectingChallengeViewController.h"

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
@property (weak, nonatomic) IBOutlet UILabel *currentNOLabel;  //当前题号  2/5
- (IBAction)nextButtonClicked:(id)sender;
@property (strong,nonatomic) UIButton *propOfShowingAnswer; //显示答案道具
@property (strong,nonatomic) UIButton *propOfReduceTime; //时间-5道具

@property (assign,nonatomic) BOOL isViewingHistory; //当前行为类型:查看历史/做题
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

@property (assign,nonatomic) NSInteger totalRatio; //正确率
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
}

#pragma mark -- 选择挑战的生命周期
/*读取answer,判断完成与否
  a,如果查看做题记录,则从第一题开始. 只支持"下一个"和"播放声音"
    查看到最后一题,可退出本界面
  b,如果做题,则从第1/第n题开始,开始计时
    点击"检查"切换到下一题
    做题结束,提交answer
*/

//解析JSON并保存dic,获取有用信息
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
            self.lastTimeCurrentNO = [(NSString *)[dicc objectForKey:@"branch_item"] integerValue];
            
            NSArray *questions = [dicc objectForKey:@"questions"];
            if ([questions firstObject]) {
                NSDictionary *questionDic = [questions firstObject];
                if ([questionDic objectForKey:@"branch_questions"]) {
                    NSArray *branches = [questionDic objectForKey:@"branch_questions"];
                    [self.answerArray removeAllObjects];  //此处清空answerArray,注意
                    for (int i = 0; i < branches.count; i ++) {
                        NSDictionary *branch = branches[i];
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

//开始,根据答题状态决定
- (void)getStart{
    if ([self.answerStatus isEqualToString:@"1"]) {
        self.isViewingHistory = YES;
        [self viewHistory];
    }else{
        self.isViewingHistory = NO;
        [self continueChallenge];
    }
}

//查看历史  ---初始化界面,获取数据
- (void)viewHistory{
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
    }
    
    [self.propOfReduceTime setBackgroundColor:[UIColor lightGrayColor]];
    [self.propOfShowingAnswer setBackgroundColor:[UIColor lightGrayColor]];
    //添加正确率+时间label
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
    
    [self loadNextQuestion];
}

//继续做题   --初始化界面
- (void)continueChallenge{
    
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
    }else{
        [self endChallenge];
    }
}

- (void)endChallenge{
    if (self.isViewingHistory) {
        //退出本界面
    }else{
        [self showResultView];
    }
}

//显示结果界面
- (void)showResultView{
    
}

#pragma mark property
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
    self.currentNOLabel.text = [NSString stringWithFormat:@"%d/%d",currentNO,self.questionArray.count];
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
                
                self.questionTextView.frame = (CGRect){38,17,650,200};
                self.optionTable.frame = (CGRect){38,217,650,400};
                
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
                
            }
                break;
                
            default:
                break;
        }
        [self.view setNeedsDisplay];
    });
}

//检查正确与否
-(void) checkAnswer{
    
}

#pragma mark 界面交互
- (IBAction)nextButtonClicked:(id)sender {
    if (!self.isViewingHistory) {
        [self checkAnswer];
    }
    [self loadNextQuestion];
}

- (IBAction)questionPlayButtonClicked:(id)sender {
}

//道具2
-(void)propOfReduceTimeClicked:(id)sender{
    
}

//道具1
-(void)propOfShowingAnswerClicked:(id)sender{
    
}

#pragma mark TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}

#pragma mark TableViewDataDelegate

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
