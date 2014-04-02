//
//  LHLReplyNotificationCell.m
//  cjzyb_ios
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLReplyNotificationCell.h"

#define LHLTEXT_PADDING 5
#define LHLFONT [UIFont systemFontOfSize:18.0]
#define LHLFONT_FOR_CONTENT [UIFont systemFontOfSize:20.0]
#define LHLCELL_WIDTH self.bounds.size.width
#define LHLCELL_HEIGHT self.bounds.size.height

@interface LHLReplyNotificationCell()
@property (nonatomic,strong) UIView *titleBgView;  //第一行的背景
@property (nonatomic,strong) UIView *buttonBgView;  //按钮背景
@property (nonatomic,strong) UIImageView *imgView;  //头像
@property (nonatomic,strong) UILabel *unnamedLabel;   //"回复"二字
@property (nonatomic,strong) UILabel *myNameLabel;   //我的名字
@property (nonatomic,strong) UILabel *replyerNameLabel;  //回复者的名字
@property (nonatomic,strong) UILabel *timeLabel;   //时间
@property (nonatomic,strong) UITextView *textView;   //内容
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
        _buttonBgView.backgroundColor = [UIColor colorWithRed:182.0/255.0 green:183.0/255.0 blue:184.0/255.0 alpha:1.0];
        _buttonBgView.hidden = YES;
        [self addSubview:_buttonBgView];
        
        //回复按钮
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.backgroundColor = [UIColor clearColor];
        [_replyButton setImage:[UIImage imageNamed:@"replyMessage.png"] forState:UIControlStateNormal];
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
        _imgView.layer.cornerRadius = 13.0;
        [_imgView.layer setMasksToBounds:YES];
        [_contentBgView addSubview:_imgView];
        
        //回复者名字
        self.replyerNameLabel = [[UILabel alloc] init];
        _replyerNameLabel.font = LHLFONT;
        _replyerNameLabel.textColor = [UIColor colorWithRed:21.0/255.0 green:168.0/255.0 blue:95.0/255.0 alpha:1.0];
        [_titleBgView addSubview:_replyerNameLabel];
        
        //"回复"二字
        self.unnamedLabel = [[UILabel alloc] init];
        _unnamedLabel.font = LHLFONT;
        _unnamedLabel.text = @"回复";
        _unnamedLabel.textColor = [UIColor darkGrayColor];
        [_titleBgView addSubview:_unnamedLabel];
        
        //我的名字
        self.myNameLabel = [[UILabel alloc] init];
        _myNameLabel.font = LHLFONT;
        _myNameLabel.textColor = [UIColor colorWithRed:22.0/255.0 green:168.0/255.0 blue:95.0/255.0 alpha:1.0];
        [_titleBgView addSubview:_myNameLabel];
        
        //回复时间
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.font = LHLFONT;
        _timeLabel.textColor = [UIColor grayColor];
        [_titleBgView addSubview:_timeLabel];
        
        //回复内容
        self.textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = LHLFONT_FOR_CONTENT;
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
        
        _imgView.frame = (CGRect){53,34,103,103};
        
        CGRect titleBgFrame = (CGRect){CGRectGetMaxX(_imgView.frame) + 20,34,510,30};
        _titleBgView.frame = titleBgFrame;
        
        
        CGSize size = [Utility getTextSizeWithString:self.replyObject.replyerName withFont:LHLFONT];
        _replyerNameLabel.frame = (CGRect){0,0,size.width + LHLTEXT_PADDING,titleBgFrame.size.height};
        
        size = [Utility getTextSizeWithString:@"回复" withFont:LHLFONT];
        _unnamedLabel.frame = (CGRect){CGRectGetMaxX(_replyerNameLabel.frame) + LHLTEXT_PADDING,0,size.width + LHLTEXT_PADDING,titleBgFrame.size.height};
        
        size = [Utility getTextSizeWithString:self.replyObject.replyTargetName withFont:LHLFONT];
        _myNameLabel.frame = (CGRect){CGRectGetMaxX(_unnamedLabel.frame) + LHLTEXT_PADDING,0,size.width + LHLTEXT_PADDING,titleBgFrame.size.height};
        
        _timeLabel.frame = (CGRect){CGRectGetMaxX(_myNameLabel.frame) + LHLTEXT_PADDING * 2,0,titleBgFrame.size.width - (CGRectGetMaxX(_myNameLabel.frame) + LHLTEXT_PADDING),titleBgFrame.size.height};
        
        size = [Utility getTextSizeWithString:_textView.text withFont: LHLFONT_FOR_CONTENT withWidth:510];
        _textView.frame = (CGRect){titleBgFrame.origin.x - 5,CGRectGetMaxY(titleBgFrame) - 7,510,size.height + 20};
        
        _coverButton.frame = (CGRect){0,0,self.bounds.size};
        [_contentBgView bringSubviewToFront:_coverButton];
    });
}

//应有一个赋值方法
-(void)setInfomations:(ReplyNotificationObject *)reply{
    if (reply != nil) {
        self.replyObject = reply;
        NSString *urlString = [NSString stringWithFormat:@"http://58.240.210.42:3004%@",reply.replyerImageAddress];
        NSURL *url = [NSURL URLWithString:urlString];
        [_imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"systemMessage.png"]];
        _replyerNameLabel.text = reply.replyerName;
        _myNameLabel.text = reply.replyTargetName;
        _textView.text = reply.replyContent;
        _timeLabel.text = reply.replyTime;
        self.isEditing = reply.isEditing;
        
        [self layoutItems];
    }else{
        [Utility errorAlert:@"赋予的reply对象为nil!"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

////图像缓冲
//- (UIImage *)bufferedImageForAddress:(NSString *)address{
//    
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://58.240.210.42:3004%@",address]]];
//    NSMutableDictionary *tempImageDic = [NSMutableDictionary dictionary];
//    [tempImageDic setObject:imageData forKey:address];
//    return nil;
//}

#pragma mark -- 按钮响应方法
//- (void) coverButtonTouchDragInside:(id)sender{
//    NSLog(@"%@",[super class]);
//}

- (void) coverButtonClicked:(id)sender{
    _isEditing = !_isEditing;
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyCell:setIsEditing:)]) {
        [self.delegate replyCell:self setIsEditing:self.isEditing];
    }
    if (_contentBgView.frame.origin.x < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            _contentBgView.frame = (CGRect){0,0,LHLCELL_WIDTH,LHLCELL_HEIGHT};
        } completion:^(BOOL finished) {
            _buttonBgView.hidden = YES;
        }];
    }else{
        _buttonBgView.hidden = NO;
        _contentBgView.frame = (CGRect){-1,0,LHLCELL_WIDTH,LHLCELL_HEIGHT};
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

#pragma  mark property
-(void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    if (isEditing) {
        _buttonBgView.hidden = NO;
        _contentBgView.frame = (CGRect){-1,0,LHLCELL_WIDTH,LHLCELL_HEIGHT};
        _contentBgView.frame = (CGRect){-103,0,LHLCELL_WIDTH,LHLCELL_HEIGHT};
    }else{
        _contentBgView.frame = (CGRect){0,0,LHLCELL_WIDTH,LHLCELL_HEIGHT};
        _buttonBgView.hidden = YES;
    }
}

@end
