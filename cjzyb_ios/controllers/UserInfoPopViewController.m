//
//  UserInfoPopViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "UserInfoPopViewController.h"
#import "DRProgressView.h"
#import "ClassGroupViewController.h"
#import "ModelTypeViewController.h"
@interface UserInfoPopViewController ()
///用户所在班级按钮
@property (weak, nonatomic) IBOutlet UIButton *userClassButton;
@property(nonatomic,strong) WYPopoverController *popViewController;
//@property(nonatomic,strong) ClassGroupViewController *classGroupController;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userClassNameLabel;
///优异进度条
@property (weak, nonatomic) IBOutlet DRProgressView *youyiProgressView;
///精准进度条
@property (weak, nonatomic) IBOutlet DRProgressView *jingzhunProgressView;
///迅速进度条
@property (weak, nonatomic) IBOutlet DRProgressView *xunsuProgressView;
///捷足进度条
@property (weak, nonatomic) IBOutlet DRProgressView *jiezuProgressView;

///显示加入的班级列表
- (IBAction)userClassButtonClicked:(id)sender;

///修改用户名称
- (IBAction)modifyUserNameButtonClicked:(id)sender;
@end

@implementation UserInfoPopViewController

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
    [self.youyiProgressView setProgressValue:0.1 withLevelName:@"LV2"];
    [self.jingzhunProgressView setProgressValue:0.5 withLevelName:@"LV2"];
    [self.xunsuProgressView setProgressValue:0.4 withLevelName:@"LV2"];
    [self.jiezuProgressView setProgressValue:0.5 withLevelName:@"LV2"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userClassButtonClicked:(id)sender {
    [self.userClassButton setUserInteractionEnabled:NO];
    ClassGroupViewController *group = [[ClassGroupViewController alloc] initWithNibName:@"ClassGroupViewController" bundle:nil];
    self.popViewController = [[WYPopoverController alloc] initWithContentViewController:group];
    self.popViewController.popoverContentSize = (CGSize){224,150};
    CGRect rect = [self.view convertRect:self.userClassButton.frame fromView:self.userClassButton.superview];
    [self.popViewController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionRight animated:YES completion:^{
        [self.userClassButton setUserInteractionEnabled:YES];
    }];
}

- (IBAction)modifyUserNameButtonClicked:(id)sender {
    
    [ModelTypeViewController presentTypeViewWithTipString:@"请输入名称：" withFinishedInput:^(NSString *inputString) {
        
    } withCancel:nil];
}
@end
