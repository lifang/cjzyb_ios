//
//  StudentListViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "StudentListViewController.h"
#import "StudentTableViewCell.h"
#import "StudentSummaryCell.h"

@interface StudentListViewController ()

@end

@implementation StudentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)reloadClassmatesData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak StudentListViewController *weakSelf = self;
    [DownloadClassmatesInfo downloadClassmatesinfoWithUserId:@"74" withClassId:@"90" withSuccess:^(NSArray *classmatesArray) {
        DLog(@"%@",classmatesArray);
        if (weakSelf) {
            StudentListViewController *controller = weakSelf;
            for (UserObject *user in classmatesArray) {
                if (user.isTeacher) {
                    [controller.teacherArray addObject:user];
                }else{
                    [controller.studentArray addObject:user];
                }
            }
            [MBProgressHUD hideHUDForView:controller.view animated:YES];
            [controller.tableView reloadData];
        }
    } withError:^(NSError *error) {
        if (weakSelf) {
            StudentListViewController *controller = weakSelf;
            [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
            [MBProgressHUD hideHUDForView:controller.view animated:YES];
        }
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:47/255.0 green:54/255.0 blue:62/255.0 alpha:1];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentSummaryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StudentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"detailCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        Student *st = [self.teacherArray objectAtIndex:indexPath.row];
//        st.isExtend = !st.isExtend;
    }else{
        UserObject *st = [self.studentArray objectAtIndex:indexPath.row];
        st.isExtend = !st.isExtend;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}
#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserObject *st = nil;
    if (indexPath.section == 0) {
        st = [self.teacherArray objectAtIndex:indexPath.row];
    }else{
        st = [self.studentArray objectAtIndex:indexPath.row];
    }
    
    
    if (st.isExtend) {
        StudentTableViewCell *detailCell = (StudentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        detailCell.backgroundColor = self.tableView.backgroundColor;
        detailCell.userImageView.image = [UIImage imageNamed:@"jiezu@2x.png"];
        return detailCell;
    }else{
        StudentSummaryCell *summaryCell = (StudentSummaryCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        summaryCell.userImageView.image = [UIImage imageNamed:@"jiezu@2x.png"];
        summaryCell.userNameLabel.text = @"希腊女生";
        summaryCell.backgroundColor = [UIColor clearColor];
        return summaryCell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserObject *st = nil;
    if (indexPath.section == 0) {
        st = [self.teacherArray objectAtIndex:indexPath.row];
    }else{
        st= [self.studentArray objectAtIndex:indexPath.row];
    }
    if (st && st.isExtend) {
        return 130;
    }
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.teacherArray.count;
    }
    return self.studentArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = [[UILabel alloc] initWithFrame:(CGRect){0,0,CGRectGetWidth(tableView.bounds),50}];
    [header setTextColor:[UIColor lightGrayColor]];
    header.backgroundColor = self.view.backgroundColor;
    [header setFont:[UIFont systemFontOfSize:20]];
    if (section == 0) {
        header.text = @"  我的班主任";
    }else{
      header.text = @"  我的同学";
    }
    return header;
}
#pragma mark --

- (IBAction)backButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(studentListViewController:backButtonClicked:)]) {
        [self.delegate studentListViewController:self backButtonClicked:sender];
    }
}

#pragma mark property
-(NSMutableArray *)studentArray{
    if (!_studentArray) {
        _studentArray = [NSMutableArray array];
    }
    return _studentArray;
}

-(NSMutableArray *)teacherArray{
    if (!_teacherArray) {
        _teacherArray = [NSMutableArray array];
    }
    return _teacherArray;
}
#pragma mark --
@end
