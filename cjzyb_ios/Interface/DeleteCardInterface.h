//
//  DeleteCardInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol DeleteCardInterfaceDelegate;
@interface DeleteCardInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <DeleteCardInterfaceDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;
-(void)getDeleteCardDelegateDelegateWithCardId:(NSString *)cardId andTag:(NSInteger)tag;
@end


@protocol DeleteCardInterfaceDelegate <NSObject>
-(void)getDeleteCardInfoDidFinished:(NSDictionary *)result andTag:(NSInteger)tag;
-(void)getDeleteCardInfoDidFailed:(NSString *)errorMsg;

@end
