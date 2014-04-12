//
//  LogInViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LogInViewController.h"

#define AppId @"101003848"
@interface LogInViewController ()

@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(LogInterface *)logInter {
    if (!_logInter) {
        _logInter = [[LogInterface alloc]init];
        _logInter.delegate = self;
    }
    return _logInter;
}
-(PersonInfoInterface *)personInter {
    if (!_personInter) {
        _personInter = [[PersonInfoInterface alloc]init];
        _personInter.delegate = self;
    }
    return _personInter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    self.pageIndex = 0;
    [self initTencentSession];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)initTencentSession {
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:AppId andDelegate:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}
#pragma mark - 登录
-(IBAction)logWithQQ:(id)sender {
    if (self.appDel.isReachable==NO) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        NSArray* permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,nil];
        [_tencentOAuth authorize:permissions inSafari:NO];
    }
}
//登录成功
- (void)tencentDidLogin {
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        if (self.appDel.isReachable == NO) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.logInter getLogInterfaceDelegateWithQQ:_tencentOAuth.openId];
        }
    }
}
//登录失败后的回调
- (void)tencentDidNotLogin:(BOOL)cancelled {
    [Utility errorAlert:@"登录失败!"];
}

//登录时网络有问题的回调
- (void)tencentDidNotNetWork {
    [Utility errorAlert:@"网络延迟!"];
}

#pragma mark
#pragma mark - Keyboard notifications

- (void)keyboardDidShow:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.logoImg.frame;
    if (frame.origin.y==200) {
        NSInteger xx = 150;
        frame.origin.y -= xx;
        self.logoImg.frame = frame;
        
        if (self.pageIndex==1) {//激活码页面
            frame = self.activeTxt.frame;
            frame.origin.y -= xx;
            self.activeTxt.frame = frame;
            
            frame = self.activeSkipBtn.frame;
            frame.origin.y -= xx;
            self.activeSkipBtn.frame = frame;
            
        }else if (self.pageIndex==2){//班级验证码页面
            frame = self.classTxt.frame;
            frame.origin.y -= xx;
            self.classTxt.frame = frame;

        }else if (self.pageIndex==3){//完善信息页面
            frame = self.nickTxt.frame;
            frame.origin.y -= xx;
            self.nickTxt.frame = frame;
            
            frame = self.nameTxt.frame;
            frame.origin.y -= xx;
            self.nameTxt.frame = frame;
            
            frame = self.classTxt.frame;
            frame.origin.y -= xx;
            self.classTxt.frame = frame;
        }

        frame = self.detailBtn.frame;
        frame.origin.y -= xx;
        self.detailBtn.frame = frame;
    }
    
    [UIView commitAnimations];
}

- (void)keyboardDidHide:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.logoImg.frame;
    if (frame.origin.y==50) {
        NSInteger xx = 150;
        
        frame.origin.y += xx;
        self.logoImg.frame = frame;
        
        if (self.pageIndex==1) {//激活码页面
            frame = self.activeTxt.frame;
            frame.origin.y += xx;
            self.activeTxt.frame = frame;
            
            frame = self.activeSkipBtn.frame;
            frame.origin.y += xx;
            self.activeSkipBtn.frame = frame;
            
        }else if (self.pageIndex==2){//班级验证码页面
            frame = self.classTxt.frame;
            frame.origin.y += xx;
            self.classTxt.frame = frame;
        }else if (self.pageIndex==3){//完善信息页面
            frame = self.nickTxt.frame;
            frame.origin.y += xx;
            self.nickTxt.frame = frame;
            
            frame = self.nameTxt.frame;
            frame.origin.y += xx;
            self.nameTxt.frame = frame;
            
            frame = self.classTxt.frame;
            frame.origin.y += xx;
            self.classTxt.frame = frame;
        }
        frame = self.detailBtn.frame;
        frame.origin.y += xx;
        self.detailBtn.frame = frame;
    }
    
    [UIView commitAnimations];
}

-(IBAction)hiddenKeyBoard:(id)sender {
    [self.nickTxt resignFirstResponder];
    [self.nameTxt resignFirstResponder];
    [self.classTxt resignFirstResponder];
}

