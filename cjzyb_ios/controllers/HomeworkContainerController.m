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
///计时器
@property (nonatomic,strong) NSTimer *timer;
///减时间
- (IBAction)reduceTimeButtonClicked:(id)sender;
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
    self.spendSecond = 0;
    self.timerLabel.text = @"";
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
    [self startTimer];
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

- (IBAction)reduceTimeButtonClicked:(id)sender {
    if (self.spendSecond > 5) {
        self.spendSecond = self.spendSecond -5;
    }else{
        self.spendSecond = 0;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){self.view.frame.size.width/2,120,70,50}];
    [label setFont:[UIFont systemFontOfSize:50]];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor orangeColor];
    label.text = @"-5";
    [self.view addSubview:label];
    [self.view setUserInteractionEnabled:NO];
    label.alpha = 1;
    [UIView animateWithDuration:1 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
    }];
}

- (IBAction)quitButtonClicked:(id)sender {
    
}
@end
