//
//  ZZCallIphoneVideoManager.m
//  zuwome
//
//  Created by 潘杨 on 2018/2/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZCallIphoneVideoManager.h"

@implementation ZZCallIphoneVideoManager
singleton_implementation(ZZCallIphoneVideoManager)
- (void)beginRing
{
    if (self.ringPlayer.playing&&self.ringPlayer) {
        return;
    }
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"zz_callVideo" ofType:@"caf"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:musicPath];
    NSError *sessionError = nil;
    

    AVAudioSession *audionSession = [AVAudioSession sharedInstance];
    [audionSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audionSession setCategory:AVAudioSessionCategorySoloAmbient error:&sessionError];
    [audionSession setActive:YES error:nil];
    self.ringPlayer =  [[AVAudioPlayer alloc] initWithData:data error:nil];
    [self.ringPlayer setVolume:1];
    self.ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([self.ringPlayer prepareToPlay])
    {
        [self.ringPlayer play]; //播放
    }
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)appDidEnterBackground {
    if (self.ringPlayer) {
        if (self.ringPlayer.playing) {
            return;
        }
        else {
            [self.ringPlayer play];
        }
    }
}

- (void)appDidEnterPlayground {
    if (self.ringPlayer) {
        if (self.ringPlayer.playing) {
            return;
        }
        [self.ringPlayer play];
    }
}
- (void)stopRing
{
    [self.ringPlayer stop];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    _ringPlayer = nil;
}
@end
