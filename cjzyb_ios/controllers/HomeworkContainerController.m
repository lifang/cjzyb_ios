//
//  HomeworkContainerController.m
//  cjzyb_ios
//
//  Created by david on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "HomeworkContainerController.h"

@interface HomeworkContainerController ()
///连线题controller
@property (nonatomic,strong) LiningHomeworkViewController *liningHomeworkController;

///朗读题controller
@property (nonatomic,strong) ReadingTaskViewController *readingController;
@property (nonatomic,strong) ListenWriteViewController *listenView;//听写
@property (nonatomic,strong) SortViewController *sortView;//排序
@property (nonatomic,strong) SelectedViewController *selectedView;//完形填空
///计时器
@property (nonatomic,strong) NSTimer *timer;
/////减时间
//- (IBAction)reduceTimeButtonClicked:(id)sender;
///退出作业
- (IBAction)quitButtonClicked:(id)sender;

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
    self.timerLabel.text = [Utility formateDateStringWithSecond:self.spendSecond];
}

///开始计时
-(void)startTimer{
//    self.timerLabel.text = [NSString stringWithFormat:@"%lld",self.spendSecond];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.spendSecond = 0;[DataService sharedService].number_reduceTime=2;[DataService sharedService].isHistory=YES;
    //TODO:判断做题历史 or  做题
    if ([DataService sharedService].isHistory==YES) {
        self.timeImg.hidden=YES; self.timerLabel.hidden=YES;
        self.label1.hidden=NO;self.label2.hidden=NO;self.rotioLabel.hidden=NO;self.timeLabel.hidden=NO;
    }else {
        self.timeImg.hidden=NO; self.timerLabel.hidden=NO;
        self.label1.hidden=YES;self.label2.hidden=YES;self.rotioLabel.hidden=YES;self.timeLabel.hidden=YES;
    }
    [self startTimer];
    self.homeworkType = HomeworkType_fillInBlanks;
    switch (self.homeworkType) {
        case HomeworkType_line:
        {
            self.liningHomeworkController = [[LiningHomeworkViewController alloc] initWithNibName:@"LiningHomeworkViewController" bundle:nil];
            [self.liningHomeworkController willMoveToParentViewController:self];
            self.liningHomeworkController.view.frame = self.contentView.bounds;
            [self.appearCorrectButton addTarget:self.liningHomeworkController action:@selector(tipCorrectAnswer) forControlEvents:UIControlEventTouchUpInside];
            [self.checkHomeworkButton addTarget:self.liningHomeworkController action:@selector(reloadNextLineSubject) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.liningHomeworkController.view];
            [self addChildViewController:self.liningHomeworkController];
            [self.liningHomeworkController didMoveToParentViewController:self];
        }
            break;
        case HomeworkType_reading:
        {
            self.readingController = [[ReadingTaskViewController alloc] initWithNibName:@"ReadingTaskViewController" bundle:nil];
            [self.readingController willMoveToParentViewController:self];
            self.readingController.view.frame = self.contentView.bounds;
            [self.appearCorrectButton setHidden:YES];
            [self.checkHomeworkButton addTarget:self.readingController action:@selector(updateNextSentence) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.readingController.view];
            [self addChildViewController:self.readingController];
            [self.readingController didMoveToParentViewController:self];
        }
        case HomeworkType_listeningAndWrite://听写
        {
            self.listenView = [[ListenWriteViewController alloc]initWithNibName:@"ListenWriteViewController" bundle:nil];
            [self.listenView willMoveToParentViewController:self];
            self.listenView.view.frame = self.contentView.bounds;
            [self.appearCorrectButton setHidden:YES];
            self.listenView.checkHomeworkButton = self.checkHomeworkButton;
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
            [self.appearCorrectButton addTarget:self.selectedView action:@selector(showClozeCorrectAnswer) forControlEvents:UIControlEventTouchUpInside];
            [self.reduceTimeButton addTarget:self.selectedView action:@selector(clozeViewReduceTimeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            self.selectedView.checkHomeworkButton = self.checkHomeworkButton;
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
            [self.appearCorrectButton addTarget:self.sortView action:@selector(showSortCorrectAnswer) forControlEvents:UIControlEventTouchUpInside];
            [self.reduceTimeButton addTarget:self.sortView action:@selector(sortViewReduceTimeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            self.sortView.checkHomeworkButton = self.checkHomeworkButton;
            [self.contentView addSubview:self.sortView.view];
            [self addChildViewController:self.sortView];
            [self.sortView didMoveToParentViewController:self];
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



- (IBAction)quitButtonClicked:(id)sender {
    
}
@end
