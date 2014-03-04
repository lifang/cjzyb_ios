//
//  MJRefreshTableFooterView.h
//  weibo
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  上拉加载更多

#import "MJRefreshBaseView.h"
@interface MJRefreshFooterView : MJRefreshBaseView
@property (assign,nonatomic) BOOL isNotObserve;
/**
 * @brief 重新调整底部进度条
 *
 * @param
 *
 * @return
 */
- (void)adjustFrameWhenKeyboardUP;
- (void)adjustFrameWhenKeyboardDOWN;
@end