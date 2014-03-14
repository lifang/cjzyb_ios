//
//  LHLGetMyNoticeInterface.m
//  cjzyb_ios
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLGetMyNoticeInterface.h"

@implementation LHLGetMyNoticeInterface

-(void)getMyNoticeWithUserID:(NSString *)userID andSchoolClassID:(NSString *)classID andPage:(NSString *)page{
    
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(ASIHTTPRequest *)request{
    NSData *data = [[NSData alloc]initWithData:[request responseData]];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if (jsonData) {
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    @try {
                        [self.delegate getMyNoticeDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getMyNoticeDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getMyNoticeDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getMyNoticeDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getMyNoticeDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getMyNoticeDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}

-(void)requestIsFailed:(NSError *)error{
    [self.delegate getMyNoticeDidFailed:@"获取数据失败!"];
}

@end
