//
//  CalendarViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-1.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CalendarViewController.h"
@interface CalendarViewController ()
- (IBAction)okButtonClicked:(id)sender;

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calendarView = [[VRGCalendarView alloc] init];
    self.calendarView.delegate = self;
    self.calendarView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.calendarView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark VRGCalendarViewDelegate日历代理
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    NSDateFormatter *dateFormatterString = [[NSDateFormatter alloc] init];
    dateFormatterString.dateFormat = @"yyyy-MM-dd";
    [dateFormatterString setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"]];
    NSString *dateString = [dateFormatterString stringFromDate:date];
    self.selectedDateBlock(dateString);
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated{
    NSLog(@"switch:%d",month);
}
#pragma mark --

- (IBAction)okButtonClicked:(id)sender {
//    if (self.selectedDateBlock) {
//        self.selectedDateBlock(self.selectedDateArray);
//    }
}

#pragma mark property
-(NSMutableArray *)selectedDateArray{
    if (!_selectedDateArray) {
        _selectedDateArray = [NSMutableArray array];
    }
    return _selectedDateArray;
}
#pragma mark --
@end
