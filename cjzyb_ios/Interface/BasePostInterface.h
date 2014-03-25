//
//  BasePostInterface.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-18.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol PostDelegate;
@interface BasePostInterface : NSObject
@property (nonatomic, strong) ASIFormDataRequest *request;
@property (nonatomic, assign) id<PostDelegate> delegate;
-(void)postAnswerFileWith:(NSString *)jsonPath;
@end


@protocol PostDelegate <NSObject>
-(void)getPostInfoDidFinished:(NSDictionary *)result;
-(void)getPostInfoDidFailed:(NSString *)errorMsg;
@end