//
//  ZZKTVAudioPlayManager.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/13.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZKTVAudioPlayManager;
@protocol ZZKTVAudioPlayManagerDelegate<NSObject>

- (void)managerDidFinish:(ZZKTVAudioPlayManager *)manager;

@end

@interface ZZKTVAudioPlayManager : NSObject

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, weak) id<ZZKTVAudioPlayManagerDelegate> delegate;

- (void)playAudio:(NSString *)audioPath;

- (void)play;

- (void)pause;

- (void)stop;

- (void)releasePlayer;

@end

