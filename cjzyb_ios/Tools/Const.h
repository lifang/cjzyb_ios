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
#import "WYPopoverController.h"

#define kHOST @"http://58.240.210.42:3004"

#if 1 
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif