//
//  AudioManager.h
//  ZXartApp
//
//  Created by mac  on 2018/3/28.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MaximunRecodingTime 20

typedef NS_ENUM(NSInteger, RecordErrorType) {
    RecordErrorTypeAuthorizationDenied,
    RecordErrorTypeInitFailed,
    RecordErrorTypeCreateRecorderFail,
    RecordErrorTypeMultiRequest,
};

typedef NS_ENUM(NSInteger, RecordState) {
    RecordStateIdle          = 10,
    RecordStateReadyToRecord,
    RecordStateRecording,
    RecordStatePause,
    RecordStateSuccess,
    RecordStateCancel,
    RecordStateFail,
};

typedef NS_ENUM(NSInteger, AudioState) {
    AudioStateIdle,
    AudioStateRecording,
    AudioStateRecordPause,
    AudioStateRecordFinish,
    AudioStatePlaying,
    AudioStatePause,
    AudioStateFinish,
};

@protocol AudioManagerDelegate;

@interface AudioManager : NSObject

@property (nonatomic,   weak) id<AudioManagerDelegate> delegate;

@property (nonatomic, assign) RecordState recordState;

@property (nonatomic, strong) AVAudioSession  *audioSession;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, strong) NSTimer         *timer;

@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

@property (nonatomic, assign, readonly) NSTimeInterval totalTime;

@property (nonatomic,   copy) NSString *audioDirectory;

@property (nonatomic,   copy, readonly) NSString *rawFilePath;

@property (nonatomic, assign) double maximunRecordLength;

+ (AudioManager *)audioManager;

+ (AudioManager *)playAudio:(NSString *)audioPath;

- (void)defaultPlayState:(NSString *)filePath;

- (void)reset;

#pragma mark - Record
- (void)fetchRecordAuthentication:(void(^)(AVAudioSessionRecordPermission recordPermission))block;

- (void)startRecording;

- (void)pauseRecording;

- (void)stopRecording;

- (void)cancelRecording;

#pragma mark - Files
+ (void)deleteAudio:(NSString *)filePath;

- (void)deleteAudio:(NSString *)filePath;

#pragma mark - convert
+ (void)convertWAV:(NSString *)wavFilePath completeHandler:(void(^)(BOOL isSuccess, NSString *amrFilePath))completeHandler;

@end

@protocol AudioManagerDelegate <NSObject>

@optional
#pragma mark Recorder Delegate
- (void)audioManager:(AudioManager *)manager recordFail:(NSError *)error;

- (void)audioManager:(AudioManager *)manager recordStateDidChanged:(RecordState)recordState;

- (void)audioManager:(AudioManager *)manager recordSuccess:(NSString *)filePath duration:(NSTimeInterval)audioDurantion;

- (void)audioManager:(AudioManager *)manager recordingDuration:(NSTimeInterval)duration soundPower:(NSDictionary *)powerInfo;

@end
