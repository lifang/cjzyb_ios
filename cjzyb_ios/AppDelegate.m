//
//  AppDelegate.m
//  cjzyb_ios
//
//  Created by david on 14-2-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"//主页
#import "FirstViewController.h"
#import "TestViewController.h"
#import "SecondViewController.h"
#import "DRLeftTabBarViewController.h"
@implementation AppDelegate

+(AppDelegate *)shareIntance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置popoverViewController属性
    WYPopoverBackgroundView *popoverAppearance = [WYPopoverBackgroundView appearance];
    [popoverAppearance setArrowHeight:10];
    [popoverAppearance setArrowBase:20];
    [popoverAppearance setFillTopColor:[UIColor colorWithRed:47/255.0 green:201/255.0 blue:133/255.0 alpha:1]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    SecondViewController *first = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    DRLeftTabBarViewController *tabController = [[DRLeftTabBarViewController alloc] init];
    tabController.childenControllerArray = @[main,first];
//    UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:tabController];
//    self.window.rootViewController = navControl;
    
    TenSecChallengeViewController *notificationViewController = [[TenSecChallengeViewController alloc] initWithNibName:@"TenSecChallengeViewController" bundle:nil];
    self.window.rootViewController = notificationViewController;
    
    /*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    SecondViewController *first = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    DRLeftTabBarViewController *tabController = [[DRLeftTabBarViewController alloc] init];
    tabController.childenControllerArray = @[main,first];
    UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:tabController];
    self.window.rootViewController = navControl;
    [self.window makeKeyAndVisible];
    LHLNotificationViewController *notificationViewController = [[LHLNotificationViewController alloc] initWithNibName:@"LHLNotificationViewController" bundle:nil];
    self.window.rootViewController = notificationViewController;
//    LHLNotificationViewController *notificationViewController = [[LHLNotificationViewController alloc] initWithNibName:@"LHLNotificationViewController" bundle:nil];
//    self.window.rootViewController = notificationViewController;
    */
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
