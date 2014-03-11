//
//  PersonInfoInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol PersonInterfaceDelegate;
@interface PersonInfoInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <PersonInterfaceDelegate> delegate;

-(void)getPersonInterfaceDelegateWithQQ:(NSString *)qq andNick:(NSString *)nick andName:(NSString *)name andCode:(NSString *)code;
@end

@protocol PersonInterfaceDelegate <NSObject>

-(void)getPersonInfoDidFinished:(NSDictionary *)result;
-(void)getPersonInfoDidFailed:(NSString *)errorMsg;

@end
