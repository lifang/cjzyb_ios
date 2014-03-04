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
@property (assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL shouldDisplayContextMenuView;
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
    self.actualContentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.actualContentView];
    //头像
    self.headImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.headImg.backgroundColor = [UIColor clearColor];
    [self.actualContentView addSubview:self.headImg];
    //关注
    self.focusImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.focusImg.backgroundColor = [UIColor clearColor];
    self.focusImg.image = [UIImage imageNamed:@"focus"];
    [self.actualContentView addSubview:self.focusImg];
    //评论
    self.commentImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.commentImg.backgroundColor = [UIColor clearColor];
    self.commentImg.image = [UIImage imageNamed:@"comment"];
    [self.actualContentView addSubview:self.commentImg];
    //昵称from
    self.nameFromLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameFromLab.backgroundColor = [UIColor clearColor];
    self.nameFromLab.textColor = [UIColor colorWithRed:0.2078 green:0.8157 blue:0.5647 alpha:1];
    self.nameFromLab.font = [UIFont systemFontOfSize:14];
    [self.actualContentView addSubview:self.nameFromLab];
    //时间
    self.timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.timeLab.backgroundColor = [UIColor clearColor];
    self.timeLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
    self.timeLab.font = [UIFont systemFontOfSize:14];
    [self.actualContentView addSubview:self.timeLab];
    //关注
    self.focusLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.focusLab.backgroundColor = [UIColor clearColor];
    self.focusLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
    self.focusLab.font = [UIFont systemFontOfSize:14];
    [self.actualContentView addSubview:self.focusLab];
    //评论
    self.commentLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commentLab.backgroundColor = [UIColor clearColor];
    self.commentLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
    self.commentLab.font = [UIFont systemFontOfSize:14];
    [self.actualContentView addSubview:self.commentLab];
    //内容
    self.contentLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.contentLab.backgroundColor = [UIColor clearColor];
    self.contentLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
    self.contentLab.font = [UIFont systemFontOfSize:18];
    self.contentLab.numberOfLines = 0;
    [self.actualContentView addSubview:self.contentLab];
    //昵称to
    self.nameToLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.nameToLab.backgroundColor = [UIColor clearColor];
    self.nameToLab.textColor = [UIColor colorWithRed:0.2078 green:0.8157 blue:0.5647 alpha:1];
    self.nameToLab.font = [UIFont systemFontOfSize:14];
    [self.actualContentView addSubview:self.nameToLab];
    //回复
    self.huifuLab = [[UILabel alloc]initWithFrame:CGRectZero];
    self.huifuLab.backgroundColor = [UIColor clearColor];
    self.huifuLab.textColor = [UIColor colorWithRed:0.4392 green:0.4431 blue:0.451 alpha:1];
    self.huifuLab.font = [UIFont systemFontOfSize:14];
    self.huifuLab.text = @"回复";
    [self.actualContentView addSubview:self.huifuLab];
    //
    self.arrowImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.arrowImg.backgroundColor = [UIColor clearColor];
    self.arrowImg.image = [UIImage imageNamed:@"arrowImg"];
    [self.actualContentView addSubview:self.arrowImg];
    
    self.contextMenuView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contextMenuView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView insertSubview:self.contextMenuView belowSubview:self.actualContentView];
    self.shouldDisplayContextMenuView = NO;

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
    
    
    if (self.msgType == MessageTypeSend) {

        self.timeLab.frame = CGRectMake(self.nameFromLab.frame.origin.x+self.nameFromLab.frame.size.width+Insets, Insets*2, [self.aMessage.messageTime sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);
        
        self.focusImg.frame = CGRectMake(self.timeLab.frame.origin.x+self.timeLab.frame.size.width+Insets*2, Insets*2, Label_Height, Label_Height);
        self.focusLab.frame = CGRectMake(self.focusImg.frame.origin.x+self.focusImg.frame.size.width, Insets*2, [self.aMessage.followCount sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);
        
        self.commentImg.frame = CGRectMake(self.focusLab.frame.origin.x+self.focusLab.frame.size.width+Insets, Insets*2, Label_Height, Label_Height);
        self.commentLab.frame = CGRectMake(self.commentImg.frame.origin.x+self.commentImg.frame.size.width, Insets*2, [self.aMessage.replyCount sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);
        
        if (self.msgStyle == MessageCellStyleMe) {
            self.focusButton.hidden = YES;self.deleteButton.hidden = NO;
            self.commentButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3, Button_Size, Button_Size);
            self.deleteButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3*2+Button_Size, Button_Size, Button_Size);
        }else {
            self.focusButton.hidden = NO;self.deleteButton.hidden = YES;
            self.focusButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3, Button_Size, Button_Size);
            self.commentButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3*2+Button_Size, Button_Size, Button_Size);
        }
        
    }else {
        self.arrowImg.frame = CGRectMake(Insets, Insets/2, Insets, Insets);
        
        self.huifuLab.frame = CGRectMake(self.nameFromLab.frame.origin.x+self.nameFromLab.frame.size.width, Insets*2, [self.huifuLab.text sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);
        
        self.nameToLab.frame = CGRectMake(self.huifuLab.frame.origin.x+self.huifuLab.frame.size.width, Insets*2, [self.aReplyMsg.reciver_name sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);
        
        self.timeLab.frame = CGRectMake(self.nameToLab.frame.origin.x+self.nameToLab.frame.size.width+Insets, Insets*2, [self.aReplyMsg.created_at sizeWithFont:[UIFont systemFontOfSize:14]].width, Label_Height);
    }
    CGSize size = [self getSizeWithString:self.contentLab.text];
    self.contentLab.frame = CGRectMake(Insets*2+Head_Size, Insets*3+Label_Height, size.width, size.height);
    
    
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutItemViews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.contextMenuHidden) {
        self.contextMenuView.hidden = YES;
        [super setSelected:selected animated:animated];
    }
}

-(void)setAMessage:(MessageObject *)aMessage {
    _aMessage = aMessage;
    
    self.nameToLab.hidden = YES;
    self.huifuLab.hidden = YES;
    
    self.focusImg.hidden = NO;self.focusLab.hidden = NO;
    self.commentImg.hidden = NO; self.commentLab.hidden = NO;
    
    self.arrowImg.hidden = YES;
    
    _nameFromLab.text = _aMessage.name;
    _timeLab.text = _aMessage.messageTime;
    _focusLab.text = _aMessage.followCount;
    _commentLab.text = _aMessage.replyCount;
    _contentLab.text = _aMessage.messageContent;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.250:3004%@",aMessage.headUrl]];
    [self.headImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commentBtn"]];
}

-(void)setAReplyMsg:(ReplyMessageObject *)aReplyMsg {
    _aReplyMsg = aReplyMsg;
    
    self.nameToLab.hidden = NO;
    self.huifuLab.hidden = NO;
    
    self.focusImg.hidden = YES;self.focusLab.hidden = YES;
    self.commentImg.hidden = YES; self.commentLab.hidden = YES;
    
    self.arrowImg.hidden = NO;
    
    _nameFromLab.text = _aReplyMsg.sender_name;
    _timeLab.text = _aReplyMsg.created_at;
    _contentLab.text = _aReplyMsg.content;
    _nameToLab.text = _aReplyMsg.reciver_name;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.250:3004%@",_aReplyMsg.sender_avatar_url]];
    [self.headImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commentBtn"]];
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
        [_focusButton setImage:[UIImage imageNamed:@"focusBtn"] forState:UIControlStateNormal];
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
#warning 判断是否关注过
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
