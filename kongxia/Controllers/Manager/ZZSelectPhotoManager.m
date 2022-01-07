//
//  ZZSelectPhotoManager.m
//  zuwome
//
//  Created by YuTianLong on 2017/10/24.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZSelectPhotoManager.h"

@interface ZZSelectPhotoManager ()

@end

@implementation ZZSelectPhotoManager

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

- (void)videoStarClips {
    [self notifyObserversWithSelector:@selector(videoStarClip) withObject:nil];
}

- (void)videoClipCompleteForUrl:(NSURL *)url pixelWidth:(NSUInteger)pixelWidth pixelHeight:(NSUInteger)pixelHeight {
    [self notifyObserversWithSelector:@selector(videoClipCompleteWithUrl:pixelWidth:pixelHeight:) withObjectOne:url objectTwo:INT_TO_STRING(pixelWidth) objectThree:INT_TO_STRING(pixelHeight)];
}

@end
