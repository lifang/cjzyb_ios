//
//  MessageInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol MessageInterfaceDelegate;

@interface MessageInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic, assign) id <MessageInterfaceDelegate> delegate;

-(void)getMessageInterfaceDelegateWithClassId:(NSString *)classId andUserId:(NSString *)userId;
@end

@protocol MessageInterfaceDelegate <NSObject>

-(void)getMessageInfoDidFinished:(NSDictionary *)result;
-(void)getMessageInfoDidFailed:(NSString *)errorMsg;

@end
