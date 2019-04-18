//
//  ViewController.m
//  NSURLCache
//
//  Created by CXY on 2019/1/29.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <AVKit/AVKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)act:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:@"https://video.ubtrobot.com/jimu/post/180616131624932685.mp4"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSCachedURLResponse *response =  [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
        if (response) {
            NSLog(@"---这个请求已经存在缓存---");
            if (response.data) {
                //            NSString *ret = [[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
                NSLog(@"%@----%li", response.response.URL, response.data.length);
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:url.lastPathComponent];
                if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
                    BOOL ret = [response.data writeToFile:path atomically:NO];
                    if (ret) {
                        NSLog(@"视频保存失败！");
                        return;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
                    playerViewController.player = player;
                    [self presentViewController:playerViewController animated:YES completion:^{
                        [player play];
                    }];
                });
            }
        } else {
            NSLog(@"---这个请求没有缓存---");
        }
        
    });
    
}


@end