- (BOOL)checkForm{
    NSString *nickStr = [[NSString alloc] initWithString: self.nickTxt.text?:@""];
    NSString *nameStr = [[NSString alloc] initWithString: self.nameTxt.text?:@""];
    NSString *classStr = [[NSString alloc] initWithString: self.classTxt.text?:@""];
    NSString *msgStr = @"";
    if (nickStr.length == 0){
        msgStr = @"请输入昵称!";
    }else if (nameStr.length == 0){
        msgStr = @"请输入姓名!";
    }else if (classStr.length == 0){
        msgStr = @"请输入班级验证码!";
    }

    if (msgStr.length > 0){
        [Utility errorAlert:msgStr];
        return FALSE;
    }
    return TRUE;
}

-(IBAction)sureToLoad:(id)sender {
    [self.nickTxt resignFirstResponder];
    [self.nameTxt resignFirstResponder];
    [self.classTxt resignFirstResponder];
    [self.activeTxt resignFirstResponder];
    
    BOOL isCanPush = NO;
    if (self.pageIndex==1) {//激活码页面
        if (self.activeTxt.text.length==0) {
            [Utility errorAlert:@"请输入激活码!"];
        }else {
            self.pageIndex=2;
            self.classTxt.hidden = NO;
            CGRect frame = self.classTxt.frame;
            frame.origin.y = 526;
            self.classTxt.frame = frame;
            self.activeSkipBtn.hidden= YES;
            self.activeTxt.hidden = YES;
        }
    }else if(self.pageIndex==2){//班级验证码页面
        if (self.classTxt.text.length==0) {
            [Utility errorAlert:@"请输入班级验证码!"];
        }else {
            isCanPush = YES;
        }
    }else if (self.pageIndex==3){//完善信息页面
        NSString *msgStr = @"";
        if (self.nickTxt.text.length == 0){
            msgStr = @"请输入昵称!";
        }else if (self.nameTxt.text.length == 0){
            msgStr = @"请输入姓名!";
        }else if (self.classTxt.text.length == 0){
            msgStr = @"请输入班级验证码!";
        }
        if (msgStr.length > 0){
            [Utility errorAlert:msgStr];
        }else {
            isCanPush=YES;
        }
    }
    
    if (isCanPush==YES) {
        if (self.appDel.isReachable == NO) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.personInter getPersonInterfaceDelegateWithQQ:_tencentOAuth.openId andNick:self.nickTxt.text andName:self.nameTxt.text andCode:self.classTxt.text andKey:self.activeTxt.text];
        }
    }
}

-(IBAction)backPressed:(id)sender {
    [self.nickTxt resignFirstResponder];
    [self.nameTxt resignFirstResponder];
    [self.classTxt resignFirstResponder];
    [self.activeTxt resignFirstResponder];
    
    if (self.pageIndex==3 || self.pageIndex==2) {//完善信息页面//班级验证码页面
        self.pageIndex=1;
        
        self.nickTxt.hidden = YES;
        self.nameTxt.hidden = YES;
        self.classTxt.hidden = YES;
        self.activeTxt.hidden = NO;
        self.activeSkipBtn.hidden = NO;
        
        CGRect frame = self.detailBtn.frame;
        frame.origin.y = 650;
        self.detailBtn.frame = frame;
    }else if(self.pageIndex==1){
        self.pageIndex=0;
        self.logView.hidden = NO;
        self.detailView.hidden = YES;
    }
}
-(IBAction)skipPressed:(id)sender {
    [self.nickTxt resignFirstResponder];
    [self.nameTxt resignFirstResponder];
    [self.classTxt resignFirstResponder];
    [self.activeTxt resignFirstResponder];
    
    self.pageIndex = 3;
    
    self.nickTxt.hidden = NO;
    self.nameTxt.hidden = NO;
    self.classTxt.hidden = NO;
    CGRect frame = self.classTxt.frame;
    frame.origin.y = 650;
    self.classTxt.frame = frame;
    self.activeSkipBtn.hidden= YES;
    self.activeTxt.hidden = YES;
    
    frame = self.detailBtn.frame;
    frame.origin.y = 769;
    self.detailBtn.frame = frame;
}
#pragma mark
#pragma mark - LogInterfaceDelegate

