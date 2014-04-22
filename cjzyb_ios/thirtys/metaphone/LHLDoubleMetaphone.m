//
//  LHLDoubleMetaphone.m
//  testtabbar
//
//  Created by apple on 14-4-22.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "LHLDoubleMetaphone.h"

@implementation LHLDoubleMetaphone

const unsigned int max_length = 32;

+ (BOOL)judgeIsVowelWithString:(NSString *)string atIndex:(NSInteger)index{
    if (index < 0 || index >= string.length) {
        return NO;
    }
    unichar theChar = [string characterAtIndex:index];
    if ((theChar == 'A') || (theChar == 'E') || (theChar == 'I') || (theChar =='O') ||
        (theChar =='U')  || (theChar == 'Y')) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)slavoGermanic:(NSString *)string{
    if (!string) {
        return NO;
    }
    if ([string rangeOfString:@"W"].location > 0 || [string rangeOfString:@"K"].location > 0 || [string rangeOfString:@"CZ"].location > 0 || [string rangeOfString:@"WITZ"].location > 0) {
        return YES;
    }
    return NO;
}


//char GetAt(string &s, unsigned int pos)
//{
//    if ((pos < 0) || (pos >= s.length())) {
//        return '\0';
//    }
//    
//    return s[pos];
//}
//
//
//void SetAt(string &s, unsigned int pos, char c)
//{
//    if ((pos < 0) || (pos >= s.length())) {
//        return;
//    }
//    
//    s[pos] = c;
//}

+ (BOOL)compareString:(NSString *)string startAt:(NSInteger)start withLength:(NSInteger)length withCharacters:(NSArray *)charachters{
    if (start < 0 || start + length > string.length) {
        return NO;
    }
    
    for (NSString *str in charachters){
        if ([str isEqualToString:[string substringWithRange:NSMakeRange(start, length)]]) {
            return YES;
        }
    }
    
    return NO;
}


