//
//  FirstViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstCell.h"
#import "MessageObject.h"

@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FirstCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *firstTable;
@property (nonatomic, strong) NSMutableArray *firstArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end
