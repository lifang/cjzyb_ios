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
#import "LHLNotificationContainerVC.h" //通知
#import "LogInViewController.h" //登录
#import "ReadingTaskViewController.h"
#import "HomeworkContainerController.h"//做题
#import "CardpackageViewController.h"//卡包
#import "TenSecChallengeViewController.h"
#import "PreReadingTaskViewController.h"
#import "DRSentenceSpellMatch.h"
#import "InitViewController.h"
#import "HintHelper.h"

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
-(void)loadRemoteNotificationSound:(NSInteger)index {
    NSURL *url=[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"trueMusic.wav"];
    NSError *error;
    if(self.noticationPlayer==nil)
    {
        self.noticationPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    }
    if(index==0)
        self.noticationPlayer.volume=0.0f;
    else
        self.noticationPlayer.volume=1.0f;
    [self.noticationPlayer play];
}
+(AppDelegate *)shareIntance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)showMainController{
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    HomeworkViewController *homework = [[HomeworkViewController alloc]initWithNibName:@"HomeworkViewController" bundle:nil];
    LHLNotificationContainerVC *notificationView = [[LHLNotificationContainerVC alloc]initWithNibName:@"LHLNotificationContainerVC" bundle:nil];
    CardpackageViewController *cardView = [[CardpackageViewController alloc]initWithNibName:@"CardpackageViewController" bundle:nil];
    self.tabBarController = [[DRLeftTabBarViewController alloc] init];
    self.tabBarController.childenControllerArray = @[homework,main,notificationView,cardView];
    
    self.tabBarController.currentPage = self.notification_type;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger isFirstToLoad = [[defaults objectForKey:@"isFirstToLoad"]integerValue];
    if (isFirstToLoad == 0) {
        _hintHelper = [[HintHelper alloc] initWithViewController:self.tabBarController];
        
        [defaults setObject:@"111" forKey:@"isFirstToLoad"];
        [defaults synchronize];
    }

    self.window.rootViewController = self.tabBarController;
}

//比较时间
-(BOOL)compareTimeWithString:(NSString *)string {
    NSString *str = [Utility getNowDateFromatAnDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"]];
    NSDate *endDate = [dateFormatter dateFromString:string];
    
    NSDate *nowDate = [dateFormatter dateFromString:str];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:nowDate toDate:endDate options:0];
    int hour =[d hour];int day = [d day];int month = [d month];int minute = [d minute];int second = [d second];int year = [d year];
    
    if (year>0 || month>0 || day>0 || hour>0 || minute>0 || second>0) {
        return YES;
    }else
        return NO;
}
- (void)showRootView {
    [self performSelectorOnMainThread:@selector(showMainController) withObject:nil waitUntilDone:NO];
}
-(void)showLogInView {
    LogInViewController *logView = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
    self.window.rootViewController = logView;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.the_class_id = -1;

    [DataService sharedService].notificationPage=1;
    self.notification_type = 0;
    [DataService sharedService].numberOfViewArray = [[NSMutableArray alloc]initWithCapacity:4];
    //推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //表示app是登录状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"isOn"];
    [defaults synchronize];
    
    //判断作业＋通知右上角红点点～～
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [Utility returnPath];
    NSString *filename = [path stringByAppendingPathComponent:@"type.plist"];
    if (![fileManage fileExistsAtPath:filename]) {
        self.notification_dic = [[NSMutableDictionary alloc]init];
    }else {
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        self.notification_dic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    }
    
    //网络
    self.isReachable = YES;
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
//            self.isReachable = NO;
        }
    }];
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    [self.hostReach startNotifier];  //开始监听，会启动一个run loop

    //点击推送进入App
    NSDictionary *pushDict = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (pushDict) {
        int typeValue = [[pushDict objectForKey:@"type"]integerValue];
        self.the_class_id = [[pushDict objectForKey:@"class_id"]integerValue];
        self.the_class_name = [pushDict objectForKey:@"class_name"];
        self.the_student_id = [[pushDict objectForKey:@"student_id"]integerValue];
        if (typeValue == 2) {
            self.notification_type = 0;
        }else {
            self.notification_type = 2;
            if (typeValue==0) {
                [DataService sharedService].notificationPage=1;
            }else {
                [DataService sharedService].notificationPage=0;
            }
        }
    }
    
    LogInViewController *logView = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
    self.window.rootViewController = logView;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"2" forKey:@"isOn"];
    [defaults synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"isOn"];
    [defaults synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //app退出
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"isOn"];
    [defaults synchronize];
    
    //记录作业＋通知右上角红点点～～
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [Utility returnPath];
    NSString *filename = [path stringByAppendingPathComponent:@"type.plist"];
    if ([fileManage fileExistsAtPath:filename]) {
        [fileManage removeItemAtPath:filename error:nil];
    }

    [NSKeyedArchiver archiveRootObject:self.notification_dic toFile:filename];
}

