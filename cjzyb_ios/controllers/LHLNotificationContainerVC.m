//
//  LHLNotificationContainerVC.m
//  cjzyb_ios
//
//  Created by apple on 14-3-31.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLNotificationContainerVC.h"

@interface LHLNotificationContainerVC ()

@end

@implementation LHLNotificationContainerVC

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
    
    [self tabBarInit];
}

- (void)tabBarInit{
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.topBarBackgroundColor = [UIColor colorWithRed:0.8235 green:0.8275 blue:0.8314 alpha:1];
    
    //加入子页面
    LHLNotificationViewController *notiVC = [[LHLNotificationViewController alloc] initWithNibName:@"LHLNotificationViewController" bundle:nil];
    notiVC.title = @"系统通知";
    notiVC.view.frame = (CGRect){0, self.pagesContainer.topBarHeight, 768, 1024-67-self.pagesContainer.topBarHeight};
    
    LHLReplyNotificationViewController *replyVC = [[LHLReplyNotificationViewController alloc] initWithNibName:@"LHLReplyNotificationViewController" bundle:nil];
    replyVC.title = @"回复通知";
    replyVC.view.frame = (CGRect){0, self.pagesContainer.topBarHeight, 768, 1024-67-self.pagesContainer.topBarHeight};
    
    self.pagesContainer.viewControllers = [NSArray arrayWithObjects:notiVC,replyVC,nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
