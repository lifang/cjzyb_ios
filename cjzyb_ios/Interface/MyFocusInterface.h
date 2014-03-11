//
//  MyFocusInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol MyFocusInterfaceDelegate;
@interface MyFocusInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic, assign) id <MyFocusInterfaceDelegate> delegate;

-(void)getMyFocusInterfaceDelegateWithClassId:(NSString *)classId andUserId:(NSString *)userId andPage:(NSInteger)page;
@end

@protocol MyFocusInterfaceDelegate <NSObject>

-(void)getMyFocusInfoDidFinished:(NSDictionary *)result;
-(void)getMyFocusInfoDidFailed:(NSString *)errorMsg;

@end
