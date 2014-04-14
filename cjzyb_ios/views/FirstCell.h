//
//  FirstCell.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyMessageObject.h"

@protocol FirstCellDelegate;
@interface FirstCell : UITableViewCell

@property (nonatomic, strong) UIView *actualContentView;
@property (strong, nonatomic) UIView *contextMenuView;
@property (nonatomic, strong) UIImageView *headImg;//头像
@property (nonatomic, strong) UILabel *nameFromLab;//昵称from
@property (nonatomic, strong) UILabel *timeLab;//时间

@property (nonatomic, strong) UILabel *contentLab;//内容

@property (nonatomic, assign) enum ReplyMessageCellStyle msgStyle;

@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) UILabel *nameToLab;//昵称to
@property (nonatomic, strong) UILabel *huifuLab;//回复

@property (nonatomic, strong) ReplyMessageObject*aReplyMsg;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic,assign) NSInteger aRow;
@property (nonatomic, assign) id <FirstCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *idxPath;
@property (strong, nonatomic) UIButton *coverButton;
@property (nonatomic, strong) UIImageView *praisedImg;
@property (nonatomic, assign) BOOL isHiddenLoadButton;
@property (nonatomic, strong) UIButton *loadButton;
-(void)open;
-(void)close;
@end

@protocol FirstCellDelegate <NSObject>
- (void)contextMenuCellDidSelectCoverOption:(FirstCell *)cell;
- (void)contextMenuCellDidSelectCommentOption:(FirstCell *)cell;
- (void)contextMenuCellDidSelectDeleteOption:(FirstCell *)cell;
- (void)contextMenuCellDidSelectLoadOption:(FirstCell *)cell;

@end