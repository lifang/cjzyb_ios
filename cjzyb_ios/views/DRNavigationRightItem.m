//
//  DRNavigationRightItem.m
//  cjzyb_ios
//
//  Created by david on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRNavigationRightItem.h"
@interface DRNavigationRightItem()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation DRNavigationRightItem

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

@end
