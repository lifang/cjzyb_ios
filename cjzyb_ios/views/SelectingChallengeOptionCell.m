//
//  SelectingChallengeOptionCell.m
//  cjzyb_ios
//
//  Created by lhl0033 on 14-3-9.
//  Copyright (c) 2014年 david. All rights reserved.
//
#define FONT [UIFont systemFontOfSize:40.0]
#define ABCDWIDTH 54.0
#define PADDING 25.0

#import "SelectingChallengeOptionCell.h"
@interface SelectingChallengeOptionCell()
@property (strong,nonatomic) UIView *optionBackgroundView;  //背景
@property (strong,nonatomic) UILabel *abcdLabel;
@property (strong,nonatomic) UILabel *optionLabel;
@property (strong,nonatomic) UIButton *optionButton;
@end

@implementation SelectingChallengeOptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.optionBackgroundView = [[UIView alloc] init];
        _optionBackgroundView.backgroundColor = [UIColor whiteColor];
        _optionBackgroundView.layer.cornerRadius = 8.0;
        _optionBackgroundView.layer.borderWidth = 2.0;
        _optionBackgroundView.layer.borderColor = _optionBackgroundView.backgroundColor.CGColor;
        [self addSubview:_optionBackgroundView];
        
        _abcdLabel = [[UILabel alloc] init];
        _abcdLabel.backgroundColor = [UIColor greenColor];
        _abcdLabel.layer.cornerRadius = 4.0;
        _abcdLabel.font = [UIFont systemFontOfSize:35.0];
        _abcdLabel.textColor = [UIColor whiteColor];
        _abcdLabel.textAlignment = NSTextAlignmentCenter;
        [_optionBackgroundView addSubview:_abcdLabel];
        
        _optionLabel = [[UILabel alloc] init];
        _optionLabel.backgroundColor = [UIColor clearColor];
        _optionLabel.textColor = [UIColor blackColor];
        _optionLabel.font = FONT;
        _optionLabel.textAlignment = NSTextAlignmentCenter;
        [_optionBackgroundView addSubview:_optionLabel];
        
        _optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _optionButton.backgroundColor = [UIColor clearColor];
        [_optionButton addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_optionBackgroundView addSubview:_optionButton];
        
        self.optionSelected = NO;
    }
    return self;
}

-(void)layoutSubviews{
    CGFloat cellHeight = 78.0;
    
    _optionBackgroundView.frame = (CGRect){0,0,3 * PADDING + self.maxLabelWidth + ABCDWIDTH,cellHeight};
    
    _abcdLabel.frame = (CGRect){PADDING,(cellHeight - ABCDWIDTH ) / 2,ABCDWIDTH,ABCDWIDTH};
    
    _optionLabel.frame = (CGRect){2 * PADDING + ABCDWIDTH,0,self.maxLabelWidth + PADDING ,cellHeight};
    
    _optionButton.frame = (CGRect){0,0,_optionBackgroundView.frame.size};
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)optionButtonClicked:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectingCell:clickedForSelecting:)]) {
        self.optionSelected = !self.optionSelected;
        [self.delegate selectingCell:self clickedForSelecting:self.optionSelected];
    }
}



#pragma mark property
-(void)setIndexPath:(NSIndexPath *)indexPath{
    self.abcdLabel.text = [NSString stringWithFormat:@"%c",(char)('A' + indexPath.row)];
    _indexPath = indexPath;
}

-(void)setOptionString:(NSString *)optionString{
    _optionString = optionString;
    self.optionLabel.text = optionString;
    [self setNeedsLayout];
}

-(void)setOptionSelected:(BOOL)optionSelected{
    _optionSelected = optionSelected;
    if (optionSelected) {
        self.optionBackgroundView.layer.borderColor = [UIColor greenColor].CGColor;
    }else{
        self.optionBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
