//
//  LHLNofiticationHeader.h
//  cjzyb_ios
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    NotificationDisplayCategoryDefault = 1,  //系统通知
    NotificationDisplayCategoryReply    //回复通知
} NotificationDisplayCategory;

@protocol LHLNotificationHeaderDelegate;

@interface LHLNotificationHeader : UIView

@property (nonatomic,strong) id<LHLNotificationHeaderDelegate> delegate;

-(void)initHeader;  //初始化

@end

@protocol LHLNotificationHeaderDelegate <NSObject>

@required

-(void)header:(LHLNotificationHeader *)header didSelectedDisplayCategory:(NotificationDisplayCategory) category;

@end