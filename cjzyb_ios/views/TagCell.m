//
//  TagCell.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "TagCell.h"
#define CELL_WIDTH self.contentView.frame.size.width
#define CELL_HEIGHT self.contentView.frame.size.height

@implementation TagCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLab.backgroundColor = [UIColor clearColor];
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLab];
        
        self.selectedBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.selectedBtn addTarget:self action:@selector(selectedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectedBtn];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.selectedBtn.frame = CGRectMake(10, 5, 30, 30);
    self.titleLab.frame = CGRectMake(50, 5, 250, 30);
}
-(void)selectedBtnPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedButton:)]) {
        [self.delegate pressedButton:btn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
