//
//  HomeworkViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "HomeworkViewController.h"
#import "HomeworkHistoryCollectionCell.h"

//{"id": "181", "content": "This is! an aps!", "resource_url": "/question_packages/201402/questions_package_222/media_181.mp3"},
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
-(void)addDownloadTaskWithDictionary:(NSDictionary *)dic andName:(NSString *)name{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"resource_url"]]]];
    request.delegate = self;
    
    NSString *path;
    if (platform>5.0) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *documentDirectory = [path stringByAppendingPathComponent:[DataService sharedService].taskObj.start_time];
    
    NSString *nameString = [NSString stringWithFormat:@"%@-%@.mp3",name,[dic objectForKey:@"id"]];
    NSString *savePath=[documentDirectory stringByAppendingPathComponent:nameString];
    NSString *temp = [documentDirectory stringByAppendingPathComponent:@"temp"];
    NSString *tempPath = [temp stringByAppendingPathComponent:nameString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:temp]) {
        [fileManager createDirectoryAtPath:temp
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    
    [request setDownloadDestinationPath:savePath];//下载路径
    [request setTemporaryFileDownloadPath:tempPath];//缓存路径
    request.allowResumeForFileDownloads = YES;//打开断点，是否要断点续传
    [request setShowAccurateProgress:YES];
    [[self networkQueue] addOperation:request];
}

-(void)downLoadService {
    NSDictionary * dic = [Utility initWithJSONFile:[DataService sharedService].taskObj.start_time];
    NSArray *array = [NSArray arrayWithObjects:LISTEN,READ,SELECT, nil];
    
    for (int i=0; i<array.count; i++) {
        if (i!=array.count-1) {
            NSDictionary *questionDic = [dic objectForKey:[array objectAtIndex:i]];
            NSArray *questions = [questionDic objectForKey:@"questions"];
            for (int k=0; k<questions.count; k++) {
                NSDictionary *branch_dic = [questions objectAtIndex:k];
                NSArray *branch_questions = [branch_dic objectForKey:@"branch_questions"];
                
                for (int j=0; j<branch_questions.count; j++) {
                    NSDictionary *q_dic = [branch_questions objectAtIndex:j];
                    [self addDownloadTaskWithDictionary:q_dic andName:[array objectAtIndex:i]];
                }
            }
        }else {
            NSDictionary *questionDic = [dic objectForKey:SELECT];
            NSArray *questions = [questionDic objectForKey:@"questions"];
            for (int k=0; k<questions.count; k++) {
                NSDictionary *branch_dic = [questions objectAtIndex:k];
                NSArray *branch_questions = [branch_dic objectForKey:@"branch_questions"];
                
                for (int j=0; j<branch_questions.count; j++) {
                    NSDictionary *q_dic = [branch_questions objectAtIndex:j];
                    NSString *content = [q_dic objectForKey:@"content"];
                    NSRange range = [content rangeOfString:@"</file>"];
                    if (range.location != NSNotFound) {
                        NSArray *array = [content componentsSeparatedByString:@"</file>"];
                        NSString *title_sub  =[array objectAtIndex:0];
                        NSString *title=[title_sub stringByReplacingOccurrencesOfString:@"<file>" withString:@""];
                        NSRange range2 = [title rangeOfString:@".jpg"];
                        if (range2.location != NSNotFound) {//图片
                        }else {//语音
                            NSDictionary *theDic = [NSDictionary dictionaryWithObjectsAndKeys:[q_dic objectForKey:@"id"],@"id",title,@"resource_url", nil];
                            [self addDownloadTaskWithDictionary:theDic andName:SELECT];
                        }
                    }
                }
            }
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if ([self.networkQueue requestsCount] > 0) {
        //还有未下载完成
    }
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

#pragma mark HomeworkDailyCollectionViewControllerDelegate每一个题目类型cell代理
-(void)homeworkDailyController:(HomeworkDailyCollectionViewController *)controller didSelectedAtIndexPath:(NSIndexPath *)path{

}
#pragma mark --

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
    cell.dailyCollectionViewController.delegate = self;
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
