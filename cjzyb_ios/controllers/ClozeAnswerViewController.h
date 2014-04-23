//
//  ClozeAnswerViewController.h
//  cjzyb_ios
//
//  Created by comdosoft on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClozeAnswerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSDictionary *answerDic;
@property (nonatomic, strong) NSArray *answerArray;
@end