-(void)getLogInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[result objectForKey:@"status"]isEqualToString:@"success"]) {
                NSFileManager *fileManage = [NSFileManager defaultManager];
                NSString *path = [Utility returnPath];
                NSString *filename = [path stringByAppendingPathComponent:@"class.plist"];
                if ([fileManage fileExistsAtPath:filename]) {
                    [fileManage removeItemAtPath:filename error:nil];
                }
                NSDictionary *classDic = [result objectForKey:@"class"];
                [DataService sharedService].theClass = [ClassObject classFromDictionary:classDic];
                [NSKeyedArchiver archiveRootObject:classDic toFile:filename];
                
                //小红点
                if (![[self.appDel.notification_dic objectForKey:[DataService sharedService].theClass.classId]isKindOfClass:[NSNull class]] && [self.appDel.notification_dic objectForKey:[DataService sharedService].theClass.classId]!=nil) {
                    
                }else {
                    NSArray *array = [[NSArray alloc]initWithObjects:@"0",@"0",@"0", nil];
                    [self.appDel.notification_dic setObject:array forKey:[DataService sharedService].theClass.classId];
                }
                
                NSString *filename2 = [path stringByAppendingPathComponent:@"student.plist"];
                if ([fileManage fileExistsAtPath:filename2]) {
                    [fileManage removeItemAtPath:filename2 error:nil];
                }
                NSDictionary *studentDic = [result objectForKey:@"student"];
                
                [DataService sharedService].user = [UserObject userFromDictionary:studentDic];
                [NSKeyedArchiver archiveRootObject:studentDic toFile:filename2];
                
                AppDelegate *appDel = [AppDelegate shareIntance];
                [appDel showRootView];
                
                [_tencentOAuth logout:self];
            }else {
                self.pageIndex = 1;//激活码页面
                self.logView.hidden = YES;
                self.detailView.hidden = NO;
                
                self.nickTxt.hidden = YES;
                self.nameTxt.hidden = YES;
                self.classTxt.hidden = YES;
                self.activeTxt.hidden = NO;
                self.activeSkipBtn.hidden = NO;
                
                CGRect frame = self.detailBtn.frame;
                frame.origin.y = 650;
                self.detailBtn.frame = frame;
            }
        });
    });
}
-(void)getLogInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark
#pragma mark - PersonInterfaceDelegate

-(void)getPersonInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSFileManager *fileManage = [NSFileManager defaultManager];
            NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filename = [Path stringByAppendingPathComponent:@"class.plist"];
            if ([fileManage fileExistsAtPath:filename]) {
                [fileManage removeItemAtPath:filename error:nil];
            }
            NSDictionary *classDic = [result objectForKey:@"class"];
            [DataService sharedService].theClass = [ClassObject classFromDictionary:classDic];
            [NSKeyedArchiver archiveRootObject:classDic toFile:filename];
            
            //小红点
            if (![[self.appDel.notification_dic objectForKey:[DataService sharedService].theClass.classId]isKindOfClass:[NSNull class]] && [self.appDel.notification_dic objectForKey:[DataService sharedService].theClass.classId]!=nil) {
                
            }else {
                NSArray *array = [[NSArray alloc]initWithObjects:@"0",@"0",@"0", nil];
                [self.appDel.notification_dic setObject:array forKey:[DataService sharedService].theClass.classId];
            }
            
            NSString *filename2 = [Path stringByAppendingPathComponent:@"student.plist"];
            if ([fileManage fileExistsAtPath:filename2]) {
                [fileManage removeItemAtPath:filename2 error:nil];
            }
            NSDictionary *studentDic = [result objectForKey:@"student"];
            [DataService sharedService].user = [UserObject userFromDictionary:studentDic];
            [NSKeyedArchiver archiveRootObject:studentDic toFile:filename2];
            
            AppDelegate *appDel = [AppDelegate shareIntance];
            [appDel showRootView];
            
            [_tencentOAuth logout:self];
        });
    });
}
-(void)getPersonInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
@end
