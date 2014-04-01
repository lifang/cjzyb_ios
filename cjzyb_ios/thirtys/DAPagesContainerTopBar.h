//
//  DAPagesContainerTopBar.h
//  DAPagesContainerScrollView
//
//  Created by Daria Kopaliani on 5/29/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DAPagesContainerTopBar;

@protocol DAPagesContainerTopBarDelegate <NSObject>

- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(DAPagesContainerTopBar *)bar;

@end


@interface DAPagesContainerTopBar : UIView
{
    CGFloat DAPagesContainerTopBarItemViewWidth;
    CGFloat DAPagesContainerTopBarItemsOffset;
}

@property (strong, nonatomic) NSArray *itemTitles;
@property (readonly, strong, nonatomic) NSArray *itemViews;
@property (weak, nonatomic) id<DAPagesContainerTopBarDelegate> delegate;

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index;
- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index;

- (void)setDAPagesContainerTopBarItemViewWidth:(CGFloat)value;
- (void)setDAPagesContainerTopBarItemsOffset:(CGFloat)value;

@end