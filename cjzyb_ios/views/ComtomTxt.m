//
//  ComtomTxt.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ComtomTxt.h"
#import <QuartzCore/QuartzCore.h>

@implementation ComtomTxt

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
    [self.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:6.0f];
    [self.layer setMasksToBounds:YES];
}


@end
