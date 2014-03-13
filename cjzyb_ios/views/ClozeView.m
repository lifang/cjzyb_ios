//
//  ClozeView.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ClozeView.h"

@implementation ClozeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
	[self render];
}
//  This is [[tag]] apple,[[tag]] is a book.Car has [[tag]] wheels.
- (void)render {
    
}
- (void)setText:(NSString*)text {
    _text = text;
}

@end
