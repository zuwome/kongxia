//
//  ZZCallIphoneVideoManager.h
//  zuwome
//
//  Created by 潘杨 on 2018/2/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//打电话进入播放界面的时候的来电声音管理类

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface ZZCallIphoneVideoManager : NSObject
singleton_interface(ZZCallIphoneVideoManager)
@property (strong, nonatomic) AVAudioPlayer *ringPlayer;

/**
 来电铃声
 */
- (void)beginRing;

/**
 取消来电铃声
 */
- (void)stopRing;
@end
