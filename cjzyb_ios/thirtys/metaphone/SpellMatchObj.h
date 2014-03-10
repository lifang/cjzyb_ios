//
//  SpellMatchObj.h
//  cjzyb_ios
//
//  Created by david on 14-3-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SpellMatchObj : NSObject
@property (assign,nonatomic) NSRange range;
@property (nonatomic,strong) UIColor *color;
@property (assign,nonatomic) BOOL  isUnderLine;
@property (nonatomic,strong) NSString *originText;
@property (nonatomic,assign) int lineIndex;
@property (nonatomic,strong) UILabel *textLabel;
///匹配程度，0表示不匹配，1表示完全匹配，0.5表示部分匹配
@property (nonatomic,assign) int spellLevel;
@end
