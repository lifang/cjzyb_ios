//
//  SelectingChallengeOptionCell.h
//  cjzyb_ios
//
//  Created by lhl0033 on 14-3-9.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectingChallengeOptionCellDelegate;

@interface SelectingChallengeOptionCell : UITableViewCell
@property (strong,nonatomic) UIView *optionBackgroundView;  //背景
@property (strong,nonatomic) NSString *optionString;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (assign,nonatomic) BOOL optionSelected;
@property (assign,nonatomic) CGFloat maxLabelWidth;//一个问题的最大选项label长度
@property (strong,nonatomic) id<SelectingChallengeOptionCellDelegate> delegate;
@property (strong,nonatomic) UIButton *optionButton;
@property (nonatomic,assign) NSInteger cellHeight;//指实际背景的高度 ,tableCellHeight要再加22
@property (strong,nonatomic) UILabel *optionLabel;
@end

@protocol SelectingChallengeOptionCellDelegate <NSObject>

@required

-(void)selectingCell:(SelectingChallengeOptionCell *) cell clickedForSelecting:(BOOL) selected;

@end
