//
//  CardSecondView.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CardSecondView.h"

@implementation CardSecondView

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

-(IBAction)voiceButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedVoiceBtn:)]) {
        [self.delegate pressedVoiceBtn:self.voiceBtn];
    }
}

-(IBAction)deleteButtonPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressedDeleteBtn:)]) {
        [self.delegate pressedDeleteBtn:self.deleteBtn];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cardSecondArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cardSecondCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    UIView *optionBackgroundView;
    UILabel *abcdLabel;UILabel *optionLabel;
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        optionBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 192, 40)];
        optionBackgroundView.backgroundColor = [UIColor whiteColor];
        optionBackgroundView.layer.cornerRadius = 8.0;
        optionBackgroundView.layer.borderWidth = 2.0;
        optionBackgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
        [cell.contentView addSubview:optionBackgroundView];
        
        abcdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        abcdLabel.backgroundColor = [UIColor colorWithRed:53.0/255.0 green:207.0/255.0 blue:143.0/255.0 alpha:1.0];
        abcdLabel.layer.cornerRadius = 4.0;
        abcdLabel.font = [UIFont systemFontOfSize:22.0];
        abcdLabel.textColor = [UIColor whiteColor];
        abcdLabel.textAlignment = NSTextAlignmentCenter;
        [optionBackgroundView addSubview:abcdLabel];
        
        optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 150, 30)];
        optionLabel.backgroundColor = [UIColor clearColor];
        optionLabel.textColor = [UIColor blackColor];
        optionLabel.font = [UIFont systemFontOfSize:22.0];;
        optionLabel.textAlignment = NSTextAlignmentCenter;
        [optionBackgroundView addSubview:optionLabel];
    }
    abcdLabel.text = [NSString stringWithFormat:@"%c",(char)('A' + indexPath.row)];
    optionLabel.text = [self.cardSecondArray objectAtIndex:indexPath.row];
    
    for (NSString *str in self.indexArray) {
        if ([str integerValue]==indexPath.row) {
            optionBackgroundView.layer.borderColor = [UIColor colorWithRed:53.0/255.0 green:207.0/255.0 blue:143.0/255.0 alpha:1.0].CGColor;
            break;
        }
    }
    
    return cell;
}
@end
