//
//  FirstCell.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageObject.h"

@protocol FirstCellDelegate;
@interface FirstCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *actualContentView;
@property (strong, nonatomic) UIView *contextMenuView;
@property (nonatomic, strong) UIImageView *headImg;//头像
@property (nonatomic, strong) UILabel *nameFromLab;//昵称from
@property (nonatomic, strong) UILabel *timeLab;//时间
@property (nonatomic, strong) UIImageView *focusImg,*commentImg;//关注／评论
@property (nonatomic, strong) UILabel *focusLab,*commentLab;//关注／评论
@property (nonatomic, strong) UILabel *contentLab;//内容

@property (nonatomic, assign) enum MessageType msgType;//消息类型
@property (nonatomic, assign) enum MessageCellStyle msgStyle;

@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) UILabel *nameToLab;//昵称to
@property (nonatomic, strong) UILabel *huifuLab;//回复

@property (nonatomic, strong) MessageObject *aMessage;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) id <FirstCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *idxPath;
@property (strong, nonatomic) UIButton *coverButton;
-(void)open;
-(void)close;
@end

@protocol FirstCellDelegate <NSObject>
- (void)contextMenuCellDidSelectCoverOption:(FirstCell *)cell;
- (void)contextMenuCellDidSelectFocusOption:(FirstCell *)cell;
- (void)contextMenuCellDidSelectCommentOption:(FirstCell *)cell;
- (void)contextMenuCellDidSelectDeleteOption:(FirstCell *)cell;


@end