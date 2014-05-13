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
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)setACard:(CardObject *)aCard {
    _aCard = aCard;

    [self setSubView];
}

-(CGSize)getSizeWithString:(NSString *)str withWidth:(int)width{
    UIFont *aFont = [UIFont systemFontOfSize:20];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(void)deletelWithString:(NSString *)string {
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    
    NSString *regTags = @"\\<.*?>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:mutableString
                                      options:0
                                        range:NSMakeRange(0, [mutableString length])];
    
    
    if (matches.count>0) {
        NSTextCheckingResult *math = (NSTextCheckingResult *)[matches objectAtIndex:0];
        NSRange range = [math rangeAtIndex:0];
        
        [mutableString deleteCharactersInRange:range];
        
        return [self deletelWithString:mutableString];
    }
    self.fullTextString = mutableString;
    
}
#pragma mark --取中括号
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
#pragma mark --取标点
-(NSArray *)getPoint:(NSString *)string{
    
    NSString *regTags = @"[?~!;\\.。？！；！～]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    // 执行匹配的过程
    NSArray *array = [regex matchesInString:string
                                    options:0
                                      range:NSMakeRange(0, [string length])];
    return array;
}

//原文－（20，50）  宽－240
-(void)setSubView {
    //TYPES_NAME = {0 => "听力", 1 => "朗读",  2 => "十速挑战", 3 => "选择", 4 => "连线", 5 => "完型填空", 6 => "排序"}
    self.remindImageView.hidden=YES;
    int type = [self.aCard.types integerValue];
    if (type==0) {//听力
        self.typeLabel.text = @"听写:";
        self.remindButton.hidden=NO;
        [self.remindButton setImage:[UIImage imageNamed:@"card_voiceBtn"] forState:UIControlStateNormal];
        [self.remindButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.remindButton addTarget:self action:@selector(voiceButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        //原文
        CGSize size = [self getSizeWithString:self.aCard.content withWidth:240];
        UILabel *originLabel = [self returnLabel];
        originLabel.frame = CGRectMake(20, 50, 240, size.height);
        originLabel.text = self.aCard.content;
        [self addSubview:originLabel];
        //错误
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.aCard.content];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1] range:NSMakeRange(0, self.aCard.content.length)];
        
        NSArray *yourArray = [self.aCard.your_answer componentsSeparatedByString:@";||;"];
        
        for (int i=1; i<yourArray.count; i++) {
            NSString *text = [yourArray objectAtIndex:i];
            NSRange range = [self.aCard.content rangeOfString:text];
            if (range.location != NSNotFound) {
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1] range:range];
            }
        }
        UILabel *wrongLabel = [self returnLabel];
        wrongLabel.frame = CGRectMake(20, 70+originLabel.frame.size.height, 240, size.height);
        wrongLabel.attributedText = str;
        [self addSubview:wrongLabel];
        
    }
    else if (type==1) {//朗读
        self.typeLabel.text = @"朗读:";
        self.remindButton.hidden=NO;
        [self.remindButton setImage:[UIImage imageNamed:@"card_voiceBtn"] forState:UIControlStateNormal];
        [self.remindButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.remindButton addTarget:self action:@selector(voiceButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        //原文
        CGSize size = [self getSizeWithString:self.aCard.content withWidth:240];
        UILabel *originLabel = [self returnLabel];
        originLabel.frame = CGRectMake(20, 50, 240, size.height);
        originLabel.text = self.aCard.content;
        [self addSubview:originLabel];
        //错误
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.aCard.content];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1] range:NSMakeRange(0, self.aCard.content.length)];

        NSArray *answerArray = [self.aCard.your_answer componentsSeparatedByString:@";||;"];
        for (int i=0; i<answerArray.count; i++) {
            NSString *text = [answerArray objectAtIndex:i];
            NSRange range = [self.aCard.content rangeOfString:text];
            if (range.location != NSNotFound) {
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1] range:range];
            }
        }
        UILabel *wrongLabel = [self returnLabel];
        wrongLabel.frame = CGRectMake(20, 70+originLabel.frame.size.height, 240, size.height);
        wrongLabel.attributedText = str;
        [self addSubview:wrongLabel];
    }
    
    else if (type==2) {//十速挑战
        self.typeLabel.text = @"十速:";
        self.remindButton.hidden=YES;
        
        //原文
        CGSize size = [self getSizeWithString:self.aCard.content withWidth:292];
        UILabel *originLabel = [self returnLabel];
        originLabel.frame = CGRectMake(20, 50, 292, size.height);
        originLabel.text = self.aCard.content;
        [self addSubview:originLabel];

        UILabel *trueLabel = [self returnLabel];
        trueLabel.frame = CGRectMake(20, 70+originLabel.frame.size.height, 240, 20);
        trueLabel.text = @"True";
        [trueLabel setTextColor:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1]];
        [self addSubview:trueLabel];
        
        UILabel *falseLabel = [self returnLabel];
        falseLabel.frame = CGRectMake(20, trueLabel.frame.size.height+trueLabel.frame.origin.y+20, 240, 20);
        falseLabel.text = @"False";
        [falseLabel setTextColor:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1]];
        [self addSubview:falseLabel];
        
        //错误
        if ([self.aCard.your_answer isEqualToString:@"false"]) {
            [falseLabel setTextColor:[UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1]];
        }else {
            [trueLabel setTextColor:[UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1]];
        }
        
    }
    else if (type==3) {//选择
        self.typeLabel.text = @"选择:";        

        UILabel *originLabel = [self returnLabel];
        BOOL isOrigin = NO;
        
        NSRange range = [self.aCard.content rangeOfString:@"</file>"];
        if (range.location != NSNotFound && range.length!=NSNotFound) {
            NSArray *array = [self.aCard.content componentsSeparatedByString:@"</file>"];
            NSString *title_sub  =[array objectAtIndex:0];
            NSString *title=[title_sub stringByReplacingOccurrencesOfString:@"<file>" withString:@""];
            
            
            NSString *regTags = @"jpg|png|bmp|jpeg";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            // 执行匹配的过程
            NSArray *matches = [regex matchesInString:title
                                              options:0
                                                range:NSMakeRange(0, [title length])];
            if (matches.count>0) {//图片
                self.remindButton.hidden = YES;
                self.remindImageView.hidden=NO;
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHOST,title]];
                [self.remindImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserHeaderImageBox"]];
                [self.remindImageView addDetailShow];

                if (array.count>1) {
                    isOrigin = YES;
                    CGSize size = [self getSizeWithString:[array objectAtIndex:1] withWidth:240];
                    originLabel.frame = CGRectMake(20, 50, 240, size.height);
                    originLabel.text = [array objectAtIndex:1];
                }
            }else {
                self.remindButton.hidden = NO;
                self.remindImageView.hidden=YES;
                
                [self.remindButton setImage:[UIImage imageNamed:@"card_voiceBtn"] forState:UIControlStateNormal];
                [self.remindButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                [self.remindButton addTarget:self action:@selector(voiceButtonPressed) forControlEvents:UIControlEventTouchUpInside];
                
                if (array.count>1) {
                    isOrigin = YES;
                    CGSize size = [self getSizeWithString:[array objectAtIndex:1] withWidth:240];
                    originLabel.frame = CGRectMake(20, 50, 240, size.height);
                    originLabel.text = [array objectAtIndex:1];
                }
            }
        }else {
            self.remindButton.hidden = YES;
            self.remindImageView.hidden=YES;
            isOrigin = YES;
            CGSize size = [self getSizeWithString:self.aCard.content withWidth:292];
            originLabel.frame = CGRectMake(20, 50, 292, size.height);
            originLabel.text = self.aCard.content;
        }
        
        CGRect frame;
        if (isOrigin == YES) {
            [self addSubview:originLabel];
            frame = CGRectMake(20, 70+originLabel.frame.size.height, 292, 20);
        }else {
            frame = CGRectMake(20, 50, 240, 20);
        }
        //错误
        NSArray *wrongArray = [self.aCard.your_answer componentsSeparatedByString:@";||;"];
        //正确答案
        NSArray *answerArray = [self.aCard.answer componentsSeparatedByString:@";||;"];
        //选项
        NSArray *optionsArray = [self.aCard.options componentsSeparatedByString:@";||;"];
        for (int i=0; i<optionsArray.count; i++) {
            if (i>0) {
                frame.origin.y += 30;
            }
            
            NSString *optionStr = [optionsArray objectAtIndex:i];
            UILabel *optionlabel = [self returnLabel];
            optionlabel.frame = frame;
            optionlabel.text = [NSString stringWithFormat:@"%c.%@",(char)('A' + i),optionStr];
            
            if ([answerArray containsObject:optionStr]) {
                [optionlabel setTextColor:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1]];
            }else {
                if ([wrongArray containsObject:optionStr]) {
                    [optionlabel setTextColor:[UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1]];
                }
            }
            [self addSubview:optionlabel];
        }
    }
    else if (type==4) {//连线
        self.typeLabel.text = @"连线:";
        self.remindButton.hidden=YES;
        
        NSMutableArray *mutableArray = [NSMutableArray array];
        //原文
        NSMutableString *answerStr = [NSMutableString string];
        NSString *content = self.aCard.content;
        NSArray *array = [content componentsSeparatedByString:@";||;"];
        for (int i=0; i<array.count; i++) {
            NSString *str = [array objectAtIndex:i];
            NSArray *subArray = [str componentsSeparatedByString:@"<=>"];
            NSString *textStr;
            if (i==array.count-1) {
                textStr = [NSString stringWithFormat:@"%@--%@",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
            }else {
                textStr = [NSString stringWithFormat:@"%@--%@\n",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
            }
            [answerStr appendFormat:@"%@",textStr];
            [mutableArray addObject:textStr];
        }
        
        UILabel *originLabel = [self returnLabel];
        originLabel.frame = CGRectMake(20, 50, 292, 80);
        originLabel.text = answerStr;
        [self addSubview:originLabel];
        
        //错误
        NSMutableString *wrongStr = [NSMutableString string];
        NSString *wrongContent = self.aCard.your_answer;
        NSArray *wrongArray = [wrongContent componentsSeparatedByString:@";||;"];
        for (int i=0; i<wrongArray.count; i++) {
            NSString *str = [wrongArray objectAtIndex:i];
            NSArray *subArray = [str componentsSeparatedByString:@"<=>"];
            if (i==wrongArray.count-1) {
                [wrongStr appendFormat:@"%@--%@",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
            }else {
                [wrongStr appendFormat:@"%@--%@\n",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
            }
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:wrongStr];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1] range:NSMakeRange(0, wrongStr.length)];
        for (int i=0; i<mutableArray.count; i++) {
            NSString *text = [mutableArray objectAtIndex:i];
            NSRange range = [wrongStr rangeOfString:text];
            if (range.location != NSNotFound) {
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1] range:range];
            }
        }
        UILabel *wrongLabel = [self returnLabel];
        wrongLabel.frame = CGRectMake(20, 70+originLabel.frame.size.height, 292, 80);
        wrongLabel.attributedText = str;
        [self addSubview:wrongLabel];
    }
    else if (type==5) {//完型填空
        self.typeLabel.text = @"完型:";

        int index = [self.aCard.content integerValue];
        NSString *answerString;
        for (int i=0; i<self.aCard.clozeAnswer.count; i++) {
            NSDictionary *dic = [self.aCard.clozeAnswer objectAtIndex:i];
            int content_index = [[dic objectForKey:@"content"]integerValue];
            if (content_index == index) {
                answerString = [dic objectForKey:@"answer"];
                break;
            }
        }
        [self deletelWithString:self.aCard.full_text];
        self.fullTextString = [self.fullTextString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];//去空格
        self.fullTextString = [self.fullTextString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        NSMutableString *full_context = [NSMutableString stringWithString:self.fullTextString];
        //截取一小题
        NSMutableString *content_text = [NSMutableString string];
        for (int i=0; i<self.aCard.clozeAnswer.count; i++) {
            NSDictionary *dic = [self.aCard.clozeAnswer objectAtIndex:i];
            NSString *replaceStr =[dic objectForKey:@"answer"];
            NSRange range = [self dealWithString:full_context];

            int content_index = [[dic objectForKey:@"content"]integerValue];
            if (content_index==index) {
                [full_context replaceCharactersInRange:range withString:@"____"];
                NSArray *array = [self getPoint:full_context];
                for (int k=array.count-1; k>=0; k--) {
                    NSTextCheckingResult *math = (NSTextCheckingResult *)[array objectAtIndex:k];
                    NSRange range_compare = [math rangeAtIndex:0];
                    
                    if (range_compare.location<=range.location) {//倒数取
                        if (k==array.count-1) {
                            content_text = [NSMutableString stringWithString:[full_context substringWithRange:NSMakeRange(range_compare.location+1, full_context.length-range_compare.location)]];
                        }else {
                            NSTextCheckingResult *math = (NSTextCheckingResult *)[array objectAtIndex:k+1];
                            NSRange range_compare2 = [math rangeAtIndex:0];
                            content_text = [NSMutableString stringWithString:[full_context substringWithRange:NSMakeRange(range_compare.location+1, range_compare2.location-range_compare.location)]];
                        }
                        break;
                    }
                }
            }else {
                [full_context replaceCharactersInRange:range withString:replaceStr];
            }
        }
        self.fullTextString = full_context;

        self.remindButton.hidden = NO;
        [self.remindButton setImage:[UIImage imageNamed:@"txtBtn"] forState:UIControlStateNormal];
        [self.remindButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        [self.remindButton addTarget:self action:@selector(showFullTextPressed) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *tempText = [NSString stringWithFormat:@"%@",content_text];
        //原文
        CGSize size = [self getSizeWithString:content_text withWidth:240];
        UILabel *originLabel = [self returnLabel];
        tempText = [tempText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];//去空格
        tempText = [tempText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        originLabel.frame = CGRectMake(20, 50, 240, size.height);
        originLabel.text = tempText;
        [self addSubview:originLabel];
        //选项
        CGRect frame = CGRectMake(20, originLabel.frame.size.height+originLabel.frame.origin.y+20, 292, 20);
        NSArray *optionsArray = [self.aCard.options componentsSeparatedByString:@";||;"];
        for (int i=0; i<optionsArray.count; i++) {
            if (i>0) {
                frame.origin.y += 30;
            }
            NSString *optionStr = [optionsArray objectAtIndex:i];
            UILabel *optionlabel = [self returnLabel];
            optionlabel.frame = frame;
            optionlabel.text = [NSString stringWithFormat:@"%c.%@",(char)('A' + i),optionStr];
            
            if ([optionStr isEqualToString:self.aCard.your_answer]) {
                [optionlabel setTextColor:[UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1]];
            }else {
                if ([optionStr isEqualToString:answerString]) {
                    [optionlabel setTextColor:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1]];
                }
            }
            [self addSubview:optionlabel];
        }
    }
     else if (type==6) {//排序
        self.typeLabel.text = @"排序:";
        self.remindButton.hidden=YES;
         
         //原文
         CGSize size = [self getSizeWithString:self.aCard.content withWidth:292];
         UILabel *originLabel = [self returnLabel];
         originLabel.frame = CGRectMake(20, 50, 292, size.height);
         originLabel.text = self.aCard.content;
         [self addSubview:originLabel];
         
         //错误
         NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.aCard.your_answer];
         [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1] range:NSMakeRange(0, self.aCard.your_answer.length)];
         
        [Utility shared].isOrg = YES;
        NSArray *content_array = [Utility handleTheString:self.aCard.content];
        [Utility shared].isOrg = NO;
         [Utility shared].rangeArray = [[NSMutableArray alloc]init];
        NSArray *answer_array = [Utility handleTheString:self.aCard.your_answer];
        
        for (int i=0; i<content_array.count; i++) {
            NSString *content_str = [content_array objectAtIndex:i];
            NSString *answer_str = [answer_array objectAtIndex:i];
            if (![answer_str isEqualToString:content_str]) {
                NSTextCheckingResult *math = (NSTextCheckingResult *)[[Utility shared].rangeArray objectAtIndex:i];
                NSRange range = [math rangeAtIndex:0];
               [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0 green:0/255.0 blue:18/255.0 alpha:1] range:range];
            }
        }
        [Utility shared].rangeArray = nil;
         UILabel *wrongLabel = [self returnLabel];
         wrongLabel.frame = CGRectMake(20, 70+originLabel.frame.size.height, 240, size.height);
         wrongLabel.attributedText = str;
         [self addSubview:wrongLabel];
    }
}

-(UILabel *)returnLabel {
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}
-(void)setViewtag:(NSInteger)viewtag {
    _viewtag = viewtag;
    
    self.remindButton.tag = _viewtag;
}
#pragma mark - 点击事件

-(void)voiceButtonPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedVoiceBtn:)]) {
        [self.delegate pressedVoiceBtn:self.remindButton];
    }
}

-(IBAction)deleteButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedDeleteBtn:)]) {
        [self.delegate pressedDeleteBtn:self.remindButton];
    }
}


-(void)showFullTextPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedShowFullText:andBtn:)]) {
        [self.delegate pressedShowFullText:self.fullTextString andBtn:self.remindButton];
    }
}
@end
