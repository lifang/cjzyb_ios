//
//  MainViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "MainViewController.h"
//顶部页面控制
#import "DAPagesContainer.h"
//3个子页面
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"


@interface MainViewController ()
@property (strong, nonatomic) DAPagesContainer *pagesContainer;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)tabBarInit {
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    NSLog(@"%f",self.view.bounds.size.height);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.topBarBackgroundColor = [UIColor colorWithRed:0.8235 green:0.8275 blue:0.8314 alpha:1];
    
    //TODO:加入子页面
    FirstViewController *firstView = [[FirstViewController alloc]initWithNibName:@"FirstViewController" bundle:nil];
    firstView.title = @"first";

    SecondViewController *secondView = [[SecondViewController alloc]initWithNibName:@"SecondViewController" bundle:nil];
    secondView.title = @"second";
    
    ThirdViewController *thirdView = [[ThirdViewController alloc]initWithNibName:@"ThirdViewController" bundle:nil];
    thirdView.title = @"third";
    self.pagesContainer.viewControllers = [NSArray arrayWithObjects:firstView,secondView,thirdView, nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (platform>=7.0) {
        AppDelegate *appDel = [AppDelegate shareIntance];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.view.frame = CGRectMake(0, 0, appDel.window.frame.size.width, appDel.window.frame.size.height-44);
    }
    
    self.title = @"首页";
    
    [self tabBarInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
