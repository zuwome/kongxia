//
//  AudioManager.m
//  ZXartApp
//
//  Created by mac  on 2018/3/28.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "AudioManager.h"
#import<AVFoundation/AVFoundation.h>
#import "FileCenter.h"

#define ZX_SAFE_SEND_MESSAGE(obj, msg) if ((obj) && [(obj) respondsToSelector:@selector(msg)])
#define ZX_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })
@interface AudioManager ()
<
    AVAudioRecorderDelegate,
    AVAudioPlayerDelegate
>

@end

@implementation AudioManager

static AudioManager *_instance = nil;
static dispatch_once_t predicate;

#pragma mark - Class Method
+ (AudioManager *)audioManager {
    WeakSelf
    dispatch_once(&predicate, ^{
        if (!_instance) {
            _instance = [[weakSelf alloc] init];
        }
    });
    return _instance;
}

+ (void)attempDealloc {
    predicate = 0;
    _instance = nil;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _audioSession   = [AVAudioSession sharedInstance];
        [self defaultSetting];
        _audioDirectory = [self generateAudioDirectory];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"it is Over");
}


- (void)defaultSetting {
    _maximunRecordLength = MaximunRecodingTime;
    [self recordStateChanged:RecordStateIdle];
}

- (void)recordStateChanged:(RecordState)recordState {
    _recordState         = recordState;
    if (_recordState == RecordStateRecording) {
        [self appIdleTimer:NO];
    }
    else {
        [self appIdleTimer:YES];
    }
    ZX_SAFE_SEND_MESSAGE(_delegate, audioManager:recordStateDidChanged:) {
        [_delegate audioManager:self recordStateDidChanged:_recordState];
    }
}


#pragma mark - Recording
- (void)startRecording {
    [self configureAudioRecorder:^(NSError *error) {
        if (!error) {
            [self addNotification];
            
            [self startTimer];
            [self.audioRecorder record];
            [self recordStateChanged:RecordStateRecording];
        }
        else {
            ZX_SAFE_SEND_MESSAGE(_delegate, audioManager:recordFail:) {
                [_delegate audioManager:self recordFail:error];
            }
            [self recordStateChanged:RecordStateFail];
        }
    }];
}

- (void)pauseRecording {
    if (self.audioRecorder.isRecording) {
        [self pauseTimer];
        [self.audioRecorder pause];
        [self recordStateChanged:RecordStatePause];
    }
}

- (void)stopRecording {
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
        [self stopTimer];
    }
    [self removeNotification];
}

- (void)cancelRecording {
    [self recordStateChanged:RecordStateCancel];
    [self.audioRecorder stop];
    
    [self.audioRecorder deleteRecording];
    [self stopTimer];
}

