//
//  FirstCell.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "FirstCell.h"

#define Head_Size 80.0
#define Insets 10.0
#define Label_Height 20
#define CELL_WIDTH self.contentView.frame.size.width
#define CELL_HEIGHT self.contentView.frame.size.height
#define Custom_Width  80
#define Button_Size 50
#define AnimationDuration 0.2
@interface FirstCell ()
@property (strong, nonatomic) UIButton *focusButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *deleteButton;
@end


@implementation FirstCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.actualContentView = [[UIView alloc]initWithFrame:CGRectZero];
    self.actualContentView.backgroundColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1];
    [self.contentView addSubview:self.actualContentView];
    
    self.lineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"divider"]];
    self.lineImageView.backgroundColor = [UIColor clearColor];
    [self.actualContentView addSubview:self.lineImageView];
    
    //头像
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.headImg.backgroundColor = [UIColor clearColor];
    [self.actualContentView addSubview:self.headImg];
    
    //昵称from
    self.nameFromLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameFromLab.backgroundColor = [UIColor clearColor];
    self.nameFromLab.textColor = [UIColor whiteColor];
    self.nameFromLab.font = [UIFont systemFontOfSize:14];
    [self.actualContentView addSubview:self.nameFromLab];
    //时间
    self.timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.timeLab.backgroundColor = [UIColor clearColor];
    self.timeLab.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
    self.timeLab.font = [UIFont systemFontOfSize:14];
    [self.actualContentView addSubview:self.timeLab];
    
    //内容
    self.contentLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.contentLab.backgroundColor = [UIColor clearColor];
    self.contentLab.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
    self.contentLab.font = [UIFont systemFontOfSize:18];
    self.contentLab.numberOfLines = 0;
    [self.actualContentView addSubview:self.contentLab];
    //昵称to
    self.nameToLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameToLab.backgroundColor = [UIColor clearColor];
    self.nameToLab.textColor = [UIColor whiteColor];
    self.nameToLab.font = [UIFont systemFontOfSize:14];
    [self.actualContentView addSubview:self.nameToLab];
    //回复
    self.huifuLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.huifuLab.backgroundColor = [UIColor clearColor];
    self.huifuLab.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
    self.huifuLab.font = [UIFont systemFontOfSize:14];
    self.huifuLab.text = @"回复";
    [self.actualContentView addSubview:self.huifuLab];
    //
    self.arrowImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.arrowImg.backgroundColor = [UIColor clearColor];
    self.arrowImg.image = [UIImage imageNamed:@"arrowImg"];
    [self.actualContentView addSubview:self.arrowImg];
    
    self.contextMenuView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contextMenuView.backgroundColor = [UIColor colorWithRed:190/255 green:191/255 blue:192/255 alpha:1];
    [self.contentView insertSubview:self.contextMenuView belowSubview:self.actualContentView];

}

-(void)handleTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSelectCoverOption:)]) {
        [self.delegate contextMenuCellDidSelectCoverOption:self];
    }
}
#pragma mark -- Public
-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
}


