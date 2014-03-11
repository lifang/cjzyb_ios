//
//  CMRManager.h
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SearchCore.h"

#define KSeparateWord '/'
#define KStringNull @""

@interface CMRManager : NSObject
{
    SearchTree iSearchTree;
    NSString *separateWord;
    NSString *matchFunction;
}

+ (CMRManager *)sharedService;

- (void)addCardId:(int)cardId wrong:(NSString *)wrong right:(NSString *)right;


- (void)Search:(NSString*)searchText searchArray:(NSArray*)aSearchedArray wrongMatch:(NSMutableArray*)wrongMatchArray rightMatch:(NSMutableArray*)rightMatchArray;

- (void)SearchWithFunc:(NSString*)matchFunc searchText:(NSString*)searchText searchArray:(NSArray*)aSearchedArray wrongMatch:(NSMutableArray*)wrongMatchArray rightMatch:(NSMutableArray*)rightMatchArray;

/*
 重置搜索——清空搜索缓存
 */
- (void)Reset;
@end
