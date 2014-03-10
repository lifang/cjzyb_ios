//
//  FocusInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "FocusInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation FocusInterface

-(void)getFocusInterfaceDelegateWithMessageId:(NSString *)messageId andUserId:(NSString *)userId andType:(NSInteger)type{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",messageId] forKey:@"micropost_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"user_id"];
    self.type = type;
    if (type == 0) {//取消关注
        self.interfaceUrl = @"http://58.240.210.42:3004/api/students/unfollow";
    }else {//关注
        self.interfaceUrl = @"http://58.240.210.42:3004/api/students/add_concern";
    }
    
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
                        [self.delegate getFocusInfoDidFinished:jsonData andType:self.type];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getFocusInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getFocusInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getFocusInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getFocusInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getFocusInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getFocusInfoDidFailed:@"获取数据失败!"];
}
@end
