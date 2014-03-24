//
//  PostImage.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-24.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol PostImageDelegate;
@interface PostImage : NSObject
@property (nonatomic, strong) ASIFormDataRequest *request;
@property (nonatomic, assign) id<PostImageDelegate> delegate;
-(void)postImageWithImage:(UIImage *)image;
@end

@protocol PostImageDelegate <NSObject>
-(void)getPostImageInfoDidFinished:(NSDictionary *)result;
-(void)getPostImageInfoDidFailed:(NSString *)errorMsg;
@end
