//
//  DeleteCardInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DeleteCardInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation DeleteCardInterface
-(void)getDeleteCardDelegateDelegateWithCardId:(NSString *)cardId  andTag:(NSInteger)tag{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",cardId] forKey:@"knowledges_card_id"];
    self.tag = tag;
    self.interfaceUrl = @"http://58.240.210.42:3004/api/students/delete_knowledges_card";
    
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
                        [self.delegate getDeleteCardInfoDidFinished:jsonData andTag:self.tag];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getDeleteCardInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getDeleteCardInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getDeleteCardInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getDeleteCardInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getDeleteCardInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getDeleteCardInfoDidFailed:@"获取数据失败!"];
}

@end
