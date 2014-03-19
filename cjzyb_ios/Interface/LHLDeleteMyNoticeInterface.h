//
//  LHLDeleteMyNoticeInterface.h
//  cjzyb_ios
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

/*
 根据25号API,删除我的提示
 */

#import "BaseInterface.h"
@protocol LHLDeleteMyNoticeInterfaceDelegate;

@interface LHLDeleteMyNoticeInterface : BaseInterface<BaseInterfaceDelegate>
@property (strong,nonatomic) id<LHLDeleteMyNoticeInterfaceDelegate> delegate;

-(void)deleteMyNoticeWithUserID:(NSString *)userID andClassID:(NSString *)classID andNoticeID:(NSString *)noticeID;

@end
@protocol LHLDeleteMyNoticeInterfaceDelegate <NSObject>

@required
-(void)deleteMyNoticeDidFinished:(NSDictionary *)result;
-(void)deleteMyNoticeDidFailed:(NSString *)errorMsg;

@end