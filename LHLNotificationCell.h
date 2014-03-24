//
//  LHLNotificationCell.h
//  cjzyb_ios
//
//  Created by apple on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLTextView.h"
#import "NotificationObject.h"
@protocol LHLNotificationCellDelegate;
@interface LHLNotificationCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet LHLTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
- (IBAction)coverButtonClicked:(id)sender;

@property (strong,nonatomic) NotificationObject *notification;

@property (assign,nonatomic) CGFloat cellHeight;

@property (strong,nonatomic) id<LHLNotificationCellDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (assign,nonatomic) BOOL isEditing;//正在编辑
@property (strong,nonatomic) UIView *sideView;//右侧view with 按钮



- (void) initCell;  //由tableView调用
- (void) makeSideButtons;  //选中后创建右侧view和按钮
- (void) setNotificationObject:(NotificationObject *)noti;
@end
@protocol LHLNotificationCellDelegate <NSObject>

@required
-(void)cell:(LHLNotificationCell *)cell deleteButtonClicked:(id)sender;
-(void)cell:(LHLNotificationCell *)cell setIsEditing:(BOOL)editing;
@optional
-(void)refreshHeightForCell:(LHLNotificationCell *)cell;
@end