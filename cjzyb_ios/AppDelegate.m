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

//TODO:显示朗读的预听界面
-(void)showPreReadingHomework{
    ReadingHomeworkObj *homework = [[ReadingHomeworkObj alloc] init];
    NSMutableArray *senArr = [NSMutableArray array];
    for (int i =0 ; i < 10; i++) {
        ReadingSentenceObj *sentence = [[ReadingSentenceObj alloc] init];
        sentence.readingSentenceContent = @"how are you";
        [senArr addObject:sentence];
    }
    homework.readingHomeworkSentenceObjArray = senArr;
    PreReadingTaskViewController *preReadingController = [[PreReadingTaskViewController alloc] initWithNibName:@"PreReadingTaskViewController" bundle:nil];
    [preReadingController startPreListeningHomeworkSentence:homework withPlayFinished:^(BOOL isSuccess) {
        
    }];
    self.window.rootViewController = preReadingController;
}

-(void)showMainController{
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    HomeworkViewController *homework = [[HomeworkViewController alloc]initWithNibName:@"HomeworkViewController" bundle:nil];
    LHLNotificationContainerVC *notificationView = [[LHLNotificationContainerVC alloc]initWithNibName:@"LHLNotificationContainerVC" bundle:nil];
    CardpackageViewController *cardView = [[CardpackageViewController alloc]initWithNibName:@"CardpackageViewController" bundle:nil];
    self.tabBarController = [[DRLeftTabBarViewController alloc] init];
    self.tabBarController.childenControllerArray = @[main,homework,notificationView,cardView];
    
    self.tabBarController.currentPage = self.notification_type;
    
    self.window.rootViewController = self.tabBarController;
}

-(void)showHomework{
    HomeworkContainerController *container = [[HomeworkContainerController alloc] initWithNibName:@"HomeworkContainerController" bundle:nil];
    self.window.rootViewController = container;
    container.homeworkType = HomeworkType_line;
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
//比较时间
-(BOOL)compareTimeWithString:(NSString *)string {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *endDate = [dateFormatter dateFromString:string];
    
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:nowDate toDate:endDate options:0];
    int hour =[d hour];int day = [d day];int month = [d month];int minute = [d minute];int second = [d second];int year = [d year];
    
    if (year>0 || month>0 || day>0 || hour>0 || minute>0 || second>0) {
        return YES;
    }else
        return NO;
}
- (void)showRootView{
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [Utility returnPath];
    NSString *filename = [path stringByAppendingPathComponent:@"class.plist"];
    if (![fileManage fileExistsAtPath:filename]) {
        LogInViewController *logView = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
        self.window.rootViewController = logView;
    }else {
        NSDictionary *classDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        [DataService sharedService].theClass = [ClassObject classFromDictionary:classDic];
        
        BOOL isExpire = [self compareTimeWithString:[DataService sharedService].theClass.expireTime];
        if (isExpire==NO) {
            [fileManage removeItemAtPath:filename error:nil];
            filename = [path stringByAppendingPathComponent:@"student.plist"];
            [fileManage removeItemAtPath:filename error:nil];
            
            LogInViewController *logView = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
            self.window.rootViewController = logView;
        }else {
            filename = [path stringByAppendingPathComponent:@"student.plist"];
            NSDictionary *userDic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
            [DataService sharedService].user = [UserObject userFromDictionary:userDic];
            
            if (self.the_class_id>0) {
                if (self.the_student_id == [[DataService sharedService].user.studentId integerValue]) {//学生student—id相同
                    [DataService sharedService].theClass.classId = [NSString stringWithFormat:@"%d",self.the_class_id];
                    [DataService sharedService].theClass.name = [NSString stringWithFormat:@"%@",self.the_class_name];
                    
                    [self performSelectorOnMainThread:@selector(showMainController) withObject:nil waitUntilDone:NO];
                }else {
                    NSFileManager *fileManage = [NSFileManager defaultManager];
                    NSString *path = [Utility returnPath];
                    NSString *filename = [path stringByAppendingPathComponent:@"class.plist"];
                    if ([fileManage fileExistsAtPath:filename]) {
                        [fileManage removeItemAtPath:filename error:nil];
                    }
                    NSString *filename2 = [path stringByAppendingPathComponent:@"student.plist"];
                    if ([fileManage fileExistsAtPath:filename2]) {
                        [fileManage removeItemAtPath:filename2 error:nil];
                    }
                    LogInViewController *logView = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
                    self.window.rootViewController = logView;
                }
            }else {
                [self performSelectorOnMainThread:@selector(showMainController) withObject:nil waitUntilDone:NO];
            }
        }
    }
}


