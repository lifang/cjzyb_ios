//
//  LiningItemButton.h
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineDualSentenceObj.h"
/** LiningItemButton
 *
 * 每个单词的button
 */
@interface LiningItemButton : UIButton
@property (assign,nonatomic) int liningLocationIndex;
///对应的LineDualSentenceObj对象
@property (strong,nonatomic) LineDualSentenceObj *liningSentenceObj;

///用户连接对应的LiningItemButton对象
@property (strong,nonatomic) LiningItemButton *liningOppositeItemButton;

///判断左右位置，YES：表示左边，NO：表示右边
@property (assign,nonatomic) BOOL isLeft;

///是否处于选中状态
@property (assign,nonatomic) BOOL isTaped;

///是否使用道具提示过
@property (assign,nonatomic) BOOL isTiped;
-(id)initDefaultLiningItemButton;
@end
