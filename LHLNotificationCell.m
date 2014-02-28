//
//  LHLNotificationCell.m
//  cjzyb_ios
//
//  Created by apple on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLNotificationCell.h"

@implementation LHLNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell{
    [self.imgView.layer setCornerRadius:4.0];
    
    //载入数据
//    self.textView.text = @"xxx";
    self.textView.delegate = self;
    
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = self.scrollView.frame;
    [self.scrollView setContentSize:(CGSize){680,rect.size.height}]; //此处宽度暂时写死
}

- (void)makeSideButtons{
    if (!self.sideView) {
        self.sideView = [[UIView alloc] initWithFrame:(CGRect){600,0,80,self.frame.size.height}];
        self.sideView.backgroundColor = [UIColor lightGrayColor];
        [self.scrollView addSubview:self.sideView];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed: @"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
        bgImageView.frame = (CGRect){0,0,self.sideView.frame.size};
        [self.sideView addSubview:bgImageView];

        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"trash_icon.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.sideView addSubview:deleteButton];
        deleteButton.frame = (CGRect){0,0,self.sideView.frame.size};
    }
}

-(void)deleteButtonClicked:(UIButton *)sender{
    
}

#pragma mark TextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    self.textViewHeightConstraint.constant = self.textView.contentSize.height;
    self.cellHeight = self.textView.contentSize.height + 28 + 20;
    [self setNeedsUpdateConstraints];
    if(self.delegate && [self.delegate respondsToSelector:@selector(refreshHeightForCell:)]){
        [self.delegate refreshHeightForCell:self];
    }
}


@end
