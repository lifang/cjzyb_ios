//
//  DRLeftTabBarViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRLeftTabBarViewController.h"
#import "DRNavigationBar.h"
#import "UserInfoPopViewController.h"

@interface DRLeftTabBarViewController ()
@property (nonatomic,strong) LeftTabBarView *leftTabBar;
@property (nonatomic,strong) DRNavigationBar *drNavigationBar;
@property (nonatomic,strong) UserInfoPopViewController *userInfoPopViewController;
@property (nonatomic,strong) WYPopoverController *poprController;
@property (nonatomic,strong) StudentListViewController *studentListViewController;
@end

@implementation DRLeftTabBarViewController

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
    //设置左边栏
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"LeftTabBarView" owner:self options:nil];
    self.leftTabBar = (LeftTabBarView*)[bundles objectAtIndex:0];
    self.leftTabBar.delegate = self;
    _isHiddleLeftTabBar = YES;
    self.leftTabBar.frame = (CGRect){-120,67,120,1024-67};
    [self.view addSubview:self.leftTabBar];
    [self.leftTabBar defaultSelected];
    
    //设置导航栏
    self.drNavigationBar = [[[NSBundle mainBundle]  loadNibNamed:@"DRNavigationBar" owner:self options:nil] firstObject];
    [self.drNavigationBar.rightButtonItem addTarget:self action:@selector(navigationRightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.drNavigationBar.leftButtonItem addTarget:self action:@selector(navigationLeftItemClicked) forControlEvents:UIControlEventTouchUpInside];
    self.drNavigationBar.frame = (CGRect){0,0,768,67};
    [self.view addSubview:self.drNavigationBar];
    //设置子controller
    self.currentViewController = [self.childenControllerArray firstObject];
    if (self.currentViewController) {
        [self addOneController:self.currentViewController];
    }
    
    //加载用户信息界面
    self.userInfoPopViewController = [[UserInfoPopViewController alloc] initWithNibName:@"UserInfoPopViewController" bundle:nil];
    
    //加载学生列表界面
    self.studentListViewController = [[StudentListViewController alloc] initWithNibName:@"StudentListViewController" bundle:nil];
    self.studentListViewController.delegate = self;
}


#pragma mark 子controller之间切换
-(void)addOneController:(UIViewController*)childController{
    if (!childController) {
        return;
    }
    [childController willMoveToParentViewController:childController];
    childController.view.frame = (CGRect){0,67,768,1024-67};
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.leftTabBar];
}

