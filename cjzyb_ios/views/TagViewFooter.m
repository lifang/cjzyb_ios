//
//  TagViewFooter.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TagViewFooter.h"

@implementation TagViewFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coverBt = [UIButton buttonWithType:UIButtonTypeCustom];
        self.coverBt.backgroundColor = [UIColor clearColor];
        self.coverBt.frame = frame;
        [self addSubview:self.coverBt];
        [self.coverBt addTarget:self action:@selector(cellSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)cellSelected{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailHeader:)]) {
        [self.delegate detailHeader:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
