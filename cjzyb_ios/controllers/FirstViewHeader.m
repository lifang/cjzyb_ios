//
//  FirstViewHeader.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "FirstViewHeader.h"

#define Head_Size 102.75
#define Space_Height 30
#define Space_head_text 23.25


#define Insets 10.0
#define Label_Height 20
#define CELL_WIDTH self.frame.size.width
#define CELL_HEIGHT self.frame.size.height
#define Custom_Width  102
#define Button_Size 45.78
#define AnimationDuration 0.2

@interface FirstViewHeader ()
@property (strong, nonatomic) UIButton *focusButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *deleteButton;
@end

@implementation FirstViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.actualContentView = [[UIView alloc]initWithFrame:CGRectZero];
        self.actualContentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.actualContentView];
        
        //头像
        self.headImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.headImg.backgroundColor = [UIColor clearColor];
        [self.headImg.layer setCornerRadius:8.0f];
        [self.headImg.layer setMasksToBounds:YES];
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
        self.nameFromLab.textColor = [UIColor colorWithRed:53/255.0 green:207/255.0 blue:143/255.0 alpha:1];
        self.nameFromLab.font = [UIFont systemFontOfSize:18];
        [self.actualContentView addSubview:self.nameFromLab];
        
        //时间
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.timeLab.backgroundColor = [UIColor clearColor];
        self.timeLab.textColor = [UIColor colorWithRed:144/255.0 green:148/255.0 blue:152/255.0 alpha:1];
        self.timeLab.font = [UIFont systemFontOfSize:18];
        [self.actualContentView addSubview:self.timeLab];
        //关注
        self.focusLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.focusLab.backgroundColor = [UIColor clearColor];
        self.focusLab.textColor = [UIColor colorWithRed:144/255.0 green:148/255.0 blue:152/255.0 alpha:1];
        self.focusLab.font = [UIFont systemFontOfSize:18];
        [self.actualContentView addSubview:self.focusLab];
        //评论
        self.commentLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.commentLab.backgroundColor = [UIColor clearColor];
        self.commentLab.textColor = [UIColor colorWithRed:144/255.0 green:148/255.0 blue:152/255.0 alpha:1];
        self.commentLab.font = [UIFont systemFontOfSize:18];
        [self.actualContentView addSubview:self.commentLab];
        //内容
        self.contentLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.contentLab.backgroundColor = [UIColor clearColor];
        self.contentLab.textColor = [UIColor colorWithRed:144/255.0 green:148/255.0 blue:152/255.0 alpha:1];
        self.contentLab.font = [UIFont systemFontOfSize:20];
        self.contentLab.numberOfLines = 0;
        self.contentLab.lineBreakMode = NSLineBreakByCharWrapping;
        [self.actualContentView addSubview:self.contentLab];
        
        self.contextMenuView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contextMenuView.backgroundColor = [UIColor colorWithRed:0.8235 green:0.8275 blue:0.8314 alpha:1];
        [self insertSubview:self.contextMenuView belowSubview:self.actualContentView];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
}
-(void)setASection:(NSInteger)aSection {
    _aSection = aSection;
    if (_aSection%2==0) {
        self.actualContentView.backgroundColor = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1];
    }else {
        self.actualContentView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    }
}
-(CGSize)getSizeWithString:(NSString *)str{
    UIFont *aFont = [UIFont systemFontOfSize:20];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(CELL_WIDTH-108-Head_Size-Space_head_text, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.coverButton.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
    self.actualContentView.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
    self.contextMenuView.frame = CGRectMake(Custom_Width, 0, CELL_WIDTH, CELL_HEIGHT);
    self.headImg.frame = CGRectMake(54, Space_Height, Head_Size, Head_Size);
    
    self.nameFromLab.frame = CGRectMake(54+Head_Size+Space_head_text, Space_Height, [self.nameFromLab.text sizeWithFont:[UIFont systemFontOfSize:18]].width, Label_Height);
    
    self.timeLab.frame = CGRectMake(self.nameFromLab.frame.origin.x+self.nameFromLab.frame.size.width+Insets, Space_Height, [self.aMessage.messageTime sizeWithFont:[UIFont systemFontOfSize:18]].width, Label_Height);
    
    self.focusImg.frame = CGRectMake(self.timeLab.frame.origin.x+self.timeLab.frame.size.width+Insets*2, Space_Height, Label_Height, Label_Height);
    self.focusLab.frame = CGRectMake(self.focusImg.frame.origin.x+self.focusImg.frame.size.width, Space_Height, [self.aMessage.followCount sizeWithFont:[UIFont systemFontOfSize:18]].width, Label_Height);
    
    self.commentImg.frame = CGRectMake(self.focusLab.frame.origin.x+self.focusLab.frame.size.width+Insets, Space_Height, Label_Height, Label_Height);
    self.commentLab.frame = CGRectMake(self.commentImg.frame.origin.x+self.commentImg.frame.size.width, Space_Height, CELL_WIDTH-self.commentImg.frame.origin.x-self.commentImg.frame.size.width, Label_Height);
    
    if (self.msgStyle == MessageCellStyleMe) {
        self.focusButton.hidden = YES;self.deleteButton.hidden = NO;
        self.commentButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3, Button_Size, Button_Size);
        self.deleteButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3*2+Button_Size, Button_Size, Button_Size);
    }else {
        self.focusButton.hidden = NO;self.deleteButton.hidden = YES;
        self.focusButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3, Button_Size, Button_Size);
        self.commentButton.frame = CGRectMake(CELL_WIDTH-Custom_Width+(Custom_Width-Button_Size)/2, (CELL_HEIGHT-Button_Size*2)/3*2+Button_Size, Button_Size, Button_Size);
    }
    CGSize size = [self getSizeWithString:self.contentLab.text];
    self.contentLab.frame = CGRectMake(54+Head_Size+Space_head_text, Space_Height+Label_Height+Insets, size.width, size.height);
    
    if (self.isSelected) {
        self.actualContentView.frame = CGRectOffset(self.contentView.bounds, 0-Custom_Width, 0);
        self.contextMenuView.frame = CGRectOffset(self.contentView.bounds, 0, 0);
    }else {
        self.actualContentView.frame = CGRectOffset(self.contentView.bounds, 0, 0);
        self.contextMenuView.frame = CGRectOffset(self.contentView.bounds, Custom_Width, 0);
    }
    
}

