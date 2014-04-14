//
//  LogInViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "LogInterface.h"
#import "PersonInfoInterface.h"
#import "MainViewController.h"//主页


@interface LogInViewController : UIViewController<TencentSessionDelegate,UITextFieldDelegate,LogInterfaceDelegate,PersonInterfaceDelegate>

@property (nonatomic, strong) LogInterface*logInter;
@property (nonatomic, strong) PersonInfoInterface *personInter;


@property (nonatomic, strong) IBOutlet UIView *logView;
@property (nonatomic, strong) IBOutlet UIButton *logBtn;
@property (nonatomic, strong) AppDelegate *appDel;

@property (nonatomic, strong) IBOutlet UIControl *detailView;
@property (nonatomic, strong) IBOutlet UITextField *nickTxt;
@property (nonatomic, strong) IBOutlet UITextField *nameTxt;
@property (nonatomic, strong) IBOutlet UITextField *classTxt;
@property (nonatomic, strong) IBOutlet UIButton *detailBtn;
@property (nonatomic, strong) IBOutlet UIImageView *logoImg;
@property (nonatomic, strong) IBOutlet UIButton *backBtn;
//激活码

@property (nonatomic, strong) IBOutlet UITextField *activeTxt;

@property (nonatomic, strong) IBOutlet UIButton *activeSkipBtn;

///0=QQ登录页面   1=激活码页面   2=班级验证码页面   3=完善信息页面
@property (nonatomic, assign) NSInteger pageIndex;


@property (nonatomic, strong) IBOutlet UIView *IconView;
@property (nonatomic, strong) IBOutlet UILabel *visonLabel;
@property (nonatomic, strong) IBOutlet UILabel *companyLabel;
@end
