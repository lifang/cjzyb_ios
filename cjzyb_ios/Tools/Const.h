//
//  Const.h
//  cjzyb_ios
//
//  Created by david on 14-2-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#ifndef cjzyb_ios_Const_h
#define cjzyb_ios_Const_h



#endif

#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>

#define kHOST @"http://116.255.202.123:3014"
//#define kHOST @"http://58.240.210.42:3004"

//修改用户昵称
#define kModifyUserNickNameNotification @"kModifyUserNickNameNotification"

//切换班级
#define kChangeGradeNotification @"kChangeGradeNotification"
#if 1 
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif