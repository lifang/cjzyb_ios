//
//  MyPageControl.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "MyPageControl.h"

@implementation MyPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imagePageStateNormal = [UIImage imageNamed:@"card_normal"];
        self.imagePageStateHighlighted = [UIImage imageNamed:@"card_highted"];
    }
    return self;
}
- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)updateDots { // 更新显示所有的点按钮
    
    if (self.imagePageStateNormal || self.imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            UIView *dot =[self.subviews objectAtIndex:i];
            [dot setBackgroundColor:[UIColor colorWithPatternImage:self.currentPage == i ? self.imagePageStateHighlighted : self.imagePageStateNormal]];
        }
    }
}

@end
