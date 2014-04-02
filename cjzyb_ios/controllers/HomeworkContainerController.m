

//
//  HomeworkContainerController.m
//  cjzyb_ios
//
//  Created by david on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "HomeworkContainerController.h"
@interface HomeworkContainerController ()
///朗读题controller
@property (nonatomic,strong) ReadingTaskViewController *readingController;
@property (nonatomic,strong) ListenWriteViewController *listenView;//听写
@property (nonatomic,strong) SortViewController *sortView;//排序
@property (nonatomic,strong) SelectedViewController *selectedView;//完形填空
@property (nonatomic, strong) LininggViewController *liningView;//连线
@property (nonatomic,strong) TenSecChallengeViewController *tenSecViewController;///十速挑战
@property (nonatomic,strong) SelectingChallengeViewController *selectingChallengeViewController; ///选择挑战

///上传answer文件
@property (nonatomic,strong) BasePostInterface *postAnswerInterface;
@property (nonatomic,strong) void (^successBlock)(NSString *success);
@property (nonatomic,strong) void (^failureBlock)(NSString *error);
///计时器
@property (nonatomic,strong) NSTimer *timer;
/////减时间
//- (IBAction)reduceTimeButtonClicked:(id)sender;


@end

@implementation HomeworkContainerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)timerExecute{
    self.spendSecond++;
    self.timerLabel.text = [Utility formateDateStringWithSecond:(NSInteger)self.spendSecond];
}

///开始计时
-(void)startTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerExecute) userInfo:nil repeats:YES];
}

