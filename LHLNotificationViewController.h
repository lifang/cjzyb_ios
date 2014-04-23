//
//  LHLNotificationViewController.h
//  cjzyb_ios
//
//  Created by apple on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLNotificationCell.h"

@interface LHLNotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LHLNotificationCellDelegate,UITextViewDelegate>
@property (strong,nonatomic) AppDelegate *appDel;
-(void)requestSysNoticeWithStudentID:(NSString *)studentID andClassID:(NSString *)classID andPage:(NSString *)page;
@end
