//
//  LHLGetSysNoticeInterface.h
//  cjzyb_ios
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

/*
 根据27号API ,获取系统通知
 */

#import "BaseInterface.h"
@protocol LHLGetSysNoticeInterfaceDelegate;

@interface LHLGetSysNoticeInterface : BaseInterface<BaseInterfaceDelegate>

@property (strong,nonatomic) id<LHLGetSysNoticeInterfaceDelegate> delegate;

-(void)getSysNoticeWithUserID:(NSString *)userID andSchoolClassID:(NSString *)classID andPage:(NSString *)page;

@end

@protocol LHLGetSysNoticeInterfaceDelegate <NSObject>
@required
-(void)getSysNoticeDidFinished:(NSDictionary *)result;
-(void)getSysNoticeDidFailed:(NSString *)errorMsg;
@end