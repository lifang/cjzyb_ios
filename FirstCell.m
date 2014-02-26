//
//  FirstCell.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "FirstCell.h"

#define Head_Size 40.0
#define Insets 4.0

@implementation FirstCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头像
        self.headImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.headImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headImg];
        //关注
        self.focusImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.focusImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.focusImg];
        //评论
        self.commentImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.commentImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.commentImg];
        //昵称from
        self.nameFromLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameFromLab.backgroundColor = [UIColor clearColor];
        self.nameFromLab.textColor = [UIColor colorWithRed:0.2078 green:0.8157 blue:0.5647 alpha:1];
        self.nameFromLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameFromLab];
        //时间
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.timeLab.backgroundColor = [UIColor clearColor];
        self.timeLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
        self.timeLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.timeLab];
        //关注
        self.focusLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.focusLab.backgroundColor = [UIColor clearColor];
        self.focusLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
        self.focusLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.focusLab];
        //评论
        self.commentLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.commentLab.backgroundColor = [UIColor clearColor];
        self.commentLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
        self.commentLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.commentLab];
        //内容
        self.contentLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.contentLab.backgroundColor = [UIColor clearColor];
        self.contentLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
        self.contentLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.contentLab];
        //昵称to
        self.nameToLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameToLab.backgroundColor = [UIColor clearColor];
        self.nameToLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
        self.nameToLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameToLab];
        //回复
        self.huifuLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.huifuLab.backgroundColor = [UIColor clearColor];
        self.huifuLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
        self.huifuLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.huifuLab];
        
    }
    return self;
}


- (void)layoutItemViews {
    self.headImg.frame = CGRectMake(Insets, Insets, Head_Size, Head_Size);
    
    self.nameFromLab.frame = CGRectMake(Insets*2+Head_Size, Insets, , );
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutItemViews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMessageObject:(MessageObject *)aMessage {
    _aMessage = aMessage;
}
@end
