//
//  MessageInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "MessageInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation MessageInterface
-(void)getMessageInterfaceDelegateWithClassId:(NSString *)classId andUserId:(NSString *)userId{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",classId] forKey:@"school_class_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"student_id"];
    
    self.interfaceUrl =[NSString stringWithFormat:@"%@/api/students/get_class_info",kHOST];

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
                        [self.delegate getMessageInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getMessageInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getMessageInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getMessageInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getMessageInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getMessageInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getMessageInfoDidFailed:@"获取数据失败!"];
}
@end
