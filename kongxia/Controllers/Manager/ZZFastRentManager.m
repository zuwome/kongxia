//
//  ZZFastRentManager.m
//  zuwome
//
//  Created by YuTianLong on 2017/10/12.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZFastRentManager.h"

@interface ZZFastRentManager ()

@end

@implementation ZZFastRentManager

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

- (void)syncUpdateMissionStatus:(BOOL)isUnderway {
    [self notifyObserversWithSelector:@selector(missionDidChangeWithUnderway:) withObject:isUnderway ? @"1" : @"0"];
}

- (void)syncUpdateRemainingTimeWithTime:(NSString *)time {
    [self notifyObserversWithSelector:@selector(remainingTimeDidChangeWithTime:) withObject:time];
}

@end
