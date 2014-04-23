//
//  ReplyMessageInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ReplyMessageInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation ReplyMessageInterface

-(void)getReplyMessageInterfaceDelegateWithMessageId:(NSString *)messageId andPage:(NSInteger)page {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",messageId] forKey:@"micropost_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
    self.interfaceUrl =[NSString stringWithFormat:@"%@/api/students/get_reply_microposts",kHOST];
    
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connectWithMethod:@"GET"];
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
                        [self.delegate getReplyMessageInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getReplyMessageInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getReplyMessageInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getReplyMessageInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getReplyMessageInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getReplyMessageInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getReplyMessageInfoDidFailed:@"获取数据失败!"];
}

@end
