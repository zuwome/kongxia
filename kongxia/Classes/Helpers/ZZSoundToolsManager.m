//
//  ZZSoundToolsManager.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/14.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZSoundToolsManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ZZSoundToolsManager () {
    SystemSoundID sound;
}

@property (nonatomic, assign, readwrite) BOOL isVibrate;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation ZZSoundToolsManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterForegroundNotification)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)invalidate {
    [super invalidate];
}

- (void)removeInstance {
    [super removeInstance];
}

- (void)enterForegroundNotification {
    [self stopAlertSound];
}

// 暂停
- (void)pauseTimer {
    if(_timer) {
        dispatch_suspend(_timer);
    }
}

// 继续/恢复
- (void)resumeTimer {
    if(_timer) {
        dispatch_resume(_timer);
    }
}

// 停止
- (void)stopTimer {
    if(_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)starAlertSound {
 
    [self startGCDTimer];
    //如果你想震动的提示播放音乐的话就在下面填入你的音乐文件
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"marbach" ofType:@"mp3"];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);  
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(sound);
    _isVibrate = YES;
}

- (void)startGCDTimer {
    
    _count = 0;
    
    NSLog(@"开始震动了。。。");
    
    WEAK_SELF();
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        _count += 1;
        [weakSelf playkSystemSound];//每秒单独震动
        if (_count == 20) { // 后台震动20秒停止
            [weakSelf stopAlertSound];
        }
    });
    dispatch_resume(_timer);
}

// 每秒震动
- (void)playkSystemSound{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)stopAlertSound {
    
    WEAK_SELF();
    _count = 0;
    NSLog(@"停止震动了。。。");
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf stopAlertSoundWithSoundID:sound];
    });

    [self stopTimer];
    _isVibrate = NO;
}

// 停止系统震动/音效
- (void)stopAlertSoundWithSoundID:(SystemSoundID)sound {
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesDisposeSystemSoundID(sound);
}

void soundCompleteCallback(SystemSoundID sound, void *clientData) {
    /*实时回调的不启用震动*/
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
    AudioServicesPlaySystemSound(sound);    //播放音乐
}

extern OSStatus
AudioServicesAddSystemSoundCompletion(SystemSoundID                         inSystemSoundID,
                                      CFRunLoopRef                          inRunLoop,
                                      CFStringRef                           inRunLoopMode,
                                      AudioServicesSystemSoundCompletionProc    inCompletionRoutine,
                                      void*                                 inClientData)
__OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_2_0);

@end
