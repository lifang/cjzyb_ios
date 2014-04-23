//
//  SendMessageInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol SendMessageInterfaceDelegate;
@interface SendMessageInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <SendMessageInterfaceDelegate> delegate;
@property (nonatomic, assign) NSInteger type;
-(void)getSendDelegateWithSendId:(NSString *)sendId andSendType:(NSString *)sendType andClassId:(NSString *)classId andReceiverId:(NSString *)receiverId andReceiverType:(NSString *)receiverType andmessageId:(NSString *)messageId andContent:(NSString *)content andType:(NSInteger)type;
@end


@protocol SendMessageInterfaceDelegate <NSObject>
-(void)getSendInfoDidFinished:(NSDictionary *)result anType:(NSInteger)type;
-(void)getSendInfoDidFailed:(NSString *)errorMsg;
@end

