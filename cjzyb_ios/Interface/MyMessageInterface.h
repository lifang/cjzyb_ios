//
//  MyMessageInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol MyMessageInterfaceDelegate;
@interface MyMessageInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic, assign) id <MyMessageInterfaceDelegate> delegate;

-(void)getMyMessageInterfaceDelegateWithClassId:(NSString *)classId andUserId:(NSString *)userId andPage:(NSInteger)page;
@end

@protocol MyMessageInterfaceDelegate <NSObject>

-(void)getMyMessageInfoDidFinished:(NSDictionary *)result;
-(void)getMyMessageInfoDidFailed:(NSString *)errorMsg;

@end
