//
//  DRSentenceSpellMatch.m
//  cjzyb_ios
//
//  Created by david on 14-3-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRSentenceSpellMatch.h"
#import "SpellMatchObj.h"

@implementation DRSentenceSpellMatch
+(void)checkSentence:(NSString*)sentence withSpellMatchSentence:(NSString*)spellSentence andSpellMatchAttributeString:(void(^)(NSAttributedString *spellAttriString,float matchScore,NSArray *errorWordArray))success orSpellMatchFailure:(void(^)(NSError *error))failure{
    if (!sentence || !spellSentence) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:10010 userInfo:@{@"msg": @"要匹配对象不存在"}]);
        }
        return;
    }
    
    NSString *senStr = [sentence stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *spellStr = [spellSentence stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([senStr isEqualToString:@""] || [spellStr isEqualToString:@""]) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:10010 userInfo:@{@"msg": @"要匹配对象不存在"}]);
        }
        return;
    }
    
    if (!success) {
        return;
    }
    
    if ([senStr isEqualToString:spellStr]) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:senStr];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, attri.length)];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, attri.length)];
        success(attri,1,nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [Utility shared].isOrg = NO;
        [Utility shared].sureArray = [[NSMutableArray alloc]init];
         [Utility shared].correctArray = [[NSMutableArray alloc]init];
        [Utility shared].noticeArray = [[NSMutableArray alloc]init];
         [Utility shared].greenArray = [[NSMutableArray alloc]init];
        [Utility shared].yellowArray = [[NSMutableArray alloc]init];
        [Utility shared].spaceLineArray = [[NSMutableArray alloc]init];
        [Utility shared].wrongArray = [[NSMutableArray alloc]init];
        [Utility shared].firstpoint = 0;
        
        [Utility shared].orgArray  = [Utility handleTheString:senStr];
        [Utility shared].metaphoneArray = [Utility metaphoneArray:[Utility shared].orgArray];
        NSArray *spellMatchRangeArr = [DRSentenceSpellMatch spellMatchWord:spellStr];
        NSMutableAttributedString *spellAttribute = [[NSMutableAttributedString alloc] initWithString:senStr];
        [spellAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, spellAttribute.length)];
        [spellAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, spellAttribute.length)];
        int unMatch = 0;
        NSMutableArray *errorWordArr = [NSMutableArray array];
        for (SpellMatchObj *obj in spellMatchRangeArr) {
            if (obj.range.location + obj.range.length > spellAttribute.length) {
                continue;
            }
            if (obj.spellLevel == 1 || obj.spellLevel == 0.5) {
                [spellAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:obj.range];
            }else{
                unMatch++;
                [errorWordArr addObject:[senStr substringWithRange:obj.range]];
                [spellAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:obj.range];
            }
        }
        float score = 1;
        if (unMatch != 0) {
            score = (spellMatchRangeArr.count - (float)unMatch)/(float)spellMatchRangeArr.count;
        }
        if (score >= 0.7) {
            [spellAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, spellAttribute.length)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success(spellAttribute,score,errorWordArr.count>0 ?errorWordArr:nil);
        });
    });

}


+(NSArray*)spellMatchWord:(NSString*)spellString{
    NSMutableArray *spellsArr = [NSMutableArray array];

    [Utility shared].isOrg = YES;
    NSString *text = spellString;
    text =   [text stringByReplacingOccurrencesOfString:@"[_]|[\n]+|[ ]{2,}" withString:@" " options:NSRegularExpressionSearch  range:NSMakeRange(0, text.length)];
    NSArray *array = [Utility handleTheString:text];
    NSArray *array2 = [Utility metaphoneArray:array];
    [Utility shared].sureArray = [[NSMutableArray alloc]init];
    [Utility shared].correctArray = [[NSMutableArray alloc]init];
    [Utility shared].noticeArray = [[NSMutableArray alloc]init];
    [Utility shared].greenArray = [[NSMutableArray alloc]init];
    [Utility shared].yellowArray = [[NSMutableArray alloc]init];
    [Utility shared].spaceLineArray = [[NSMutableArray alloc]init];
    [Utility shared].firstpoint = 0;
    NSDictionary *dic = [Utility compareWithArray:[Utility shared].orgArray andArray:[Utility shared].metaphoneArray WithArray:array andArray:array2  WithRange:[Utility shared].rangeArray];
    //绿色
    if (![[dic objectForKey:@"green"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"green"]!=nil) {
        NSMutableArray *green_array = [dic objectForKey:@"green"];
        for (int i=0; i<green_array.count; i++) {
            SpellMatchObj *spell = [[SpellMatchObj alloc] init];
            NSTextCheckingResult *math = (NSTextCheckingResult *)[green_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            spell.range = range;
            spell.color = [UIColor greenColor];
            spell.spellLevel = 1;
            [spellsArr addObject:spell];
        }
    }
    //黄色
    if (![[dic objectForKey:@"yellow"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"yellow"]!=nil) {
        NSMutableArray *yellow_array = [dic objectForKey:@"yellow"];
        for (int i=0; i<yellow_array.count; i++) {
            SpellMatchObj *spell = [[SpellMatchObj alloc] init];
            NSTextCheckingResult *math = (NSTextCheckingResult *)[yellow_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            spell.range = range;
            spell.color = [UIColor yellowColor];
            spell.spellLevel = 0.5;
            [spellsArr addObject:spell];
        }
    }
    //下划线
    if (![[dic objectForKey:@"wrong"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"wrong"]!=nil) {
        NSMutableArray *space_array = [dic objectForKey:@"wrong"];
        for (int i=0; i<space_array.count; i++) {
            NSTextCheckingResult *math = (NSTextCheckingResult *)[space_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            SpellMatchObj *spell = [[SpellMatchObj alloc] init];
            spell.range = range;
            spell.spellLevel = 0;
             [spellsArr addObject:spell];
        }
    }
    
    [spellsArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SpellMatchObj *s1 = obj1;
        SpellMatchObj *s2 = obj2;
        if (s1.range.location > s2.range.location) {
            return NSOrderedDescending;
        }else
            if (s1.range.location < s2.range.location) {
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
    }];
    NSLog(@"%@",spellsArr);
    return spellsArr;
}

@end
