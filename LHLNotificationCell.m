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
    [self.imgView.layer setCornerRadius:3.0];

    self.textView.delegate = self;
        
    [self makeSideButtons];
}

- (void)makeSideButtons{
    if (!self.sideView) {
        self.sideView = [[UIView alloc] initWithFrame:(CGRect){self.frame.size.width - 80,0,80,self.frame.size.height}];
        self.sideView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView insertSubview:self.sideView belowSubview:self.contentBgView];
        
//        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed: @"bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
//        bgImageView.frame = (CGRect){0,0,self.sideView.frame.size};
//        [self.sideView addSubview:bgImageView];

        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"trash_icon.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.sideView addSubview:deleteButton];
        deleteButton.frame = (CGRect){0,0,self.sideView.frame.size};
    }
}

-(void)deleteButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:deleteButtonClicked:)]) {
        [self.delegate cell:self deleteButtonClicked:sender];
    }
}

#pragma mark TextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
//    self.textViewHeightConstraint.constant = self.textView.contentSize.height;
    self.cellHeight = self.textView.contentSize.height + 28 + 20;
    [self setNeedsUpdateConstraints];
    if(self.delegate && [self.delegate respondsToSelector:@selector(refreshHeightForCell:)]){
        [self.delegate refreshHeightForCell:self];
    }
}


- (IBAction)coverButtonClicked:(id)sender {
    if (self.contentBgView.frame.origin.x < -1) {
        self.contentBgView.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.25 animations:^{
            self.contentBgView.frame = self.bounds;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        self.contentBgView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        [UIView animateWithDuration:0.25 animations:^{
            self.contentBgView.frame = (CGRect){-80,0,self.bounds.size};
        } completion:^(BOOL finished) {
            
        }];
    }
}
@end
