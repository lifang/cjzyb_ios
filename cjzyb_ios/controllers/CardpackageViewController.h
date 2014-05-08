//
//  CardpackageViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardObject.h"
#import "CardInterface.h"
#import "CardCustomView.h"
#import "MyPageControl.h"
#import "DeleteCardInterface.h"
#import "CMRManager.h"
#import "FullText.h"
#import "DropDownCell.h"
@interface CardpackageViewController : UIViewController<CardInterfaceDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,DeleteCardInterfaceDelegate,WYPopoverControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,CardCustomViewDelegate>

{
    BOOL dropDown1Open;
}
@property (strong, nonatomic) CardInterface *cardInter;
@property (strong, nonatomic) DeleteCardInterface *deleteInter;

@property (nonatomic, strong) NSMutableArray *cardArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@property (nonatomic, strong) AppDelegate *appDel;
//下拉状态
@property (nonatomic, strong) IBOutlet UITableView *pullTable;
@property (nonatomic, strong) NSArray *typeArray;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
@property (nonatomic, strong) IBOutlet UIView *cataview;
@property (strong, nonatomic) IBOutlet UIButton *defaultBtn;

@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTxt;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
@property (nonatomic, strong) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, strong) UITableView *myTable;
@property (strong, nonatomic) MyPageControl *myPageControl;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
@property (nonatomic, strong) FullText *fullTextView;
@end
