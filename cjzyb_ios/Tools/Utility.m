//
//  Utility.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#include "double_metaphone.h"
@interface Utility()
@property (nonatomic,strong) UIAlertView *alert;
@end
@implementation Utility
+(Utility*)defaultUtility{
    static Utility *defaultUti = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUti = [[Utility alloc] init];
    });
    return defaultUti;
}

///分数转化成等级,满100升一级
+(NSString*)formateLevelWithScore:(float)score{
    return [NSString stringWithFormat:@"L%d",(int)score/100];
}

///异步请求网络数据
+(void)requestDataWithRequest:(NSURLRequest*)request withSuccess:(void (^)(NSDictionary *dicData))success withFailure:(void (^)(NSError *error))failure{
    if (!request) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        DLog(@"%@,%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        if (error) {
            [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": tipMsg}]);
                    }
                });
            }];
            
            return ;
        }
        
        NSError *jsonError = nil;
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (!dicData || dicData.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"获取空数据"}]);
                }
            });
            return ;
        }
        
        NSString *status = [Utility filterValue:[dicData objectForKey:@"status"]];
        if (!status || [status isEqualToString:@"error"] || [status isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg": [dicData objectForKey:@"notice"]?:@"获取数据失败"}]);
                }
            });
            return;
        }
        
        if (success) {
            success(dicData);
        }
    });
}


///异步请求网络数据
+(void)requestDataWithASIRequest:(ASIHTTPRequest*)request withSuccess:(void (^)(NSDictionary *dicData))success withFailure:(void (^)(NSError *error))failure{
    if (!request) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [request startSynchronous];
        NSError *error = request.error;
        NSData *data = request.responseData;
        DLog(@"%@,%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        if (error) {
            [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": tipMsg}]);
                    }
                });
            }];
            
            return ;
        }
        
        NSError *jsonError = nil;
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (!dicData || dicData.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"获取空数据"}]);
                }
            });
            return ;
        }
        
        
        NSString *status = [Utility filterValue:[dicData objectForKey:@"status"]];
        if (!status || [status isEqualToString:@"error"] || [status isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg": [dicData objectForKey:@"notice"]?:@"获取数据失败"}]);
                }
            });
            return;
        }
        if (success) {
            success(dicData);
        }
    });
}


+(NSString *)filterValue:(NSString*)filterValue{
    NSString *value = [NSString stringWithFormat:@"%@",filterValue];
    if ([value isEqualToString:@""] || [value isEqualToString:@"<NULL>"] || [value isEqualToString:@"null"] || [value isEqualToString:@"<null>"]) {
        return nil;
    }
    return value;
}

+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day]   == [comp2 day] &&
    
    [comp1 month] == [comp2 month] &&
    
    [comp1 year]  == [comp2 year];
}

+(NSString*)formateDateStringWithSecond:(int)second{
    int temp = second;
    int level = 2;
    NSMutableString *date = [[NSMutableString alloc] init];
    while (level > 0) {
        if (temp/(int)pow(60, level) <= 0) {
            level--;
            continue;
        }
        switch (level) {
            case 2:
                [date appendFormat:@"%d ",temp/(int)pow(60, level)];
                break;
            case 1:
                [date appendFormat:@"%d' ",temp/(int)pow(60, level)];
                break;
            default:
                break;
        }
        temp = temp%(int)pow(60, level);
        level--;
    }
    [date appendFormat:@"%d\" ",temp];
    return date.lowercaseString;
}

+ (UIImage *)getNormalImage:(UIView *)view{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)errorAlert:(NSString *)message {
    if (!message || [message isEqualToString:@""]) {
        return;
    }
    if ([Utility defaultUtility].alert != nil) {
        UIAlertView *alert = [Utility defaultUtility].alert;
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [[Utility defaultUtility] setAlert:alert];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
    
}
//+ (NSString *)isExistenceNetwork {
//    NSString *str = nil;
//	Reachability *r = [Reachability reachabilityWithHostName:@"lms.finance365.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//			str = @"NotReachable";
//            break;
//        case ReachableViaWWAN:
//			str = @"ReachableViaWWAN";
//            break;
//        case ReachableViaWiFi:
//			str = @"ReachableViaWiFi";
//            break;
//    }
//    return str;
//}

+(void)judgeNetWorkStatus:(void (^)(NSString*networkStatus))networkStatus{
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *str = @"NotReachable";
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			str = @"NotReachable";
            break;
        case ReachableViaWWAN:
			str = @"ReachableViaWWAN";
            break;
        case ReachableViaWiFi:
			str = @"ReachableViaWiFi";
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        networkStatus(str);
    });
});
}


+(CGSize)getAttributeStringSizeWithWidth:(float)width withAttributeString:(NSAttributedString*)attriString{
 CGRect rect = [attriString boundingRectWithSize:(CGSize){width,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics context:nil];
    return (CGSize){rect.size.width,rect.size.height+30};
}

+(NSArray*)getAllSubStringRanges:(NSString*)string withSubString:(NSString *)subString{
    if (!string || !subString) {
        return nil;
    }
    NSMutableString *tempString = [[NSMutableString alloc] initWithString:string];
    NSMutableArray *subRangeArr = [NSMutableArray array];
    NSMutableString *replaceString = [[NSMutableString alloc] init];
    for (int index = 0; index < subString.length; index++) {
        [replaceString appendFormat:@"￡"];
    }
    
    while (YES) {
        NSRange range = [tempString rangeOfString:subString];
        if (range.length <= 0) {
            break;
        }
        [subRangeArr addObject:@{@"startIndex": [NSNumber numberWithInt:range.location],@"lenght":[NSNumber numberWithInt:range.length]}];
        [tempString replaceCharactersInRange:range withString:replaceString];
    }
    return subRangeArr;
}
+(NSString*)convertFileSizeUnitWithBytes:(NSString*)bytes{
    int level = 0;
    NSString *convertSize = nil;
    long long size = bytes.longLongValue;
    double lenght = size*1.0;
    while (lenght >= 1024.0) {
        if (level >= 3) {
            break;
        }
        level++;
        lenght = lenght/1024.0;
    }
    
    switch (level) {
        case 0:
            convertSize = [NSString stringWithFormat:@"%0.2fKB",lenght];
            break;
        case 1:
            convertSize = [NSString stringWithFormat:@"%0.2fM",lenght];
            break;
        case 2:
            convertSize = [NSString stringWithFormat:@"%0.2fG",lenght];
            break;
        case 3:
            convertSize = [NSString stringWithFormat:@"%0.2fTB",lenght];
            break;
        default:
            break;
    }
    return convertSize;
}
+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font withWidth:(float)width{
    if (text && font) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CGSize size = [text boundingRectWithSize:(CGSize){width,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: font} context:nil].size;
            return size;
        }else{
            if([text isEqualToString:@""]){
                //如果为空字符串,则本方法给出符合字体的基本高度,以与ios7的方法保持一致  
                text = @"1";
            }
            CGSize size = [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sizeWithFont:font constrainedToSize:(CGSize){width,MAXFLOAT} lineBreakMode:NSLineBreakByWordWrapping];
            return size;
        }
    } else {
        return CGSizeZero;
    }
}

