//
//  SpellMatchObj.m
//  cjzyb_ios
//
//  Created by david on 14-3-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SpellMatchObj.h"

@implementation SpellMatchObj
-(NSString *)description{
    return [NSString stringWithFormat:@"range:%@==color:%@==underline:%@==originText:%@",NSStringFromRange(self.range),self.color,self.isUnderLine?@"_":@"NO",self.originText];
}
@end