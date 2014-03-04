//
//  TenSecChallengeViewController.m
//  cjzyb_ios
//
//  Created by apple on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TenSecChallengeViewController.h"

@interface TenSecChallengeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton; //返回键
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;     //顶部时间
@property (weak, nonatomic) IBOutlet UILabel *upperOptionLabel;  //上选项
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;  //问题
@property (weak, nonatomic) IBOutlet UILabel *lowerOptionLabel;  //下选项
@property (weak, nonatomic) IBOutlet UIImageView *countDownImageView;  //题目序号
@property (weak, nonatomic) IBOutlet UIButton *upperButton;
@property (weak, nonatomic) IBOutlet UIButton *lowerButton;
@property (assign,nonatomic) CGFloat timeCount; //计时时间(单位为秒)
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) NSInteger currentNO;//当前题目序号
@property (strong,nonatomic) TenSecChallengeObject *currentQuestion; //当前题目
@property (assign,nonatomic) BOOL isLastQuestion; //是否最后一题
@property (strong,nonatomic) NSArray *questionNumberImages; //题号图片数组
@property (strong,nonatomic) NSMutableArray *answerArray; //选择的答案
@end

@implementation TenSecChallengeViewController

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
    [self setupViews];
    
    
    self.questionArray = [NSMutableArray arrayWithArray:[TenSecChallengeObject parseTenSecQuestionsFromFile]];
    
    [self startChallenge];
    
    NSLog(@"sdf");
}

- (void)setupViews{  //控件初始设置
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.upperOptionLabel.layer.cornerRadius = 8.0;
    
    [self.upperButton addTarget:self action:@selector(upperClicked:) forControlEvents:UIControlEventTouchDown];
    
    self.lowerOptionLabel.layer.cornerRadius = 8.0;
    
    [self.lowerButton addTarget:self action:@selector(lowerClicked:) forControlEvents:UIControlEventTouchDown];
}

#pragma mark -- 挑战的生命周期

- (void)startChallenge{
    self.timeCount = 0;
    self.currentNO = 0;
    self.answerArray = [NSMutableArray array];
    [self showNextQuestion];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
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
}


#pragma mark --按钮响应
- (void)cancelButtonClicked:(id)sender{
    
}

- (void)upperClicked:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.answerArray addObject:self.upperOptionLabel.text];
        self.upperOptionLabel.backgroundColor = [UIColor greenColor];
        [UIView animateWithDuration:0.5 animations:^{
            self.upperButton.alpha = self.upperButton.alpha > 0.5 ? 0.5 : 1;
        } completion:^(BOOL finished) {
            self.upperOptionLabel.backgroundColor = [UIColor blackColor];
            self.lowerOptionLabel.backgroundColor = [UIColor blackColor];
            if (self.isLastQuestion) {
                [self finishChallenge];
            }else{
                [self showNextQuestion];
            }
        }];
    });
}

- (void)lowerClicked:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.answerArray addObject:self.lowerOptionLabel.text];
        self.lowerOptionLabel.backgroundColor = [UIColor greenColor];
        [UIView animateWithDuration:0.5 animations:^{
            self.upperButton.alpha = self.upperButton.alpha > 0.5 ? 0.5 : 1;
        } completion:^(BOOL finished) {
            self.upperOptionLabel.backgroundColor = [UIColor blackColor];
            self.lowerOptionLabel.backgroundColor = [UIColor blackColor];
            if (self.isLastQuestion) {
                [self finishChallenge];
            }else{
                [self showNextQuestion];
            }
        }];
    });
}

#pragma mark -- action
//选择了一个答案
- (void) didMadeAChoice:(NSString *)answer{
    //1,保存本次选择的结果
    //2,
}

//每调用一次,读取下一道题目
- (void) showNextQuestion{
    if (self.questionArray.count > 0) {
        if (self.currentNO < self.questionArray.count) {
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
    NSInteger seconds = (NSInteger)(self.timeCount * 10);
    if (seconds % 10 == 0) {
        [self refreshClock];
    }
}

-(void)refreshClock{//跳秒
    NSInteger second = self.timeCount;
    NSInteger minite = second / 60;
    second = second % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%i'%i",(minite > 0 ? minite : 0),second];
}

#pragma mark -- property
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
    [self.resultView removeFromSuperview];
    self.resultView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
