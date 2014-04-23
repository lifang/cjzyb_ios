//
//  TagViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardObject.h"
#import "TagObject.h"
#import "TagCell.h"
#import "CMRManager.h"
#import "TagInterface.h"
#import "TagViewFooter.h"
#import "SelectedTagInterface.h"

@interface TagViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TagInterfaceDelegate,TagCellDelegate,CMRDetailHeaderDelegate,SelectedTagInterfaceDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tagTable;
@property (nonatomic, strong) IBOutlet UITextField *tagtxt;
@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) CardObject *aCard;
@property (nonatomic, strong) TagInterface *tagInter;
@property (nonatomic, strong) SelectedTagInterface *selectedInter;
@property (nonatomic, strong) NSMutableArray  *filteredArray;
@property (nonatomic, strong) AppDelegate *appDel;
@property (nonatomic, assign) NSInteger tmpIndex;
@end
