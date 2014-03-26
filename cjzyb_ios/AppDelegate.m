//
//  AppDelegate.m
//  cjzyb_ios
//
//  Created by david on 14-2-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"//主页

#import "TestViewController.h"
#import "DRLeftTabBarViewController.h"
#import "HomeworkDailyCollectionViewController.h"
#import "HomeworkViewController.h"//作业
#import "LHLNotificationViewController.h"//通知
#import "LogInViewController.h" //登录

#import "ReadingTaskViewController.h"

#import "HomeworkContainerController.h"//做题
#import "CardpackageViewController.h"//卡包
#import "TenSecChallengeViewController.h"


@implementation AppDelegate
-(void)loadTrueSound:(NSInteger)index {
    NSURL *url=[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"trueMusic.wav"];
    NSError *error;
    if(self.truePlayer==nil)
    {
        self.truePlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    }
    if(index==0)
        self.truePlayer.volume=0.0f;
    else
        self.truePlayer.volume=1.0f;
    [self.truePlayer play];
}
-(void)loadFalseSound:(NSInteger)index {
    NSURL *url=[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"falseMusic.wav"];
    NSError *error;
    if(self.falsePlayer==nil)
    {
        self.falsePlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    }
    if(index==0)
        self.falsePlayer.volume=0.0f;
    else
        self.falsePlayer.volume=1.0f;
    
    [self.falsePlayer play];
}
+(AppDelegate *)shareIntance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)showHomework{
//    HomeworkContainerController *container = [[HomeworkContainerController alloc] initWithNibName:@"HomeworkContainerController" bundle:nil];
//    self.window.rootViewController = container;
//    container.homeworkType = HomeworkType_line;
}

-(void)showHomeworkType{
    HomeworkViewController *cv = [[HomeworkViewController alloc] initWithNibName:@"HomeworkViewController" bundle:nil];
    self.window.rootViewController = cv;
}

-(void)showTabBarController{
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    DRLeftTabBarViewController *tabBarController = [[DRLeftTabBarViewController alloc] init];
    tabBarController.childenControllerArray = @[main];
    self.window.rootViewController = tabBarController;
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
        DRLeftTabBarViewController *tabBarController = [[DRLeftTabBarViewController alloc] init];
        tabBarController.childenControllerArray = @[main];
        self.window.rootViewController = tabBarController;
    }
    LHLNotificationViewController *notificationViewController = [[LHLNotificationViewController alloc] initWithNibName:@"LHLNotificationViewController" bundle:nil];
    self.window.rootViewController = notificationViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    [DataService sharedService].numberOfViewArray = [[NSMutableArray alloc]initWithCapacity:4];
    //设置popoverViewController属性
    WYPopoverBackgroundView *popoverAppearance = [WYPopoverBackgroundView appearance];
    [popoverAppearance setArrowHeight:10];
    [popoverAppearance setArrowBase:20];
    [popoverAppearance setFillTopColor:[UIColor colorWithRed:47/255.0 green:201/255.0 blue:133/255.0 alpha:1]];
    
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        self.isReachable = NO;
    }else
        self.isReachable = YES;
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    [self.hostReach startNotifier];  //开始监听，会启动一个run loop
    
    
    //设置语音识别的apikey
    [[iSpeechSDK sharedSDK] setAPIKey:@"74acbcbba2f470f9c9341c7e4e303027"];
    

    
    [self showHomework];
    
//    [self showHomeworkType];
    
//    [self showTabBarController];

    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    HomeworkViewController *homework = [[HomeworkViewController alloc]initWithNibName:@"HomeworkViewController" bundle:nil];
    LHLNotificationViewController *notificationView = [[LHLNotificationViewController alloc]initWithNibName:@"LHLNotificationViewController" bundle:nil];
    CardpackageViewController *cardView = [[CardpackageViewController alloc]initWithNibName:@"CardpackageViewController" bundle:nil];
    DRLeftTabBarViewController *tabBarController = [[DRLeftTabBarViewController alloc] init];
    tabBarController.childenControllerArray = @[main,homework,notificationView,cardView];
    self.window.rootViewController = tabBarController;

    

//    [self performSelectorOnMainThread:@selector(showRootView) withObject:nil waitUntilDone:NO];
    
    
    
    
//    NSString *oringStr = @"this is an apple";
//    NSArray *orgArray = [Utility handleTheString:oringStr];
//    NSArray *metaphoneArray = [Utility metaphoneArray:orgArray];
//    NSLog(@"orgArray = %@",orgArray);
//    NSLog(@"metaphoneArray = %@",metaphoneArray);
//    
//    
//    NSString *text = @"this a salple";
//    NSArray *array = [Utility handleTheString:text];
//    NSLog(@"array = %@",array);
//    NSArray *array2 = [Utility metaphoneArray:array];
//    NSLog(@"array2 = %@",array2);
//    
//    [Utility shared].isOrg = NO;
//    [Utility shared].sureArray = [[NSMutableArray alloc]init];
//    [Utility shared].correctArray = [[NSMutableArray alloc]init];
//    [Utility shared].noticeArray = [[NSMutableArray alloc]init];
//    [Utility shared].greenArray = [[NSMutableArray alloc]init];
//    [Utility shared].yellowArray = [[NSMutableArray alloc]init];
//    [Utility shared].spaceLineArray = [[NSMutableArray alloc]init];
//    [Utility shared].wrongArray = [[NSMutableArray alloc]init];
//    [Utility shared].firstpoint = 0;
//    NSDictionary *dic = [Utility compareWithArray:array andArray:array2 WithArray:orgArray andArray:metaphoneArray WithRange:[Utility shared].rangeArray];
//    NSLog(@"dic = %@",dic);
    
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

//连接改变
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    self.isReachable = YES;
    if(status == NotReachable)
    {
//        [Utility errorAlert:@"暂无网络!"];
        self.isReachable = NO;
    }
}


@end
