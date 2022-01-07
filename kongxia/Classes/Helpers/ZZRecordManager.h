//
//  ZZRecordManager.h
//  zuwome
//
//  Created by angBiu on 16/10/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
/**
 *  聊天 --- 录音
 */

#define shortRecord @"shortRecord"

@protocol ZZRecordManagerDelegate <NSObject>

- (void)voiceDidPlayFinished;

@end

@interface ZZRecordManager : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic, weak) id<ZZRecordManagerDelegate>delegate;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

+ (id)shareManager;

// start recording
- (void)startRecordingWithFileName:(NSString *)fileName
                        completion:(void(^)(NSError *error))completion;
// stop recording
- (void)stopRecordingWithCompletion:(void(^)(NSString *recordPath))completion;

// 是否拥有权限
- (BOOL)canRecord;

// 取消当前录制
- (void)cancelCurrentRecording;

- (void)removeCurrentRecordFile:(NSString *)fileName;

/*********-------播放----------************/

- (void)startPlayRecorder:(NSData *)recorderData;

- (void)stopPlayRecorder:(NSData *)recorderData;

- (void)pause;

// 接收到的语音保存路径(文件以fileKey为名字)
- (NSString *)receiveVoicePathWithFileKey:(NSString *)fileKey;

// 获取语音时长
- (NSUInteger)durationWithVideo:(NSURL *)voiceUrl;

@end
