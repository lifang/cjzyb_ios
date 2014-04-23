//
//  FocusInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol FocusInterfaceDelegate;

@interface FocusInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <FocusInterfaceDelegate> delegate;
@property (nonatomic, assign) NSInteger type;
-(void)getFocusInterfaceDelegateWithMessageId:(NSString *)messageId andUserId:(NSString *)userId andType:(NSInteger)type;
@end


@protocol FocusInterfaceDelegate <NSObject>
-(void)getFocusInfoDidFinished:(NSDictionary *)result andType:(NSInteger)type;
-(void)getFocusInfoDidFailed:(NSString *)errorMsg;
@end

