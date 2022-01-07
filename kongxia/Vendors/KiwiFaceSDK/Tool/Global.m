//
//  Global.m
//  zuwome
//
//  Created by qiming xiao on 2019/2/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "Global.h"

@implementation Global

+ (Global *)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
