//
//  FirstViewHeader.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObject.h"

@protocol FirstViewHeaderDelegate;
@interface FirstViewHeader : UITableViewHeaderFooterView

@property (nonatomic,assign) id<FirstViewHeaderDelegate>delegate;
@property (nonatomic,strong) UIButton *coverButton;
@property (nonatomic,assign) NSInteger aSection;
@property (nonatomic,strong) UIView *actualContentView;
@property (nonatomic,strong) UIView *contextMenuView;
@property (nonatomic,assign) BOOL isSelected;


@property (nonatomic, strong) MessageObject *aMessage;
@property (nonatomic, assign) enum MessageCellStyle msgStyle;

@property (nonatomic, strong) UIImageView *headImg;//头像
@property (nonatomic, strong) UILabel *nameFromLab;//昵称from
@property (nonatomic, strong) UILabel *timeLab;//时间
@property (nonatomic, strong) UIImageView *focusImg,*commentImg;//关注／评论
@property (nonatomic, strong) UILabel *focusLab,*commentLab;//关注／评论
@property (nonatomic, strong) UILabel *contentLab;//内容

-(void)open;
-(void)close;
@end

@protocol FirstViewHeaderDelegate <NSObject>

- (void)contextMenuHeaderDidSelectCoverOption:(FirstViewHeader *)header;
- (void)contextMenuHeaderDidSelectFocusOption:(FirstViewHeader *)header;
- (void)contextMenuHeaderDidSelectCommentOption:(FirstViewHeader *)header;
- (void)contextMenuHeaderDidSelectDeleteOption:(FirstViewHeader *)header;

@end