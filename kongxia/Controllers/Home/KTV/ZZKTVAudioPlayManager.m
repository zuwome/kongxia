//
//  ZZKTVAudioPlayManager.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/13.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVAudioPlayManager.h"
#import "kongxia-Swift.h"


static dispatch_once_t ZZAudioPlayerManagerOnce = 0;
__strong static id _audioPlayerManagersharedObject = nil;

@interface ZZKTVAudioPlayManager () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVPlayer      *player;

@property (nonatomic, strong) AVPlayerItem  *playItem;

@property (nonatomic, strong) id            timeObserver;


@end

@implementation ZZKTVAudioPlayManager

+ (ZZKTVAudioPlayManager *)audioPlayManager {
    dispatch_once(&ZZAudioPlayerManagerOnce, ^{
        _audioPlayerManagersharedObject = [[self alloc] init];
    });
    return _audioPlayerManagersharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)playAudio:(NSString *)audioPath{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:nil];
    [[AVAudioSession sharedInstance] setActive:YES
                 withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                       error:nil];
    NSString *fullPath;
    if (![audioPath hasPrefix:kQNPrefix_url]) {
        fullPath =  [NSString stringWithFormat:@"%@%@", kQNPrefix_url, audioPath];
    }
    else {
        fullPath = audioPath;
    }
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:fullPath]];
    
    //替换当前音乐资源
    [self.player replaceCurrentItemWithPlayerItem:item];
    
//    //监听播放器状态
//    [self addPlayStatus];
//    
//    //监听音乐缓冲进度
//    [self addPlayLoadTime];
//    
//    //监听音乐播放的进度
//    [self addMusicProgressWithItem:item];
    
    [self addNotification];
    
    [self play];
}

- (void)play {
    _isPlaying = YES;
    [_player play];
}

- (void)pause {
    _isPlaying = NO;
    [_player pause];
}

- (void)stop {
    _isPlaying = NO;
    [_player pause];
}

- (void)releasePlayer {
    [_player pause];
    [_player replaceCurrentItemWithPlayerItem:nil];
    _player = nil;
    
    [self removeNotification];
}

//通过KVO监听播放器状态
-(void)addPlayStatus {
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removePlayStatus {
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
}
    

//KVO监听音乐缓冲状态
- (void)addPlayLoadTime {
  [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}

//移除监听音乐缓冲状态
- (void)removePlayLoadTime {
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

//观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
   //注意这里查看的是self.player.status属性
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown: {
                NSLog(@"未知转态");
                break;
            }
            case AVPlayerStatusReadyToPlay: {
                NSLog(@"准备播放");
                [self play];
                _isPlaying = YES;
                break;
            }
            case AVPlayerStatusFailed: {
                NSLog(@"加载失败");
                break;
            }
            default:
                break;
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        //更新缓冲进度条
        NSLog(@"buffer is %f", scale);
    }
}

//监听音乐播放的进度
- (void)addMusicProgressWithItem:(AVPlayerItem *)item {
    //移除监听音乐播放进度
    [self removeTimeObserver];
    self.timeObserver =  [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        float current = CMTimeGetSeconds(time);
        //总时间
        float total = CMTimeGetSeconds(item.duration);
        if (current) {
            float progress = current / total;
            //更新播放进度条
           NSLog(@"progress is %f", progress);
        }
    }];
    
}

//移除监听音乐播放进度
-(void)removeTimeObserver {
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}


#pragma mark - Notifications
- (void)addNotification {
    //添加AVPlayerItem播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayDidFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_player.currentItem];
    
    //添加AVPlayerItem开始缓冲通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bufferStart:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:_player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayError:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayEnterBack:) name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayBecomeActive:) name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemPlaybackStalledNotification
                                                  object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemPlaybackStalledNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    
    if (self.playItem) {
        [self.playItem removeObserver:self forKeyPath:@"status"];
    }
}

- (void)videoPlayDidFinished:(NSNotification*)notification {
    _isPlaying = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(managerDidFinish:)]) {
        [self.delegate managerDidFinish:self];
    }
}

- (void)videoPlayError:(NSNotification*)notification {
    _isPlaying = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(managerDidFinish:)]) {
        [self.delegate managerDidFinish:self];
    }
}

- (void)bufferStart:(NSNotification*)notification {
    
}

- (void)videoPlayEnterBack:(NSNotification*)notification {
//    [self stop];
}

- (void)videoPlayBecomeActive:(NSNotification*)notification {
    
}

#pragma mark - getter
-(AVPlayer *)player {
    if (_player == nil) {
        //初始化_player
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@""]];
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
    }
    
    return _player;
}

@end
