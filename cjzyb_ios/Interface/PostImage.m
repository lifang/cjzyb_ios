//
//  PostImage.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-24.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "PostImage.h"

@implementation PostImage
-(void)postImageWithImage:(UIImage *)image {
    
}

- (void)requestFinished:(ASIFormDataRequest *)requestForm {
    NSData *data = [[NSData alloc]initWithData:[requestForm responseData]];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if (jsonData){
                if ([[jsonData objectForKey:@"status"]isEqualToString:@"success"]) {
                    @try {
                        [self.delegate getPostImageInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getPostImageInfoDidFailed:@"获取数据失败!"];
                    }
                }
            }else {
                [self.delegate getPostImageInfoDidFailed:@"获取数据失败!"];
            }
        }
    }else {
        [self.delegate getPostImageInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request {
    [self.delegate getPostImageInfoDidFailed:@"获取数据失败!"];
}

@end
