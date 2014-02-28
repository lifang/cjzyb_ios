//
//  DRLeftTabBarViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRLeftTabBarViewController.h"
#import "DRNavigationRightItem.h"
#import "UserInfoPopViewController.h"

@interface DRLeftTabBarViewController ()
@property (nonatomic,strong) LeftTabBarView *leftTabBar;
@property (nonatomic,strong) UIButton *leftItemButton;
@property (nonatomic,strong) DRNavigationRightItem *rightItemButton;
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
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:47/255.0 green:201/255.0 blue:133/255.0 alpha:1]];
    //设置左边按钮
     self.leftItemButton = [[UIButton alloc] initWithFrame:(CGRect){0,0,50,44}];
    [self.leftItemButton setImage:[UIImage imageNamed:@"navigationBarLeftItem.png"] forState:UIControlStateNormal];
    [self.leftItemButton addTarget:self action:@selector(navigationLeftItemClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftItemButton];
    
    //设置左边栏
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"LeftTabBarView" owner:self options:nil];
    self.leftTabBar = (LeftTabBarView*)[bundles objectAtIndex:0];
    self.leftTabBar.delegate = self;
    _isHiddleLeftTabBar = YES;
    self.leftTabBar.frame = (CGRect){-100,44,100,1024-44};
    [self.view addSubview:self.leftTabBar];
    [self.leftTabBar defaultSelected];
    
    //设置右边按钮
    NSArray *rightItemBundles = [[NSBundle mainBundle] loadNibNamed:@"DRNavigationRightItem" owner:self options:nil];
    self.rightItemButton = (DRNavigationRightItem*)[rightItemBundles objectAtIndex:0];
    [self.rightItemButton.itemCoverButton addTarget:self action:@selector(navigationRightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItemButton];
    // Do any additional setup after loading the view from its nib.
    
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
    childController.view.frame = (CGRect){0,44,768,1024-44};
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
    to.view.frame =  (CGRect){0,44,768,1024-44};
    [self transitionFromViewController:from toViewController:to duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        self.currentViewController = to;
        [self.view bringSubviewToFront:self.leftTabBar];
    }];
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
    [self.rightItemButton setUserInteractionEnabled:NO];
     self.poprController= [[WYPopoverController alloc] initWithContentViewController:self.userInfoPopViewController];
    self.poprController.popoverContentSize = (CGSize){224,293};
    [self.poprController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES completion:^{
        [self.rightItemButton setUserInteractionEnabled:YES];
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
    
    [self hiddleStudentListViewController:self.studentListViewController];
    if (itemType < self.childViewControllers.count) {
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
     [self.leftItemButton setEnabled:NO];
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
            [self.leftItemButton setEnabled:YES];
        }];
    }else{
        if (isHiddle) {
            self.leftTabBar.center = (CGPoint){-CGRectGetWidth(self.leftTabBar.frame),self.leftTabBar.center.y};
        }else{
            self.leftTabBar.center = (CGPoint){CGRectGetWidth(self.leftTabBar.frame)/2,self.leftTabBar.center.y};
        }
        [self.leftItemButton setEnabled:YES];
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
