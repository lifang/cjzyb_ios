//
//  LHLTestInterface.m
//  cjzyb_ios
//
//  Created by apple on 14-3-5.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLTestInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation LHLTestInterface
-(void)getLHLTestDelegateWithClassId:(NSString *)classId andUserId:(NSString *)userId{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",classId] forKey:@"school_class_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"user_id"];
    
    self.interfaceUrl = @"http://58.240.210.42:3004/api/students/get_messages";
    
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connectWithMethod:@"GET"];
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(ASIHTTPRequest *)request{
//    NSData *data = [[NSData alloc]initWithData:[request responseData]];
//    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    if (jsonObject !=nil) {
//        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *jsonData=(NSDictionary *)jsonObject;
//            if (jsonData) {
//                if ([[jsonData objectForKey:@"status"]isEqualToString:@"success"]) {
//                    @try {
//                        [self.delegate getLHLInfoDidFinished:jsonData];
//                    }
//                    @catch (NSException *exception) {
//                        [self.delegate getLHLInfoDidFailed:@"获取数据失败!"];
//                    }
//                }else {
//                    [self.delegate getLHLInfoDidFailed:[jsonData objectForKey:@"notice"]];
//                }
//            }else {
//                [self.delegate getLHLInfoDidFailed:@"获取数据失败!"];
//            }
//        }else{
//            [self.delegate getLHLInfoDidFailed:@"服务器连接失败，请稍后再试!"];
//        }
//    }else{
//        [self.delegate getLHLInfoDidFailed:@"服务器连接失败，请稍后再试!"];
//    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getLHLInfoDidFailed:@"获取数据失败!"];
}
@end
