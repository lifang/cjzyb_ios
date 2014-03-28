//
//  ReadingSentenceObj.m
//  cjzyb_ios
//
//  Created by david on 14-3-4.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ReadingSentenceObj.h"

@implementation ReadingSentenceObj
-(NSMutableArray *)readingErrorWordArray{
    if (!_readingErrorWordArray) {
        _readingErrorWordArray = [NSMutableArray array];
    }
    return _readingErrorWordArray;
}
@end
