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
@property (weak, nonatomic) IBOutlet UIView *contentBgView;  //正文背景
@property (weak, nonatomic) IBOutlet UIView *itemsView;   //道具背景
@property (weak, nonatomic) IBOutlet UIView *questionView;  //问题view
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITableView *optionTable;  //选项table

@property (assign,nonatomic) SelectingType selectingType;  //本题题目类型 填空/看图/听力
@property (assign,nonatomic) NSTimeInterval timeCount;//计时 (秒)
@property (strong,nonatomic) NSTimer *timer;
@property (assign,nonatomic) NSInteger currentNO;//当前正在做的题目序号,如超过问题数量代表答题完毕
@property (assign,nonatomic) BOOL isLastQuestion; //是否最后一题
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
    NSArray *ary = [SelectingChallengeObject parseSelectingChallengeFromQuestion];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