-(void)setAMessage:(MessageObject *)aMessage {
    _aMessage = aMessage;
    _nameFromLab.text = _aMessage.name;
    _timeLab.text = _aMessage.messageTime;
    _focusLab.text = _aMessage.followCount;
    _commentLab.text = _aMessage.replyCount;
    _contentLab.text = _aMessage.messageContent;
    
    if (_aMessage.isFollow == YES) {
        [self.focusButton setImage:[UIImage imageNamed:@"focusBtn_active"] forState:UIControlStateNormal];
    }else {
        [self.focusButton setImage:[UIImage imageNamed:@"focusBtn"] forState:UIControlStateNormal];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://58.240.210.42:3004%@",aMessage.headUrl]];
    [self.headImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commentBtn"]];
}

#pragma mark -- 按钮及其点击事件
- (UIButton *)coverButton {
    if (!_coverButton) {
        CGRect frame = CGRectMake(0, 0, Button_Size, Button_Size);
        _coverButton = [[UIButton alloc] initWithFrame:frame];
        [self.actualContentView addSubview:_coverButton];
        [_coverButton addTarget:self action:@selector(coverButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

- (void)coverButtonTapped {
    if ([self.delegate respondsToSelector:@selector(contextMenuHeaderDidSelectCoverOption:)]) {
        [self.delegate contextMenuHeaderDidSelectCoverOption:self];
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
    if ([self.delegate respondsToSelector:@selector(contextMenuHeaderDidSelectFocusOption:)]) {
        [self.delegate contextMenuHeaderDidSelectFocusOption:self];
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
    if ([self.delegate respondsToSelector:@selector(contextMenuHeaderDidSelectCommentOption:)]) {
        [self.delegate contextMenuHeaderDidSelectCommentOption:self];
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
    if ([self.delegate respondsToSelector:@selector(contextMenuHeaderDidSelectDeleteOption:)]) {
        [self.delegate contextMenuHeaderDidSelectDeleteOption:self];
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
