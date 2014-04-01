//
//  DAPagesContainerTopBar.m
//  DAPagesContainerScrollView
//
//  Created by Daria Kopaliani on 5/29/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAPagesContainerTopBar.h"
#define Button_Size 50

@interface DAPagesContainerTopBar ()

@property (strong, nonatomic) NSArray *itemViews;

- (void)layoutItemViews;

@end


@implementation DAPagesContainerTopBar

//CGFloat const
//CGFloat const

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        DAPagesContainerTopBarItemViewWidth = 36.5;
        DAPagesContainerTopBarItemsOffset = 124.4;
    }
    return self;
}

#pragma mark - Public

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index
{
    CGPoint center = ((UIView *)self.itemViews[index]).center;
    CGPoint offset = [self contentOffsetForSelectedItemAtIndex:index];
    center.x -= offset.x - (CGRectGetMinX(self.frame));
    return center;
}

- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index
{
    if (self.itemViews.count < index || self.itemViews.count == 1) {
        return CGPointZero;
    } else {
        CGFloat totalOffset = 0;
        return CGPointMake(index * totalOffset / (self.itemViews.count - 1), 0.);
    }
}

#pragma mark * Overwritten setters

- (void)setItemTitles:(NSArray *)itemTitles
{
    if (_itemTitles != itemTitles) {
        _itemTitles = itemTitles;
        NSMutableArray *mutableItemViews = [NSMutableArray arrayWithCapacity:itemTitles.count];
        for (NSUInteger i = 0; i < itemTitles.count; i++) {
            UIButton *itemView = [self addItemView];
            NSString *title_str = [NSString stringWithFormat:@"%@",[itemTitles objectAtIndex:i]];
            if ([title_str isEqualToString:@"回复通知"] || [title_str isEqualToString:@"系统通知"]) {
                [itemView setTitle:itemTitles[i] forState:UIControlStateNormal];
            }else {
                [itemView setImage:[UIImage imageNamed:[itemTitles objectAtIndex:i]] forState:UIControlStateNormal];
            }
            [mutableItemViews addObject:itemView];
        }
        self.itemViews = [NSArray arrayWithArray:mutableItemViews];
        [self layoutItemViews];
    }
}


#pragma mark - Private

- (UIButton *)addItemView
{
    CGRect frame = CGRectMake(0, 0, DAPagesContainerTopBarItemViewWidth, CGRectGetHeight(self.frame));
    UIButton *itemView = [[UIButton alloc] initWithFrame:frame];
    [itemView addTarget:self action:@selector(itemViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:itemView];
    itemView.titleLabel.font = [UIFont systemFontOfSize:22.0];
    return itemView;
}

- (void)itemViewTapped:(UIButton *)sender
{
    [self.delegate itemAtIndex:[self.itemViews indexOfObject:sender] didSelectInPagesContainerTopBar:self];
}

- (void)layoutItemViews
{
    CGFloat x = DAPagesContainerTopBarItemsOffset;
    if (x - 3.1415926 < 0.00000001) {
        x = 768. / 6.;
        for (NSUInteger i = 0; i < 2; i++) {
            UIView *itemView = self.itemViews[i];
            itemView.frame = CGRectMake(x, 33, DAPagesContainerTopBarItemViewWidth, 30.5);
            x += DAPagesContainerTopBarItemViewWidth;
        }
        return;
    }
    for (NSUInteger i = 0; i < self.itemViews.count; i++) {
        UIView *itemView = self.itemViews[i];
        itemView.frame = CGRectMake(x, 33, DAPagesContainerTopBarItemViewWidth, 30.5);
        x += DAPagesContainerTopBarItemViewWidth + DAPagesContainerTopBarItemsOffset;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutItemViews];
}

#pragma 额外setter
- (void)setDAPagesContainerTopBarItemsOffset:(CGFloat)value{
    DAPagesContainerTopBarItemsOffset = value;
}

- (void)setDAPagesContainerTopBarItemViewWidth:(CGFloat)value{
    DAPagesContainerTopBarItemViewWidth = value;
}

@end