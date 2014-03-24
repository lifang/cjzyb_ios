//
//  LHLDeleteSysNoticeInterface.m
//  cjzyb_ios
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//


#import "LHLDeleteSysNoticeInterface.h"

@implementation LHLDeleteSysNoticeInterface
-(void)deleteSysNoticeWithUserID:(NSString *)userID andClassID:(NSString *)classID andSysNoticeID:(NSString *)noticeID{
    
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
                        [self.delegate deleteSysNoticeDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate deleteSysNoticeDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate deleteSysNoticeDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate deleteSysNoticeDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate deleteSysNoticeDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate deleteSysNoticeDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate deleteSysNoticeDidFailed:@"获取数据失败!"];
}
@end