- (void)configureAudioRecorder:(void(^)(NSError *error))block {
    
    if (_recordState == RecordStatePause) {
        ZX_SAFE_BLOCK(block,nil);
        return;
    }
    
    NSError *error = nil;
    
    // 判断是否正在录音
    if (self.audioRecorder.isRecording) {
        error = [NSError errorWithDomain:@"AudioManager_domain"
                                    code:RecordErrorTypeMultiRequest
                                userInfo:nil];
        NSLog(@"\n********************************\n\
                  *          录音被使用中          *\n\
                  ********************************");
        ZX_SAFE_BLOCK(block,error);
        return;
    }
    
    // 设置
    error = nil;
    BOOL isSuccess = [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (!isSuccess || error) {
        error = [NSError errorWithDomain:@"AudioManager_domain"
                                    code:RecordErrorTypeInitFailed
                                userInfo:nil];
        NSLog(@"\n********************************\n\
                  *    AVAudioSession 设置失败     *\n\
                  ********************************");
        ZX_SAFE_BLOCK(block,error);
        return;
    }
    
    // 激活Audio Session
    error     = nil;
    isSuccess = [_audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
     error:nil];
    
    if (!isSuccess || error) {
        error = [NSError errorWithDomain:@"AudioManager_domain"
                                    code:RecordErrorTypeInitFailed
                                userInfo:nil];
        NSLog(@"\n********************************\n\
                  *    AVAudioSession 激活失败     *\n\
                  ********************************");
        ZX_SAFE_BLOCK(block,error);            return;
    }
    
    // 创建RecordSetting dic
    NSDictionary *recordSettingDictionary = [self fetchAudioRecorderSetting];
    
    // 创建Raw File Path
    _rawFilePath = [self generateRecordPath];
    
    // 创建 Audio Recorder
    error  = nil;
    NSURL *filePath = [NSURL fileURLWithPath:_rawFilePath];
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:filePath settings:recordSettingDictionary error:&error];
    if (error) {
        error = [NSError errorWithDomain:@"AudioManager_domain"
                                    code:RecordErrorTypeCreateRecorderFail
                                userInfo:@{
                                           @"errorInfo" : error.localizedDescription
                                           }];
        NSLog(@"\n********************************\n\
              *      AudioRecorder 创建失败      *\n\
              ********************************");
        ZX_SAFE_BLOCK(block,error);
        return;
    }
    
    isSuccess = [_audioRecorder recordForDuration:_maximunRecordLength];
    if (!isSuccess) {
        error = [NSError errorWithDomain:@"AudioManager_domain"
                                    code:RecordErrorTypeCreateRecorderFail
                                userInfo:@{
                                           @"errorInfo" : @"设置AudioRecorder 最大时长失败"
                                           }];
        NSLog(@"\n********************************\n\
                  *  设置AudioRecorder 最大时长失败  *\n\
                  ********************************");
        ZX_SAFE_BLOCK(block,error);
        return;
    }
    
    _audioRecorder.delegate        = self;
    _audioRecorder.meteringEnabled = YES;
    [_audioRecorder prepareToRecord];
    [self.audioRecorder updateMeters];
    
    [self recordStateChanged:RecordStateReadyToRecord];
    
    NSLog(@"\n********************************\n\
          *     AudioRecorder 创建成功     *\n\
          ********************************");
    ZX_SAFE_BLOCK(block,nil);
}

// request recorder Authenticaion
- (void)fetchRecordAuthentication:(void(^)(AVAudioSessionRecordPermission recordPermission))block {
    switch (self.audioSession.recordPermission) {
        case AVAudioSessionRecordPermissionUndetermined: {
            [self.audioSession requestRecordPermission:^(BOOL granted) {
                ZX_SAFE_BLOCK(block,granted ? AVAudioSessionRecordPermissionGranted : AVAudioSessionRecordPermissionDenied);
            }];
            ZX_SAFE_BLOCK(block,AVAudioSessionRecordPermissionUndetermined);
            break;
        }
        case AVAudioSessionRecordPermissionDenied: {
            ZX_SAFE_BLOCK(block, AVAudioSessionRecordPermissionDenied);
            break;
        }
        case AVAudioSessionRecordPermissionGranted: {
            ZX_SAFE_BLOCK(block, AVAudioSessionRecordPermissionGranted);
            break;
        }
        default:
            break;
    }
}

// create Audio Recorder Setting
- (NSDictionary *)fetchAudioRecorderSetting {
    NSMutableDictionary *dicM      = @{}.mutableCopy;
    dicM[AVFormatIDKey]            = @(kAudioFormatLinearPCM);
    dicM[AVSampleRateKey]          = @(8000.0);
    dicM[AVNumberOfChannelsKey]    = @(1);
    dicM[AVLinearPCMBitDepthKey]   = @(16);
    dicM[AVEncoderAudioQualityKey] = @(AVAudioQualityHigh);
    return dicM.copy;
}

