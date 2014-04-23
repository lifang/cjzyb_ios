//
//  QuestionInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-6.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "QuestionInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation QuestionInterface
-(void)getQuestionInterfaceDelegateWithUserId:(NSString *)userId andUserType:(NSString *)userType andClassId:(NSString *)classId andContent:(NSString *)content {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"user_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userType] forKey:@"user_types"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",classId] forKey:@"school_class_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    
    self.interfaceUrl =[NSString stringWithFormat:@"%@/api/students/news_release",kHOST];
    
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connectWithMethod:@"POST"];;
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
                        [self.delegate getQuestionInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getQuestionInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getQuestionInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getQuestionInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getQuestionInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getQuestionInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getQuestionInfoDidFailed:@"获取数据失败!"];
}

@end
