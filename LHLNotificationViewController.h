//
//  LHLNotificationViewController.h
//  cjzyb_ios
//
//  Created by apple on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLNotificationCell.h"
#import "LHLReplyNotificationCell.h"
#import "LHLNotificationHeader.h"
#import "LHLGetSysNoticeInterface.h"
#import "LHLGetMyNoticeInterface.h"
#import "LHLDeleteMyNoticeInterface.h"
#import "LHLDeleteSysNoticeInterface.h"
#import "MJRefresh.h"

@interface LHLNotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LHLNotificationCellDelegate,LHLNotificationHeaderDelegate,LHLReplyNotificationCellDelegate,LHLGetMyNoticeInterfaceDelegate,LHLGetSysNoticeInterfaceDelegate,LHLDeleteSysNoticeInterfaceDelegate,LHLDeleteMyNoticeInterfaceDelegate,MJRefreshBaseViewDelegate>

@end
