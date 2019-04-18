//
//  VideoViewController.m
//  HLS
//
//  Created by CXY on 2019/1/11.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

#import "HLSPlayerController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HLSPlayerController ()
{
    AVPlayerViewController *_playerViewController;
}
@end

@implementation HLSPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置资源路径
    NSString *m3u8 = @"http://localhost:8080/hls/a/a.m3u8";
    NSURL *url = [NSURL URLWithString:m3u8];
    AVPlayer *avPlayer= [AVPlayer playerWithURL:url];
    // player的控制器对象
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    // 控制器的player播放器
    playerViewController.player = avPlayer;
    // 试图的填充模式
    playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
    // 是否显示播放控制条
    playerViewController.showsPlaybackControls = YES;
    // 设置显示的Frame
    playerViewController.view.frame = self.view.bounds;
    _playerViewController = playerViewController;
    // 将播放器控制器添加到当前页面控制器中
    [self addChildViewController:_playerViewController];
    // view一定要添加，否则将不显示
    [self.view addSubview:playerViewController.view];
    // 播放
    [playerViewController.player play];

}


@end
