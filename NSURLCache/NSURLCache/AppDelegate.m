//
//  AppDelegate.m
//  NSURLCache
//
//  Created by CXY on 2019/1/29.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"doc === %@", doc);
    
    // declare a shared NSURLCache with 2mb of memory and 100mb of disk space
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024  diskCapacity:100 * 1024 * 1024  diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"https://video.ubtrobot.com/jimu/post/180616131624932685.mp4"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    _request = request;
    // 2.设置缓存策略(有缓存就用缓存，没有缓存就重新请求)
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    // 3.发送请求
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    _session = session;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"data.length === %lu", data.length);
            
        }
    }];
    _dataTask = dataTask;
    [dataTask resume];
    return YES;
}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
// willCacheResponse:(NSCachedURLResponse *)proposedResponse
// completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
//    completionHandler(proposedResponse);
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
