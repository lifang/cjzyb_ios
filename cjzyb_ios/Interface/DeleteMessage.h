//
//  DeleteMessage.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol DeleteMessageDelegate;
@interface DeleteMessage : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <DeleteMessageDelegate> delegate;
@property (nonatomic, assign) NSInteger type;
-(void)getDeleteMessageDelegateDelegateWithMessageId:(NSString *)messageId andType:(NSInteger)type;
@end


@protocol DeleteMessageDelegate <NSObject>
-(void)getDeleteMsgInfoDidFinished:(NSDictionary *)result andType:(NSInteger)type;
-(void)getDeleteMsgInfoDidFailed:(NSString *)errorMsg;

@end
