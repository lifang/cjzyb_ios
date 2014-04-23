//
//  CardInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation CardInterface
-(void)getCardInterfaceDelegateWithStudentId:(NSString *)studentId andClassId:(NSString *)classId andType:(NSString *)type {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",studentId] forKey:@"student_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",classId] forKey:@"school_class_id"];

    self.interfaceUrl = [NSString stringWithFormat:@"%@/api/students/get_knowledges_card",kHOST];
    
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
                        [self.delegate getCardInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getCardInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getCardInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getCardInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getCardInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getCardInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getCardInfoDidFailed:@"获取数据失败!"];
}


@end
