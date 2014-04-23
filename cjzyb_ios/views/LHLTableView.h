//
//  LHLTableView.h
//  cjzyb_ios
//
//  Created by apple on 14-3-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LHLTableViewDelegate;
@interface LHLTableView : UITableView
@property (nonatomic,strong) IBOutlet id<LHLTableViewDelegate> delegateCustom;
@end
@protocol LHLTableViewDelegate <NSObject>

@required
-(void)dragMethod:(BOOL)toLeft;
@end