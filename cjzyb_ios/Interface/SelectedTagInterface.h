//
//  SelectedTagInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-12.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol SelectedTagInterfaceDelegate;
@interface SelectedTagInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <SelectedTagInterfaceDelegate> delegate;
-(void)getSelectedTagInterfaceDelegateWithStudentId:(NSString *)studentId andClassId:(NSString *)classId andCardId:(NSString *)cardId andCardTagId:(NSString *)cardTagId;
@end


@protocol SelectedTagInterfaceDelegate <NSObject>
-(void)getSelectedTagInfoDidFinished:(NSDictionary *)result;
-(void)getSelectedTagInfoDidFailed:(NSString *)errorMsg;

@end
