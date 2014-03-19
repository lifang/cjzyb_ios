//
//  LHLDeleteSysNoticeInterface.h
//  cjzyb_ios
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//
/*
 根据26号API,删除系统通知
 */

#import "BaseInterface.h"
@protocol LHLDeleteSysNoticeInterfaceDelegate;

@interface LHLDeleteSysNoticeInterface : BaseInterface<BaseInterfaceDelegate>
@property (strong,nonatomic) id<LHLDeleteSysNoticeInterfaceDelegate> delegate;

-(void)deleteSysNoticeWithUserID:(NSString *) userID andClassID:(NSString *)classID andSysNoticeID:(NSString *)noticeID;

@end

@protocol LHLDeleteSysNoticeInterfaceDelegate <NSObject>

@required
-(void)deleteSysNoticeDidFinished:(NSDictionary *)result;
-(void)deleteSysNoticeDidFailed:(NSString *)errorMsg;

@end
