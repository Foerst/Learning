//
//  AppDelegate.h
//  NSURLCache
//
//  Created by CXY on 2019/1/29.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSMutableURLRequest *request;

@end

