//
//  CardInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol CardInterfaceDelegate;
@interface CardInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <CardInterfaceDelegate> delegate;

-(void)getCardInterfaceDelegateWithStudentId:(NSString *)studentId andClassId:(NSString *)classId andType:(NSString *)type;
@end

@protocol CardInterfaceDelegate <NSObject>

-(void)getCardInfoDidFinished:(NSDictionary *)result;
-(void)getCardInfoDidFailed:(NSString *)errorMsg;

@end
