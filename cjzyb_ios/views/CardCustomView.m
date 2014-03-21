//
//  CardCustomView.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardCustomView.h"

@implementation CardCustomView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andFirst:nil andSecond:nil andObj:nil];
}
- (id)initWithFrame:(CGRect)frame andFirst:(CardFirstView *)first andSecond:(CardSecondView *)second andObj:(CardObject *)object 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.displayingPrimary = YES;
        
        self.cardFirst = first;
        CGRect frame1 = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.cardFirst setFrame: frame1];
        self.cardFirst.userInteractionEnabled = YES;
        self.cardFirst.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"card_back"]];
        [self.cardFirst addTarget:self action:@selector(flipTouched) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cardFirst];
        
        self.cardSecond = second;
        [self.cardSecond setFrame: frame1];
        [self addSubview:self.cardSecond];
        self.cardSecond.userInteractionEnabled = YES;
        [self sendSubviewToBack:self.cardSecond];
        self.cardSecond.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"card_back_selected"]];
        [self.cardSecond addTarget:self action:@selector(flipTouched) forControlEvents:UIControlEventTouchUpInside];
        
        self.aCard = object;
        
        [self setSubView];
        
    
    }
    return self;
}
-(CGSize)getSizeWithString:(NSString *)str{
    UIFont *aFont = [UIFont systemFontOfSize:22];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(292, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height-100>0) {
        size.height = 100;
    }
    return size;
}

