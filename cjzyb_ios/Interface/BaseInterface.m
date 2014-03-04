//
//  BaseInterface.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "BaseInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "InterfaceCache.h"

@implementation BaseInterface
@synthesize baseDelegate = _baseDelegate , request = _request;
@synthesize interfaceUrl = _interfaceUrl , headers = _headers , bodys = _bodys;

-(NSString *)createPostURL:(NSDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

-(void)connect {
    if (self.interfaceUrl) {
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",self.interfaceUrl];
        NSString *postURL=[self createPostURL:self.headers];
        [urlStr appendFormat:@"?%@",postURL];
        //url含中文转化UTF8
        urlStr = (NSMutableString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (CFStringRef)urlStr,
                                                                        NULL,
                                                                        NULL,
                                                                        kCFStringEncodingUTF8));
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        if (url) {
            self.request = [ASIHTTPRequest requestWithURL:url];
        }

        [self.request setTimeOutSeconds:60];
        
        [self.request setRequestMethod:@"GET"];
        [self.request setDelegate:self];
        [self.request startAsynchronous];

    }else{
        //抛出异常
    }
}

#pragma mark - ASIHttpRequestDelegate

-(void)requestFinished:(ASIHTTPRequest *)request {
    
    [self.baseDelegate parseResult:request];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    [_baseDelegate requestIsFailed:request.error];
}


@end
