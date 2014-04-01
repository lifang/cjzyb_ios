//
//  LHLNotificationContainerVC.h
//  cjzyb_ios
//
//  Created by apple on 14-3-31.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAPagesContainer.h"
#import "LHLNotificationViewController.h"
#import "LHLReplyNotificationViewController.h"

@interface LHLNotificationContainerVC : UIViewController
@property (nonatomic,strong) DAPagesContainer *pagesContainer; //主页面

- (void)setSelectedIndex:(NSUInteger )index animated:(BOOL)animated; //选择页面,从左到右 0 - 1
@end
