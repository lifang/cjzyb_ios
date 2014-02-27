//
//  FirstViewController.m
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "FirstViewController.h"

#define Head_Size 80.0
#define Insets 10
#define Label_Height 20
#define CELL_WIDTH self.view.frame.size.width

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)testData {
    for (int i=0; i<10; i++) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",M_ID,@"陆平",M_From,@"拉开受",M_Content,@"2014-01-11 17:58",M_Time,@"dfwfs",M_head,@"334566",M_focus,@"4435",M_answer,@"ss",M_To, nil];
        MessageObject *message = [MessageObject messageFromDictionary:dic];
        [self.firstArray addObject:message];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)firstArray {
    if (!_firstArray) {
        _firstArray = [[NSMutableArray alloc]init];
    }
    return _firstArray;
}
-(NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}

#pragma mark
#pragma mark -- UITableViewDelegate

-(CGSize)getSizeWithString:(NSString *)str{
    UIFont *aFont = [UIFont systemFontOfSize:18];
    CGSize size = [str sizeWithFont:aFont constrainedToSize:CGSizeMake(CELL_WIDTH-Insets*4-Head_Size, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.firstArray.count;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:indexPath.row];
    CGSize size = [self getSizeWithString:message.messageContent];
    
    return Insets*6+Label_Height+size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier= @"firstCell";
    FirstCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[FirstCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    MessageObject *message = (MessageObject *)[self.firstArray objectAtIndex:indexPath.row];
    cell.aMessage = message;
    cell.idxPath = indexPath;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    FirstCell *cell = (FirstCell *)[tableView cellForRowAtIndexPath:indexPath];
    
}


#pragma mark
#pragma mark -- FirstCellDelegate

-(void)tapCell:(FirstCell *)cell byIndex:(NSIndexPath *)aIndex {
    if (self.selectedArray.count > 0) {
        NSInteger aRow = [[self.selectedArray objectAtIndex:0]integerValue];
        if (aRow != aIndex.row) {
            NSIndexPath *idx = [NSIndexPath indexPathForRow:aRow inSection:0];
            FirstCell *cell = (FirstCell *)[self.firstTable cellForRowAtIndexPath:idx];
            [cell close];
            [self.selectedArray removeAllObjects];
            [self.selectedArray addObject:[NSString stringWithFormat:@"%d",aIndex.row]];
        }
    }else {
        [self.selectedArray addObject:[NSString stringWithFormat:@"%d",aIndex.row]];
    }
}

- (void)contextMenuCellDidSelectFocusOption:(FirstCell *)cell {
    
}
- (void)contextMenuCellDidSelectCommentOption:(FirstCell *)cell {
    
}
- (void)contextMenuCellDidSelectDeleteOption:(FirstCell *)cell {
    
}
@end