///停止计时
-(void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//TODO:上传answer文件
-(void)uploadAnswerJsonFileWithPath:(NSString*)answerPath withSuccess:(void (^)(NSString *success))success withFailure:(void (^)(NSString *error ))failure{
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.labelText = @"正在上传做题结果，请稍后...";
    self.successBlock = success;
    self.failureBlock = failure;
    NSString *path = @"";
    if (answerPath) {
        path = [[answerPath stringByDeletingLastPathComponent] lastPathComponent];
    }
    [self.postAnswerInterface postAnswerFileWith:path];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //TODO:判断做题历史 or  做题
    if ([DataService sharedService].isHistory==YES) {
        self.timeImg.hidden=YES; self.timerLabel.hidden=YES;
        self.label1.hidden=NO;self.label2.hidden=NO;self.rotioLabel.hidden=NO;self.timeLabel.hidden=NO;
    }else {
        self.timeImg.hidden=NO; self.timerLabel.hidden=NO;
        self.label1.hidden=YES;self.label2.hidden=YES;self.rotioLabel.hidden=YES;self.timeLabel.hidden=YES;
        if ([DataService sharedService].number_reduceTime <= 0) {
            [self.reduceTimeButton setEnabled:NO];
        }
        if ([DataService sharedService].number_correctAnswer <= 0) {
            [self.appearCorrectButton setEnabled:NO];
        }
    }
    [self startTimer];
    switch (self.homeworkType) {
        case HomeworkType_line://连线
        {
            self.liningView = [[LininggViewController alloc]initWithNibName:@"LininggViewController" bundle:nil];
            [self.liningView willMoveToParentViewController:self];
            self.liningView.view.frame = self.contentView.bounds;
            [self.appearCorrectButton addTarget:self.liningView action:@selector(showLiningCorrectAnswer) forControlEvents:UIControlEventTouchUpInside];
            [self.reduceTimeButton addTarget:self.liningView action:@selector(liningViewReduceTimeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.quitHomeworkButton addTarget:self.liningView action:@selector(exitLiningView) forControlEvents:UIControlEventTouchUpInside];
            self.liningView.checkHomeworkButton = self.checkHomeworkButton;
            [self.contentView addSubview:self.liningView.view];
            [self addChildViewController:self.liningView];
            [self.liningView didMoveToParentViewController:self];
        }
            break;
        case HomeworkType_reading:
        {
            self.readingController = [[ReadingTaskViewController alloc] initWithNibName:@"ReadingTaskViewController" bundle:nil];
            [self.readingController willMoveToParentViewController:self];
            self.readingController.view.frame = self.contentView.bounds;
            [self.appearCorrectButton setHidden:YES];
            [self.quitHomeworkButton addTarget:self.readingController action:@selector(exithomeworkUI) forControlEvents:UIControlEventTouchUpInside];
            [self.reduceTimeButton addTarget:self.readingController action:@selector(reduceTimeProBtClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.checkHomeworkButton addTarget:self.readingController action:@selector(startBeginninghomework) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.readingController.view];
            [self addChildViewController:self.readingController];
            [self.readingController didMoveToParentViewController:self];
            self.readingController.isPrePlay = YES;
            self.readingController.isFirst = YES;
            break;
        }
        case HomeworkType_listeningAndWrite://听写
        {
            self.listenView = [[ListenWriteViewController alloc]initWithNibName:@"ListenWriteViewController" bundle:nil];
            [self.listenView willMoveToParentViewController:self];
            self.listenView.view.frame = self.contentView.bounds;
            [self.appearCorrectButton setHidden:YES];
            self.listenView.checkHomeworkButton = self.checkHomeworkButton;
            [self.quitHomeworkButton addTarget:self.listenView action:@selector(exitListenView) forControlEvents:UIControlEventTouchUpInside];
            [self.reduceTimeButton addTarget:self.listenView action:@selector(listenViewReduceTimeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.listenView.view];
            [self addChildViewController:self.listenView];
            [self.listenView didMoveToParentViewController:self];
        }
            break;
        case HomeworkType_fillInBlanks://完形填空
        {
            self.selectedView = [[SelectedViewController alloc]initWithNibName:@"SelectedViewController" bundle:nil];
            [self.selectedView willMoveToParentViewController:self];
            self.selectedView.view.frame = self.contentView.bounds;
            self.selectedView.checkHomeworkButton = self.checkHomeworkButton;
             [self.quitHomeworkButton addTarget:self.selectedView action:@selector(exitClozeView) forControlEvents:UIControlEventTouchUpInside];
            [self.appearCorrectButton addTarget:self.selectedView action:@selector(showClozeCorrectAnswer) forControlEvents:UIControlEventTouchUpInside];
            [self.reduceTimeButton addTarget:self.selectedView action:@selector(clozeViewReduceTimeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
           
            [self.contentView addSubview:self.selectedView.view];
            [self addChildViewController:self.selectedView];
            [self.selectedView didMoveToParentViewController:self];
        }
            break;
        case HomeworkType_sort://排序
        {
            self.sortView = [[SortViewController alloc]initWithNibName:@"SortViewController" bundle:nil];
            [self.sortView willMoveToParentViewController:self];
            self.sortView.view.frame = self.contentView.bounds;
             self.sortView.checkHomeworkButton = self.checkHomeworkButton;
            [self.quitHomeworkButton addTarget:self.sortView action:@selector(exitSortView) forControlEvents:UIControlEventTouchUpInside];
            [self.appearCorrectButton addTarget:self.sortView action:@selector(showSortCorrectAnswer) forControlEvents:UIControlEventTouchUpInside];
            [self.reduceTimeButton addTarget:self.sortView action:@selector(sortViewReduceTimeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
           
            [self.contentView addSubview:self.sortView.view];
            [self addChildViewController:self.sortView];
            [self.sortView didMoveToParentViewController:self];
        }
            break;
        case HomeworkType_quick://十速挑战
            //十速挑战没有道具栏,contentView应为 {0,75,768,949}
        {
            [self.djView setHidden:YES];
            self.tenSecViewController = [[TenSecChallengeViewController alloc] initWithNibName:@"TenSecChallengeViewController" bundle:nil];
            [self.tenSecViewController willMoveToParentViewController:self];
            [self.contentView setFrame:(CGRect){0,75,768,949}];
            
            [self.tenSecViewController.contentBgView setFrame:(CGRect){0,0,768,949}];
            [self addChildViewController:self.tenSecViewController];
            [self.contentView addSubview:self.tenSecViewController.view];
            [self.tenSecViewController didMoveToParentViewController:self];
            self.tenSecViewController.isViewingHistory = [DataService sharedService].isHistory;
            [self.tenSecViewController startChallenge];
            [self.quitHomeworkButton addTarget:self.tenSecViewController action:@selector(tenQuitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (![DataService sharedService].isHistory) {
                [self.checkBgView setHidden:YES];
            }else{
                [self.checkHomeworkButton addTarget:self.tenSecViewController action:@selector(showNextQuestion) forControlEvents:UIControlEventTouchUpInside];
                [self.checkHomeworkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [self.checkHomeworkButton setTitle:@"下一题" forState:UIControlStateNormal];
                self.checkHomeworkButton.frame = (CGRect){0,0,[self.checkHomeworkButton superview].frame.size};
                self.checkHomeworkButton.backgroundColor = self.checkBgView.backgroundColor ;
            }
        }
            break;
        case HomeworkType_select://选择挑战
        {
            self.selectingChallengeViewController = [[SelectingChallengeViewController alloc] initWithNibName:@"SelectingChallengeViewController" bundle:nil];
            [self.selectingChallengeViewController willMoveToParentViewController:self];
            [self.selectingChallengeViewController.contentBgView setFrame:(CGRect){0,0,768,874}];
            [self addChildViewController:self.selectingChallengeViewController];
            [self.contentView addSubview:self.selectingChallengeViewController.view];
            [self.selectingChallengeViewController didMoveToParentViewController:self];
            [self.checkHomeworkButton addTarget:self.selectingChallengeViewController action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.appearCorrectButton addTarget:self.selectingChallengeViewController action:@selector(propOfShowingAnswerClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.reduceTimeButton addTarget:self.selectingChallengeViewController action:@selector(propOfReduceTimeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.quitHomeworkButton addTarget:self.selectingChallengeViewController action:@selector(seQuitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            self.selectingChallengeViewController.topBarView.hidden = YES;
//            self.selectingChallengeViewController.itemsView.hidden = YES;
            self.selectingChallengeViewController.isViewingHistory = [DataService sharedService].isHistory;
        }
            break;
        default:
            break;
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PostDelegate上传answer文件代理
-(void)getPostInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.successBlock) {
            self.successBlock(@"上传成功");
        }
    });
}

-(void)getPostInfoDidFailed:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.failureBlock) {
            self.failureBlock(errorMsg);
        }
    });
}
#pragma mark --


#pragma mark -- property
-(BasePostInterface *)postAnswerInterface{
    if (!_postAnswerInterface) {
        _postAnswerInterface = [[BasePostInterface alloc] init];
        _postAnswerInterface.delegate = self;
    }
    return _postAnswerInterface;
}

-(void)setSpendSecond:(long long)spendSecond{
    _spendSecond = spendSecond;
    self.timerLabel.text = [Utility formateDateStringWithSecond:(NSInteger)self.spendSecond];
}

- (IBAction)quitButtonClicked:(id)sender {
    
}
@end
