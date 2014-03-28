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
    self.tableView.layer.cornerRadius = 10;
    self.view.layer.cornerRadius = 10;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///重新加载数据
-(void)reloadDataWithTaskId:(NSString*)taskId withHomeworkType:(HomeworkType)homeworkType{
    __weak HomeworkRankingViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HomeworkDaoInterface downloadHomeworkRankingWithTaskId:taskId withHomeworkType:homeworkType withSuccess:^(NSArray *rankingObjArr) {
        HomeworkRankingViewController *tempSelf = weakSelf;
        if (tempSelf) {
            tempSelf.rankingUserArray = rankingObjArr;
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
    [cell.headerImageView setImageWithURL:[NSURL URLWithString:rank.rankingHeaderURL]];
    cell.nameLabel.text = rank.rankingName;
    cell.rankLabel.text = rank.rankingNumber;
    cell.scoreLabel.text = rank.rankingScore;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rankingUserArray.count;
}


#pragma mark --
- (IBAction)exitButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
