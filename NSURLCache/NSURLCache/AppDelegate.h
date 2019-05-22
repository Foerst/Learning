//
//  AppDelegate.h
//  NSURLCache
//
//  Created by CXY on 2019/1/29.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *videoUrl = @"https://video.ubtrobot.com/jimu/post/180616131624932685.mp4";

static NSString *mp3Url = @"http://sc1.111ttt.cn/2018/1/03/13/396131232171.mp3";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSMutableURLRequest *request;

@end

