//
//  CardFirstView.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardFirstView.h"

@implementation CardFirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

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

-(IBAction)txtButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedTxtBtn:)]) {
        [self.delegate pressedTxtBtn:self.txtBtn];
    }
}
@end
