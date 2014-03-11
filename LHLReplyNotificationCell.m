//
//  LHLReplyNotificationCell.m
//  cjzyb_ios
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLReplyNotificationCell.h"

#define LHLTEXT_PADDING 5
#define LHLFONT [UIFont systemFontOfSize:17.0]
#define LHLCELL_WIDTH self.bounds.size.width
#define LHLCELL_HEIGHT self.bounds.size.height

@interface LHLReplyNotificationCell()
@property (nonatomic,strong) UIView *contentBgView;  //头像,名字,内容等的背景
@property (nonatomic,strong) UIView *titleBgView;  //第一行的背景
@property (nonatomic,strong) UIView *buttonBgView;  //按钮背景
@property (nonatomic,strong) UIImageView *imgView;  //头像
@property (nonatomic,strong) UILabel *myNameLabel;   //我的名字
@property (nonatomic,strong) UILabel *replyerNameLabel;  //回复者的名字
@property (nonatomic,strong) UILabel *timeLabel;   //时间
@property (nonatomic,strong) LHLTextView *textView;   //内容
@property (nonatomic,strong) UIButton *coverButton;  //覆盖CELL的按钮
@property (nonatomic,strong) UIButton *replyButton;   //回复消息按钮
@property (nonatomic,strong) UIButton *deleteButton;  //删除消息按钮
@end

@implementation LHLReplyNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //按钮背景
        self.buttonBgView = [[UIView alloc] init];
        _buttonBgView.backgroundColor = [UIColor colorWithRed:177.0/255.0 green:178.0/255.0 blue:179.0/255.0 alpha:1.0];
        _buttonBgView.hidden = YES;
        [self addSubview:_buttonBgView];
        
        //回复按钮
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.backgroundColor = [UIColor clearColor];
        [_replyButton setImage:[UIImage imageNamed:@"smile.png"] forState:UIControlStateNormal];
        [_replyButton addTarget:self action:@selector(rreplyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonBgView addSubview:_replyButton];
        
        //删除按钮
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = [UIColor clearColor];
        [_deleteButton setImage:[UIImage imageNamed:@"trash_icon.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(ddeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonBgView addSubview:_deleteButton];
        
        //主要内容背景
        self.contentBgView = [[UIView alloc] init];
        _contentBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentBgView];
//        [self.contentView bringSubviewToFront:_contentBgView];
        
        //标题背景
        self.titleBgView = [[UIView alloc] init];
        _titleBgView.backgroundColor = [UIColor clearColor];
        [_contentBgView addSubview:_titleBgView];
        
        //头像
        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile.png"]];
        _imgView.layer.cornerRadius = 3.0;
        [_contentBgView addSubview:_imgView];
        
        //回复者名字
        self.replyerNameLabel = [[UILabel alloc] init];
        _replyerNameLabel.font = LHLFONT;
        _replyerNameLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:120.0/255.0 blue:50.0/255.0 alpha:1.0];
        [_titleBgView addSubview:_replyerNameLabel];
        
        //我的名字
        self.myNameLabel = [[UILabel alloc] init];
        _myNameLabel.font = LHLFONT;
        _myNameLabel.textColor = [UIColor blueColor];
        [_titleBgView addSubview:_myNameLabel];
        
        //回复时间
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.font = LHLFONT;
        _timeLabel.textColor = [UIColor lightGrayColor];
        [_titleBgView addSubview:_timeLabel];
        
        //回复内容
        self.textView = [[LHLTextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = LHLFONT;
        _textView.textColor = [UIColor darkGrayColor];
        [_textView setUserInteractionEnabled:NO];
        [_contentBgView addSubview:_textView];
        
        //覆盖按钮
        self.coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverButton.backgroundColor = [UIColor clearColor];
        [_coverButton addTarget:self action:@selector(coverButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentBgView addSubview:_coverButton];
    }
    [self layoutItems];
    return self;
}

-(void)layoutItems{
    dispatch_async(dispatch_get_main_queue(), ^{
        _buttonBgView.frame = (CGRect){LHLCELL_WIDTH - 103,0,103,LHLCELL_HEIGHT};
        
        _replyButton.frame = (CGRect){0,0,_buttonBgView.frame.size.width,_buttonBgView.frame.size.height / 2};
        
        _deleteButton.frame = (CGRect){0,_buttonBgView.frame.size.height / 2,_buttonBgView.frame.size.width,_buttonBgView.frame.size.height / 2};
        
        _contentBgView.frame = (CGRect){0,0,self.bounds.size};
        
        _imgView.frame = (CGRect){53,50,103,103};
        
        CGRect titleBgFrame = (CGRect){CGRectGetMaxX(_imgView.frame) + 20,50,510,30};
        _titleBgView.frame = titleBgFrame;
        
        
        CGSize size = [Utility getTextSizeWithString:@"崔斯洛夫莫克" withFont:LHLFONT];
        _replyerNameLabel.frame = (CGRect){0,0,size.width,titleBgFrame.size.height};
        
        size = [Utility getTextSizeWithString:[NSString stringWithFormat:@"回复 %@",@"我"] withFont:LHLFONT];
        _myNameLabel.frame = (CGRect){CGRectGetMaxX(_replyerNameLabel.frame) + LHLTEXT_PADDING,0,size.width,titleBgFrame.size.height};
        
        _timeLabel.frame = (CGRect){CGRectGetMaxX(_myNameLabel.frame) + LHLTEXT_PADDING * 2,0,titleBgFrame.size.width - (CGRectGetMaxX(_myNameLabel.frame) + LHLTEXT_PADDING),titleBgFrame.size.height};
        
        size = [Utility getTextSizeWithString:_textView.text withFont: LHLFONT withWidth:510];
        _textView.frame = (CGRect){titleBgFrame.origin.x - 5,CGRectGetMaxY(titleBgFrame) - 7,510,size.height + 20};
        
        _coverButton.frame = (CGRect){0,0,self.bounds.size};
        [_contentBgView bringSubviewToFront:_coverButton];
    });
}

//应有一个赋值方法
-(void)setInfomations:(ReplyNotificationObject *)reply{
    if (reply != nil) {
        self.replyObject = reply;
        
        _replyerNameLabel.text = reply.replyerName;
        _myNameLabel.text = @"回复 我";
        _textView.text = reply.replyContent;
        _timeLabel.text = reply.replyTime;
        
        [self layoutIfNeeded];
    }else{
        [Utility errorAlert:@"赋予的reply对象为nil!"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 按钮响应方法

- (void) coverButtonClicked:(id)sender{
    if (_contentBgView.frame.origin.x < 0) {
        _contentBgView.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.25 animations:^{
            _contentBgView.frame = (CGRect){0,0,LHLCELL_WIDTH,LHLCELL_HEIGHT};
        } completion:^(BOOL finished) {
            _buttonBgView.hidden = YES;
        }];
    }else{
        _buttonBgView.hidden = NO;
        _contentBgView.frame = (CGRect){-1,0,LHLCELL_WIDTH,LHLCELL_HEIGHT};
        _contentBgView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        [UIView animateWithDuration:0.25 animations:^{
            _contentBgView.frame = (CGRect){-103,0,LHLCELL_WIDTH,LHLCELL_HEIGHT};
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void) rreplyButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyCell:replyButtonClicked:)]) {
        [self.delegate replyCell:self replyButtonClicked:sender];
    }
}

- (void) ddeleteButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyCell:deleteButtonClicked:)]) {
        [self.delegate replyCell:self deleteButtonClicked:sender];
    }
}

@end
