//
//  LHLGetMyNoticeInterface.h
//  cjzyb_ios
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

/*
  根据22号API,获取别人对我的回复消息/对我关注的问题的回复消息
 */


#import "BaseInterface.h"
@protocol LHLGetMyNoticeInterfaceDelegate;

@interface LHLGetMyNoticeInterface : BaseInterface<BaseInterfaceDelegate>

@property (strong,nonatomic) id<LHLGetMyNoticeInterfaceDelegate> delegate;

-(void)getMyNoticeWithUserID:(NSString *)userID andSchoolClassID:(NSString *) classID andPage:(NSString *)page;

@end

@protocol LHLGetMyNoticeInterfaceDelegate <NSObject>

@required

-(void)getMyNoticeDidFinished:(NSDictionary *)result;
-(void)getMyNoticeDidFailed:(NSString *) errorMsg;

@end