-(CGSize)getSizeWithString:(NSString *)str{
    UIFont *aFont = [UIFont systemFontOfSize:18];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(CELL_WIDTH-Insets*4-Head_Size, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (void)layoutItemViews {
    self.coverButton.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
    self.actualContentView.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
    self.contextMenuView.frame = CGRectMake(Custom_Width, 0, CELL_WIDTH, CELL_HEIGHT);
    self.headImg.frame = CGRectMake(Insets, Insets*2, Head_Size, Head_Size);
    
    self.nameFromLab.frame = CGRectMake(Insets*2+Head_Size, Insets*2, [self.nameFromLab.text sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);

    self.arrowImg.frame = CGRectMake(Insets, Insets/2, Insets, Insets);
    
    self.huifuLab.frame = CGRectMake(self.nameFromLab.frame.origin.x+self.nameFromLab.frame.size.width, Insets*2, [self.huifuLab.text sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);
    
    self.nameToLab.frame = CGRectMake(self.huifuLab.frame.origin.x+self.huifuLab.frame.size.width, Insets*2, [self.aReplyMsg.reciver_name sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);
    
    self.timeLab.frame = CGRectMake(self.nameToLab.frame.origin.x+self.nameToLab.frame.size.width+Insets, Insets*2, [self.aReplyMsg.created_at sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);

    if (self.msgStyle == ReplyMessageCellStyleMe) {
        self.focusButton.hidden = YES;self.deleteButton.hidden = NO;
        self.commentButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3, Button_Size, Button_Size);
        self.deleteButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3*2+Button_Size, Button_Size, Button_Size);
    }else {
        self.focusButton.hidden = NO;self.deleteButton.hidden = YES;
        self.focusButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3, Button_Size, Button_Size);
        self.commentButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3*2+Button_Size, Button_Size, Button_Size);
    }
    
    CGSize size = [self getSizeWithString:self.contentLab.text];
    self.contentLab.frame = CGRectMake(Insets*2+Head_Size, Insets*3+Label_Height, size.width, size.height);
    
    self.lineImageView.frame = CGRectMake(Insets,CELL_HEIGHT-1,CELL_WIDTH-Insets,1);
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutItemViews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setAReplyMsg:(ReplyMessageObject *)aReplyMsg {
    _aReplyMsg = aReplyMsg;

    _nameFromLab.text = _aReplyMsg.sender_name;
    _timeLab.text = _aReplyMsg.created_at;
    _contentLab.text = _aReplyMsg.content;
    _nameToLab.text = _aReplyMsg.reciver_name;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://58.240.210.42:3004%@",_aReplyMsg.sender_avatar_url]];
    [self.headImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"focusBtn_active"]];
    
    if (_aReplyMsg.isFollow == YES) {
        [self.focusButton setImage:[UIImage imageNamed:@"focusBtn_active"] forState:UIControlStateNormal];
    }else {
        [self.focusButton setImage:[UIImage imageNamed:@"focusBtn"] forState:UIControlStateNormal];
    }
}
#pragma mark -- 按钮及其点击事件
- (UIButton *)coverButton {
    if (!_coverButton) {
        CGRect frame = CGRectMake(0, 0, Button_Size, Button_Size);
        _coverButton = [[UIButton alloc] initWithFrame:frame];
        [self.actualContentView addSubview:_coverButton];
        _coverButton.tag = self.idxPath.row;
        [_coverButton addTarget:self action:@selector(coverButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

- (void)coverButtonTapped {
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSelectCoverOption:)]) {
        [self.delegate contextMenuCellDidSelectCoverOption:self];
    }
}

- (UIButton *)focusButton
{
    if (!_focusButton) {
        CGRect frame = CGRectMake(0, 0, Button_Size, Button_Size);
        _focusButton = [[UIButton alloc] initWithFrame:frame];
        [self.contextMenuView addSubview:_focusButton];
        [_focusButton addTarget:self action:@selector(focusButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusButton;
}

- (void)focusButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSelectFocusOption:)]) {
        [self.delegate contextMenuCellDidSelectFocusOption:self];
    }
}

- (UIButton *)commentButton
{
    if (!_commentButton) {
        CGRect frame = CGRectMake(0, 0, Button_Size, Button_Size);
        _commentButton = [[UIButton alloc] initWithFrame:frame];
        [_commentButton setImage:[UIImage imageNamed:@"commentBtn"] forState:UIControlStateNormal];
        [self.contextMenuView addSubview:_commentButton];
        [_commentButton addTarget:self action:@selector(commentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (void)commentButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSelectCommentOption:)]) {
        [self.delegate contextMenuCellDidSelectCommentOption:self];
    }
}


- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        CGRect frame = CGRectMake(0, 0, Button_Size, Button_Size);
        _deleteButton = [[UIButton alloc] initWithFrame:frame];
        [_deleteButton setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
        [self.contextMenuView addSubview:_deleteButton];
        [_deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (void)deleteButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSelectDeleteOption:)]) {
        [self.delegate contextMenuCellDidSelectDeleteOption:self];
    }
}

-(void)open {
    [UIView animateWithDuration:AnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.actualContentView.frame = CGRectOffset(self.contentView.bounds, 0-Custom_Width, 0);
                         self.contextMenuView.frame = CGRectOffset(self.contentView.bounds, 0, 0);
                     }
                     completion:^(BOOL finished) {
                         self.isSelected = YES;
                     }
     ];
}
-(void)close {
    [UIView animateWithDuration:AnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.actualContentView.frame = CGRectOffset(self.contentView.bounds, 0, 0);
                         self.contextMenuView.frame = CGRectOffset(self.contentView.bounds, Custom_Width, 0);
                     }
                     completion:^(BOOL finished) {
                         self.isSelected = NO;
                     }
     ];

}
@end
