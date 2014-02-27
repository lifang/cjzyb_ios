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
    LeftTabBarItemType_userGroup
}LeftTabBarItemType;
@protocol LeftTabBarViewDelegate;
@interface LeftTabBarView : UIView
@property (weak,nonatomic) id <LeftTabBarViewDelegate> delegate;
-(void)defaultSelected;
@end

@protocol LeftTabBarViewDelegate <NSObject>

-(void)leftTabBar:(LeftTabBarView*)tabBarView selectedItem:(LeftTabBarItemType)itemType;

@end