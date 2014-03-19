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
#import "HomeworkDailyCollectionViewController.h"
#import "HomeworkViewController.h"

#import "LogInViewController.h" //登录
#import "CardpackageViewController.h"//卡包

#import "ReadingTaskViewController.h"
#import "LiningHomeworkViewController.h"
#import "HomeworkContainerController.h"//做题

#import "ListenWriteViewController.h"//听写
#import "SortViewController.h"//排序
#import "SelectedViewController.h"//完形填空

#import "TenSecChallengeViewController.h"


@implementation AppDelegate

+(AppDelegate *)shareIntance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)showRootView {
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"class.plist"];
    if (![fileManage fileExistsAtPath:filename]) {
        LogInViewController *logView = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
        self.window.rootViewController = logView;
    }else {
        NSDictionary *classDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        [DataService sharedService].theClass = [ClassObject classFromDictionary:classDic];
        filename = [Path stringByAppendingPathComponent:@"student.plist"];
        NSDictionary *userDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        [DataService sharedService].user = [UserObject userFromDictionary:userDic];
        
        MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:main];
        self.window.rootViewController = navControl;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置popoverViewController属性
    WYPopoverBackgroundView *popoverAppearance = [WYPopoverBackgroundView appearance];
    [popoverAppearance setArrowHeight:10];
    [popoverAppearance setArrowBase:20];
    [popoverAppearance setFillTopColor:[UIColor colorWithRed:47/255.0 green:201/255.0 blue:133/255.0 alpha:1]];
    
    //设置语音识别的apikey
    [[iSpeechSDK sharedSDK] setAPIKey:@"74acbcbba2f470f9c9341c7e4e303027"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


//    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//    DRLeftTabBarViewController *tabBarController = [[DRLeftTabBarViewController alloc] init];
//    tabBarController.childenControllerArray = @[main];
    
    
    HomeworkContainerController *homeView = [[HomeworkContainerController alloc]initWithNibName:@"HomeworkContainerController" bundle:nil];
    self.window.rootViewController = homeView;
//    TenSecChallengeViewController *notificationViewController = [[TenSecChallengeViewController alloc] initWithNibName:@"TenSecChallengeViewController" bundle:nil];
//    self.window.rootViewController = notificationViewController;

//    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//    DRLeftTabBarViewController *tabBarController = [[DRLeftTabBarViewController alloc] init];
//    tabBarController.childenControllerArray = @[main];
//    self.window.rootViewController = tabBarController;


//     CardpackageViewController *cardView = [[CardpackageViewController alloc]initWithNibName:@"CardpackageViewController" bundle:nil];
//     UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:cardView];
//    self.window.rootViewController = navControl;
    

//    [self performSelectorOnMainThread:@selector(showRootView) withObject:nil waitUntilDone:NO];
//    [self showRootView];
    
    [self.window makeKeyAndVisible];
    
    [DataService sharedService].first = 0;[DataService sharedService].second = 0;[DataService sharedService].third = 0;[DataService sharedService].fourth = 0;
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
//QQ
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    //注册推送成功,收到设备token号
//    NSString *tokenStr = [deviceToken description];
//    NSString *pushToken = [[[tokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString *urlStr = [NSString stringWithFormat:@"https://%@/push_token",@"58.240.210.42:3004"];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
//    [req setHTTPMethod:@"POST"];
//    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
//    NSMutableData *postBody = [NSMutableData data];
//    [postBody appendData:[[NSString stringWithFormat:@"username=%@",@"啦啦"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postBody appendData:[[NSString stringWithFormat:@"&token=%@",pushToken] dataUsingEncoding:NSUTF8StringEncoding]];
//    [req setHTTPBody:postBody];
//    id a = [[NSURLConnection alloc] initWithRequest:req delegate:nil];
//}

//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
//    //注册推送不成功
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    //收到远程通知推送
//}



@end
