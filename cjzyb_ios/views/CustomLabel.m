//
//  CustomLabel.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-20.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);//重置
    CGContextTranslateCTM(context,0,self.bounds.size.height); //y轴高度
    CGContextScaleCTM(context,1.0,-1.0);//y轴翻转
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path,NULL,self.bounds);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0),path,NULL);
    CGContextSetTextPosition(context,0,0);
    CTFrameDraw(frame,context);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    int lineNumber = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineNumber];
    CTFrameGetLineOrigins(frame,CFRangeMake(0,lineNumber), lineOrigins);
    for(int lineIndex = 0;lineIndex < lineNumber;lineIndex++){
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines,lineIndex);
        CGContextSetTextPosition(context,lineOrigin.x,lineOrigin.y);
        CTLineDraw(line,context);
    }
    
    CFRelease(framesetter);
    CFRelease(frame);
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)color.CGColor
                       range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                      font.pointSize,
                                                      NULL))
                       range:NSMakeRange(location, length)];
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                       value:(id)[NSNumber numberWithInt:style]
                       range:NSMakeRange(location, length)];
}
//自动换行
-(void)setLine {
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;//换行模式
    
    CTTextAlignment alignment = kCTLeftTextAlignment;//对齐方式
    
    float lineSpacing =2.0;//行间距
    
    CTParagraphStyleSetting paraStyles[3] = {
        
        {.spec = kCTParagraphStyleSpecifierLineBreakMode,.valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
        
        {.spec = kCTParagraphStyleSpecifierAlignment,.valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
        
        {.spec = kCTParagraphStyleSpecifierLineSpacing,.valueSize = sizeof(CGFloat), .value = (const void*)&lineSpacing},
        
    };
    CTParagraphStyleRef style2 = CTParagraphStyleCreate(paraStyles,3);
    [_attString addAttribute:(NSString*)(kCTParagraphStyleAttributeName) value:(__bridge id)style2 range:NSMakeRange(0,self.text.length)];
    CFRelease(style2);
    
    
    CGFloat widthValue = -1.0;
    CFNumberRef strokeWidth = CFNumberCreate(NULL,kCFNumberFloatType,&widthValue);
    [_attString addAttribute:(NSString*)(kCTStrokeWidthAttributeName) value:(__bridge id)strokeWidth range:NSMakeRange(0,self.text.length)];
    [_attString addAttribute:(NSString*)(kCTStrokeColorAttributeName) value:(id)[[UIColor whiteColor]CGColor] range:NSMakeRange(0,self.text.length)];
}
@end
