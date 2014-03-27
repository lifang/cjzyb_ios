//
//  LHLTableView.m
//  cjzyb_ios
//
//  Created by apple on 14-3-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLTableView.h"
@interface LHLTableView()
@property (nonatomic,assign) CGPoint startPoint;//起始点
@property (nonatomic,assign) CGPoint endPoint;//结束点
@end
@implementation LHLTableView

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
    [super touchesBegan:touches withEvent:event];
    for(UITouch *touch in event.allTouches){
        self.startPoint = [touch locationInView:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    for(UITouch *touch in event.allTouches){
        self.endPoint = [touch locationInView:self];
    }
    double distanceBetweenStartAndEnd = self.startPoint.x - self.endPoint.x;
    NSLog(@"%f",distanceBetweenStartAndEnd);
    if (distanceBetweenStartAndEnd >= 100.0) {  //起点在终点右边,表示向左划
        if (self.delegateCustom && [self.delegateCustom respondsToSelector:@selector(dragMethod:)]) {
            [self.delegateCustom dragMethod:YES];
        }
    }else if (distanceBetweenStartAndEnd <= -100.0){
        if (self.delegateCustom && [self.delegateCustom respondsToSelector:@selector(dragMethod:)]) {
            [self.delegateCustom dragMethod:NO];
        }
    }
}

@end
