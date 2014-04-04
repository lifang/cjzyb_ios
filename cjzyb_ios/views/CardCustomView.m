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
-(CGSize)getSizeWithString:(NSString *)str withWidth:(int)width{
    UIFont *aFont = [UIFont systemFontOfSize:22];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
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
    int type = [self.aCard.types integerValue];
    
    if (type==0) {//听力
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
        [self.cardSecond.rtLab setText:self.aCard.content];
        NSMutableString *string = [NSMutableString string];
        NSArray *answerArray = [self.aCard.your_answer componentsSeparatedByString:@";||;"];
        for (int i=0; i<answerArray.count; i++) {
            NSString *text = [answerArray objectAtIndex:i];
            [string appendFormat:@"%@ ",text];
            NSRange range = [self.aCard.content rangeOfString:text];
            if (range.location != NSNotFound) {
                [self.cardSecond.rtLab setStyle:kCTUnderlineStyleSingle fromIndex:range.location length:range.length];
            }
        }
        self.cardFirst.wrongLetterLab.text = string;
        
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:self.aCard.content.length];
        [self.cardSecond.rtLab setLine];
        
    }else if (type==2) {//十速挑战
        self.cardFirst.wrongLetterLab.text =self.aCard.your_answer;
        self.cardFirst.rightLetterLab.text = self.aCard.answer;
        [self.cardSecond.rtLab setText:self.aCard.content];
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:self.aCard.content.length];
        [self.cardSecond.rtLab setLine];
    }else if (type==3) {//选择
        
        self.cardFirst.wrongLetterLab.text =self.aCard.your_answer;
        NSArray *answerArray = [self.aCard.answer componentsSeparatedByString:@";||;"];
        self.cardFirst.rightLetterLab.text = [answerArray componentsJoinedByString:@"  "];
        
        self.cardSecond.cardSecondTable = [[UITableView alloc]initWithFrame:CGRectMake(20, self.cardSecond.label_title.frame.origin.y+self.cardSecond.label_title.frame.size.height, 292, 212)];
        self.cardSecond.cardSecondTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.cardSecond.cardSecondTable.backgroundColor = [UIColor clearColor];
        self.cardSecond.cardSecondTable.userInteractionEnabled = NO;
        self.cardSecond.cardSecondTable.delegate = self.cardSecond;
        self.cardSecond.cardSecondTable.dataSource = self.cardSecond;
        [self.cardSecond addSubview:self.cardSecond.cardSecondTable];

        self.cardSecond.cardSecondArray = [self.aCard.options componentsSeparatedByString:@";||;"];
        
        NSMutableArray *indexArray = [[NSMutableArray alloc]init];
        for (int i=0; i<answerArray.count; i++) {
            NSString *str = [answerArray objectAtIndex:i];
            if ([self.cardSecond.cardSecondArray containsObject:str]) {
                NSString *index_str = [NSString stringWithFormat:@"%d",[self.cardSecond.cardSecondArray indexOfObject:str]];
                [indexArray addObject:index_str];
            }
        }
        
        self.cardSecond.indexArray = indexArray;
        [self.cardSecond.cardSecondTable reloadData];
        [self.cardSecond.rtLab removeFromSuperview];
        
        NSRange range = [self.aCard.content rangeOfString:@"</file>"];
        if (range.location != NSNotFound) {
            self.cardSecond.titleLab.hidden = YES;
            NSArray *array = [self.aCard.content componentsSeparatedByString:@"</file>"];
            NSString *title_sub  =[array objectAtIndex:0];
            NSString *title=[title_sub stringByReplacingOccurrencesOfString:@"<file>" withString:@""];
            
            NSRange range2 = [title rangeOfString:@".jpg"];
            if (range2.location != NSNotFound) {//图片
                self.cardSecond.imgView = [self returnImageView];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",title]];
                [self.cardSecond.imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserHeaderImageBox"]];
                [self.cardSecond addSubview:self.cardSecond.imgView];
                
                if (array.count>1) {
                    self.cardSecond.label_title = [self returnLabel];
                    CGSize size = [self getSizeWithString:[array objectAtIndex:1] withWidth:212];
                    self.cardSecond.label_title.frame = CGRectMake(90, 50, 212, size.height);
                    self.cardSecond.label_title.text = [array objectAtIndex:1];
                    [self.cardSecond addSubview:self.cardSecond.label_title];
                }
                self.cardSecond.cardSecondTable.frame = CGRectMake(20, 110, 292, 212);
                
            }else {//语音
                self.cardSecond.cardSecondTable.frame = CGRectMake(20, 50, 292, 212);
            }
            
        }else {
            self.cardSecond.titleLab.hidden = NO;
            self.cardSecond.label_title = [self returnLabel];
            CGSize size = [self getSizeWithString:self.aCard.content withWidth:292];
            self.cardSecond.label_title.frame = CGRectMake(20, 50, 292, size.height);
            self.cardSecond.label_title.text = self.aCard.content;
            [self.cardSecond addSubview:self.cardSecond.label_title];
            
            self.cardSecond.cardSecondTable.frame = CGRectMake(20, self.cardSecond.label_title.frame.origin.y+self.cardSecond.label_title.frame.size.height, 292, 212);
        }
        
    }else if (type==4) {//连线

        NSMutableString *wrongStr = [NSMutableString string];
        NSString *wrongContent = self.aCard.your_answer;
        NSArray *wrongArray = [wrongContent componentsSeparatedByString:@";||;"];
        for (int i=0; i<wrongArray.count; i++) {
            NSString *str = [wrongArray objectAtIndex:i];
            NSArray *subArray = [str componentsSeparatedByString:@"<=>"];
            if (i==wrongArray.count-1) {
                [wrongStr appendFormat:@"%@ %@",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
            }else {
                [wrongStr appendFormat:@"%@ %@    ",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
            }
        }
        
        self.cardFirst.wrongLetterLab.text =wrongStr;
        
        NSMutableString *answerStr = [NSMutableString string];
        NSString *content = self.aCard.content;
        NSArray *array = [content componentsSeparatedByString:@";||;"];
        for (int i=0; i<array.count; i++) {
            NSString *str = [array objectAtIndex:i];
            NSArray *subArray = [str componentsSeparatedByString:@"<=>"];
            if (i==array.count-1) {
                [answerStr appendFormat:@"%@ %@",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
            }else {
                [answerStr appendFormat:@"%@ %@    ",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
            }
        }
        self.cardFirst.rightLetterLab.text = answerStr;
        [self.cardSecond.rtLab setText:answerStr];
        
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:answerStr.length];
        [self.cardSecond.rtLab setLine];
    }else if (type==5) {//完型填空
        self.cardFirst.wrongLetterLab.text =self.aCard.your_answer;
        
        int index = [self.aCard.content integerValue];
        
        for (int i=0; i<self.aCard.clozeAnswer.count; i++) {
            NSDictionary *dic = [self.aCard.clozeAnswer objectAtIndex:i];
            int content_index = [[dic objectForKey:@"content"]integerValue];
            if (content_index == index) {
                self.cardFirst.rightLetterLab.text = [dic objectForKey:@"answer"];
                break;
            }
        }

        NSMutableString *full_context = [NSMutableString stringWithString:self.aCard.full_text];
        
        NSRange UnderLineRange;
        
        for (int i=0; i<self.aCard.clozeAnswer.count; i++) {
            NSDictionary *dic = [self.aCard.clozeAnswer objectAtIndex:i];
            NSString *replaceStr =[dic objectForKey:@"answer"];
            NSRange range = [self dealWithString:full_context];
            [full_context replaceCharactersInRange:range withString:replaceStr];
            int content_index = [[dic objectForKey:@"content"]integerValue];
            if (content_index==index) {
                range.length = replaceStr.length;
                UnderLineRange = range;
            }
        }
        [self.cardSecond.rtLab setText:full_context];
        [self.cardSecond.rtLab setStyle:kCTUnderlineStyleSingle fromIndex:UnderLineRange.location length:UnderLineRange.length];
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:full_context.length];
        [self.cardSecond.rtLab setLine];
        
    }else if (type==6) {//排序
        [Utility shared].isOrg = NO;
        [Utility shared].rangeArray = [[NSMutableArray alloc]init];
        [self.cardSecond.rtLab setText:self.aCard.content];
        NSArray *content_array = [Utility handleTheString:self.aCard.content];
        
        [Utility shared].isOrg = YES;
        self.cardFirst.wrongLetterLab.text =self.aCard.your_answer;
        NSArray *answer_array = [Utility handleTheString:self.aCard.your_answer];
        
        for (int i=0; i<content_array.count; i++) {
            NSString *content_str = [content_array objectAtIndex:i];
            NSString *answer_str = [answer_array objectAtIndex:i];
            if (![answer_str isEqualToString:content_str]) {
                NSTextCheckingResult *math = (NSTextCheckingResult *)[[Utility shared].rangeArray objectAtIndex:i];
                NSRange range = [math rangeAtIndex:0];
                [self.cardSecond.rtLab setStyle:kCTUnderlineStyleSingle fromIndex:range.location length:range.length];
            }
        }
        [Utility shared].rangeArray = nil;
        self.cardFirst.rightLetterLab.text = self.aCard.answer;
        [self.cardSecond.rtLab setFont:[UIFont systemFontOfSize:22] fromIndex:0 length:self.aCard.content.length];
        [self.cardSecond.rtLab setLine];
    }

}
-(UIImageView *)returnImageView {
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 70, 70)];
    imgView.backgroundColor = [UIColor clearColor];
    return imgView;
}
-(UILabel *)returnLabel {
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:22];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
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
