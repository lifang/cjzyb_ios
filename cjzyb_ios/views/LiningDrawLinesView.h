//
//  LiningDrawLinesView.h
//  cjzyb_ios
//
//  Created by david on 14-3-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineObj.h"
/** LiningDrawLinesView
 *
 * 画连接线
 */
@interface LiningDrawLinesView : UIView
///重新划线
-(void)redrawLinesWithLineObjArray:(NSArray*)linesArr;
@end
