//
//  CalendarViewController.h
//  cjzyb_ios
//
//  Created by david on 14-3-1.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
@interface CalendarViewController : UIViewController<VRGCalendarViewDelegate>
@property (strong, nonatomic)  VRGCalendarView *calendarView;
@property (strong, nonatomic) void (^selectedDateBlock)(NSString *dateString);
@property (strong, nonatomic) NSMutableArray *selectedDateArray;
@end
