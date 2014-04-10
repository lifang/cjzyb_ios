//
//  HomeworkRankingViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "HomeworkRankingViewController.h"

@interface HomeworkRankingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *tableBackView;

@end

@implementation HomeworkRankingViewController

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeworkRankingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.titleLabel.layer.cornerRadius = 10;
    self.tableBackView.layer.cornerRadius = 10;
    self.tableBackView.backgroundColor = [UIColor colorWithRed:24./255. green:139./255. blue:79./255. alpha:1.];
    
    
//    self.view.layer.cornerRadius = 10;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///重新加载数据
-(void)reloadDataWithTaskId:(NSString*)taskId withHomeworkType:(HomeworkType)homeworkType{
    NSString *titleString;
    switch (homeworkType) {
        case HomeworkType_quick:
            titleString = @"十速挑战当日排名";
            break;
        case HomeworkType_fillInBlanks:
            titleString = @"完形填空当日排名";
            break;
        case HomeworkType_line:
            titleString = @"连线挑战当日排名";
            break;
        case HomeworkType_listeningAndWrite:
            titleString = @"听写挑战当日排名";
            break;
        case HomeworkType_reading:
            titleString = @"朗读挑战当日排名";
            break;
        case HomeworkType_select:
            titleString = @"选择挑战当日排名";
            break;
        case HomeworkType_sort:
            titleString = @"排序挑战当日排名";
            break;
            
        default:
            break;
    }
    self.titleLabel.text = titleString;
    
    __weak HomeworkRankingViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HomeworkDaoInterface downloadHomeworkRankingWithTaskId:taskId withHomeworkType:homeworkType withSuccess:^(NSArray *rankingObjArr) {
        HomeworkRankingViewController *tempSelf = weakSelf;
        if (tempSelf) {
            tempSelf.rankingUserArray = [NSArray arrayWithArray:rankingObjArr];
            [tempSelf.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } withError:^(NSError *error) {
        HomeworkRankingViewController *tempSelf = weakSelf;
        if (tempSelf) {
            [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeworkRankingTableViewCell *cell = (HomeworkRankingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    RankingObject *rank = [self.rankingUserArray objectAtIndex:indexPath.row];
    [cell.headerImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHOST,rank.rankingHeaderURL]]];
    cell.nameLabel.text = rank.rankingName;
//    cell.rankLabel.text = rank.rankingNumber;
    cell.rankLabel.text = [self rankTextFromRowNumber:indexPath.row];
    cell.scoreLabel.text = rank.rankingScore;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:24./255. green:139./255. blue:79./255. alpha:1.];
//    self.view.layer.cornerRadius = 10;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rankingUserArray.count;
}

//根据indexPath计算排名文字
- (NSString *)rankTextFromRowNumber:(NSInteger )row{
    NSInteger number = row + 1;
    NSString *rankText;
    if (number == 1) {
        rankText = @"1st";
    }
    if (number == 2) {
        rankText = @"2nd";
    }
    if (number == 3) {
        rankText = @"3rd";
    }
    if (number > 3) {
        rankText = [NSString stringWithFormat:@"%dth",number];
    }
    return rankText;
}

#pragma mark --
- (IBAction)exitButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
