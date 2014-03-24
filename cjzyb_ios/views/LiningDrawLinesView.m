//
//  LiningDrawLinesView.m
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LiningDrawLinesView.h"
@interface LiningDrawLinesView()
@property(nonatomic,strong) NSArray *linesArray;
@end
@implementation LiningDrawLinesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)redrawLinesWithLineObjArray:(NSArray*)linesArr{
    self.linesArray = linesArr;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    /*设置线条颜色*/
    [[UIColor clearColor] set];
    //获得当前图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextFillRect(currentContext, rect);
    //设置连接类型
    CGContextSetLineJoin(currentContext, kCGLineJoinRound);
    //设置线条宽度
    CGContextSetLineWidth(currentContext,4.0f);
    
    UIColor *color = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
    [color set];
    for (LineObj *line  in self.linesArray) {
        CGContextMoveToPoint(currentContext, line.startPoint.x, line.startPoint.y);
        CGContextAddLineToPoint(currentContext, line.endPoint.x, line.endPoint.y);
        CGContextStrokePath(currentContext);
    }
}

@end
