//
//  LogInterface.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "LogInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation LogInterface

-(void)getLogInterfaceDelegateWithQQ:(NSString *)qq {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    AppDelegate *appDel = [AppDelegate shareIntance];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",qq] forKey:@"open_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",appDel.pushstr] forKey:@"token"];

    self.interfaceUrl = @"http://58.240.210.42:3004/api/students/login";

    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connectWithMethod:@"POST"];
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(ASIHTTPRequest *)request{
    NSData *data = [[NSData alloc]initWithData:[request responseData]];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if (jsonData) {
                [self.delegate getLogInfoDidFinished:jsonData];   
            }else {
                [self.delegate getLogInfoDidFailed:@"登录失败!"];
            }
        }
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getLogInfoDidFailed:@"请求失败!"];
}

@end
