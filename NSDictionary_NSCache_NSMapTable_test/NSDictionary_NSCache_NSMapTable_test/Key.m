//
//  Key.m
//  NSDictionary_NSCache_NSMapTable_test
//
//  Created by CXY on 2018/9/21.
//  Copyright © 2018年 CXY. All rights reserved.
//

#import "Key.h"

@interface Key()


@end

@implementation Key

- (id)copyWithZone:(NSZone *)zone {
    Key *ret = [[Key allocWithZone:zone] init];
    ret.name = [_name copy];
    return ret;
}
@end

