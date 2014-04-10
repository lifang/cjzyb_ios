//
//  ClassGroupViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ClassGroupViewController.h"
#import "UserObjDaoInterface.h"
#import "ModelTypeViewController.h"
@interface ClassGroupViewController ()
@property (nonatomic,strong) UIView *footerBackView;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
-(IBAction)addMoreClasses;
@end

@implementation ClassGroupViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.classArray addObject:@"夏洛克三班"];
//    [self.classArray addObject:@"好基友五班级"];
    self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO:加入更多班级
-(IBAction)addMoreClasses{
    __weak ClassGroupViewController *weakSelf = self;
    DataService *data = [DataService sharedService];
    
    [ModelTypeViewController presentTypeViewWithTipString:@"请输入班级验证码:" withFinishedInput:^(NSString *inputString) {
        AppDelegate *app = [AppDelegate shareIntance];

        NSString *msgStr = @"";
        NSString *regexCall = @"[0-9]{10}";
        NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
        if ([predicateCall evaluateWithObject:inputString]) {
            
        }else {
            msgStr = @"班级验证码不能为空";
        }
        if (msgStr.length>0) {
            [Utility errorAlert:msgStr];
            return ;
        }
        
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        [UserObjDaoInterface joinNewGradeWithUserId:data.user.studentId withIdentifyCode:inputString withSuccess:^(UserObject *userObj, ClassObject *gradeObj) {
            ClassGroupViewController *tempSelf = weakSelf;
            if (tempSelf) {
                data.user = userObj;
                data.theClass = gradeObj;
                [data.theClass archiverClass];
                //退回到主界面
//                [tempSelf.tableView reloadData];
                [MBProgressHUD hideHUDForView:app.window animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kChangeGradeNotification object:nil];
            }
        } withFailure:^(NSError *error) {
            ClassGroupViewController *tempSelf = weakSelf;
            if (tempSelf) {
                [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
                [MBProgressHUD hideHUDForView:app.window animated:YES];
            }
        }];
    } withCancel:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.classArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }

    // Configure the cell...
    DataService *data = [DataService sharedService];
    ClassObject *grade = [self.classArray objectAtIndex:indexPath.row];
    cell.textLabel.text = grade.name;
    if ([data.theClass.classId isEqualToString:grade.classId]) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point.png"]];
    }else{
        cell.accessoryView = nil;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataService *data = [DataService sharedService];
    ClassObject *grade = [self.classArray objectAtIndex:indexPath.row];
    if ([data.theClass.classId isEqualToString:grade.classId]) {
        return;
    }
    //TODO:切换班级
    __weak ClassGroupViewController *weakSelf = self;
    AppDelegate *app = [AppDelegate shareIntance];
    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    [UserObjDaoInterface exchangeGradeWithUserId:data.user.studentId withGradeId:grade.classId withSuccess:^(UserObject *userObj, ClassObject *gradeObj) {
        ClassGroupViewController *tempSelf = weakSelf;
        if (tempSelf) {
            data.user = userObj;
            data.theClass = gradeObj;
            [data.theClass archiverClass];
            
            //退回到主界面
//            [tempSelf.tableView reloadData];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChangeGradeNotification object:nil];
        }
    } withFailure:^(NSError *error) {
        ClassGroupViewController *tempSelf = weakSelf;
        if (tempSelf) {
            [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
        }
    }];
    
}


#pragma mark property
-(NSMutableArray *)classArray{
    if (!_classArray) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}
#pragma mark --
@end
