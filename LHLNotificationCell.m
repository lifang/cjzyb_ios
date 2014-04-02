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

}

- (void)initCell{
    [self.imgView.layer setCornerRadius:3.0];
    
    [self.coverButton addTarget:self action:@selector(coverButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self makeSideButtons];
}

- (void)makeSideButtons{
    if (!self.sideView) {
        self.sideView = [[UIView alloc] initWithFrame:(CGRect){self.frame.size.width - 103,0,103,self.frame.size.height}];
        self.sideView.backgroundColor = [UIColor colorWithRed:182.0/255.0 green:183.0/255.0 blue:184.0/255.0 alpha:1.0];
        [self.contentView insertSubview:self.sideView belowSubview:self.contentBgView];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"trash_icon.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.sideView addSubview:deleteButton];
        deleteButton.frame = (CGRect){0,0,self.sideView.frame.size};
    }
}

//为cell赋值 ,textView自动增长
-(void)setNotificationObject:(NotificationObject *)noti{
    if (noti != nil) {
        self.textView.text = noti.notiContent;
        self.textView.frame = (CGRect){self.textView.frame.origin,self.textView.frame.size.width,self.textView.contentSize.height + 20};
        self.timeLabel.text = noti.notiTime;
        self.isEditing = noti.isEditing;
    }
}

-(void)deleteButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:deleteButtonClicked:)]) {
        [self.delegate cell:self deleteButtonClicked:sender];
    }
}


- (void)coverButtonClicked:(id)sender {
    _isEditing = !_isEditing;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:setIsEditing:)]) {
        [self.delegate cell:self setIsEditing:_isEditing];
    }
    if (self.contentBgView.frame.origin.x < -1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.contentBgView.frame = self.bounds;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.contentBgView.frame = (CGRect){-103,0,self.bounds.size};
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark property
-(void) setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    if (isEditing) {
        self.contentBgView.frame = (CGRect){-103,0,self.bounds.size};
    }else{
        self.contentBgView.frame = self.bounds;
    }
}
@end
