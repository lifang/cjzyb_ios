//
//  LHLButton.m
//  cjzyb_ios
//
//  Created by apple on 14-3-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLButton.h"
@interface LHLButton()
@property (nonatomic,assign) CGPoint startPoint;//起始点
@property (nonatomic,assign) CGPoint endPoint;//结束点
@end
@implementation LHLButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark 响应链方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in event.allTouches){
        self.startPoint = [touch locationInView:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in event.allTouches){
        self.endPoint = [touch locationInView:self];
    }
    double distanceBetweenStartAndEnd = sqrt(pow((self.startPoint.x - self.endPoint.x), 2.0) + pow((self.startPoint.y - self.endPoint.y), 2.0));
    if (distanceBetweenStartAndEnd < 10.) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(coverButtonClicked:)]) {
            [self.delegate coverButtonClicked:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in event.allTouches) {
        self.endPoint = [touch locationInView:self];
    }
    CGFloat xMoved = self.startPoint.x - self.endPoint.x;
    if (xMoved >= 80) {
        //向左划
        if (self.delegate && [self.delegate respondsToSelector:@selector(coverButtonDraged:)]) {
            [self.delegate coverButtonDraged:YES];
        }
    }else if(xMoved <= -80){
        //向右划
        if (self.delegate && [self.delegate respondsToSelector:@selector(coverButtonDraged:)]) {
            [self.delegate coverButtonDraged:NO];
        }
    }
}

@end
