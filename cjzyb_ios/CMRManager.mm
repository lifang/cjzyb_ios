//
//  CMRManager.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRManager.h"
static CMRManager *dataService = nil;
@implementation CMRManager

- (id)init{
    self = [super init];
    if (self) {
        SearchTreeInit(&iSearchTree);
        NSString *multiPYinpath = [[NSBundle mainBundle] pathForResource:@"multipy_unicode" ofType:@"dat"];
        LoadMultiPYinWords([multiPYinpath UTF8String]);
        separateWord = [[NSString stringWithFormat:@"%c",KSeparateWord]retain];
    }
    return self;
}
+ (CMRManager *)sharedService {
    if (!dataService) {
        dataService = [[CMRManager alloc] init];
    }
    return dataService;
}

- (void)SetMatchFunction:(NSString*) matchFunc {
    if (matchFunction==matchFunc || [matchFunction isEqualToString:matchFunc]) {
        return;
    }
    if (matchFunction) {
        [matchFunction release];
    }
    matchFunction = [matchFunc retain];
    
    
	u2char buf[256];
	[self string_u2char:matchFunc u2char:buf];
	
	Tree_SetMatchFunction(&iSearchTree,buf);
}

//string 转 u2char
- (void)string_u2char:(NSString*)src u2char:(u2char*)des {
    u2char* ptr = des;
    for (int i = 0; i < [src length]; i ++) {
        unichar word = [src characterAtIndex:i];
        *ptr = word;
        ptr ++;
    }
    *ptr = 0;
}

//Array 转 NSArray
- (void)ArrayToNSArray:(Array*)array NSArray:(NSMutableArray*)arrayDes {
    [arrayDes removeAllObjects];
    
    for (int i = 0; i < array->size; i ++) {
        int aID = array->GetValue(array,i);
        [arrayDes addObject:[NSNumber numberWithInt:aID]];
    }
}

- (void)addCardId:(int)cardId wrong:(NSString *)wrong right:(NSString *)right {
    
    u2char wrongBuf[wrong.length + 1];
    [self string_u2char:wrong u2char:wrongBuf];
    
    u2char rightBuf[right.length + 1];
    [self string_u2char:right u2char:rightBuf];

    Tree_AddData(&iSearchTree,cardId,wrongBuf,rightBuf);
}


- (void)SearchDefault:(NSString*)searchText searchArray:(NSArray*)aSearchedArray wrongMatch:(NSMutableArray*)wrongMatchArray rightMatch:(NSMutableArray*)rightMatchArray {
    
    u2char searchTextBuf[searchText.length + 1];
    [self string_u2char:searchText u2char:searchTextBuf];
    
    Array* searchedArray = NULL;
	Array* nameMatchHits = NULL;
	Array* phoneMatchHits = NULL;
	if (aSearchedArray) {
		searchedArray = new Array;
		ArrayInit(searchedArray);
        
        for (int i = 0; i < [aSearchedArray count]; i ++) {
            NSNumber *number = [aSearchedArray objectAtIndex:i];
            searchedArray->Append(searchedArray,[number intValue]);
        }
    }
	
	if (wrongMatchArray) {
        [wrongMatchArray removeAllObjects];
        
		nameMatchHits = new Array;
		ArrayInit(nameMatchHits);
    }
	
	if (rightMatchArray) {
        [rightMatchArray removeAllObjects];
        
		phoneMatchHits = new Array;
		ArrayInit(phoneMatchHits);
    }
	
	Tree_Search(&iSearchTree,searchTextBuf,searchedArray,nameMatchHits,phoneMatchHits);
	
	if (nameMatchHits) {
        [self ArrayToNSArray:nameMatchHits NSArray:wrongMatchArray];
		nameMatchHits->Reset(nameMatchHits);
		delete nameMatchHits;
    }
	
	if (phoneMatchHits) {
        [self ArrayToNSArray:phoneMatchHits NSArray:rightMatchArray];
		phoneMatchHits->Reset(phoneMatchHits);
		delete phoneMatchHits;
    }
	
	if (searchedArray) {
		searchedArray->Reset(searchedArray);
		delete searchedArray;
    }
    
}

//搜索 MatchFunction为空
- (void)Search:(NSString*)searchText searchArray:(NSArray*)aSearchedArray wrongMatch:(NSMutableArray*)wrongMatchArray rightMatch:(NSMutableArray*)rightMatchArray {
    [self SetMatchFunction:KStringNull];
    [self SearchDefault:searchText searchArray:aSearchedArray wrongMatch:wrongMatchArray rightMatch:rightMatchArray];
}

//搜索 带MatchFunction
- (void)SearchWithFunc:(NSString*)matchFunc searchText:(NSString*)searchText searchArray:(NSArray*)aSearchedArray wrongMatch:(NSMutableArray*)wrongMatchArray rightMatch:(NSMutableArray*)rightMatchArray {
    [self SetMatchFunction:matchFunc];
    [self SearchDefault:searchText searchArray:aSearchedArray wrongMatch:wrongMatchArray rightMatch:rightMatchArray];
}

- (void)Reset {
    if (matchFunction) {
        [matchFunction release];
    }
    
    FreeSearchTree(&iSearchTree);
    SearchTreeInit(&iSearchTree);
}
- (void)dealloc {
    //释放多音字库
    ReleaseMultiPYinWords();
    
    //释放搜索库
    FreeSearchTree(&iSearchTree);
	
    if (separateWord) {
        [separateWord release];
    }
    if (matchFunction) {
        [matchFunction release];
    }
    
    [super dealloc];
}
@end
