//
//  LHLReplyNotificationViewController.h
//  cjzyb_ios
//
//  Created by apple on 14-3-31.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLReplyNotificationCell.h"

@interface LHLReplyNotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LHLReplyNotificationCellDelegate,UITextViewDelegate>
@property (strong,nonatomic) AppDelegate *appDel;

-(void)requestMyNoticeWithUserID:(NSString *)userID andClassID:(NSString *)classID andPage:(NSString *)page;
@end