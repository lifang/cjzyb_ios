//
//  LHLDeleteMyNoticeInterface.m
//  cjzyb_ios
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLDeleteMyNoticeInterface.h"

@implementation LHLDeleteMyNoticeInterface
-(void)deleteMyNoticeWithUserID:(NSString *)userID andClassID:(NSString *)classID andNoticeID:(NSString *)noticeID{
    
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(ASIHTTPRequest *)request{
    NSData *data = [[NSData alloc]initWithData:[request responseData]];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if (jsonData) {
                if ([[jsonData objectForKey:@"status"]isEqualToString:@"success"]) {
                    @try {
                        [self.delegate deleteMyNoticeDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate deleteMyNoticeDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate deleteMyNoticeDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate deleteMyNoticeDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate deleteMyNoticeDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate deleteMyNoticeDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate deleteMyNoticeDidFailed:@"获取数据失败!"];
}
@end
