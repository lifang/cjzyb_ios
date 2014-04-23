//
//  ReplyMessageInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol RMessageInterfaceDelegate;
@interface ReplyMessageInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <RMessageInterfaceDelegate> delegate;

-(void)getReplyMessageInterfaceDelegateWithMessageId:(NSString *)messageId andPage:(NSInteger)page;
@end

@protocol RMessageInterfaceDelegate <NSObject>

-(void)getReplyMessageInfoDidFinished:(NSDictionary *)result;
-(void)getReplyMessageInfoDidFailed:(NSString *)errorMsg;

@end
