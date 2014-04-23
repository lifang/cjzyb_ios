//
//  LogInterface.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "BaseInterface.h"

@protocol LogInterfaceDelegate;
@interface LogInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <LogInterfaceDelegate> delegate;

-(void)getLogInterfaceDelegateWithQQ:(NSString *)qq;
@end

@protocol LogInterfaceDelegate <NSObject>

-(void)getLogInfoDidFinished:(NSDictionary *)result;
-(void)getLogInfoDidFailed:(NSString *)errorMsg;

@end