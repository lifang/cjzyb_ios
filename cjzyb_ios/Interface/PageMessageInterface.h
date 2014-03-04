//
//  PageMessageInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol PMessageInterfaceDelegate;
@interface PageMessageInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic, assign) id <PMessageInterfaceDelegate> delegate;

-(void)getPageMessageInterfaceDelegateWithClassId:(NSString *)classId andUserId:(NSString *)userId andPage:(NSInteger)page;
@end

@protocol PMessageInterfaceDelegate <NSObject>

-(void)getPageMessageInfoDidFinished:(NSDictionary *)result;
-(void)getPageMessageInfoDidFailed:(NSString *)errorMsg;

@end

