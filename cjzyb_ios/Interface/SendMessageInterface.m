
//
//  SendMessageInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SendMessageInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation SendMessageInterface
-(void)getSendDelegateWithSendId:(NSString *)sendId andSendType:(NSString *)sendType andClassId:(NSString *)classId andReceiverId:(NSString *)receiverId andReceiverType:(NSString *)receiverType andmessageId:(NSString *)messageId andContent:(NSString *)content andType:(NSInteger)type{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sendId] forKey:@"sender_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sendType] forKey:@"sender_types"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",receiverId] forKey:@"reciver_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",receiverType] forKey:@"reciver_types"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",classId] forKey:@"school_class_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",messageId] forKey:@"micropost_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    
    self.type = type;
    self.interfaceUrl =[NSString stringWithFormat:@"%@/api/students/reply_message",kHOST];
    

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
                if ([[jsonData objectForKey:@"status"]isEqualToString:@"success"]) {
                    @try {
                        [self.delegate getSendInfoDidFinished:jsonData anType:self.type];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getSendInfoDidFailed:@"获取数据失败!"];
                    }
                }else {
                    [self.delegate getSendInfoDidFailed:[jsonData objectForKey:@"notice"]];
                }
            }else {
                [self.delegate getSendInfoDidFailed:@"获取数据失败!"];
            }
        }else{
            [self.delegate getSendInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else{
        [self.delegate getSendInfoDidFailed:@"服务器连接失败，请稍后再试!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSendInfoDidFailed:@"获取数据失败!"];
}
@end