#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"Recording Success!!!!!!!!!!!!!!!!!!!!!!!");
    
    if (_recordState != RecordStateCancel) {
        
        NSURL *voiceURL = [NSURL fileURLWithPath:_rawFilePath];
        AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:voiceURL options:nil];
        CMTime audioDuration = audioAsset.duration;
        NSTimeInterval audioTime = CMTimeGetSeconds(audioDuration);
        
        ZX_SAFE_SEND_MESSAGE(_delegate, audioManager:recordSuccess:duration:) {
            [_delegate audioManager:self recordSuccess:_rawFilePath duration:audioTime];
        }
        [self recordStateChanged:RecordStateSuccess];
    }
    [self stopTimer];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    NSError *error1 = error = [NSError errorWithDomain:@"AudioManager_domain"
                                                  code:RecordErrorTypeCreateRecorderFail
                                              userInfo:@{
                                                         @"audioError" : error.localizedDescription
                                                         }];
    ZX_SAFE_SEND_MESSAGE(_delegate, audioManager:recordFail:) {
        [_delegate audioManager:self recordFail:error1];
    }
    [self recordStateChanged:RecordStateFail];
    [self stopTimer];
}

#pragma mark - Application Active State
- (void)appIdleTimer:(BOOL)enable {
//    if (enable) {
//        [UIApplication enableIdleTimer];
//    }
//    else {
//        [UIApplication disableIdleTimer];
//    }
}

#pragma mark File Path
- (NSString *)generateAudioDirectory {
    NSError *error = nil;
    NSString *audioDirectory = [[FileCenter fileCenter] createFileDirectoryForDirectoryName:[NSString stringWithFormat:@"Audios"] error:&error];
    if (error) {
        return nil;
    }
    return audioDirectory;
}

- (NSString *)generateRecordPath {
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.pcm",[ZZUserHelper shareInstance].loginer.uid,[ZZDateHelper fetchCurrentTimeStampe]];
    return [self generateAudioPath:fileName];
}

- (NSString *)generateAudioPath:(NSString *)fileName {
    NSString *directoryPath = _audioDirectory ? _audioDirectory : DocumentsPath;
    return [directoryPath stringByAppendingPathComponent:fileName];
}

#pragma mark - Files
+ (void)deleteAudio:(NSString *)filePath {
    [[FileCenter fileCenter] removeFileAt:filePath error:nil];
}

- (void)deleteAudio:(NSString *)filePath {
    [[FileCenter fileCenter] removeFileAt:filePath error:nil];
}


#pragma mark - NSTimer
- (void)audioPowerChange {
    if(_recordState == RecordStateRecording) {
        // 跟新检测值
        [self.audioRecorder updateMeters];
        
        // 获取第一个通道的音频，注音音频的强度方位-160到0
//        float power = [self.audioRecorder averagePowerForChannel:1];
//        CGFloat progerss = (1.0 / 160) * (power + 160);
//        NSLog(@"audio power  is %f",progerss);
//        NSLog(@"current time is %.0f",_audioRecorder.currentTime);
        ZX_SAFE_SEND_MESSAGE(_delegate, audioManager:recordingDuration:soundPower:) {
            [_delegate audioManager:self recordingDuration:_audioRecorder.currentTime soundPower:nil];
        }
    }
}

- (void)configureTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                              target:self
                                            selector:@selector(audioPowerChange)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)startTimer {
    if (!_timer) {
        [self configureTimer];
    }
    self.timer.fireDate = [NSDate distantPast];
}

- (void)pauseTimer {
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)stopTimer {
    if (!self.timer) {
        return;
    }
    self.timer.fireDate = [NSDate distantFuture];
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - Notifications
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayEnterBack:) name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayBecomeActive:) name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    

}

- (void)videoPlayEnterBack:(NSNotification*)notification {
    [self stopRecording];
}

- (void)videoPlayBecomeActive:(NSNotification*)notification {
    
}

- (void)monitorAppActive {
//    [[NotificationManager applicationObserver] monitorAppActiveStateChange:^(BOOL didBecomActive) {
//        [self appIdleTimer:!didBecomActive];
//    }];
}

- (void)stopMonitor {
//    [[NotificationManager applicationObserver] stopAppActiveObserver];;
}


#pragma mark - Setter&Getter
- (void)setDelegate:(id<AudioManagerDelegate>)delegate {
    _delegate = delegate;
}

@end

