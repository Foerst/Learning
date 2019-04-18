//
//  ViewController.m
//  NSDictionary_NSCache_NSMapTable_test
//
//  Created by CXY on 2018/9/21.
//  Copyright © 2018年 CXY. All rights reserved.
//

#import "ViewController.h"
#import "Cat.h"
#import "Key.h"

@interface ViewController ()
@property (nonatomic, assign) NSMutableDictionary *dict;
@property (nonatomic, assign) NSMutableArray *array;
@property (nonatomic, assign) NSCache *cache;
@property (nonatomic, assign) NSHashTable *hashTable;
@property (nonatomic, assign) NSMapTable *mapTable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dict = [NSMutableDictionary new];
    _array = [NSMutableArray new];
    _cache = [NSCache new];
    _hashTable = [NSHashTable new];
    _mapTable = [NSMapTable new];
    
    
    Key *key = [Key new];
    Cat *obj = [Cat new];
    NSLog(@"retainCount == %ld", obj.retainCount);
//    [self.hashTable setObject:obj forKey:key];
//    [self.hashTable addObject:obj];
    [self.mapTable setObject:obj forKey:key];
//    [self.array addObject:obj];
    NSLog(@"retainCount == %ld", obj.retainCount);
    
    [self.dict release];
    _dict = nil;
}


@end