//TODO:显示作业类型
-(void)showDailyhomeworkType{
    
    TaskObj *task = [[TaskObj alloc] init];
    NSMutableArray *homeworkType = [NSMutableArray array];
    for (int i=0; i < 10; i++) {
        HomeworkTypeObj *type = [[HomeworkTypeObj alloc] init];
        type.homeworkType = HomeworkType_line;
        [homeworkType addObject:type];
    }
    task.taskHomeworkTypeArray = homeworkType;
    HomeworkDailyCollectionViewController *controller = [[HomeworkDailyCollectionViewController alloc] initWithNibName:@"HomeworkDailyCollectionViewController" bundle:nil];
    controller.taskObj = task;
    self.window.rootViewController = controller;
     [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    InitViewController *initView = [[InitViewController alloc]initWithNibName:@"InitViewController" bundle:nil];
    self.window.rootViewController = initView;
    self.window.backgroundColor = [UIColor whiteColor];

    self.the_class_id = -1;

    [DataService sharedService].notificationPage=1;
    self.notification_type = 0;
    [DataService sharedService].numberOfViewArray = [[NSMutableArray alloc]initWithCapacity:4];
    //推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
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
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[pushDict debugDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [alert show];
    
    if (pushDict) {
        int typeValue = [[pushDict objectForKey:@"type"]integerValue];
        self.the_class_id = [[pushDict objectForKey:@"class_id"]integerValue];
        self.the_class_name = [pushDict objectForKey:@"class_name"];
        self.the_student_id = [[pushDict objectForKey:@"student_id"]integerValue];
        if (typeValue == 2) {
            self.notification_type = 1;
        }else {
            self.notification_type = 2;
            if (typeValue==0) {
                [DataService sharedService].notificationPage=0;
            }else {
                [DataService sharedService].notificationPage=1;
            }
        }
    }

//    [self performSelectorOnMainThread:@selector(showRootView) withObject:nil waitUntilDone:NO];
    [self showMainController];
    
//    [DataService sharedService].user = [[UserObject alloc]init];
//    [DataService sharedService].user.nickName = @"大小姐";
//    [DataService sharedService].user.name = @"多少分";
//    [DataService sharedService].user.headUrl = @"/avatars/students/2014-03/student_91";
//    [DataService sharedService].user.userId = @"150";
//    [DataService sharedService].user.studentId = @"89";
//    
//    [DataService sharedService].theClass = [[ClassObject alloc]init];
//    [DataService sharedService].theClass.classId = @"106";
//    [DataService sharedService].theClass.name = @"大结局";
//    [DataService sharedService].theClass.tId = @"75";
//    [DataService sharedService].theClass.tName = @"黄河";
//    [DataService sharedService].theClass.expireTime = @"2014-04-26 23:59:59";
//
//    [self showMainController];
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //记录作业＋通知右上角红点点～～
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [Utility returnPath];
    NSString *filename = [path stringByAppendingPathComponent:@"type.plist"];
    if ([fileManage fileExistsAtPath:filename]) {
        [fileManage removeItemAtPath:filename error:nil];
    }
    
    [NSKeyedArchiver archiveRootObject:self.notification_dic toFile:filename];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
    //接收到push  会震动
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
        
    }
}


#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[userInfo debugDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    //接收到push  会震动
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
