//
//  LeftTabBarItem.m
//  cjzyb_ios
//
//  Created by david on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LeftTabBarItem.h"
@interface LeftTabBarItem()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagTitleLabel;
@end
@implementation LeftTabBarItem

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

#pragma mark property
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    [self.backImageView setHidden:!isSelected];
    [self setUserInteractionEnabled:!isSelected];
}
#pragma mark --
@end