///返回两个音标字符串 , 第一个为主要,第二个为参考
+ (NSArray *)doubleMetaphone:(NSString *)str
{
    if (!str || str.length < 1) {
        return nil;
    }
    
    NSInteger length;
    NSMutableString *original;
    NSMutableString *primary;
    NSMutableString *secondary;
    NSInteger current;
    NSInteger last;
    NSMutableArray * codes = [NSMutableArray array]; //返回值
    
    current = 0;
    /* we need the real length and last prior to padding */
    length  = str.length;
    last    = length - 1;
    original = [NSMutableString stringWithString:str]; // make a copy
    /* Pad original so we can index beyond end */
    [original appendString:@"     "];
    
    primary = [NSMutableString stringWithString:@""];
    secondary = [NSMutableString stringWithString:@""];
    
//    MakeUpper(original);
    original = [NSMutableString stringWithString:[original uppercaseString]];
    
    /* skip these when at start of word */
    if ([LHLDoubleMetaphone compareString:original startAt:0 withLength:2 withCharacters:@[@"GN", @"KN", @"PN", @"WR", @"PS"]]) {
        current += 1;
    }
    
    /* Initial 'X' is pronounced 'Z' e.g. 'Xavier' */
    if ([original characterAtIndex:0] == 'X') {
        [primary appendString:@"S"];  /* 'Z' maps to 'S' */
        [secondary appendString:@"S"];
        current += 1;
    }
    
    /* main loop */
    while ((primary.length < max_length) || (secondary.length < max_length)) {
        if (current >= length) {
            break;
        }
        
        //TODO:attention here!
        switch ([original characterAtIndex:current]) {
            case 'A':
            case 'E':
            case 'I':
            case 'O':
            case 'U':
            case 'Y':
                if (current == 0) {
                    /* all init vowels now map to 'A' */
                    [primary appendString:@"A"];
                    [secondary appendString:@"A"];
                }
                current += 1;
                break;
                
            case 'B':
                /* "-mb", e.g", "dumb", already skipped over... */
                [primary appendString:@"P"];
                [secondary appendString:@"P"];
                
                if ([original characterAtIndex:current + 1] == 'B')
                    current += 2;
                else
                    current += 1;
                break;
                
//            case '«':
//                [primary appendString:@"S";
//                [secondary appendString:@"S";
//                current += 1;
//                break;
                
            case 'C':
                /* various germanic */
                if (((current > 1) &&
                    ![LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:current - 2] &&
                    [LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:3 withCharacters:@[@"ACH"]] &&
                    ([original characterAtIndex:current + 2] != 'I') &&
                    ([original characterAtIndex:current + 2] != 'E')) ||
                    [LHLDoubleMetaphone compareString:original startAt:current - 2 withLength:6 withCharacters:@[@"BACHER",@"MACHER"]]) {
                    [primary appendString:@"K"];
                    [secondary appendString:@"K"];
                         current += 2;
                         break;
                     }
                
                /* special case 'caesar' */
                if ((current == 0) && [LHLDoubleMetaphone compareString:original startAt:current withLength:6 withCharacters:@[@"CAESAR"]]) {
                    [primary appendString:@"S"];
                    [secondary appendString:@"S"];
                    current += 2;
                    break;
                }
                
                /* italian 'chianti' */
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:4 withCharacters:@[@"CHIA"]]) {
                    [primary appendString:@"K"];
                    [secondary appendString:@"K"];
                    current += 2;
                    break;
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"CH"]]) {
                    /* find 'michael' */
                    if ((current > 0) && [LHLDoubleMetaphone compareString:original startAt:current withLength:4 withCharacters:@[@"CHAE"]]) {
                        [primary appendString:@"K"];
                        [secondary appendString:@"X"];
                        current += 2;
                        break;
                    }
                    
                    /* greek roots e.g. 'chemistry', 'chorus' */
                    if ((current == 0) &&
                        ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:5 withCharacters:@[@"HARAC", @"HARIS"]] ||
                         [LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:3 withCharacters:@[@"HOR", @"HYM", @"HIA", @"HEM"]]) &&
                        ![LHLDoubleMetaphone compareString:original startAt:0 withLength:5 withCharacters:@[@"CHORE"]]) {
                        [primary appendString:@"K"];
                        [secondary appendString:@"K"];
                        current += 2;
                        break;
                    }
                    
                    /* germanic, greek, or otherwise 'ch' for 'kh' sound */
                    if (([LHLDoubleMetaphone compareString:original startAt:0 withLength:4 withCharacters:@[@"VAN ", @"VON "]] ||
                        [LHLDoubleMetaphone compareString:original startAt:0 withLength:3 withCharacters:@[@"SCH"]]) ||
                        /*  'architect but not 'arch', 'orchestra', 'orchid' */
                        [LHLDoubleMetaphone compareString:original startAt:current - 2 withLength:6 withCharacters:@[@"ORCHES", @"ARCHIT", @"ORCHID"]] ||
                        [LHLDoubleMetaphone compareString:original startAt:current + 2 withLength:1 withCharacters:@[@"T",@"S"]] ||
                        (([LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:1 withCharacters:@[@"A",@"O",@"U",@"E"]] ||
                          (current == 0)) &&
                         /* e.g., 'wachtler', 'wechsler', but not 'tichner' */
                         [LHLDoubleMetaphone compareString:original startAt:current + 2 withLength:1 withCharacters:@[@"L", @"R",@"N", @"M", @"B", @"H", @"F", @"V", @"W"]])) {
                            [primary appendString:@"K"];
                            [secondary appendString:@"K"];
                         } else {
                             if (current > 0) {
                                 if ([LHLDoubleMetaphone compareString:original startAt:0 withLength:2 withCharacters:@[@"MC"]]) {
                                     /* e.g., "McHugh" */
                                     [primary appendString:@"K"];
                                     [secondary appendString:@"K"];
                                 } else {
                                     [primary appendString:@"X"];
                                     [secondary appendString:@"K"];
                                 }
                             } else {
                                 [primary appendString:@"X"];
                                 [secondary appendString:@"X"];
                             }
                         }
                    current += 2;
                    break;
                }
                /* e.g, 'czerny' */
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"CZ"]] &&
                    ![LHLDoubleMetaphone compareString:original startAt:current - 2 withLength:4 withCharacters:@[@"WICZ"]]) {
                    [primary appendString:@"S"];
                    [secondary appendString:@"X"];
                    current += 2;
                    break;
                }
                
                /* e.g., 'focaccia' */
                if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:3 withCharacters:@[@"CIA"]]) {
                    [primary appendString:@"X"];
                    [secondary appendString:@"X"];
                    current += 3;
                    break;
                }
                
                /* double 'C', but not if e.g. 'McClellan' */
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"CC"]] &&
                    !((current == 1) && ([original characterAtIndex:0] == 'M'))) {
                    /* 'bellocchio' but not 'bacchus' */
                    if ([LHLDoubleMetaphone compareString:original startAt:current + 2 withLength:1 withCharacters:@[@"I",@"E",@"H"]] &&
                        ![LHLDoubleMetaphone compareString:original startAt:current + 2 withLength:2 withCharacters:@[@"HU"]]) {
                        /* 'accident', 'accede' 'succeed' */
                        if (((current == 1) && ([original characterAtIndex:current - 1] == 'A')) ||
                            [LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:5 withCharacters:@[@"UCCEE",@"UCCES"]]) {
                            [primary appendString:@"KS"];
                            [secondary appendString:@"KS"];
                            /* 'bacci', 'bertucci', other italian */
                        } else {
                            [primary appendString:@"X"];
                            [secondary appendString:@"X"];
                        }
                        current += 3;
                        break;
                    } else {  /* Pierce's rule */
                        [primary appendString:@"K"];
                        [secondary appendString:@"K"];
                        current += 2;
                        break;
                    }
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"CK",@"CG",@"CQ"]]) {
                    [primary appendString:@"K"];
                    [secondary appendString:@"K"];
                    current += 2;
                    break;
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"CI",@"CE",@"CY"]]) {
                    /* italian vs. english */
                    if ([LHLDoubleMetaphone compareString:original startAt:current withLength:3 withCharacters:@[@"CIO", @"CIE", @"CIA"]]) {
                        [primary appendString:@"S"];
                        [secondary appendString:@"X"];
                    } else {
                        [primary appendString:@"S"];
                        [secondary appendString:@"S"];
                    }
                    current += 2;
                    break;
                }
                
                /* else */
                [primary appendString:@"K"];
                [secondary appendString:@"K"];
                
                /* name sent in 'mac caffrey', 'mac gregor */
                if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:2 withCharacters:@[@" C", @" Q", @" G"]])
                    current += 3;
                else
                    if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"C",@"Q",@"K"]] &&
                        ![LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:2 withCharacters:@[@"CE",@"CI"]])
                        current += 2;
                    else
                        current += 1;
                break;
                
            case 'D':
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"DG"]]) {
                    if ([LHLDoubleMetaphone compareString:original startAt:current + 2 withLength:1 withCharacters:@[@"I",@"E",@"Y"]]) {
                        /* e.g. 'edge' */
                        [primary appendString:@"J"];
                        [secondary appendString:@"J"];
                        current += 3;
                        break;
                    } else {
                        /* e.g. 'edgar' */
                        [primary appendString:@"TK"];
                        [secondary appendString:@"TK"];
                        current += 2;
                        break;
                    }
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"DT",@"DD"]]) {
                    [primary appendString:@"T"];
                    [secondary appendString:@"T"];
                    current += 2;
                    break;
                }
                
                /* else */
                [primary appendString:@"T"];
                [secondary appendString:@"T"];
                current += 1;
                break;
                
            case 'F':
                if ([original characterAtIndex:current + 1] == 'F')
                    current += 2;
                else
                    current += 1;
                [primary appendString:@"F"];
                [secondary appendString:@"F"];
                break;
                
            case 'G':
                if ([original characterAtIndex:current + 1] == 'H') {
                    if ((current > 0) && ![LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:current - 1]) {
                        [primary appendString:@"K"];
                        [secondary appendString:@"K"];
                        current += 2;
                        break;
                    }
                    
                    if (current < 3) {
                        /* 'ghislane', ghiradelli */
                        if (current == 0) {
                            if ([original characterAtIndex:current + 2] == 'I') {
                                [primary appendString:@"J"];
                                [secondary appendString:@"J"];
                            } else {
                                [primary appendString:@"K"];
                                [secondary appendString:@"K"];
                            }
                            current += 2;
                            break;
                        }
                    }
                    /* Parker's rule (with some further refinements) - e.g., 'hugh' */
                    if (((current > 1) &&
                         [LHLDoubleMetaphone compareString:original startAt:current - 2 withLength:1 withCharacters:@[@"B", @"H", @"D"]]) ||
                        /* e.g., 'bough' */
                        ((current > 2) &&
                         [LHLDoubleMetaphone compareString:original startAt:current - 3 withLength:1 withCharacters:@[@"B", @"H", @"D"]]) ||
                        /* e.g., 'broughton' */
                        ((current > 3) &&
                         [LHLDoubleMetaphone compareString:original startAt:current - 4 withLength:1 withCharacters:@[@"B", @"H"]])) {
                            current += 2;
                            break;
                        } else {
                            /* e.g., 'laugh', 'McLaughlin', 'cough', 'gough', 'rough', 'tough' */
                            if ((current > 2) &&
                                ([original characterAtIndex:current - 1] == 'U') &&
                                [LHLDoubleMetaphone compareString:original startAt:current - 3 withLength:1 withCharacters:@[@"C",@"G",@"L",@"R",@"T"]]) {
                                [primary appendString:@"F"];
                                [secondary appendString:@"F"];
                                } else if ((current > 0) &&
                                           [original characterAtIndex:current - 1] != 'I') {
                                    [primary appendString:@"K"];
                                    [secondary appendString:@"K"];
                                }
                            
                            current += 2;
                            break;
                        }
                }
                
                if ([original characterAtIndex:current + 1] == 'N') {
                    if ((current == 1) &&
                        [LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:0] &&
                        ![LHLDoubleMetaphone slavoGermanic:original]) {
                        [primary appendString:@"KN"];
                        [secondary appendString:@"N"];
                    } else
                    /* not e.g. 'cagney' */
                        if (![LHLDoubleMetaphone compareString:original startAt:current + 2 withLength:2 withCharacters:@[@"EY"]] &&
                            ([original characterAtIndex:current + 1] != 'Y') &&
                            ![LHLDoubleMetaphone slavoGermanic:original]) {
                            [primary appendString:@"N"];
                            [secondary appendString:@"KN"];
                        } else {
                            [primary appendString:@"KN"];
                            [secondary appendString:@"KN"];
                        }
                    current += 2;
                    break;
                }
                
                /* 'tagliaro' */
                if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:2 withCharacters:@[@"LI"]] &&
                    ![LHLDoubleMetaphone slavoGermanic:original]) {
                    [primary appendString:@"KL"];
                    [secondary appendString:@"L"];
                    current += 2;
                    break;
                }
                
                /* -ges-,-gep-,-gel-, -gie- at beginning */
                if ((current == 0) &&
                    (([original characterAtIndex:current + 1] == 'Y') ||
                     [LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:2 withCharacters:@[@"ES", @"EP",@"EB", @"EL", @"EY", @"IB", @"IL",@"EI", @"ER"]])) {
                        [primary appendString:@"K"];
                        [secondary appendString:@"J"];
                         current += 2;
                         break;
                     }
                
                /*  -ger-,  -gy- */
                if (([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:2 withCharacters:@[@"ER"]] ||
                     ([original characterAtIndex:current + 1] == 'Y')) &&
                    ![LHLDoubleMetaphone compareString:original startAt:0 withLength:6 withCharacters:@[@"DANGER", @"RANGER", @"MANGER"]] &&
                    ![LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:1 withCharacters:@[@"E",@"I"]] &&
                    ![LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:3 withCharacters:@[@"RGY", @"OGY"]]) {
                    [primary appendString:@"K"];
                    [secondary appendString:@"J"];
                    current += 2;
                    break;
                }
                
                /*  italian e.g, 'biaggi' */
                if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"E",@"I",@"Y"]] ||
                    [LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:4 withCharacters:@[@"AGGI", @"OGGI"]]) {
                    /* obvious germanic */
                    if (([LHLDoubleMetaphone compareString:original startAt:0 withLength:4 withCharacters:@[@"VAN",@"VON"]] ||
                         [LHLDoubleMetaphone compareString:original startAt:0 withLength:3 withCharacters:@[@"SCH"]]) ||
                        [LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:2 withCharacters:@[@"ET"]])
                    {
                        [primary appendString:@"K"];
                        [secondary appendString:@"K"];
                    } else {
                        /* always soft if french ending */
                        if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:4 withCharacters:@[@"IER"]]) {
                            [primary appendString:@"J"];
                            [secondary appendString:@"J"];
                        } else {
                            [primary appendString:@"J"];
                            [secondary appendString:@"K"];
                        }
                    }
                    current += 2;
                    break;
                }
                
                if ([original characterAtIndex:current + 1] == 'G')
                    current += 2;
                else
                    current += 1;
                [primary appendString:@"K"];
                [secondary appendString:@"K"];
                break;
                
            case 'H':
                /* only keep if first & before vowel or btw. 2 vowels */
                if (((current == 0) ||
                     [LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:current - 1]) &&
                    [LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:current + 1]) {
                    [primary appendString:@"H"];
                    [secondary appendString:@"H"];
                    current += 2;
                }
                else		/* also takes care of 'HH' */
                    current += 1;
                break;
                
            case 'J':
                /* obvious spanish, 'jose', 'san jacinto' */
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:4 withCharacters:@[@"JOSE"]] ||
                    [LHLDoubleMetaphone compareString:original startAt:0 withLength:4 withCharacters:@[@"SAN "]]) {
                    if (((current == 0) && ([original characterAtIndex:current + 4] == ' ')) ||
                        [LHLDoubleMetaphone compareString:original startAt:0 withLength:4 withCharacters:@[@"SAN "]]) {
                        [primary appendString:@"H"];
                        [secondary appendString:@"H"];
                    } else {
                        [primary appendString:@"J"];
                        [secondary appendString:@"H"];
                    }
                    current += 1;
                    break;
                }
                
                if ((current == 0) && ![LHLDoubleMetaphone compareString:original startAt:current withLength:4 withCharacters:@[@"JOSE"]]) {
                    [primary appendString:@"J"];	/* Yankelovich/Jankelowicz */
                    [secondary appendString:@"A"];
                } else {
                    /* spanish pron. of e.g. 'bajador' */
                    if ([LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:current - 1] &&
                        ![LHLDoubleMetaphone slavoGermanic:original] &&
                        (([original characterAtIndex:current + 1] == 'A') ||
                         ([original characterAtIndex:current + 1] == 'O'))) {
                            [primary appendString:@"J"];
                            [secondary appendString:@"H"];
                        } else {
                            if (current == last) {
                                [primary appendString:@"J"];
                                [secondary appendString:@""];
                            } else {
                                if (![LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"L", @"T", @"K", @"S", @"N", @"M", @"B", @"Z"]] &&
                                    ![LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:1 withCharacters:@[@"S",@"K",@"L"]]) {
                                    [primary appendString:@"J"];
                                    [secondary appendString:@"J"];
                                }
                            }
                        }
                }
                
                if ([original characterAtIndex:current + 1] == 'J')	/* it could happen! */
                    current += 2;
                else
                    current += 1;
                break;
                
            case 'K':
                if ([original characterAtIndex:current + 1] == 'K')
                    current += 2;
                else
                    current += 1;
                [primary appendString:@"K"];
                [secondary appendString:@"K"];
                break;
                
            case 'L':
                if ([original characterAtIndex:current + 1] == 'L') {
                    /* spanish e.g. 'cabrillo', 'gallegos' */
                    if (((current == (length - 3)) &&
                         [LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:4 withCharacters:@[@"ILLO", @"ILLA", @"ALLE"]]) ||
                        (([LHLDoubleMetaphone compareString:original startAt:last - 1 withLength:2 withCharacters:@[@"AS",@"OS"]] ||
                          [LHLDoubleMetaphone compareString:original startAt:last withLength:1 withCharacters:@[@"A",@"O"]]) &&
                         [LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:4 withCharacters:@[@"ALLE"]])) {
                            [primary appendString:@"L"];
                            [secondary appendString:@""];
                            current += 2;
                            break;
                        }
                    current += 2;
                }
                else
                    current += 1;
                [primary appendString:@"L"];
                [secondary appendString:@"L"];
                break;
                
            case 'M':
                if (([LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:3 withCharacters:@[@"UMB"]] &&
                     (((current + 1) == last) ||
                      [LHLDoubleMetaphone compareString:original startAt:current + 2 withLength:2 withCharacters:@[@"ER"]])) ||
                    /* 'dumb','thumb' */
                    ([original characterAtIndex:current + 1] == 'M')) {
                    current += 2;
                } else {
                    current += 1;
                }
                [primary appendString:@"M"];
                [secondary appendString:@"M"];
                break;
                
            case 'N':
                if ([original characterAtIndex:current + 1] == 'N') {
                    current += 2;
                } else {
                    current += 1;
                }
                [primary appendString:@"N"];
                [secondary appendString:@"N"];
                break;
                
