//
//  ViewController.m
//  RtmpPush
//
//  Created by CXY on 2019/1/12.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

#import "RTMPLivePushStreamViewController.h"
#import <LFLiveKit.h>

@interface RTMPLivePushStreamViewController ()
@property (nonatomic, strong) LFLiveSession *session;
@end

@implementation RTMPLivePushStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAccessForAudio];
    [self requestAccessForVideo];
}

- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:nil];
            break;
        case AVAuthorizationStatusDenied:
            break;
        case AVAuthorizationStatusAuthorized:
            break;
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

- (void)requestAccessForVideo {
    __weak typeof(self) weakSelf = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf startSession];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            [weakSelf startSession];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}


- (void)startSession {
    if (!_session) {
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        _session.preView = self.view;
        _session.beautyFace = YES;
    }
    [_session setRunning:YES];
}


- (IBAction)startLive:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"开始直播"]) {
        [sender setTitle:@"结束直播" forState:UIControlStateNormal];
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        stream.url = @"rtmp://10.10.60.209:1935/hls/live";
        [self.session startLive:stream];
    } else {
        [sender setTitle:@"开始直播" forState:UIControlStateNormal];
        [self.session stopLive];
    }
}

- (IBAction)beaty:(UIButton *)sender {
    self.session.beautyFace = !self.session.beautyFace;
    NSString *title = self.session.beautyFace ? @"美颜关闭" : @"美颜打开";
    [sender setTitle:title forState:UIControlStateNormal];
}

- (IBAction)switchCamera:(UIButton *)sender {
    if (self.session.captureDevicePosition == AVCaptureDevicePositionBack) {
        self.session.captureDevicePosition = AVCaptureDevicePositionFront;
    } else {
        self.session.captureDevicePosition = AVCaptureDevicePositionBack;
    }
}

@end