-(NSRange)dealWithString:(NSString *)string{
    NSString *regTags = @"\\[\\[.*?]]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    // 执行匹配的过程
    NSArray *array = [regex matchesInString:string
                                    options:0
                                      range:NSMakeRange(0, [string length])];
    NSTextCheckingResult *math = (NSTextCheckingResult *)[array objectAtIndex:0];
    NSRange range = [math rangeAtIndex:0];
    
    return range;
}
-(void)setSubView {
    if (![self.aCard.resource_url isKindOfClass:[NSNull class]] && self.aCard.resource_url!=nil && self.aCard.resource_url.length>0) {
        self.cardSecond.voiceBtn.hidden=NO;
    }else {
        self.cardSecond.voiceBtn.hidden=YES;
    }
    [self.cardFirst setTagNameArray:self.aCard.tagArray];
    
    switch (self.aCard.mistake_types) {
        case 1:
            self.cardFirst.titleLab1.text = @"读错词汇:";
            self.cardFirst.titleLab2.hidden=YES;
            self.cardFirst.rightLetterLab.hidden = YES;
            break;
        case 2:
            self.cardFirst.titleLab1.text = @"拼错词汇:";
            self.cardFirst.titleLab2.text = @"正确拼写:";
            self.cardFirst.titleLab2.hidden=NO;
            self.cardFirst.rightLetterLab.hidden = NO;
            
            break;
        case 3:
            self.cardFirst.titleLab1.text = @"选错词汇:";
            self.cardFirst.titleLab2.text = @"正确选择:";
            self.cardFirst.titleLab2.hidden=NO;
            self.cardFirst.rightLetterLab.hidden = NO;
            break;
            
        default:
            break;
    }
    //TYPES_NAME = {0 => "听力", 1 => "朗读",  2 => "十速挑战", 3 => "选择", 4 => "连线", 5 => "完型填空", 6 => "排序"}
    //错误答案
    int type = 4;
//    self.aCard.your_answer = @"a";
//    self.aCard.answer = @"this;||;an;||;apple";
//    self.aCard.content = @"0";
//    self.aCard.full_text = @"[[tag]] is [[tag]] what are you dong [[tag]]";
    
    self.aCard.your_answer = @"this this  a is  is a";
    self.aCard.answer = @"this this  is is  a a";
    
    if (type==0) {//听力
        self.aCard.your_answer = @"this is a salple ;||;apple;||;an";
        self.aCard.content = @"this is an apple this this this this this this this this this this ";
        [self.cardSecond.rtLab setText:self.aCard.content];
        NSArray *yourArray = [self.aCard.your_answer componentsSeparatedByString:@";||;"];
        NSString *wrongStr = [yourArray objectAtIndex:0];
        self.cardFirst.wrongLetterLab.text =wrongStr;
        
        NSMutableString *string = [NSMutableString string];
        for (int i=1; i<yourArray.count; i++) {
            NSString *text = [yourArray objectAtIndex:i];
            [string appendFormat:@"%@  ",text];
            NSRange range = [self.aCard.content rangeOfString:text];
            if (range.location != NSNotFound) {
                [self.cardSecond.rtLab setStyle:kCTUnderlineStyleSingle fromIndex:range.location length:range.length];
            }
        }
        self.cardFirst.rightLetterLab.text = string;
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:self.aCard.content.length];
        [self.cardSecond.rtLab setLine];
        
    }else if (type==1) {//朗读
        self.cardFirst.wrongLetterLab.text =self.aCard.your_answer;
        [self.cardSecond.rtLab setText:self.aCard.content];
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:self.aCard.content.length];
        [self.cardSecond.rtLab setLine];
        
    }else if (type==2) {//十速挑战
        self.cardFirst.wrongLetterLab.text =self.aCard.your_answer;
        self.cardFirst.rightLetterLab.text = self.aCard.answer;
        [self.cardSecond.rtLab setText:self.aCard.content];
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:self.aCard.content.length];
        [self.cardSecond.rtLab setLine];
    }else if (type==3) {//选择
        
    }else if (type==4) {//连线
        self.cardFirst.wrongLetterLab.text =self.aCard.your_answer;
        self.cardFirst.rightLetterLab.text = self.aCard.answer;
        [self.cardSecond.rtLab setText:self.aCard.answer];
        
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:self.aCard.answer.length];
        [self.cardSecond.rtLab setLine];
    }else if (type==5) {//完型填空
        self.cardFirst.wrongLetterLab.text =self.aCard.your_answer;
        
        NSArray *answerArray = [self.aCard.answer componentsSeparatedByString:@";||;"];
        int index = [self.aCard.content integerValue];
        self.cardFirst.rightLetterLab.text = [answerArray objectAtIndex:index];
        
        NSMutableString *full_context = [NSMutableString stringWithString:self.aCard.full_text];
        
        NSRange UnderLineRange;
        
        for (int i=0; i<answerArray.count; i++) {
            NSString *replaceStr =[answerArray objectAtIndex:i];
            NSRange range = [self dealWithString:full_context];
            [full_context replaceCharactersInRange:range withString:replaceStr];
            if (i==index) {
                range.length = replaceStr.length;
                UnderLineRange = range;
            }
        }
        [self.cardSecond.rtLab setText:full_context];
        [self.cardSecond.rtLab setStyle:kCTUnderlineStyleSingle fromIndex:UnderLineRange.location length:UnderLineRange.length];
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:full_context.length];
        [self.cardSecond.rtLab setLine];
        
    }else if (type==6) {//排序
        [self.cardSecond.rtLab setText:self.aCard.content];
        
        NSArray *yourArray = [self.aCard.your_answer componentsSeparatedByString:@";||;"];
        NSString *wrongStr = [yourArray objectAtIndex:0];
        self.cardFirst.wrongLetterLab.text =wrongStr;
        
        NSMutableString *string = [NSMutableString string];
        for (int i=1; i<yourArray.count; i++) {
            NSString *text = [yourArray objectAtIndex:i];
            [string appendFormat:@"%@  ",text];
            NSRange range = [self.aCard.content rangeOfString:text];
            if (range.location != NSNotFound) {
                [self.cardSecond.rtLab setStyle:kCTUnderlineStyleSingle fromIndex:range.location length:range.length];
            }
        }
        self.cardFirst.rightLetterLab.text = string;
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:self.aCard.content.length];
        [self.cardSecond.rtLab setLine];
    }

}


-(void)setViewtag:(NSInteger)viewtag {
    _viewtag = viewtag;
    
    self.cardFirst.txtBtn.tag = _viewtag;
    
    self.cardSecond.voiceBtn.tag = _viewtag;
    self.cardSecond.deleteBtn.tag = _viewtag;
}

-(void)flipTouched {
    [UIView transitionFromView:(self.displayingPrimary ? self.cardFirst : self.cardSecond)
                        toView:(self.displayingPrimary ? self.cardSecond : self.cardFirst)
                      duration: 1
                       options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionCurveEaseInOut
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.displayingPrimary = !self.displayingPrimary;
                            
                            NSString *str = [NSString stringWithFormat:@"%d",self.viewtag];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"changePlayerByView" object:str];
                        }
                    }
     ];
}

@end
