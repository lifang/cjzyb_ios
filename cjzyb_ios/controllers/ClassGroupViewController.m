//
//  ClassGroupViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-27.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ClassGroupViewController.h"

@interface ClassGroupViewController ()
@property (nonatomic,strong) UIButton *addClassButton;
@property (nonatomic,strong) UIView *footerBackView;
@end

@implementation ClassGroupViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.classArray addObject:@"夏洛克三班"];
//    [self.classArray addObject:@"好基友五班级"];
    self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]];
    self.addClassButton = [[UIButton alloc] initWithFrame:(CGRect){0,0,200,70}];
    [self.addClassButton addTarget:self action:@selector(addMoreClasses) forControlEvents:UIControlEventTouchUpInside];
    [self.addClassButton setImage:[UIImage imageNamed:@"addClass.png"] forState:UIControlStateNormal];
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

///加入更多班级
-(void)addMoreClasses{

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
    if (indexPath.row == 0) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point.png"]];
    }else{
        cell.accessoryView = nil;
    }
    // Configure the cell...
    cell.textLabel.text = @"夏洛克";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.footerBackView) {
        self.footerBackView = [[UIView alloc] initWithFrame:(CGRect){0,0,tableView.frame.size.width,70}];
        self.footerBackView.backgroundColor = tableView.backgroundColor;
        [self.footerBackView addSubview:self.addClassButton];
    }
    self.addClassButton.center = (CGPoint){CGRectGetWidth(self.footerBackView.frame)/2,CGRectGetHeight(self.footerBackView.frame)/2};
    return self.footerBackView;
}
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    
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