//            case '—':
//                current += 1;
//                [primary appendString:@"N";
//                [secondary appendString:@"N";
//                break;
                
            case 'P':
                if ([original characterAtIndex:current + 1] == 'H') {
                    [primary appendString:@"F"];
                    [secondary appendString:@"F"];
                    current += 2;
                    break;
                }
                
                /* also account for "campbell", "raspberry" */
                if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"P",@"B"]])
                    current += 2;
                else
                    current += 1;
                [primary appendString:@"P"];
                [secondary appendString:@"P"];
                break;
                
            case 'Q':
                if ([original characterAtIndex:current + 1] == 'Q')
                    current += 2;
                else
                    current += 1;
                [primary appendString:@"K"];
                [secondary appendString:@"K"];
                break;
                
            case 'R':
                /* french e.g. 'rogier', but exclude 'hochmeier' */
                if ((current == last) &&
                    ![LHLDoubleMetaphone slavoGermanic:original] &&
                    [LHLDoubleMetaphone compareString:original startAt:current -2 withLength:2 withCharacters:@[@"IE"]] &&
                    ![LHLDoubleMetaphone compareString:original startAt:current -4 withLength:2 withCharacters:@[@"ME",@"MA"]]) {
                    [primary appendString:@""];
                    [secondary appendString:@"R"];
                } else {
                    [primary appendString:@"R"];
                    [secondary appendString:@"R"];
                }
                
                if ([original characterAtIndex:current + 1] == 'R')
                    current += 2;
                else
                    current += 1;
                break;
                
            case 'S':
                /* special cases 'island', 'isle', 'carlisle', 'carlysle' */
                if ([LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:3 withCharacters:@[@"ISL",@"YSL"]]) {
                    current += 1;
                    break;
                }
                
                /* special case 'sugar-' */
                if ((current == 0) && [LHLDoubleMetaphone compareString:original startAt:current withLength:5 withCharacters:@[@"SUGAR"]]) {
                    [primary appendString:@"X"];
                    [secondary appendString:@"S"];
                    current += 1;
                    break;
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"SH"]]) {
                    /* germanic */
                    if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:4 withCharacters:@[@"HEIM", @"HOEK", @"HOLM", @"HOLZ"]]) {
                        [primary appendString:@"S"];
                        [secondary appendString:@"S"];
                    } else {
                        [primary appendString:@"X"];
                        [secondary appendString:@"X"];
                    }
                    current += 2;
                    break;
                }
                
                /* italian & armenian */
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:3 withCharacters:@[@"SIO",@"SIA"]] ||
                    [LHLDoubleMetaphone compareString:original startAt:current withLength:4 withCharacters:@[@"SIAN"]]) {
                    if (![LHLDoubleMetaphone slavoGermanic:original]) {
                        [primary appendString:@"S"];
                        [secondary appendString:@"X"];
                    } else {
                        [primary appendString:@"S"];
                        [secondary appendString:@"S"];
                    }
                    current += 3;
                    break;
                }
                
                /* german & anglicisations, e.g. 'smith' match 'schmidt', 'snider' match 'schneider'
                 also, -sz- in slavic language altho in hungarian it is pronounced 's' */
                if (((current == 0) &&
                     [LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"M",@"N",@"W",@"L"]]) ||
                    [LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"Z"]]) {
                    [primary appendString:@"S"];
                    [secondary appendString:@"X"];
                    if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"Z"]])
                        current += 2;
                    else
                        current += 1;
                    break;
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"SC"]]) {
                    /* Schlesinger's rule */
                    if ([original characterAtIndex:current + 2] == 'H') {
                        /* dutch origin, e.g. 'school', 'schooner' */
                        if ([LHLDoubleMetaphone compareString:original startAt:current + 3 withLength:2 withCharacters:@[@"OO", @"ER", @"EN", @"UY", @"ED", @"EM"]]) {
                            /* 'schermerhorn', 'schenker' */
                            if ([LHLDoubleMetaphone compareString:original startAt:current + 3 withLength:2 withCharacters:@[@"ER",@"EN"]]) {
                                [primary appendString:@"X"];
                                [secondary appendString:@"SK"];
                            } else {
                                [primary appendString:@"SK"];
                                [secondary appendString:@"SK"];
                            }
                            current += 3;
                            break;
                        } else {
                            if ((current == 0) && ![LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:3] &&
                                ([original characterAtIndex:3] != 'W')) {
                                [primary appendString:@"X"];
                                [secondary appendString:@"S"];
                            } else {
                                [primary appendString:@"X"];
                                [secondary appendString:@"X"];
                            }
                            current += 3;
                            break;
                        }
                    }
                    
                    if ([LHLDoubleMetaphone compareString:original startAt:current + 2 withLength:1 withCharacters:@[@"I",@"E",@"Y"]]) {
                        [primary appendString:@"S"];
                        [secondary appendString:@"S"];
                        current += 3;
                        break;
                    }
                    /* else */
                    [primary appendString:@"SK"];
                    [secondary appendString:@"SK"];
                    current += 3;
                    break;
                }
                
                /* french e.g. 'resnais', 'artois' */
                if ((current == last) &&
                    [LHLDoubleMetaphone compareString:original startAt:current - 2 withLength:2 withCharacters:@[@"AI",@"OI"]]) {
                    [primary appendString:@""];
                    [secondary appendString:@"S"];
                } else {
                    [primary appendString:@"S"];
                    [secondary appendString:@"S"];
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"S",@"Z"]])
                    current += 2;
                else
                    current += 1;
                break;
                
            case 'T':
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:4 withCharacters:@[@"TION"]]) {
                    [primary appendString:@"X"];
                    [secondary appendString:@"X"];
                    current += 3;
                    break;
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:3 withCharacters:@[@"TIA",@"TCH"]]) {
                    [primary appendString:@"X"];
                    [secondary appendString:@"X"];
                    current += 3;
                    break;
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"TH"]] ||
                    [LHLDoubleMetaphone compareString:original startAt:current withLength:3 withCharacters:@[@"TTH"]]) {
                    /* special case 'thomas', 'thames' or germanic */
                    if ([LHLDoubleMetaphone compareString:original startAt:current + 2 withLength:2 withCharacters:@[@"OM",@"AM"]] ||
                        [LHLDoubleMetaphone compareString:original startAt:0 withLength:4 withCharacters:@[@"VAN ",@"VON "]] ||
                        [LHLDoubleMetaphone compareString:original startAt:0 withLength:3 withCharacters:@[@"SCH"]]) {
                        [primary appendString:@"T"];
                        [secondary appendString:@"T"];
                    } else {
                        [primary appendString:@"0"]; /* yes, zero */
                        [secondary appendString:@"T"];
                    }
                    current += 2;
                    break;
                }
                
                if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"T",@"D"]]) {
                    current += 2;
                } else {
                    current += 1;
                }
                [primary appendString:@"T"];
                [secondary appendString:@"T"];
                break;
                
            case 'V':
                if ([original characterAtIndex:current + 1] == 'V') {
                    current += 2;
                } else {
                    current += 1;
                }
                [primary appendString:@"F"];
                [secondary appendString:@"F"];
                break;
                
            case 'W':
                /* can also be in middle of word */
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"WR"]]) {
                    [primary appendString:@"R"];
                    [secondary appendString:@"R"];
                    current += 2;
                    break;
                }
                
                if ((current == 0) &&
                    ([LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:current + 1] ||
                     [LHLDoubleMetaphone compareString:original startAt:current withLength:2 withCharacters:@[@"WH"]])) {
                        /* Wasserman should match Vasserman */
                        if ([LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:current + 1]) {
                            [primary appendString:@"A"];
                            [secondary appendString:@"F"];
                        } else {
                            /* need Uomo to match Womo */
                            [primary appendString:@"A"];
                            [secondary appendString:@"A"];
                        }
                    }
                
                /* Arnow should match Arnoff */
                if (((current == last) && [LHLDoubleMetaphone judgeIsVowelWithString:original atIndex:current - 1]) ||
                    [LHLDoubleMetaphone compareString:original startAt:current - 1 withLength:5 withCharacters:@[@"EWSKI", @"EWSKY", @"OWSKI", @"OWSKY"]] ||
                    [LHLDoubleMetaphone compareString:original startAt:0 withLength:3 withCharacters:@[@"SCH"]]) {
                    [primary appendString:@""];
                    [secondary appendString:@"F"];
                    current += 1;
                    break;
                }
                
                /* polish e.g. 'filipowicz' */
                if ([LHLDoubleMetaphone compareString:original startAt:current withLength:4 withCharacters:@[@"WICZ",@"WITZ"]]) {
                    [primary appendString:@"TS"];
                    [secondary appendString:@"FX"];
                    current += 4;
                    break;
                }
                
                /* else skip it */
                current += 1;
                break;
                
            case 'X':
                /* french e.g. breaux */
                if (!((current == last) &&
                      ([LHLDoubleMetaphone compareString:original startAt:current - 3 withLength:3 withCharacters:@[@"IAU",@"EAU"]] ||
                       [LHLDoubleMetaphone compareString:original startAt:current - 2 withLength:2 withCharacters:@[@"AU",@"OU"]]))) {
                          [primary appendString:@"KS"];
                          [secondary appendString:@"KS"];
                      }
                
                
                if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:1 withCharacters:@[@"C",@"X"]])
                    current += 2;
                else
                    current += 1;
                break;
                
            case 'Z':
                /* chinese pinyin e.g. 'zhao' */
                if ([original characterAtIndex:current + 1] == 'H') {
                    [primary appendString:@"J"];
                    [secondary appendString:@"J"];
                    current += 2;
                    break;
                } else if ([LHLDoubleMetaphone compareString:original startAt:current + 1 withLength:2 withCharacters:@[@"ZO",@"ZI",@"ZA"]] ||
                           ([LHLDoubleMetaphone slavoGermanic:original] &&
                            ((current > 0) &&
                             [original characterAtIndex:current - 1] != 'T'))) {
                                [primary appendString:@"S"];
                                [secondary appendString:@"TS"];
                            } else {
                                [primary appendString:@"S"];
                                [secondary appendString:@"S"];
                            }
                
                if ([original characterAtIndex:current + 1] == 'Z')
                    current += 2;
                else
                    current += 1;
                break;
                
            default:
                current += 1;
        }
        /* printf("PRIMARY: %s\n", primary.str);
         printf("SECONDARY: %s\n", secondary.str);  */
    }
    
    
    if (primary.length > max_length){
        primary = [NSMutableString stringWithString:[primary substringWithRange:NSMakeRange(0, max_length)]];
    }
    
    
    if (secondary.length > max_length)
        secondary = [NSMutableString stringWithString:[secondary substringWithRange:NSMakeRange(0, max_length)]];
    
//    codes->push_back(primary);
//    codes->push_back(secondary);
    [codes addObject:primary];
    [codes addObject:secondary];
    return [NSArray arrayWithArray:codes];
}

@end
