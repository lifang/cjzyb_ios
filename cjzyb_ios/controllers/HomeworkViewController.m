//
//  HomeworkViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "HomeworkViewController.h"
#import "HomeworkHistoryCollectionCell.h"
@interface HomeworkViewController ()
@property (nonatomic,strong) WYPopoverController *calendarPopController;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

///顶部显示当前任务时显示
@property (weak, nonatomic) IBOutlet UIView *currentTopBackView;
///顶部显示历史任务时显示
@property (weak, nonatomic) IBOutlet UIView *historyTopBackView;
///顶部显示当前任务发布时间
@property (weak, nonatomic) IBOutlet UILabel *startTaskTimeLabel;
///顶部显示当前任务结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTaskTimeLabel;
///底部显示历史任务发布时间
@property (weak, nonatomic) IBOutlet UILabel *historyStartTaskLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
///底部向左滑动的按钮
@property (weak, nonatomic) IBOutlet UIButton *leftSwipButton;
///底部向右滑动的按钮
@property (weak, nonatomic) IBOutlet UIButton *rightSwipButton;
///显示历史任务
- (IBAction)historyButtonClicked:(id)sender;
///显示日历
- (IBAction)calendarButtonClicked:(id)sender;
///回到当前记录
- (IBAction)backButtonClicked:(id)sender;
///显示上一次的历史任务
- (IBAction)leftSwipButtonClicked:(id)sender;
///显示下一次的历史任务
- (IBAction)rightSwipButtonClicked:(id)sender;
@end

@implementation HomeworkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isShowHistory = NO;
    [self.collectionView registerClass:[HomeworkHistoryCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.flowLayout setItemSize:(CGSize){CGRectGetWidth(self.collectionView.frame),CGRectGetHeight(self.collectionView.frame)}];
    [self.flowLayout setMinimumInteritemSpacing:0];
    [self.flowLayout setMinimumLineSpacing:0];
//    [self.flowLayout setSectionInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [self.flowLayout setSectionInset:UIEdgeInsetsZero];
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
    for (int i = 0; i < 5; i++) {
        TaskObj *task = [[TaskObj alloc] init];
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i < 15; i++) {
            HomeworkTypeObj *obj = [[HomeworkTypeObj alloc] init];
            obj.homeworkType = HomeworkType_line;
            obj.homeworkTypeRanking = @"100";
            obj.homeworkTypeIsFinished = YES;
            [types addObject:obj];
        }
        task.taskHomeworkTypeArray = types;
        self.taskObj = task;
        [self.allHistoryTaskArray addObject:task];
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)historyButtonClicked:(id)sender {
    self.isShowHistory = YES;
    [self.collectionView reloadData];
}

- (IBAction)calendarButtonClicked:(id)sender {
    CalendarViewController *calendarViewContr = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    self.calendarPopController = [[WYPopoverController alloc] initWithContentViewController:calendarViewContr];
    __weak WYPopoverController *weakPopoverController = self.calendarPopController;
    calendarViewContr.selectedDateBlock =   ^(NSArray *selectedDateArray){
        [weakPopoverController dismissPopoverAnimated:YES];
    };
    WYPopoverTheme *theme = [self.calendarPopController theme];
    [theme setFillTopColor:[UIColor whiteColor]];
    self.calendarPopController.popoverContentSize = (CGSize){500,650};
    [self.calendarPopController presentPopoverFromRect:[(UIButton*)sender frame] inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES completion:^{
        
    }];
}

- (IBAction)backButtonClicked:(id)sender {
    self.isShowHistory = NO;
    [self.collectionView reloadData];
}

