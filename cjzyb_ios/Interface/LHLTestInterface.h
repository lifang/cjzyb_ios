//
//  LHLTestInterface.h
//  cjzyb_ios
//
//  Created by apple on 14-3-5.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol LHLTestInterfaceDelegate;

@interface LHLTestInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id <LHLTestInterfaceDelegate> delegate;

-(void)getLHLTestDelegateWithClassId:(NSString *)classId andUserId:(NSString *)userId;

@end

@protocol LHLTestInterfaceDelegate <NSObject>
@required

-(void)getLHLInfoDidFinished:(NSDictionary *)result;
-(void)getLHLInfoDidFailed:(NSString *)errorMsg;

@end