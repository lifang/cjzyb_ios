//
//  HomeworkTypeCollctionCell.m
//  cjzyb_ios
//
//  Created by david on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "HomeworkTypeCollctionCell.h"
@interface HomeworkTypeCollctionCell()
@property (weak, nonatomic) IBOutlet UIImageView *finishedFlagImageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
- (IBAction)rankingButtonClicked:(id)sender;

@end
@implementation HomeworkTypeCollctionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
#pragma mark property
-(void)setIsFinished:(BOOL)isFinished{
    _isFinished = isFinished;
    [self.finishedFlagImageview setHidden:!isFinished];
}
-(void)setIsShowRankingBtn:(BOOL)isShowRankingBtn {
    _isShowRankingBtn = isShowRankingBtn;
    [self.rankingButton setHidden:!isShowRankingBtn];
    [self.rankLabel setHidden:!isShowRankingBtn];
}
-(void)setHomeworkType:(HomeworkType )homeworkType{
    _homeworkType = homeworkType;
    switch (homeworkType) {
        case HomeworkType_quick:
        {
            self.nameLabel.text = @"十速挑战";
            self.backImageView.image = [UIImage imageNamed:@"homework_quik.png"];
        }
            break;
        case HomeworkType_reading:
        {
            self.nameLabel.text = @"朗读任务";
            self.backImageView.image = [UIImage imageNamed:@"homework_reading.png"];
        }
            break;
        case HomeworkType_listeningAndWrite:
        {
            self.nameLabel.text = @"听写任务";
            self.backImageView.image = [UIImage imageNamed:@"homwwork_listenWrite.png"];
        }
            break;
        case HomeworkType_select:
        {
            self.nameLabel.text = @"选择挑战";
            self.backImageView.image = [UIImage imageNamed:@"homework_select.png"];
        }
            break;
        case HomeworkType_line:
        {
            self.nameLabel.text = @"连线挑战";
            self.backImageView.image = [UIImage imageNamed:@"homework_line.png"];
        }
            break;
        case HomeworkType_fillInBlanks:
        {
            self.nameLabel.text = @"完形填空";
            self.backImageView.image = [UIImage imageNamed:@"homework_blank.png"];
        }
            break;
        case HomeworkType_sort:
        {
            self.nameLabel.text = @"排序挑战";
            self.backImageView.image = [UIImage imageNamed:@"homework_sort.png"];
        }
            break;
        case HomeworkType_other:
        {
            self.nameLabel.text = @"其他题型";
            self.backImageView.image = [UIImage imageNamed:@"homework_quik.png"];
        }
            break;
        default:
            break;
    }
}

#pragma mark --

- (IBAction)rankingButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeworkTypeCollctionCell:rankingButtonClickedAtIndexPath:)]) {
        [self.delegate homeworkTypeCollctionCell:self rankingButtonClickedAtIndexPath:self.path];
    }
}
@end
