//
//  ModelTypeViewController.h
//  cjzyb_ios
//
//  Created by david on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
/** ModelTypeViewController
 *
 * 弹出输入框，位置在键盘之上，输入框随着输入的内容自动增加
 */
@interface ModelTypeViewController : UIViewController<UITextViewDelegate>
/**
 * @brief
 *
 * @param  tip 提示字符串
 *
 * @return inputString 输入的字符
 */
+(void)presentTypeViewWithTipString:(NSString*)tip withFinishedInput:(void (^)(NSString *inputString))finished withCancel:(void(^)())cancel;
@end
