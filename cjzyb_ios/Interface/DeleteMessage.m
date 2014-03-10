//
//  DeleteMessage.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DeleteMessage.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation DeleteMessage

-(void)getDeleteMessageDelegateDelegateWithMessageId:(NSString *)messageId{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",messageId] forKey:@"micropost_id"];

    self.interfaceUrl = @"http://58.240.210.42:3004/api/students/delete_posts";

    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connectWithMethod:@"GET"];;
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
                        [self.delegate getDeleteMsgInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getDeleteMsgInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getDeleteMsgInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getDeleteMsgInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getDeleteMsgInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getDeleteMsgInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getDeleteMsgInfoDidFailed:@"获取数据失败!"];
}
@end
