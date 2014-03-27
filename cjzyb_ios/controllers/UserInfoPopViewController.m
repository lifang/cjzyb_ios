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
#import "UserObjDaoInterface.h"
#import "ModelTypeViewController.h"
#import "DRLeftTabBarViewController.h"
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
//    [self.youyiProgressView setProgressValue:0.1 withLevelName:@"LV2"];
//    [self.jingzhunProgressView setProgressValue:0.5 withLevelName:@"LV2"];
//    [self.xunsuProgressView setProgressValue:0.4 withLevelName:@"LV2"];
//    [self.jiezuProgressView setProgressValue:0.5 withLevelName:@"LV2"];
    // Do any additional setup after loading the view from its nib.
}

-(void)updateViewContents{
    DataService *data = [DataService sharedService];
    self.userNameLabel.text = data.user.nickName;
    self.drleftTabBarController.drNavigationBar.userNameLabel.text = data.user.nickName;
    self.userClassNameLabel.text = data.theClass.name;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak UserInfoPopViewController *weakSelf = self;
    [UserObjDaoInterface downloadUserAchievementWithUserId:data.user.studentId withGradeID:data.theClass.classId withSuccess:^(int youxi, int xunsu, int jiezu, int jingzhun) {
        UserInfoPopViewController *tempSelf = weakSelf;
        if (tempSelf) {
            data.user.youyiScore = youxi;
            data.user.xunsuScore = xunsu;
            data.user.jiezuScore = jiezu;
            data.user.jingzhunScore = jingzhun;
            [self.youyiProgressView updateContentWithScore:youxi];
            [self.xunsuProgressView updateContentWithScore:xunsu];
            [self.jiezuProgressView updateContentWithScore:jiezu];
            [self.jingzhunProgressView updateContentWithScore:jingzhun];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } withFailure:^(NSError *error) {
        UserInfoPopViewController *tempSelf = weakSelf;
        if (tempSelf) {
            [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userClassButtonClicked:(id)sender {
    [self.userClassButton setUserInteractionEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak UserInfoPopViewController *weakSelf = self;
    
    [UserObjDaoInterface dowloadGradeListWithUserId:[DataService sharedService].user.studentId withSuccess:^(NSArray *gradeList) {
        UserInfoPopViewController *tempSelf = weakSelf;
        if (tempSelf) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ClassGroupViewController *group = [[ClassGroupViewController alloc] initWithNibName:@"ClassGroupViewController" bundle:nil];
            tempSelf.popViewController = [[WYPopoverController alloc] initWithContentViewController:group];
            tempSelf.popViewController.theme.tintColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
            tempSelf.popViewController.theme.fillTopColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
            tempSelf.popViewController.theme.fillBottomColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
            tempSelf.popViewController.theme.glossShadowColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
            tempSelf.popViewController.popoverContentSize = (CGSize){224,150};
            group.classArray =[NSMutableArray arrayWithArray:gradeList] ;
            CGRect rect = [tempSelf.view convertRect:tempSelf.userClassButton.frame fromView:tempSelf.userClassButton.superview];
            [tempSelf.popViewController presentPopoverFromRect:rect inView:tempSelf.view permittedArrowDirections:WYPopoverArrowDirectionRight animated:YES completion:^{
                [tempSelf.userClassButton setUserInteractionEnabled:YES];
            }];
        }
    } withFailure:^(NSError *error) {
        UserInfoPopViewController *tempSelf = weakSelf;
        if (tempSelf) {
            [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
            [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
             [tempSelf.userClassButton setUserInteractionEnabled:YES];
        }
    }];
}

- (IBAction)modifyUserNameButtonClicked:(id)sender {
    __weak UserInfoPopViewController *weakSelf = self;
    DataService *data = [DataService sharedService];
    
    [ModelTypeViewController presentTypeViewWithTipString:@"请输入新名称：" withFinishedInput:^(NSString *inputString) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [UserObjDaoInterface modifyUserNickNameAndHeaderImageWithUserId:data.user.studentId withUserName:data.user.name withUserNickName:data.user.nickName withHeaderData:nil withSuccess:^(NSString *msg) {
            UserInfoPopViewController *tempSelf = weakSelf;
            if (tempSelf) {
                data.user.nickName = inputString;
                [tempSelf updateViewContents];
                [Utility errorAlert:msg];
                [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
            }
        } withFailure:^(NSError *error) {
            UserInfoPopViewController *tempSelf = weakSelf;
            if (tempSelf) {
                [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
                [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
            }
        }];
    } withCancel:nil];
}
@end