//+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font withWidth:(float)width{
//    if (text && font) {
//        CGSize size = [text boundingRectWithSize:(CGSize){width,2000.0} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: font} context:nil].size;
//        return size;
//    } else {
//        return CGSizeZero;
//    }
//}


+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font{
    if (text && font) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            return [text sizeWithAttributes:@{NSFontAttributeName: font}];
        }else{
            CGSize size = [text sizeWithFont:font];
            return size;
        }
    } else {
        return CGSizeZero;
    }
}

+(NSString *)createMD5:(NSString *)signString
{
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

+ (Class)JSONParserClass {
    return objc_getClass("NSJSONSerialization");
}

+ (NSDictionary *)initWithJSONFile:(NSString *)jsonPath {
    Class JSONSerialization = [Utility JSONParserClass];
    NSAssert(JSONSerialization != NULL, @"No JSON serializer available!");
    
    NSError *jsonParsingError = nil;
    
    NSString *path;
    if (platform>5.0) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *documentDirectory = [path stringByAppendingPathComponent:jsonPath];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"question.json"];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonPath ofType:@"json"];
    NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:0 error:&jsonParsingError];
    return dataObject;
}

+(NSString*)getStringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}
+(NSDate*)getDateFromDateString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)getNowDateFromatAnDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
    return timeString;
}


+(BOOL)requestFailure:(NSError*)error tipMessageBlock:(void(^)(NSString *tipMsg))msg{
    if (!error) {
        msg(@"无法连接服务器");
        return NO;
    }
    NSString *tip = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    if (!tip) {
        msg(@"无法连接服务器");
        return NO;
    }
    
    if ([tip isEqualToString:@"The request timed out"]) {
        msg(@"连接网络失败");
        return YES;
    }
    
    if ([tip isEqualToString:@"A connection failure occurred"] || [tip isEqualToString:@"The Internet connection appears to be offline."]) {
        msg(@"当前网络不可用");
        return YES;
    }
    
    if ([tip isEqualToString:@"Could not connect to the server."]) {
        msg(@"无法连接服务器");
        return YES;
    }
    if ([tip isEqualToString:@"Expected status code in (200-299)"]) {
        msg(@"无法连接服务器");
        return YES;
    }
    if ([tip isEqualToString:@"The network connection was lost."]) {
        msg(@"无法连接服务器");
        return YES;
    }
    
    if ([tip isEqualToString:@"未能连接到服务器。"]) {
        msg(@"未能连接到服务器");
        return YES;
    }
    
    if ([tip isEqualToString:@"似乎已断开与互联网的连接。"]) {
        msg(@"无法连接网络");
        return YES;
    }
    
    msg(@"无法连接服务器");
    return NO;
}



/////////////////////////////////////////下面都是单词匹配使用的

+ (Utility *)shared{
    static Utility *defaultUti = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUti = [[Utility alloc] init];
    });
    return defaultUti;
}
+(NSString*)spellStringWithWord:(NSString*)word{
    if (!word) {
        return NULL;
    }
     char *reslut = nil;
    DoubleMetaphone([word UTF8String], &reslut);
    return [NSString stringWithCString:reslut encoding:NSUTF8StringEncoding];
}

+(NSArray *)metaphoneArray:(NSArray *)array {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    if (array.count>0) {
        for (int i=0; i<array.count; i++) {
            NSString *strTest = [Utility  spellStringWithWord:[array objectAtIndex:i]];
            [tempArray addObject:strTest];
        }
    }
    return tempArray;
}
//去除标点符号 hello,will: can't. project me serve?
+(NSArray *)handleTheString:(NSString *)string {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSError *error;
    NSString *regTags = @"([a-zA-Z]+[-']*[a-zA-Z]+)|([a-zA-Z]+)";//added by david
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    if ([Utility shared].isOrg == NO) {
        [Utility shared].rangeArray = matches;
    }
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *str = [string substringWithRange:matchRange];
        
        [tempArray addObject:str];
    }
    
    return tempArray;
}
//单词转化字母数组
+(NSArray *)handleTheLetter:(NSString *)string {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSError *error;
    NSString *regTags = @"[a-zA-Z]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *str = [string substringWithRange:matchRange];
        [tempArray addObject:str];
        
    }
    
    return tempArray;
}

