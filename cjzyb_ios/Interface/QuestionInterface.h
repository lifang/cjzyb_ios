//
//  QuestionInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol QuestionInterfaceDelegate;

@interface QuestionInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <QuestionInterfaceDelegate> delegate;

-(void)getQuestionInterfaceDelegateWithUserId:(NSString *)userId andUserType:(NSString *)userType andClassId:(NSString *)classId andContent:(NSString *)content;
@end

@protocol QuestionInterfaceDelegate <NSObject>
-(void)getQuestionInfoDidFinished:(NSDictionary *)result;
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg;
@end
