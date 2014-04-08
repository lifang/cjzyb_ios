//
//  ClozeView.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ClozeView.h"

#define UnderLab_tag 1234567
#define UnderLab_width 100
@implementation ClozeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}

-(void)dealWithString:(NSString *)string{
    self.modelArray = nil;
    NSString *regTags = @"\\[\\[.*?]]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    self.modelArray = [NSMutableArray arrayWithArray:matches];
    self.number = 0;
    [self setUI];
}


- (void)setText:(NSString*)text {
    _text = text;
    [self dealWithString:_text];
}
-(UILabel *)returnLabel {
    UILabel *lab = [[UILabel alloc]init];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:33];
    lab.textColor = [UIColor colorWithRed:67/255.0 green:71/255.0 blue:75/255.0 alpha:1];
    return lab;
}

-(NSString *)handleWithString:(NSString *)text andFrame:(CGRect)frame{
    NSMutableString *mutableString = [NSMutableString stringWithString:text];
    UIFont *aFont = [UIFont systemFontOfSize:33];
    
    [Utility shared].rangeArray = [[NSMutableArray alloc]init];
    [Utility shared].isOrg = NO;
    NSArray *array = [Utility handleTheString:mutableString];
    for (int i=array.count-1; i>=0; i--) {
        NSTextCheckingResult *math = (NSTextCheckingResult *)[[Utility shared].rangeArray objectAtIndex:i];
        NSRange range = [math rangeAtIndex:0];
        
        NSString *str = [text substringWithRange:NSMakeRange(0, range.location)];
        CGSize size = [str sizeWithFont:aFont];
        if (size.width+frame.origin.x<768) {
            return str;
        }
    }
    
    return mutableString;
}
//This is [[tag]] apple,[[tag]] is a book.Car has [[tag]] wheels.
-(void)setUI {
    CGRect frame = CGRectMake(40, 10, 0, 40);
    NSInteger count = 0;
    UIFont *aFont = [UIFont systemFontOfSize:33];
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",self.text];
    for (int i=0; i<self.modelArray.count; i++) {
        NSTextCheckingResult *math = (NSTextCheckingResult *)[self.modelArray objectAtIndex:i];
        NSRange range = [math rangeAtIndex:0];
        NSString *str = [mutableString substringWithRange:NSMakeRange(count, range.location-count)];
        
        if (str.length>0) {
            CGSize size = [str sizeWithFont:aFont];
            if (size.width+frame.origin.x>768) {//换行
                while (![str isEqualToString:@" "] && str.length>0) {
                    NSString *str_sub = [self handleWithString:str andFrame:frame];
                    NSLog(@"str_sub = %@",str_sub);
                    if (![str_sub isEqualToString:@" "] && str_sub.length>0) {
                        UILabel *label = [self returnLabel];
                        CGSize size1 = [str_sub sizeWithFont:aFont];
                        frame.size.width = size1.width;
                        label.frame = frame;
                        label.text = str_sub;
                        [self addSubview:label];
                        
                        str = [str substringWithRange:NSMakeRange(str_sub.length, str.length-str_sub.length)];
                        if (![str isEqualToString:@" "] && str.length>0) {
                            self.number += 1;
                            frame.origin.x = 40;
                            frame.origin.y = 10+60*self.number;
                            
                            CGSize size2 = [str sizeWithFont:aFont];
                            if (size2.width+frame.origin.x<768) {
                                UILabel *label = [self returnLabel];
                                CGSize size1 = [str sizeWithFont:aFont];
                                frame.size.width = size1.width;
                                label.frame = frame;
                                label.text = str;
                                [self addSubview:label];
                                
                                break;
                            }
                        }
                    }
                }
            }else {
                UILabel *label3 = [self returnLabel];
                frame.size.width = size.width;
                label3.frame = frame;
                label3.text = str;
                [self addSubview:label3];
            }
        }
        //空格
        frame.origin.x += frame.size.width;
        if (frame.origin.x+UnderLab_width>768) {//换行
            self.number += 1;
            frame.origin.x = 40;
            frame.origin.y = 10+60*self.number;
        }
        frame.size.width = UnderLab_width;
        UnderLineLabel *underLab = [[UnderLineLabel alloc] initWithFrame:frame];
        [underLab setTag:i+UnderLab_tag];
        underLab.textAlignment = NSTextAlignmentCenter;
        [underLab setText:@"" andFrame:frame];
        underLab.backgroundColor = [UIColor clearColor];
        underLab.font = [UIFont systemFontOfSize:33];
        underLab.textColor = [UIColor colorWithRed:67/255.0 green:71/255.0 blue:75/255.0 alpha:1];
        underLab.highlightedColor = [UIColor colorWithRed:39./255. green:48./255. blue:57./255. alpha:1.0];
        
        underLab.shouldUnderline = YES;
        [underLab addTarget:self action:@selector(labelClicked:)];
        [self addSubview:underLab];
        
        
        frame.origin.x += frame.size.width;
        count = range.location+range.length;
        
        //最后是否还有文字
        if (i==self.modelArray.count-1) {
            if (mutableString.length>count) {
                NSString *str = [mutableString substringWithRange:NSMakeRange(count, mutableString.length-count)];
                
                CGSize size = [str sizeWithFont:aFont];
                if (size.width+frame.origin.x>768) {//换行
                    
                    while (![str isEqualToString:@" "] && str.length>0) {
                        NSString *str_sub = [self handleWithString:str andFrame:frame];
                        if (str_sub.length>0) {
                            UILabel *label = [self returnLabel];
                            CGSize size1 = [str_sub sizeWithFont:aFont];
                            frame.size.width = size1.width;
                            label.frame = frame;
                            label.text = str_sub;
                            [self addSubview:label];
                            
                            str = [str substringWithRange:NSMakeRange(str_sub.length, str.length-str_sub.length)];
                            if (![str isEqualToString:@" "] && str.length>0) {
                                self.number += 1;
                                frame.origin.x = 40;
                                frame.origin.y = 10+60*self.number;
                                
                                CGSize size2 = [str sizeWithFont:aFont];
                                if (size2.width+frame.origin.x<768) {
                                    UILabel *label = [self returnLabel];
                                    CGSize size1 = [str sizeWithFont:aFont];
                                    frame.size.width = size1.width;
                                    label.frame = frame;
                                    label.text = str;
                                    [self addSubview:label];
                                    
                                    break;
                                }
                            }
                        }
                    }
                }else {
                    UILabel *label = [self returnLabel];
                    frame.size.width = size.width;
                    label.frame = frame;
                    label.text = str;
                    [self addSubview:label];
                }
            }
        }
    }
    
    CGRect frame2 = self.frame;
    frame2.size.height = frame.origin.y+frame.size.height +180;
    [self setFrame:frame2];
}

-(void)labelClicked:(id)sender {
    UIControl *control = (UIControl *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedLabel:)]) {
        [self.delegate pressedLabel:control];
    }
}
@end
