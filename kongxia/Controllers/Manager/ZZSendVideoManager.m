//
//  ZZSendVideoManager.m
//  zuwome
//
//  Created by YuTianLong on 2017/11/16.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZSendVideoManager.h"

@interface ZZSendVideoManager ()

@end

@implementation ZZSendVideoManager

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)invalidate {
    [super invalidate];
}

- (void)removeInstance {
    [super removeInstance];
}

- (void)asyncVideoStartSendingVideo:(ZZVideoUploadStatusView *)model {
    [self notifyObserversWithSelector:@selector(videoStartSendingVideoUploadStatus:) withObject:model];
}

- (void)asyncVideoSendProgress:(NSString *)progress {
    [self notifyObserversWithSelector:@selector(videoSendProgress:) withObject:progress];
}

- (void)asyncSendVideoWithVideoId:(ZZSKModel *)sk {
    [self notifyObserversWithSelector:@selector(videoSendSuccessWithVideoId:) withObject:sk];
}

- (void)asyncSendVideoFailWithError:(NSDictionary *)error {
    [self notifyObserversWithSelector:@selector(videoSendFailWithError:) withObject:error];
}

@end
