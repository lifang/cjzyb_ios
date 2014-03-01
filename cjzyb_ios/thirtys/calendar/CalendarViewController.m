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
    [self.view addSubview:self.calendarView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark VRGCalendarViewDelegate日历代理
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    NSLog(@"%@",date);
//    for (NSDate *date2 in self.selectedDateArray) {
//        if ([Utility isSameDay:date date2:date2]) {
//            [self.selectedDateArray removeObject:date2];
//            return;
//        }
//    }
//    [self.selectedDateArray addObject:date];
    
    [self.selectedDateArray removeAllObjects];
    [self.selectedDateArray addObject:date];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated{
    NSLog(@"switch:%d",month);
}
#pragma mark --

- (IBAction)okButtonClicked:(id)sender {
    if (self.selectedDateBlock) {
        self.selectedDateBlock(self.selectedDateArray);
    }
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
