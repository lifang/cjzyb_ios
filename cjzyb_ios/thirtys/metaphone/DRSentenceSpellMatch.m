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
+(void)checkSentence:(NSString*)sentence withSpellMatchSentence:(NSString*)spellSentence andSpellMatchAttributeString:(void(^)(NSAttributedString *spellAttriString,float matchScore))success orSpellMatchFailure:(void(^)(NSError *error))failure{
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
        success(attri,1);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [Utility shared].isOrg = NO;
        [Utility shared].orgArray  = [Utility handleTheString:senStr];
        [Utility shared].metaphoneArray = [Utility metaphoneArray:[Utility shared].orgArray];
        NSArray *spellMatchRangeArr = [DRSentenceSpellMatch spellMatchWord:spellStr];
        NSMutableAttributedString *spellAttribute = [[NSMutableAttributedString alloc] initWithString:senStr];
        [spellAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, spellAttribute.length)];
        [spellAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, spellAttribute.length)];
        int unMatch = 0;
        for (SpellMatchObj *obj in spellMatchRangeArr) {
            if (obj.spellLevel == 1 || obj.spellLevel == 0.5) {
                [spellAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:obj.range];
            }else{
                unMatch++;
            }
        }
        float score = 1;
        if (unMatch != 0) {
            score = spellMatchRangeArr.count/(float)unMatch;
        }
        if (score > 0.5) {
            [spellAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, spellAttribute.length)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success(spellAttribute,score);
        });
    });

}


+(NSArray*)spellMatchWord:(NSString*)spellString{
    NSMutableArray *spellsArr = [NSMutableArray array];

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
    NSDictionary *dic = [Utility compareWithArray:array andArray:array2 WithArray:[Utility shared].orgArray andArray:[Utility shared].metaphoneArray WithRange:[Utility shared].rangeArray];
    //绿色
    if (![[dic objectForKey:@"green"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"green"]!=nil) {
        NSMutableArray *green_array = [dic objectForKey:@"green"];
        for (int i=0; i<green_array.count; i++) {
            SpellMatchObj *spell = [[SpellMatchObj alloc] init];
            NSTextCheckingResult *math = (NSTextCheckingResult *)[green_array objectAtIndex:i];
            NSRange range = [math rangeAtIndex:0];
            spell.range = range;
            spell.color = [UIColor greenColor];
            spell.isUnderLine = NO;
            spell.spellLevel = 1;
            if (![[dic objectForKey:@"notice"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"notice"]!=nil) {
                NSMutableArray *notice_array = [dic objectForKey:@"notice"];
                for (int k=0; k<notice_array.count; k++) {
                    NSTextCheckingResult *math2 = (NSTextCheckingResult *)[notice_array objectAtIndex:k];
                    NSRange range2 = [math2 rangeAtIndex:0];
                    if (range.location==range2.location && range.length==range2.length) {
                        NSMutableArray *correct_array = [dic objectForKey:@"correct"];
                        spell.originText = [correct_array objectAtIndex:k];
                        break;
                    }
                }
            }
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
            spell.isUnderLine = NO;
            spell.spellLevel = 0.5;
            NSMutableArray *correct_array = [dic objectForKey:@"sure"];
            spell.originText = [correct_array objectAtIndex:i];
            [spellsArr addObject:spell];
        }
    }
    //下划线
    if (![[dic objectForKey:@"space"]isKindOfClass:[NSNull class]] && [dic objectForKey:@"space"]!=nil) {
        NSMutableArray *space_array = [dic objectForKey:@"space"];
        for (int i=0; i<space_array.count; i++) {
            NSString *str = [space_array objectAtIndex:i];
            NSArray *arr = [str componentsSeparatedByString:@"_"];
            int location = [[arr objectAtIndex:0]intValue];
            int length = [[arr objectAtIndex:1]intValue];
            
            SpellMatchObj *spell = [[SpellMatchObj alloc] init];
            NSRange range =NSMakeRange(location, length);
            spell.range = range;
            spell.isUnderLine = YES;
            spell.spellLevel = 0;
            BOOL isInsert = NO;
            for ( int index = 0;index < spellsArr.count;index++) {
                SpellMatchObj *obj = [spellsArr objectAtIndex:index];
                if (obj.range.location == spell.range.location) {
                    isInsert = YES;
                    [spellsArr insertObject:spell atIndex:index];
                    break;
                }
            }
            if (!isInsert) {
                [spellsArr addObject:spell];
            }
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
