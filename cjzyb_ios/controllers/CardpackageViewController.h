//
//  CardpackageViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-2-28.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardObject.h"
#import "CardFirstView.h"
#import "CardSecondView.h"
#import "CardInterface.h"
#import "CardCustomView.h"
#import "MyPageControl.h"
#import "DeleteCardInterface.h"
#import "TagObject.h"
#import "TagViewController.h"
#import "CMRManager.h"
#import "FullText.h"
@interface CardpackageViewController : UIViewController<CardFirstViewDelegate,CardSecondViewDelegate,CardInterfaceDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,DeleteCardInterfaceDelegate,WYPopoverControllerDelegate>

@property (strong, nonatomic) CardInterface *cardInter;
@property (strong, nonatomic) DeleteCardInterface *deleteInter;

@property (nonatomic, strong) NSMutableArray *cardArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@property (nonatomic, strong) AppDelegate *appDel;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
@property (nonatomic, strong) IBOutlet UIView *cataview;
@property (strong, nonatomic) IBOutlet UIButton *redBtn;
@property (strong, nonatomic) IBOutlet UIButton *writeBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectedBtn;
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
