//
//  TagInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol TagInterfaceDelegate;
@interface TagInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <TagInterfaceDelegate> delegate;
-(void)getTagInterfaceDelegateWithStudentId:(NSString *)studentId andClassId:(NSString *)classId andCardId:(NSString *)cardId andName:(NSString *)name;
@end


@protocol TagInterfaceDelegate <NSObject>
-(void)getTagInfoDidFinished:(NSDictionary *)result;
-(void)getTagInfoDidFailed:(NSString *)errorMsg;

@end
