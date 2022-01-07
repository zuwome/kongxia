//
//  ZZVideoPreProcessing.h
//  zuwome
//
//  Created by angBiu on 2017/8/30.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AgoraRtcEngineKit;

@interface ZZVideoPreProcessing : NSObject

+ (int) registerVideoPreprocessing:(AgoraRtcEngineKit*) kit;
+ (int) deregisterVideoPreprocessing:(AgoraRtcEngineKit*) kit;

@end
