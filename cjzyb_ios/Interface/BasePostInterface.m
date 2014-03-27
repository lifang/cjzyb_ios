//
//  BasePostInterface.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-18.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BasePostInterface.h"

@implementation BasePostInterface

-(void)postAnswerFileWith:(NSString *)jsonPath {
    NSString *path = [Utility returnPath];
    NSString *documentDirectory = [path stringByAppendingPathComponent:jsonPath];
    NSString *jsPath=[documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"answer_%@.json",[DataService sharedService].user.userId]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://58.240.210.42:3004/api/students/finish_question_packge"]];
    [request setPostValue:[DataService sharedService].user.studentId forKey:@"student_id"];
    [request setPostValue:[DataService sharedService].theClass.classId forKey:@"school_class_id"];
    [request setPostValue:[DataService sharedService].taskObj.taskID forKey:@"publish_question_package_id"];
    
    [request setFile:jsPath forKey:@"answer_file"];
    
    [request setDelegate:self];
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIFormDataRequest *)requestForm {
    NSData *data = [[NSData alloc]initWithData:[requestForm responseData]];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            if (jsonData){
                if ([[jsonData objectForKey:@"status"]isEqualToString:@"success"]) {
                    @try {
                        [self.delegate getPostInfoDidFinished:jsonData];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getPostInfoDidFailed:@"获取数据失败!"];
                    }
                }
            }else {
                [self.delegate getPostInfoDidFailed:@"获取数据失败!"];
            }
        }
    }else {
        [self.delegate getPostInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request {
    [self.delegate getPostInfoDidFailed:@"获取数据失败!"];
}
@end
