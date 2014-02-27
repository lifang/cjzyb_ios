//
//  LHLReplyNotificationCell.m
//  cjzyb_ios
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLReplyNotificationCell.h"

#define LHLTEXT_PADDING 5
#define LHLFONT ([UIFont systemFontOfSize:17.0])

@interface LHLReplyNotificationCell()
@property (nonatomic,strong) UIView *titleBgView;  //第一行的背景
@property (nonatomic,strong) UIImageView *imgView;  //头像
@property (nonatomic,strong) UILabel *myNameLabel;   //我的名字
@property (nonatomic,strong) UILabel *replyerNameLabel;  //回复者的名字
@property (nonatomic,strong) UILabel *timeLabel;   //时间
@property (nonatomic,strong) UITextView *textView;   //内容

@end

@implementation LHLReplyNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleBgView = [[UIView alloc] init];
        _titleBgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleBgView];
        
        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile.png"]];
        _imgView.layer.cornerRadius = 3.0;
        [self addSubview:_imgView];
        
        self.replyerNameLabel = [[UILabel alloc] init];
        _replyerNameLabel.font = LHLFONT;
        _replyerNameLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:120.0/255.0 blue:50.0/255.0 alpha:1.0];
        [_titleBgView addSubview:_replyerNameLabel];
        
        self.myNameLabel = [[UILabel alloc] init];
        _myNameLabel.font = LHLFONT;
        _myNameLabel.textColor = [UIColor blueColor];
        [_titleBgView addSubview:_myNameLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.font = LHLFONT;
        _timeLabel.textColor = [UIColor lightGrayColor];
        [_titleBgView addSubview:_timeLabel];
        
        self.textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = LHLFONT;
        _textView.textColor = [UIColor darkGrayColor];
        [_textView setUserInteractionEnabled:NO];
        [self addSubview:_textView];
        
    }
    return self;
}

-(void)layoutSubviews{
    _imgView.frame = (CGRect){41,38,80,80};
    
    CGRect titleBgFrame = (CGRect){CGRectGetMaxX(_imgView.frame) + 20,38,365,20};
    _titleBgView.frame = titleBgFrame;
    
    
    CGSize size = [Utility getTextSizeWithString:@"崔斯洛夫莫克" withFont:LHLFONT];
    _replyerNameLabel.frame = (CGRect){0,0,size.width,titleBgFrame.size.height};
    
    size = [Utility getTextSizeWithString:[NSString stringWithFormat:@"回复 %@",@"我"] withFont:LHLFONT];
    _myNameLabel.frame = (CGRect){CGRectGetMaxX(_replyerNameLabel.frame) + LHLTEXT_PADDING,0,size.width,titleBgFrame.size.height};
    
    _timeLabel.frame = (CGRect){CGRectGetMaxX(_myNameLabel.frame) + LHLTEXT_PADDING * 2,0,titleBgFrame.size.width - (CGRectGetMaxX(_myNameLabel.frame) + LHLTEXT_PADDING),titleBgFrame.size.height};
    
    size = [Utility getTextSizeWithString:@"哈哈哈哈哈,这个我也知道的,饿饿饿饿,怎么打字还打不满三行,快乐,块三行了,马上就要三行了可以看见效果了,哦也,搞定~~~~~~!!!!!" withFont:LHLFONT withWidth:365];
    _textView.frame = (CGRect){titleBgFrame.origin.x - 5,CGRectGetMaxY(titleBgFrame) - 7,365,size.height + 20};
}

//应有一个赋值方法
-(void)setInfomations{
    _replyerNameLabel.text = @"崔斯洛夫莫克";
    _myNameLabel.text = @"回复 我";
    _textView.text = @"哈哈哈哈哈,这个我也知道的,饿饿饿饿,怎么打字还打不满三行,快乐,块三行了,马上就要三行了可以看见效果了,哦也,搞定~~~~~~!!!!!";
    _timeLabel.text = @"2014/02/15  20:59";
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
