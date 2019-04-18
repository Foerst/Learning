//
//  Cat.m
//  NSDictionary_NSCache_NSMapTable_test
//
//  Created by CXY on 2018/9/21.
//  Copyright © 2018年 CXY. All rights reserved.
//

#import "Cat.h"

@implementation Cat

- (void)dealloc {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [super dealloc];
}
@end