-(void)changeFromController:(UIViewController*)from toController:(UIViewController*)to{
    if (!from || !to) {
        return;
    }
    if (from == to) {
        return;
    }
    to.view.frame =  (CGRect){0,67,768,1024-67};
    [self transitionFromViewController:from toViewController:to duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        self.currentViewController = to;
        [self.view bringSubviewToFront:self.leftTabBar];
    }];
    [self.view bringSubviewToFront:self.leftTabBar];
}
#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 导航栏
///导航栏左边item点击事件
-(void)navigationLeftItemClicked{
    self.isHiddleLeftTabBar = !self.isHiddleLeftTabBar;
    if (self.isHiddleLeftTabBar) {
        self.leftTabBar.userGroupTabBarItem.isSelected = NO;
        [self hiddleStudentListViewController:self.studentListViewController];
    }
}
///导航栏右边item点击事件
-(void)navigationRightItemClicked{
    [self.drNavigationBar.rightButtonItem setUserInteractionEnabled:NO];
     self.poprController= [[WYPopoverController alloc] initWithContentViewController:self.userInfoPopViewController];
    self.poprController.theme.tintColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillTopColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillBottomColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.glossShadowColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    
    self.poprController.popoverContentSize = (CGSize){224,293};
    CGRect rect = (CGRect){720,0,50,70};
    [self.poprController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES completion:^{
        [self.drNavigationBar.rightButtonItem setUserInteractionEnabled:YES];
    }];
}
#pragma mark --
///隐藏学生列表
-(void)hiddleStudentListViewController:(StudentListViewController*)controller{
    if ([self.childViewControllers containsObject:controller]) {
        [self.view setUserInteractionEnabled:NO];
        [controller willMoveToParentViewController:nil];
        [UIView animateWithDuration:0.5 animations:^{
            controller.view.center = (CGPoint){-CGRectGetWidth(controller.view.frame),controller.view.center.y};
        } completion:^(BOOL finished) {
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
            [controller didMoveToParentViewController:nil];
            [self.view setUserInteractionEnabled:YES];
        }];
        
    }
}
///显示学生列表
-(void)appearStudentListViewController:(StudentListViewController*)controller{
    if (![self.childViewControllers containsObject:controller]) {
        [self.view setUserInteractionEnabled:NO];
        [controller willMoveToParentViewController:self];
        [self addChildViewController:controller];
        controller.view.frame = (CGRect){-CGRectGetWidth(controller.view.frame),CGRectGetMinY(self.leftTabBar.frame),200,CGRectGetHeight(self.leftTabBar.frame)};
        [self.view addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        [self.view bringSubviewToFront:self.leftTabBar];
        [UIView animateWithDuration:0.5 animations:^{
            controller.view.frame = (CGRect){CGRectGetMaxX(self.leftTabBar.frame)-12,CGRectGetMinY(self.leftTabBar.frame),200,CGRectGetHeight(self.leftTabBar.frame)};
        } completion:^(BOOL finished) {
            [self.view setUserInteractionEnabled:YES];
        }];
        
    }
}
#pragma mark LeftTabBarViewDelegate 左边栏代理
-(void)leftTabBar:(LeftTabBarView *)tabBarView selectedItem:(LeftTabBarItemType)itemType{
    NSLog(@"%d",itemType);

    
    if (itemType == LeftTabBarItemType_userGroup ) {
        if (tabBarView.userGroupTabBarItem.isSelected) {
            [self appearStudentListViewController:self.studentListViewController];
        }else{
            [self hiddleStudentListViewController:self.studentListViewController];
        }
        return;
    }else{
        if (tabBarView.userGroupTabBarItem.isSelected) {
            tabBarView.userGroupTabBarItem.isSelected = NO;
             [self hiddleStudentListViewController:self.studentListViewController];
        }
    }
    
    if (itemType < self.childenControllerArray.count) {
        [self changeFromController:self.currentViewController toController:[self.childenControllerArray objectAtIndex:itemType]];
    }
}
#pragma mark --

#pragma mark StudentListViewControllerDelegate学生列表点击返回按钮
-(void)studentListViewController:(StudentListViewController *)controller backButtonClicked:(UIButton *)button{
    self.leftTabBar.userGroupTabBarItem.isSelected = NO;
    [self hiddleStudentListViewController:controller];
}
#pragma mark --

///设置隐藏左侧边栏
-(void)hiddleLeftTabBar:(BOOL)isHiddle withAnimation:(BOOL)animation{
     [self.drNavigationBar.leftButtonItem setEnabled:NO];
    if (animation) {
        [self.leftTabBar.layer removeAllAnimations];
        if (isHiddle) {
            self.leftTabBar.center = (CGPoint){CGRectGetWidth(self.leftTabBar.frame)/2,self.leftTabBar.center.y};
        }else{
            self.leftTabBar.center = (CGPoint){-CGRectGetWidth(self.leftTabBar.frame),self.leftTabBar.center.y};
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            if (isHiddle) {
                self.leftTabBar.center = (CGPoint){-CGRectGetWidth(self.leftTabBar.frame),self.leftTabBar.center.y};
            }else{
                self.leftTabBar.center = (CGPoint){CGRectGetWidth(self.leftTabBar.frame)/2,self.leftTabBar.center.y};
            }
        } completion:^(BOOL finished) {
            [self.drNavigationBar.leftButtonItem setEnabled:YES];
        }];
    }else{
        if (isHiddle) {
            self.leftTabBar.center = (CGPoint){-CGRectGetWidth(self.leftTabBar.frame),self.leftTabBar.center.y};
        }else{
            self.leftTabBar.center = (CGPoint){CGRectGetWidth(self.leftTabBar.frame)/2,self.leftTabBar.center.y};
        }
        [self.drNavigationBar.leftButtonItem setEnabled:YES];
    }
}


#pragma mark progerty
-(void)setIsHiddleLeftTabBar:(BOOL)isHiddleLeftTabBar{
    _isHiddleLeftTabBar = isHiddleLeftTabBar;
    [self hiddleLeftTabBar:isHiddleLeftTabBar withAnimation:YES];
}

-(void)setChildenControllerArray:(NSArray *)childenControllerArray{
    if (_childenControllerArray != childenControllerArray && childenControllerArray&& childenControllerArray.count > 0) {
        for (UIViewController *controller in childenControllerArray) {
            [self addChildViewController:controller];
        }
    }
    
    _childenControllerArray = childenControllerArray;
}
#pragma mark --

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    self.isHiddleLeftTabBar = YES;
//}
@end
