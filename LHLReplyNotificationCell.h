//
//  LHLReplyNotificationCell.h
//  cjzyb_ios
//
//  Created by apple on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLTextView.h"
#import "ReplyNotificationObject.h"
@protocol LHLReplyNotificationCellDelegate;
@interface LHLReplyNotificationCell : UITableViewCell
@property (strong,nonatomic) id<LHLReplyNotificationCellDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) ReplyNotificationObject *replyObject;
@property (assign,nonatomic) BOOL isEditing;

- (void) setInfomations:(ReplyNotificationObject *)reply;
@end
@protocol LHLReplyNotificationCellDelegate <NSObject>

@required
-(void) replyCell:(LHLReplyNotificationCell *)cell replyButtonClicked:(id)sender;
-(void) replyCell:(LHLReplyNotificationCell *)cell deleteButtonClicked:(id)sender;
-(void) replyCell:(LHLReplyNotificationCell *)cell setIsEditing:(BOOL)editing;
-(UIImage *) replyCell:(LHLReplyNotificationCell *)cell bufferedImageForAddress:(NSString *)address;
@end