#pragma mark - QQ
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}
#pragma mark - 推送
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString *deviceStr=[deviceToken description];
    
    NSString *tempStr1=[deviceStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@">" withString:@""];
    _pushstr=[tempStr2 stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    _pushstr=@"";
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NOTIFICATIONSOUND;
    
    int type = [[userInfo objectForKey:@"type"] intValue];//推送类型
    NSString * classId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"class_id"]];//推送班级
    NSString * studentId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"student_id"]];//推送学生
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        if (i==type) {
            [mutableArray addObject:[NSString stringWithFormat:@"%d",1]];
        }else {
            [mutableArray addObject:[NSString stringWithFormat:@"%d",0]];
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isOn = [defaults objectForKey:@"isOn"];
    if ([isOn intValue] == 1) {//app登录
        BOOL isPush = NO;
        if (type==2) {
            if ([classId integerValue] == [[DataService sharedService].theClass.classId integerValue]) {//班级相同
                isPush = YES;
                if (![[self.notification_dic objectForKey:classId]isKindOfClass:[NSNull class]]  && [self.notification_dic objectForKey:classId]!=nil) {
                    NSMutableArray *mutableArr = [[NSMutableArray alloc]initWithArray:[self.notification_dic objectForKey:classId]];
                    [mutableArr replaceObjectAtIndex:type withObject:@"1"];
                    [self.notification_dic setObject:mutableArr forKey:classId];
                }else {
                    [self.notification_dic setObject:mutableArray forKey:classId];
                }
            }
        }else {
            if ([studentId integerValue] == [[DataService sharedService].user.studentId integerValue] && [classId integerValue] == [[DataService sharedService].theClass.classId integerValue]) {//学生相同
                isPush = YES;
                if (![[self.notification_dic objectForKey:classId]isKindOfClass:[NSNull class]]  && [self.notification_dic objectForKey:classId]!=nil) {
                    NSMutableArray *mutableArr = [[NSMutableArray alloc]initWithArray:[self.notification_dic objectForKey:classId]];
                    [mutableArr replaceObjectAtIndex:type withObject:@"1"];
                    [self.notification_dic setObject:mutableArr forKey:classId];
                }else {
                    [self.notification_dic setObject:mutableArray forKey:classId];
                }
            }
        }
        if (isPush==YES) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadByNotification" object:[self.notification_dic objectForKey:classId]];
        }
        
    }else if ([isOn intValue] == 2) {//app从后台进入前台
        [defaults setObject:@"1" forKey:@"isOn"];
        [defaults synchronize];
        
        self.the_class_id = [[userInfo objectForKey:@"class_id"]integerValue];
        self.the_class_name = [userInfo objectForKey:@"class_name"];
        self.the_student_id = [[userInfo objectForKey:@"student_id"]integerValue];
        if (type == 2) {
            self.notification_type = 0;
        }else {
            self.notification_type = 2;
            if (type==0) {
                [DataService sharedService].notificationPage=1;
            }else {
                [DataService sharedService].notificationPage=0;
            }
        }
        [self showRootView];
    }
}

#ifdef __IPHONE_7_0
//0:系统，1：回复，2：作业
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NOTIFICATIONSOUND;
    
    int type = [[userInfo objectForKey:@"type"] intValue];//推送类型
    NSString * classId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"class_id"]];//推送班级
    NSString * studentId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"student_id"]];//推送学生
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        if (i==type) {
            [mutableArray addObject:[NSString stringWithFormat:@"%d",1]];
        }else {
            [mutableArray addObject:[NSString stringWithFormat:@"%d",0]];
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isOn = [defaults objectForKey:@"isOn"];
    if ([isOn intValue] == 1) {//app登录
        BOOL isPush = NO;
        if (type==2) {
            if ([classId integerValue] == [[DataService sharedService].theClass.classId integerValue]) {//班级相同
                isPush = YES;
                if (![[self.notification_dic objectForKey:classId]isKindOfClass:[NSNull class]]  && [self.notification_dic objectForKey:classId]!=nil) {
                    NSMutableArray *mutableArr = [[NSMutableArray alloc]initWithArray:[self.notification_dic objectForKey:classId]];
                    [mutableArr replaceObjectAtIndex:type withObject:@"1"];
                    [self.notification_dic setObject:mutableArr forKey:classId];
                }else {
                    [self.notification_dic setObject:mutableArray forKey:classId];
                }
            }
        }else {
            if ([studentId integerValue] == [[DataService sharedService].user.studentId integerValue] && [classId integerValue] == [[DataService sharedService].theClass.classId integerValue]) {//学生相同
                isPush = YES;
                if (![[self.notification_dic objectForKey:classId]isKindOfClass:[NSNull class]]  && [self.notification_dic objectForKey:classId]!=nil) {
                    NSMutableArray *mutableArr = [[NSMutableArray alloc]initWithArray:[self.notification_dic objectForKey:classId]];
                    [mutableArr replaceObjectAtIndex:type withObject:@"1"];
                    [self.notification_dic setObject:mutableArr forKey:classId];
                }else {
                    [self.notification_dic setObject:mutableArray forKey:classId];
                }
            }
        }
        if (isPush==YES) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loadByNotification" object:[self.notification_dic objectForKey:classId]];
        }
        
    }else if ([isOn intValue] == 2) {//app从后台进入前台
        [defaults setObject:@"1" forKey:@"isOn"];
        [defaults synchronize];
        
        self.the_class_id = [[userInfo objectForKey:@"class_id"]integerValue];
        self.the_class_name = [userInfo objectForKey:@"class_name"];
        self.the_student_id = [[userInfo objectForKey:@"student_id"]integerValue];
        if (type == 2) {
            self.notification_type = 0;
        }else {
            self.notification_type = 2;
            if (type==0) {
                [DataService sharedService].notificationPage=1;
            }else {
                [DataService sharedService].notificationPage=0;
            }
        }
        [self showRootView];
    }
    completionHandler(UIBackgroundFetchResultNoData);
}
#endif

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
