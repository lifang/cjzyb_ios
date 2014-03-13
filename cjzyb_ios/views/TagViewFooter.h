//
//  TagViewFooter.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMRDetailHeaderDelegate;
@interface TagViewFooter : UITableViewHeaderFooterView
@property (nonatomic, assign) id<CMRDetailHeaderDelegate>delegate;
@property (nonatomic, strong) UIButton *coverBt;
@end
@protocol CMRDetailHeaderDelegate <NSObject>
-(void)detailHeader:(TagViewFooter*)header;
@end