+(int) MiniNum:(int)x SetY:(int)y SetZ:(int)z
{
    int tempNum;
    tempNum = x;
    if (y<tempNum) {
        tempNum = y;
    }
    if (z<tempNum) {
        tempNum = z;
    }
    return tempNum;
}
//匹配相似度
+(int)DistanceBetweenTwoString:(NSString*)strA StrAbegin:(int)strAbegin StrAend:(int)strAend StrB:(NSString*)strB StrBbegin:(int)strBbegin StrBend:(int)strBend
{
    int x,y,z;
    if (strAbegin>strAend) {
        if (strBbegin>strBend) {
            return 0;
        }else {
            return strBend -strBbegin +1;
        }
    }
    if (strBbegin>strBend) {
        if (strAbegin>strAend) {
            return 0;
        }else {
            return strAend -strAbegin +1;
        }
    }
    if ([[[strA substringWithRange:NSMakeRange(strAbegin, 1)]uppercaseString] isEqualToString:[[strB substringWithRange:NSMakeRange(strBbegin, 1)]uppercaseString]]) {
        return [Utility DistanceBetweenTwoString:strA StrAbegin:strAbegin+1 StrAend:strAend StrB:strB StrBbegin: strBbegin+1 StrBend: strBend];
    }else {
        x = [Utility DistanceBetweenTwoString:strA StrAbegin:strAbegin+1 StrAend:strAend StrB:strB StrBbegin: strBbegin+1 StrBend: strBend];
        y = [Utility DistanceBetweenTwoString:strA StrAbegin:strAbegin StrAend:strAend StrB:strB StrBbegin: strBbegin+1 StrBend: strBend];
        z = [Utility DistanceBetweenTwoString:strA StrAbegin:strAbegin+1 StrAend:strAend StrB:strB StrBbegin: strBbegin StrBend: strBend];
        return[Utility MiniNum:x SetY:y SetZ:z] +1;
    }
}
///@"hello,will: can't.u project me serve?";
//返回结果 arrA:输入文本的单词数组  /  arrAA:输入文本简化后的单词数组
//        arrB:原文本单词数组    /   arrBB:原文本简化后的单词数组
+(NSDictionary *)listenCompareWithArray:(NSArray *)arrA andArray:(NSArray *)arrAA WithArray:(NSArray *)arrB andArray:(NSArray *)arrBB {
    NSMutableArray *temp_arrA = [NSMutableArray arrayWithArray:arrA];//输入文本的单词数组
    NSMutableArray *temp_arrAA = [NSMutableArray arrayWithArray:arrAA];//输入文本简化后的单词数组
    NSMutableArray *temp_arrB = [NSMutableArray arrayWithArray:arrB];//原文本单词数组
    NSMutableArray *temp_arrBB = [NSMutableArray arrayWithArray:arrBB];//原文本简化后的单词数组

    for (int i=0; i<arrA.count; i++) {
        NSString *orgStringA = [temp_arrA objectAtIndex:i];
        NSString *orgStringB = [temp_arrB objectAtIndex:i];
        if ([[orgStringA uppercaseString] isEqualToString:[orgStringB uppercaseString]]) {
            NSLog(@"完全正确");
            [[Utility shared].greenArray addObject:[NSString stringWithFormat:@"%d",i]];
        }//原文完全匹配
        else {
            NSString *strAA = [temp_arrAA objectAtIndex:i];
            NSString *strBB = [temp_arrBB objectAtIndex:i];
            if ([strAA isEqualToString:strBB]) {
                int rotateDis = [Utility DistanceBetweenTwoString:orgStringA StrAbegin:0 StrAend:orgStringA.length-1 StrB:orgStringB StrBbegin:0 StrBend:orgStringB.length-1];
                if (rotateDis == 0) {
                    NSLog(@"完全正确");
                    [[Utility shared].greenArray addObject:[NSString stringWithFormat:@"%d",i]];
                }else if (rotateDis<= (abs(orgStringB.length-orgStringA.length)==0?1:2)) {
                    NSLog(@"基本正确");
                    [[Utility shared].yellowArray addObject:[NSString stringWithFormat:@"%d",i]];
                    [[Utility shared].sureArray addObject:[temp_arrB objectAtIndex:i]];
                }else {
                    NSLog(@"黑户");
                    [[Utility shared].wrongArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
            }//简化文完全匹配－－计算原文的相似度
            else {//简化文不同，原文不同
                int m=0,n=0;
                NSArray *arrayA = [Utility handleTheLetter:orgStringA];
                NSArray *arrayB = [Utility handleTheLetter:orgStringB];
                for (int k=0; k<arrayA.count; k++) {
                    NSString *letter = [arrayA objectAtIndex:k];
                    if ([arrayB containsObject:letter]) {
                        n++;
                    }
                }
                float y = (float)orgStringB.length/2;
                if (n-y>=0){//原文部分匹配
                    NSArray *arrayAA = [Utility handleTheLetter:strAA];
                    NSArray *arrayBB = [Utility handleTheLetter:strBB];
                    for (int k=0; k<arrayAA.count; k++) {
                        NSString *letter = [arrayAA objectAtIndex:k];
                        if ([arrayBB containsObject:letter]) {
                            m++;
                        }
                    }
                    float x = (float)strBB.length/2;
                    if (m-x>0) {//简化部分匹配
                        NSLog(@"部分匹配");
                        [[Utility shared].yellowArray addObject:[NSString stringWithFormat:@"%d",i]];
                        [[Utility shared].sureArray addObject:[temp_arrB objectAtIndex:i]];
                    }else {
                        NSLog(@"黑户");
                        [[Utility shared].wrongArray addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                }else {
                    NSLog(@"黑户");
                    [[Utility shared].wrongArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
 
            }
        }
    }
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]init];
    if ([Utility shared].greenArray.count>0) {
        [mutableDic setObject:[Utility shared].greenArray forKey:@"green"];
    }
    if ([Utility shared].yellowArray.count>0) {
        [mutableDic setObject:[Utility shared].yellowArray forKey:@"yellow"];
        [mutableDic setObject:[Utility shared].sureArray forKey:@"sure"];
    }

    if ([Utility shared].wrongArray.count>0) {
        [mutableDic setObject:[Utility shared].wrongArray forKey:@"wrong"];
    }

    [Utility shared].greenArray = nil;
    [Utility shared].yellowArray = nil;
    [Utility shared].sureArray = nil;
    [Utility shared].wrongArray = nil;
    return mutableDic;
    
}
+(NSDictionary *)compareWithArray:(NSArray *)arrA andArray:(NSArray *)arrAA WithArray:(NSArray *)arrB andArray:(NSArray *)arrBB WithRange:(NSArray *)rangeArray{
    NSMutableArray *temp_arrA = [NSMutableArray arrayWithArray:arrA];//输入文本的单词数组
    NSMutableArray *temp_arrAA = [NSMutableArray arrayWithArray:arrAA];//输入文本简化后的单词数组
    NSMutableArray *temp_arrB = [NSMutableArray arrayWithArray:arrB];//原文本单词数组
    NSMutableArray *temp_arrBB = [NSMutableArray arrayWithArray:arrBB];//原文本简化后的单词数组
    NSMutableArray *temp_range = [NSMutableArray arrayWithArray:rangeArray];
    if (temp_arrAA.count>0 && temp_arrA.count>[Utility shared].firstpoint && temp_arrBB.count>0) {
        NSString *strAA = [temp_arrAA objectAtIndex:[Utility shared].firstpoint];
        if ([temp_arrBB containsObject:strAA]) {
            NSUInteger index = [temp_arrBB indexOfObject:strAA];
            if (index>[Utility shared].firstpoint) {//位置不同
                //先比较2个数组中的第index个字符
                if (temp_arrAA.count>index) {
                    NSString *strAA2 = [temp_arrAA objectAtIndex:index];
                    if ([strAA isEqualToString:strAA2]) {//index位置元素相同
                        //比较相同后一位的相似度
                        if (temp_arrBB.count>index+1) {//第一位与index＋1位
                            NSString *strBB = [temp_arrBB objectAtIndex:index+1];
                            NSString *strAA3 = [temp_arrAA objectAtIndex:[Utility shared].firstpoint+1];
                            if ([temp_arrBB containsObject:strAA3]) {//arrAA里面后一位在arrBB里面
                                NSUInteger index2 = [temp_arrBB indexOfObject:strAA3];
                                if (index2>index) {//0位置与index位置对应
                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                    NSString *string = [temp_arrA objectAtIndex:[Utility shared].firstpoint];
                                    int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                    BOOL isSure = NO;
                                    if (rotateDis == 0) {
                                        NSLog(@"完全正确");
                                        isSure = YES;
                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {
                                        NSLog(@"基本正确");
                                        isSure = YES;
                                        [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                        [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                    }else {
                                        NSLog(@"黑户");
                                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                        [Utility shared].firstpoint +=1;
                                    }
                                    if (isSure == YES) {
                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                                        NSRange range = [match rangeAtIndex:0];
                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utility shared].firstpoint];//从起点0开始到中点
                                        [[Utility shared].spaceLineArray addObject:str];
                                        
                                        [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                                        [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                                        if (index > [Utility shared].firstpoint) {
                                            NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                            NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                            for (int yy=[Utility shared].firstpoint; yy<=index; yy++) {
                                                [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                            }
                                            [temp_arrB removeObjectsInArray:tempArrayB];
                                            [temp_arrBB removeObjectsInArray:tempArrayBB];
                                        }else {
                                            [temp_arrB removeObjectAtIndex:index];
                                            [temp_arrBB removeObjectAtIndex:index];
                                        }
                                        [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                                    }
                                }
                                else {//index位置与index位置对应
                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                    NSString *string = [temp_arrA objectAtIndex:index];
                                    int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                    BOOL isSure = NO;
                                    if (rotateDis == 0) {
                                        NSLog(@"完全正确");
                                        isSure = YES;
                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {
                                        NSLog(@"基本正确");
                                        isSure = YES;
                                        [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                        [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                    }else {
                                        NSLog(@"黑户");
                                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:index]];
                                        [Utility shared].firstpoint +=1;
                                    }
                                    if (isSure == YES) {
                                        [temp_arrA removeObjectAtIndex:index];
                                        [temp_arrAA removeObjectAtIndex:index];
                                        [temp_arrB removeObjectAtIndex:index];
                                        [temp_arrBB removeObjectAtIndex:index];
                                        [temp_range removeObjectAtIndex:index];
                                    }
                                }
                            }
                            else {//第一位与index＋1位是否部分匹配
                                BOOL exit = NO;
                                for (int i=0; i<temp_arrBB.count; i++) {
                                    int m=0,n=0;
                                    if (i!=index) {
                                        NSString *strBB3 = [temp_arrBB objectAtIndex:i];
                                        NSArray *arrayAA = [Utility handleTheLetter:strAA3];
                                        NSArray *arrayBB = [Utility handleTheLetter:strBB3];
                                        for (int k=0; k<arrayAA.count; k++) {
                                            NSString *letter = [arrayAA objectAtIndex:k];
                                            if ([arrayBB containsObject:letter]) {
                                                m++;
                                            }
                                        }
                                        float x = (float)strBB.length/2;
                                        if (m-x>0) {//简化部分匹配
                                            NSString *strA = [temp_arrA objectAtIndex:[Utility shared].firstpoint+1];
                                            NSString *strB = [temp_arrB objectAtIndex:i];
                                            NSArray *arrayA = [Utility handleTheLetter:strA];
                                            NSArray *arrayB = [Utility handleTheLetter:strB];
                                            for (int k=0; k<arrayA.count; k++) {
                                                NSString *letter = [arrayA objectAtIndex:k];
                                                if ([arrayB containsObject:letter]) {
                                                    n++;
                                                }
                                            }
                                            float y = (float)strB.length/2;
                                            if (n-y>=0) {//原文部分匹配
                                                exit = YES;
                                                NSLog(@"部分匹配");
                                                //i位置与第一位部分匹配
                                                if (i>index) {//0位置与index位置对应
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:[Utility shared].firstpoint+1];
                                                    
                                                    int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                        [Utility shared].firstpoint +=1;
                                                    }
                                                    if (isSure == YES) {
                                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                                                        NSRange range = [match rangeAtIndex:0];
                                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utility shared].firstpoint];//从起点0开始到中点
                                                        [[Utility shared].spaceLineArray addObject:str];
                                                        
                                                        [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                                                        [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                                                        if (index > [Utility shared].firstpoint) {
                                                            NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                                            NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                                            for (int yy=[Utility shared].firstpoint; yy<=index; yy++) {
                                                                [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                                [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                                            }
                                                            [temp_arrB removeObjectsInArray:tempArrayB];
                                                            [temp_arrBB removeObjectsInArray:tempArrayBB];
                                                        }else {
                                                            [temp_arrB removeObjectAtIndex:index];
                                                            [temp_arrBB removeObjectAtIndex:index];
                                                        }
                                                        
                                                        [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                                                    }
                                                    break;
                                                }
                                                else {//index位置与index位置对应
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:index];
                                                    int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:index]];
                                                        [Utility shared].firstpoint +=1;
                                                    }
                                                    if (isSure == YES) {
                                                        [temp_arrA removeObjectAtIndex:index];
                                                        [temp_arrAA removeObjectAtIndex:index];
                                                        [temp_arrB removeObjectAtIndex:index];
                                                        [temp_arrBB removeObjectAtIndex:index];
                                                        [temp_range removeObjectAtIndex:index];
                                                    }
                                                }
                                                break;
                                            }
                                        }
                                        if (index == temp_arrBB.count-1) {
                                            if (i==temp_arrBB.count-2 && exit==NO) {//没有部分匹配index
                                                NSString *orgString = [temp_arrB objectAtIndex:index];
                                                NSString *string = [temp_arrA objectAtIndex:index];
                                                int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                BOOL isSure = NO;
                                                if (rotateDis == 0) {//完全相同
                                                    NSLog(@"完全正确");
                                                    isSure = YES;
                                                    [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                    NSLog(@"基本正确");
                                                    isSure = YES;
                                                    [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                    [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                                    [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                }else {
                                                    NSLog(@"黑户");
                                                    [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:index]];
                                                    [Utility shared].firstpoint +=1;
                                                }
                                                if (isSure == YES) {
                                                    [temp_arrA removeObjectAtIndex:index];
                                                    [temp_arrAA removeObjectAtIndex:index];
                                                    [temp_arrB removeObjectAtIndex:index];
                                                    [temp_arrBB removeObjectAtIndex:index];
                                                    [temp_range removeObjectAtIndex:index];
                                                }
                                            }
                                        }else {
                                            if (i==temp_arrBB.count-1 && exit==NO) {//没有部分匹配index
                                                NSString *orgString = [temp_arrB objectAtIndex:index];
                                                NSString *string = [temp_arrA objectAtIndex:index];
                                                int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                BOOL isSure = NO;
                                                if (rotateDis == 0) {//完全相同
                                                    NSLog(@"完全正确");
                                                    isSure = YES;
                                                    [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                    NSLog(@"基本正确");
                                                    isSure = YES;
                                                    [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                    [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                                    [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                }else {
                                                    NSLog(@"黑户");
                                                    [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:index]];
                                                    [Utility shared].firstpoint +=1;
                                                }
                                                [temp_arrA removeObjectAtIndex:index];
                                                [temp_arrAA removeObjectAtIndex:index];
                                                [temp_arrB removeObjectAtIndex:index];
                                                [temp_arrBB removeObjectAtIndex:index];
                                                [temp_range removeObjectAtIndex:index];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {//index最后的位数
                            NSString *orgString = [temp_arrB objectAtIndex:index];
                            NSString *string = [temp_arrA objectAtIndex:index];
                            int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                            BOOL isSure = NO;
                            if (rotateDis == 0) {//完全相同
                                NSLog(@"完全正确");
                                isSure = YES;
                                [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                            }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                NSLog(@"基本正确");
                                isSure = YES;
                                [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                [[Utility shared].greenArray addObject:[temp_range objectAtIndex:index]];
                            }else {
                                NSLog(@"黑户");
                                [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:index]];
                                [Utility shared].firstpoint +=1;
                            }
                            if (isSure == YES) {
                                [temp_arrA removeObjectAtIndex:index];
                                [temp_arrAA removeObjectAtIndex:index];
                                [temp_arrB removeObjectAtIndex:index];
                                [temp_arrBB removeObjectAtIndex:index];
                                [temp_range removeObjectAtIndex:index];
                            }
                        }
                    }
                    else {//index位置元素不同
                        //比较>0位置
                        if (temp_arrAA.count>[Utility shared].firstpoint+1) {
                            for (int j=[Utility shared].firstpoint+1; j<temp_arrAA.count; j++) {
                                BOOL exit = NO;
                                NSString *str_AA = [temp_arrAA objectAtIndex:j];
                                if ([str_AA isEqualToString:strAA]) {
                                    for (int k=0; k<temp_arrBB.count; k++) {
                                        if (k!=index) {
                                            NSString *str_BB = [temp_arrBB objectAtIndex:k];
                                            if ([str_BB isEqualToString:str_AA]) {
                                                if (k>index) {
                                                    exit = YES;
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:[Utility shared].firstpoint];
                                                    int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        
                                                        [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                        [Utility shared].firstpoint +=1;
                                                    }
                                                    if (isSure == YES) {
                                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                                                        NSRange range = [match rangeAtIndex:0];
                                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utility shared].firstpoint];//从起点0开始到中点
                                                        [[Utility shared].spaceLineArray addObject:str];
                                                        
                                                        [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                                                        [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                                                        if (index > [Utility shared].firstpoint) {
                                                            NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                                            NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                                            for (int yy=[Utility shared].firstpoint; yy<=index; yy++) {
                                                                [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                                [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                                            }
                                                            [temp_arrB removeObjectsInArray:tempArrayB];
                                                            [temp_arrBB removeObjectsInArray:tempArrayBB];
                                                        }else {
                                                            [temp_arrB removeObjectAtIndex:index];
                                                            [temp_arrBB removeObjectAtIndex:index];
                                                        }
                                                        [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                                                    }
                                                    break;
                                                }
                                            }else {//j与index对应
                                                if (index>j) {
                                                    exit = YES;
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:j];
                                                    int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:j]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:j]];
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:j]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:j]];
                                                        [Utility shared].firstpoint +=1;
                                                    }
                                                    
                                                    if (isSure == YES) {
                                                        NSTextCheckingResult *match = [temp_range objectAtIndex:j];
                                                        NSRange range = [match rangeAtIndex:0];
                                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-j];//从起点0开始到中点
                                                        [[Utility shared].spaceLineArray addObject:str];
                                                        
                                                        [temp_arrA removeObjectAtIndex:j];
                                                        [temp_arrAA removeObjectAtIndex:j];
                                                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                                        for (int yy=j; yy<=index; yy++) {
                                                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                                        }
                                                        [temp_arrB removeObjectsInArray:tempArrayB];
                                                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                                                        [temp_range removeObjectAtIndex:j];
                                                    }
                                                    break;
                                                }
                                                else {
                                                    exit = YES;
                                                    //0与index对应
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:[Utility shared].firstpoint];
                                                    int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        
                                                        [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                                        [Utility shared].firstpoint +=1;
                                                    }
                                                    if (isSure == YES) {
                                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                                                        NSRange range = [match rangeAtIndex:0];
                                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utility shared].firstpoint];//从起点0开始到中点
                                                        [[Utility shared].spaceLineArray addObject:str];
                                                        
                                                        [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                                                        [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                                                        if (index > [Utility shared].firstpoint) {
                                                            NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                                            NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                                            for (int yy=[Utility shared].firstpoint; yy<=index; yy++) {
                                                                [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                                [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                                            }
                                                            [temp_arrB removeObjectsInArray:tempArrayB];
                                                            [temp_arrBB removeObjectsInArray:tempArrayBB];
                                                        }else {
                                                            [temp_arrB removeObjectAtIndex:index];
                                                            [temp_arrBB removeObjectAtIndex:index];
                                                        }
                                                        [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                                                    }
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                                if (j==temp_arrAA.count-1 && exit ==NO) {
                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                    NSString *string = [temp_arrA objectAtIndex:[Utility shared].firstpoint];
                                    int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                    BOOL isSure = NO;
                                    if (rotateDis == 0) {//完全相同
                                        NSLog(@"完全正确");
                                        isSure = YES;
                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                        NSLog(@"基本正确");
                                        isSure = YES;
                                        [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                        [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                    }else {
                                        NSLog(@"黑户");
                                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                        [Utility shared].firstpoint +=1;
                                    }
                                    if (isSure == YES) {
                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                                        NSRange range = [match rangeAtIndex:0];
                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utility shared].firstpoint];//从起点0开始到中点
                                        [[Utility shared].spaceLineArray addObject:str];
                                        
                                        [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                                        [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                                        if (index > [Utility shared].firstpoint) {
                                            NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                            NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                            for (int yy=[Utility shared].firstpoint; yy<=index; yy++) {
                                                [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                            }
                                            [temp_arrB removeObjectsInArray:tempArrayB];
                                            [temp_arrBB removeObjectsInArray:tempArrayBB];
                                        }else {
                                            [temp_arrB removeObjectAtIndex:index];
                                            [temp_arrBB removeObjectAtIndex:index];
                                        }
                                        [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                                    }
                                }
                            }
                        }
                        else {
                            //0与index对应
                            NSString *orgString = [temp_arrB objectAtIndex:index];
                            NSString *string = [temp_arrA objectAtIndex:[Utility shared].firstpoint];
                            int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                            BOOL isSure = NO;
                            if (rotateDis == 0) {//完全相同
                                NSLog(@"完全正确");
                                isSure = YES;
                                [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                            }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                NSLog(@"基本正确");
                                isSure = YES;
                                [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                            }else {
                                NSLog(@"黑户");
                                [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                [Utility shared].firstpoint +=1;
                            }
                            
                            if (isSure == YES) {
                                NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                                NSRange range = [match rangeAtIndex:0];
                                NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utility shared].firstpoint];//从起点0开始到中点
                                [[Utility shared].spaceLineArray addObject:str];
                                
                                [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                                [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                                if (index > [Utility shared].firstpoint) {
                                    NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                    NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                    for (int yy=[Utility shared].firstpoint; yy<=index; yy++) {
                                        [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                        [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                    }
                                    [temp_arrB removeObjectsInArray:tempArrayB];
                                    [temp_arrBB removeObjectsInArray:tempArrayBB];
                                }else {
                                    [temp_arrB removeObjectAtIndex:index];
                                    [temp_arrBB removeObjectAtIndex:index];
                                }
                                [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                            }
                        }
                    }
                }
                else {//就是0位置与index位置对应
                    NSString *orgString = [temp_arrB objectAtIndex:index];
                    NSString *string = [temp_arrA objectAtIndex:[Utility shared].firstpoint];
                    int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                    BOOL isSure = NO;
                    if (rotateDis == 0) {//完全相同
                        NSLog(@"完全正确");
                        isSure = YES;
                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                        NSLog(@"基本正确");
                        isSure = YES;
                        [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                        [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                        [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                    }else {
                        NSLog(@"黑户");
                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                        [Utility shared].firstpoint +=1;
                    }
                    
                    if (isSure == YES) {
                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                        NSRange range = [match rangeAtIndex:0];
                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utility shared].firstpoint];
                        [[Utility shared].spaceLineArray addObject:str];
                        
                        [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                        [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                        if (index > [Utility shared].firstpoint) {
                            NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                            NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                            for (int yy=[Utility shared].firstpoint; yy<=index; yy++) {
                                [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                            }
                            [temp_arrB removeObjectsInArray:tempArrayB];
                            [temp_arrBB removeObjectsInArray:tempArrayBB];
                        }else {
                            [temp_arrB removeObjectAtIndex:index];
                            [temp_arrBB removeObjectAtIndex:index];
                        }
                        [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                    }
                }
                return [Utility compareWithArray:temp_arrA andArray:temp_arrAA WithArray:temp_arrB andArray:temp_arrBB WithRange:temp_range];
            }
            //输入句子长度大于原文本长度
            else if (index <[Utility shared].firstpoint) {
                NSString *orgString = [temp_arrB objectAtIndex:index];
                NSString *string = [temp_arrA objectAtIndex:[Utility shared].firstpoint];
                int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                BOOL isSure = NO;
                if (rotateDis == 0) {//完全相同
                    NSLog(@"完全正确");
                    isSure = YES;
                    [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                    NSLog(@"基本正确");
                    isSure = YES;
                    [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                    [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                    [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                }else {
                    NSLog(@"黑户");
                    [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                    [Utility shared].firstpoint +=1;
                }
                if (isSure == YES) {
                    [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                    [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                    [temp_arrB removeObjectAtIndex:index];
                    [temp_arrBB removeObjectAtIndex:index];
                    [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                }
                return [Utility compareWithArray:temp_arrA andArray:temp_arrAA WithArray:temp_arrB andArray:temp_arrBB WithRange:temp_range];
            }
            else {//位置相同
                NSString *orgString = [temp_arrB objectAtIndex:[Utility shared].firstpoint];
                NSString *string = [temp_arrA objectAtIndex:[Utility shared].firstpoint];
                int rotateDis = [Utility DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                BOOL isSure = NO;
                if (rotateDis == 0) {//完全相同
                    NSLog(@"完全正确");
                    isSure = YES;
                    [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {
                    NSLog(@"基本正确");
                    isSure = YES;
                    [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:[Utility shared].firstpoint]];
                    [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                    [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                }else {
                    NSLog(@"黑户");
                    [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                    [Utility shared].firstpoint +=1;
                }
                if (isSure == YES) {
                    [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                    [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                    [temp_arrB removeObjectAtIndex:[Utility shared].firstpoint];
                    [temp_arrBB removeObjectAtIndex:[Utility shared].firstpoint];
                    [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                }
                return [Utility compareWithArray:temp_arrA andArray:temp_arrAA WithArray:temp_arrB andArray:temp_arrBB WithRange:temp_range];
            }
        }else {//不包含
            BOOL exit = NO;
            if (strAA.length>1) {
                for (int i=0; i<temp_arrBB.count; i++) {
                    int m=0,n=0;
                    NSString *strBB = [temp_arrBB objectAtIndex:i];
                    NSRange range = [strBB rangeOfString:strAA];
                    if (range.location!=NSNotFound) {
                        if (range.location==0 && range.length <strBB.length) {
                            NSString *strLetter = [strBB substringFromIndex:range.length];
                            if ([strLetter isEqualToString:@"S"]) {
                                NSLog(@"基本正确");
                                [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:i]];
                                [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                if (i > [Utility shared].firstpoint) {
                                    NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                                    NSRange range = [match rangeAtIndex:0];
                                    NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,i-[Utility shared].firstpoint];//从起点x开始之前少x个单词
                                    [[Utility shared].spaceLineArray addObject:str];
                                }
                                [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                                [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                                if (i>[Utility shared].firstpoint) {
                                    NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                    NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                    for (int yy=[Utility shared].firstpoint; yy<=i; yy++) {
                                        [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                        [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                    }
                                    [temp_arrB removeObjectsInArray:tempArrayB];
                                    [temp_arrBB removeObjectsInArray:tempArrayBB];
                                }else {
                                    [temp_arrB removeObjectAtIndex:i];
                                    [temp_arrBB removeObjectAtIndex:i];
                                }
                                
                                [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                                break;
                            }
                        }
                    }
                    else {
                        NSRange range2 = [strAA rangeOfString:strBB];
                        if (range2.location!=NSNotFound) {
                            if (range2.location==0 && range2.length <strAA.length) {
                                NSString *strLetter = [strAA substringFromIndex:range2.length];
                                if ([strLetter isEqualToString:@"S"]) {
                                    NSLog(@"基本正确");
                                    [[Utility shared].correctArray addObject:[temp_arrB objectAtIndex:i]];
                                    [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                    [[Utility shared].greenArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                    if (i > [Utility shared].firstpoint) {
                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                                        NSRange range = [match rangeAtIndex:0];
                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,i-[Utility shared].firstpoint];//从起点x开始之前少x个单词
                                        [[Utility shared].spaceLineArray addObject:str];
                                    }
                                    [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                                    [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                                    if (i>[Utility shared].firstpoint) {
                                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                        for (int yy=[Utility shared].firstpoint; yy<=i; yy++) {
                                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                        }
                                        [temp_arrB removeObjectsInArray:tempArrayB];
                                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                                    }else {
                                        [temp_arrB removeObjectAtIndex:i];
                                        [temp_arrBB removeObjectAtIndex:i];
                                    }
                                    
                                    [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                                    break;
                                }
                            }
                        }else {
                            //判断是否部分匹配
                            NSArray *arrayAA = [Utility handleTheLetter:strAA];
                            NSArray *arrayBB = [Utility handleTheLetter:strBB];
                            for (int k=0; k<arrayAA.count; k++) {
                                NSString *letter = [arrayAA objectAtIndex:k];
                                if ([arrayBB containsObject:letter]) {
                                    m++;
                                }
                            }
                            
                            float x = (float)strBB.length/2;
                            if (m-x>0) {//简化部分匹配
                                NSString *strA = [temp_arrA objectAtIndex:[Utility shared].firstpoint];
                                NSString *strB = [temp_arrB objectAtIndex:i];
                                NSArray *arrayA = [Utility handleTheLetter:strA];
                                NSArray *arrayB = [Utility handleTheLetter:strB];
                                for (int k=0; k<arrayA.count; k++) {
                                    NSString *letter = [arrayA objectAtIndex:k];
                                    if ([arrayB containsObject:letter]) {
                                        n++;
                                    }
                                }
                                float y = (float)strB.length/2;
                                if (n-y>=0) {//原文部分匹配
                                    exit = YES;
                                    NSLog(@"部分匹配");
                                    [[Utility shared].yellowArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                    [[Utility shared].sureArray addObject:[temp_arrB objectAtIndex:i]];
                                    [[Utility shared].noticeArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                                    if (i > [Utility shared].firstpoint) {
                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utility shared].firstpoint];
                                        NSRange range = [match rangeAtIndex:0];
                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,i-[Utility shared].firstpoint];//从起点x开始之前少x个单词
                                        [[Utility shared].spaceLineArray addObject:str];
                                    }
                                    [temp_arrA removeObjectAtIndex:[Utility shared].firstpoint];
                                    [temp_arrAA removeObjectAtIndex:[Utility shared].firstpoint];
                                    if (i>[Utility shared].firstpoint) {
                                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                        for (int yy=[Utility shared].firstpoint; yy<=i; yy++) {
                                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                        }
                                        [temp_arrB removeObjectsInArray:tempArrayB];
                                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                                    }else {
                                        [temp_arrB removeObjectAtIndex:i];
                                        [temp_arrBB removeObjectAtIndex:i];
                                    }
                                    
                                    [temp_range removeObjectAtIndex:[Utility shared].firstpoint];
                                    break;
                                }
                            }
                        }
                    }
                    if (i==temp_arrBB.count-1 && exit==NO) {//没有部分匹配
                        NSLog(@"黑户");
                        [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                        [Utility shared].firstpoint +=1;
                    }
                }
            }else {
                NSLog(@"黑户");
                [[Utility shared].wrongArray addObject:[temp_range objectAtIndex:[Utility shared].firstpoint]];
                [Utility shared].firstpoint +=1;
            }
            return [Utility compareWithArray:temp_arrA andArray:temp_arrAA WithArray:temp_arrB andArray:temp_arrBB WithRange:temp_range];
        }
    }else {
        if (temp_arrBB.count>temp_arrAA.count) {
            NSTextCheckingResult *match = [[Utility shared].rangeArray objectAtIndex:[Utility shared].rangeArray.count-1];
            NSRange range = [match rangeAtIndex:0];
            NSString *str = [NSString stringWithFormat:@"%d_%d",range.location+range.length,temp_arrBB.count-temp_arrAA.count];//从起点x开始之前少x个单词
            [[Utility shared].spaceLineArray addObject:str];
        }
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]init];
        if ([Utility shared].greenArray.count>0) {
            [mutableDic setObject:[Utility shared].greenArray forKey:@"green"];
        }
        if ([Utility shared].yellowArray.count>0) {
            [mutableDic setObject:[Utility shared].yellowArray forKey:@"yellow"];
            [mutableDic setObject:[Utility shared].sureArray forKey:@"sure"];
        }
        if ([Utility shared].spaceLineArray.count>0) {
            [mutableDic setObject:[Utility shared].spaceLineArray forKey:@"space"];
        }
        if ([Utility shared].noticeArray.count>0) {
            [mutableDic setObject:[Utility shared].noticeArray forKey:@"notice"];
            [mutableDic setObject:[Utility shared].correctArray forKey:@"correct"];
        }
        if ([Utility shared].wrongArray.count>0) {
            [mutableDic setObject:[Utility shared].wrongArray forKey:@"wrong"];
        }
        [Utility shared].noticeArray = nil;
        [Utility shared].correctArray = nil;
        [Utility shared].greenArray = nil;
        [Utility shared].yellowArray = nil;
        [Utility shared].sureArray = nil;
        [Utility shared].spaceLineArray = nil;
        [Utility shared].wrongArray = nil;
        return mutableDic;
    }
    return nil;
}

//TODO:请求当天题目
+ (NSString *)getTodayNewestQuestionPackage{
    __block NSString *returnMsg;
    NSString *str = [NSString stringWithFormat:@"http://58.240.210.42:3004/api/students/get_newer_task?student_id=%@&school_class_id=%@",[DataService sharedService].user.studentId,[DataService sharedService].theClass.classId];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [Utility requestDataWithRequest:request withSuccess:^(NSDictionary *dicData) {
        NSNumber *cards_count = [dicData objectForKey:@"knowledges_cards_count"];
        if (cards_count.integerValue > 20) {
            returnMsg = @"先清卡包";
            return;
        }
        NSArray *taskArray = [dicData objectForKey:@"tasks"];
        if (taskArray.count < 1) {
            returnMsg = @"暂未发布今日作业";
            return;
        }
        NSDictionary *packageDic = [taskArray firstObject];
        TaskObj *taskObj = [TaskObj taskFromDictionary:packageDic];
        [DataService sharedService].taskObj = taskObj;
        returnMsg = @"读取成功";
        
    } withFailure:^(NSError *error) {
        returnMsg = [error.userInfo objectForKey:@"msg"];
    }];
    return returnMsg;
}

//下载questionJSON.js ,用户选择"下载"之后调用
+ (NSDictionary *)downloadQuestionJSON{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[DataService sharedService].taskObj.taskStartDate];
    if (![manager fileExistsAtPath:path]) {
        NSError *error;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"questionJSON.js"]];
    NSError *error;
    NSData *questionData;
    if ([manager fileExistsAtPath:path]) {
        questionData = [NSData dataWithContentsOfFile:path];
    }else{
        questionData =  [NSData dataWithContentsOfURL:[NSURL URLWithString:[DataService sharedService].taskObj.taskFileDownloadURL]];
        [questionData writeToFile:path atomically:YES]; //保存文件,并返回JSON 字典
    }
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:questionData options:NSJSONReadingAllowFragments error:&error];
    return jsonDic;
}

//下载当天的answerJSON.js
+ (NSDictionary *)downloadAnswerJSON{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[DataService sharedService].taskObj.taskStartDate];
    if (![manager fileExistsAtPath:path]) {
        NSError *error;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"answerJSON.js"]];
    NSError *error;
    NSData *answerData;
    if ([manager fileExistsAtPath:path]) {
        answerData = [NSData dataWithContentsOfFile:path];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:answerData options:NSJSONReadingAllowFragments error:&error];
        NSMutableArray *localFinishedChallenges = [NSMutableArray array];
        {
            NSDictionary *dic = [jsonDic objectForKey:@"listening"];
            NSString *status = [dic objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                [localFinishedChallenges addObject:@"0"];
            }
        }
        {
            NSDictionary *dic = [jsonDic objectForKey:@"reading"];
            NSString *status = [dic objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                [localFinishedChallenges addObject:@"1"];
            }
        }
        {
            NSDictionary *dic = [jsonDic objectForKey:@"time_limit"];
            NSString *status = [dic objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                [localFinishedChallenges addObject:@"2"];
            }
        }
        {
            NSDictionary *dic = [jsonDic objectForKey:@"selecting"];
            NSString *status = [dic objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                [localFinishedChallenges addObject:@"3"];
            }
        }
        {
            NSDictionary *dic = [jsonDic objectForKey:@"lining"];
            NSString *status = [dic objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                [localFinishedChallenges addObject:@"4"];
            }
        }
        {
            NSDictionary *dic = [jsonDic objectForKey:@"cloze"];
            NSString *status = [dic objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                [localFinishedChallenges addObject:@"5"];
            }
        }
        {
            NSDictionary *dic = [jsonDic objectForKey:@"sort"];
            NSString *status = [dic objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                [localFinishedChallenges addObject:@"6"];
            }
        }
        for(NSNumber *number in [DataService sharedService].taskObj.finish_types){
            //如果服务器上有本地未完成的答案
            if(![localFinishedChallenges containsObject:[NSString stringWithFormat:@"%d",number.integerValue]]){
                answerData =  [NSData dataWithContentsOfURL:[NSURL URLWithString:[DataService sharedService].taskObj.taskAnswerFileDownloadURL]];
                [answerData writeToFile:path atomically:YES]; //保存文件,并返回JSON 字典
                break;
            };
        }
    }else{
        answerData =  [NSData dataWithContentsOfURL:[NSURL URLWithString:[DataService sharedService].taskObj.taskAnswerFileDownloadURL]];
        [answerData writeToFile:path atomically:YES]; //保存文件,并返回JSON 字典
    }
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:answerData options:NSJSONReadingAllowFragments error:&error];
    return jsonDic;
}


//添加不用备份的属性5.0.1
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    if (platform>=5.1) {//5.1的阻止备份
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            
        }
        return success;
    }else if (platform>5.0 && platform<5.1){//5.0.1的阻止备份
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    return YES;
}
//TODO:返回题目
+(NSMutableDictionary *)returnAnswerDictionaryWithName:(NSString *)name  andDate:(NSString *)timeString{
    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSString *path;
    if (platform>5.0) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
    NSString *documentDirectory = [path stringByAppendingPathComponent:timeString];
    NSString *jsPath=[documentDirectory stringByAppendingPathComponent:@"answer.json"];
    if ([fileManage fileExistsAtPath:jsPath]) {
        NSError *error = nil;
        Class JSONSerialization = [Utility JSONParserClass];
        NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsPath] options:0 error:&error];
        
        NSMutableDictionary *answerDic = [NSMutableDictionary dictionaryWithDictionary:dataObject];
        if (![[answerDic objectForKey:name]isKindOfClass:[NSNull class]] && [answerDic objectForKey:name]!=nil) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[answerDic objectForKey:name]];
            return dic;
        }else {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[NSString stringWithFormat:@"%d",-1] forKey:@"status"];
            NSString *time = [Utility getNowDateFromatAnDate];
            [dic setObject:time forKey:@"update_time"];
            [dic setObject:[NSString stringWithFormat:@"%d",-1] forKey:@"questions_item"];
            [dic setObject:[NSString stringWithFormat:@"%d",-1] forKey:@"branch_item"];
            [dic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"use_time"];
            [dic setObject:[NSMutableArray array] forKey:@"questions"];
            
            return dic;
        }
    }else {
        [Utility addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:jsPath]];
        [fileManage createFileAtPath:jsPath contents:nil attributes:nil];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[NSString stringWithFormat:@"%d",-1] forKey:@"status"];
        NSString *time = [Utility getNowDateFromatAnDate];
        [dic setObject:time forKey:@"update_time"];
        [dic setObject:[NSString stringWithFormat:@"%d",-1] forKey:@"questions_item"];
        [dic setObject:[NSString stringWithFormat:@"%d",-1] forKey:@"branch_item"];
        [dic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"use_time"];
        [dic setObject:[NSMutableArray array] forKey:@"questions"];
        
        return dic;
    }
}
//TODO:保存题目
+(void)returnAnswerPathWithDictionary:(NSDictionary *)aDic andName:(NSString *)name andDate:(NSString *)timeString{
    NSString *path;
    if (platform>5.0) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *documentDirectory = [path stringByAppendingPathComponent:timeString];
    NSString *jsPath=[documentDirectory stringByAppendingPathComponent:@"answer.json"];

    NSError *error = nil;
    Class JSONSerialization = [Utility JSONParserClass];
    NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsPath] options:0 error:&error];
    NSMutableDictionary *answerDic = [NSMutableDictionary dictionaryWithDictionary:dataObject];

//    [answerDic setObject:[DataService sharedService].taskObj.taskId forKey:@"pub_id"];
    [answerDic setObject:aDic forKey:name];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:answerDic options:NSJSONWritingPrettyPrinted error:&error];
    [jsonData writeToFile:jsPath atomically:YES];

}
//TODO:返回道具
+(NSMutableArray *)returnAnswerPropsandDate:(NSString *)timeString{
    NSFileManager *fileManage =[NSFileManager defaultManager];
    NSString *path;
    if (platform>5.0) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *documentDirectory = [path stringByAppendingPathComponent:timeString];
    NSString *jsPath=[documentDirectory stringByAppendingPathComponent:@"answer.json"];
    if ([fileManage fileExistsAtPath:jsPath]) {
        NSError *error = nil;
        Class JSONSerialization = [Utility JSONParserClass];
        NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsPath] options:0 error:&error];
        
        NSMutableDictionary *answerDic = [NSMutableDictionary dictionaryWithDictionary:dataObject];
        if (![[answerDic objectForKey:@"props"]isKindOfClass:[NSNull class]] && [answerDic objectForKey:@"props"]!=nil) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[answerDic objectForKey:@"props"]];
            return array;
        }else {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (int i=0; i<2; i++) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"types",[NSMutableArray array],@"branch_id", nil];
                [array addObject:dic];
            }
            return array;
        }
    }else {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i=0; i<2; i++) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"types",[NSMutableArray array],@"branch_id", nil];
            [array addObject:dic];
        }
        return array;
    }
}
//TODO:保存道具
+(void)returnAnswerPathWithProps:(NSMutableArray *)array andDate:(NSString *)timeString{
    NSString *path;
    if (platform>5.0) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *documentDirectory = [path stringByAppendingPathComponent:timeString];
    NSString *jsPath=[documentDirectory stringByAppendingPathComponent:@"answer.json"];
    
    NSError *error = nil;
    Class JSONSerialization = [Utility JSONParserClass];
    NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsPath] options:0 error:&error];
    NSMutableDictionary *answerDic = [NSMutableDictionary dictionaryWithDictionary:dataObject];
    
//    [answerDic setObject:[DataService sharedService].taskObj.taskId forKey:@"pub_id"];
    [answerDic setObject:array forKey:@"props"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:answerDic options:NSJSONWritingPrettyPrinted error:&error];
    [jsonData writeToFile:jsPath atomically:YES];
}
//比较时间
+(BOOL)compareTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *endDate = [dateFormatter dateFromString:[DataService sharedService].taskObj.taskEndDate];
    
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:nowDate toDate:endDate options:0];
    int hour =[d hour];

    if (hour>=2) {
        return YES;
    }else
        return NO;
}
+ (NSString *)isExistenceNetwork {
    NSString *str = nil;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			str = @"NotReachable";
            break;
        case ReachableViaWWAN:
			str = @"ReachableViaWWAN";
            break;
        case ReachableViaWiFi:
			str = @"ReachableViaWiFi";
            break;
    }
    return str;
}


@end