- (IBAction)leftSwipButtonClicked:(id)sender {
    NSArray *visibleItemIndexPath  = [self.collectionView indexPathsForVisibleItems];
    if (visibleItemIndexPath && visibleItemIndexPath.count > 0) {
        NSIndexPath *path = visibleItemIndexPath.firstObject;
        if (path.item -1 >= 0) {
             [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:path.item-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        }

        if (path.item - 1 > 0 ) {
            [self.leftSwipButton setHidden:NO];
        }else{
            [self.leftSwipButton setHidden:YES];
        }
        [self.rightSwipButton setHidden:NO];
        if (self.allHistoryTaskArray.count <= 1) {
            [self.rightSwipButton setHidden:YES];
            [self.leftSwipButton setHidden:YES];
        }
    }
}

- (IBAction)rightSwipButtonClicked:(id)sender {
    NSArray *visibleItemIndexPath  = [self.collectionView indexPathsForVisibleItems];
    if (visibleItemIndexPath && visibleItemIndexPath.count > 0) {
        NSIndexPath *path = visibleItemIndexPath.firstObject;
        if (path.item+1 < self.allHistoryTaskArray.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:path.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        }
        
        if (path.item+1 == self.allHistoryTaskArray.count-1) {
            [self.rightSwipButton setHidden:YES];
        }else{
            [self.rightSwipButton setHidden:NO];
        }
         [self.leftSwipButton setHidden:NO];
        if (self.allHistoryTaskArray.count <= 1) {
            [self.rightSwipButton setHidden:YES];
            [self.leftSwipButton setHidden:YES];
        }
    }
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark --

#pragma mark UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeworkHistoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (![cell.subviews containsObject:cell.dailyCollectionViewController.view]) {
        cell.dailyCollectionViewController.view.frame = (CGRect){10,0,cell.bounds.size.width-20,cell.bounds.size.height};
        [cell.dailyCollectionViewController resizeItemSize];
        [cell addSubview:cell.dailyCollectionViewController.view];
    }
    if (self.isShowHistory) {
        TaskObj *task = [self.allHistoryTaskArray objectAtIndex:indexPath.item];
        cell.dailyCollectionViewController.taskObj = task;
        self.historyStartTaskLabel.text = [NSString stringWithFormat:@"%@ 发布",task.taskStartDate];
    }else{
        cell.dailyCollectionViewController.taskObj = self.taskObj;
        self.startTaskTimeLabel.text = [NSString stringWithFormat:@"发布时间为 %@",self.taskObj.taskStartDate];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日作业截止时间为 %@",self.taskObj.taskEndDate]];
        [str addAttribute:NSFontAttributeName value:self.endTaskTimeLabel.font range:NSMakeRange(0, str.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 9)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9, str.length - 9)];
        self.endTaskTimeLabel.attributedText = str;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isShowHistory) {
        return self.allHistoryTaskArray.count;
    }else{
        return 1;
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.isShowHistory) {
        NSArray *visibleItemIndexPath  = [self.collectionView indexPathsForVisibleItems];
        if (visibleItemIndexPath && visibleItemIndexPath.count > 0) {
            NSIndexPath *indexPath = visibleItemIndexPath.firstObject;
            if (indexPath.item == 0) {
                [self.leftSwipButton setHidden:YES];
            }else{
                [self.leftSwipButton setHidden:NO];
            }
            
            if (indexPath.item == self.allHistoryTaskArray.count-1) {
                [self.rightSwipButton setHidden:YES];
            }else{
                [self.rightSwipButton setHidden:NO];
            }
        }
    }
}
#pragma mark --

#pragma mark property
-(void)setIsShowHistory:(BOOL)isShowHistory{
    _isShowHistory = isShowHistory;
    [self.historyTopBackView setHidden:!isShowHistory];
    [self.currentTopBackView setHidden:isShowHistory];
    [self.historyStartTaskLabel setHidden:!isShowHistory];
    [self.leftSwipButton setHidden:YES];
    if (isShowHistory) {
        [self.rightSwipButton setHidden:self.allHistoryTaskArray.count > 1?NO:YES];
    }else{
        [self.rightSwipButton setHidden:YES];
    }
}

-(NSMutableArray *)allHistoryTaskArray{
    if (!_allHistoryTaskArray) {
        _allHistoryTaskArray = [NSMutableArray array];
    }
    return _allHistoryTaskArray;
}
#pragma mark --
@end
