//
//  LHLReplyNotificationCell.h
//  cjzyb_ios
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLTextView.h"
@protocol LHLReplyNotificationCellDelegate;
@interface LHLReplyNotificationCell : UITableViewCell
@property (strong,nonatomic) id<LHLReplyNotificationCellDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *indexPath;

- (void) setInfomations;
@end
@protocol LHLReplyNotificationCellDelegate <NSObject>

@required
-(void) replyCell:(LHLReplyNotificationCell *)cell replyButtonClicked:(id)sender;
-(void) replyCell:(LHLReplyNotificationCell *)cell deleteButtonClicked:(id)sender;
@end