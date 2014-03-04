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
    [alert show];
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
	Reachability *r = [Reachability reachabilityWithHostName:@"lms.finance365.com"];
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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonPath ofType:@"json"];
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

@end
