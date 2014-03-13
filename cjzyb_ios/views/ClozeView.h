//
//  ClozeView.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface ClozeView : UIView

@property (nonatomic, strong) NSString *text;

- (void)setText:(NSString*)text;
@end
