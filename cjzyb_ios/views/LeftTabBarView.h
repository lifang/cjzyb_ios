//
//  LeftTabBarView.h
//  cjzyb_ios
//
//  Created by david on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftTabBarItem.h"
typedef enum{
    LeftTabBarItemType_main=0,
    LeftTabBarItemType_homework,
    LeftTabBarItemType_notification,
    LeftTabBarItemType_carBag,
    LeftTabBarItemType_userGroup,
    LeftTabBarItemType_logOut
}LeftTabBarItemType;
@protocol LeftTabBarViewDelegate;
@interface LeftTabBarView : UIView
@property (weak,nonatomic) id <LeftTabBarViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet LeftTabBarItem *userGroupTabBarItem;
@property (weak, nonatomic) IBOutlet LeftTabBarItem *mainTabBarItem;
@property (weak, nonatomic) IBOutlet LeftTabBarItem *homeworkTabBarItem;
@property (weak, nonatomic) IBOutlet LeftTabBarItem *notificationTabBarItem;
@property (weak, nonatomic) IBOutlet LeftTabBarItem *carBarTabBarItem;

@property (weak, nonatomic) IBOutlet LeftTabBarItem *logOutItem;


- (IBAction)userGroupItemClicked:(id)sender;
- (IBAction)carBagItemClicked:(id)sender;
- (IBAction)notificationItemClicked:(id)sender;
- (IBAction)homeworkItemClicked:(id)sender;
- (IBAction)mainItemClicked:(id)sender;
- (IBAction)logOutItemClicked:(id)sender;

-(void)defaultSelected;
@end

@protocol LeftTabBarViewDelegate <NSObject>

-(void)leftTabBar:(LeftTabBarView*)tabBarView selectedItem:(LeftTabBarItemType)itemType;

@end