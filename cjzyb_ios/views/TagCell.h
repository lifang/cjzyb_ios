//
//  TagCell.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagCellDelegate <NSObject>
-(void)pressedButton:(UIButton *)btn;
@end

@interface TagCell : UITableViewCell

@property (nonatomic, assign) id<TagCellDelegate>delegate;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UILabel *titleLab;

@end
