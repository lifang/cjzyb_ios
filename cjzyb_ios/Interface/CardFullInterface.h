//
//  CardFullInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-19.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol CardFullInterfaceDelegate;
@interface CardFullInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <CardFullInterfaceDelegate> delegate;
-(void)getCardFullInterfaceDelegate;
@end


@protocol CardFullInterfaceDelegate <NSObject>
-(void)getCardFullInfoDidFinished:(NSDictionary *)result;
-(void)getCardFullInfoDidFailed:(NSString *)errorMsg;

@end
