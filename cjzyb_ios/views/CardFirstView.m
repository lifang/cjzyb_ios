//
//  CardFirstView.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardFirstView.h"
#import "TagObject.h"
const CGFloat kScroll1ObjHeight	= 40;

@implementation CardFirstView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)initData {
    NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
    for (int i=0; i<[DataService sharedService].tagsArray.count; i++) {
        TagObject *tagObj = (TagObject *)[[DataService sharedService].tagsArray objectAtIndex:i];
        for (int k=0; k<self.tagNameArray.count; k++) {
            NSInteger t_id = [[self.tagNameArray objectAtIndex:k]integerValue];
            if ([tagObj.tagId integerValue]==t_id) {
                [tmpArr addObject:tagObj.tagName];
            }
        }
    }
    NSString *tagStr = [tmpArr componentsJoinedByString:@","];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    UILabel *label = nil;
	NSArray *subviews = [self.scrollView subviews];
	for (label in subviews)
	{
		if ([label isKindOfClass:[UILabel class]])
		{
            [label removeFromSuperview];
		}
	}

    
    
    UILabel *lab = [[UILabel alloc]init];
    lab.tag = 5;
    lab.textColor = [UIColor whiteColor];   
    lab.text = tagStr;
    CGRect rect = lab.frame;
    rect.size.height = kScroll1ObjHeight;
    rect.size.width = [tagStr sizeWithFont:[UIFont systemFontOfSize:18]].width;
    lab.frame = rect;
    [self.scrollView addSubview:lab];
    
    if ([tagStr sizeWithFont:[UIFont systemFontOfSize:18]].width<316) {
        [self.scrollView setContentSize:CGSizeMake(316, [self.scrollView bounds].size.height)];
    }else {
        [self.scrollView setContentSize:CGSizeMake([tagStr sizeWithFont:[UIFont systemFontOfSize:18]].width, [self.scrollView bounds].size.height)];
    }
    
    tmpArr = nil;
    lab = nil;
}
-(void)setTagNameArray:(NSMutableArray *)tagNameArray {
    _tagNameArray = tagNameArray;
    [self initData];
}
-(IBAction)txtButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedTxtBtn:)]) {
        [self.delegate pressedTxtBtn:self.txtBtn];
    }
}


@end
