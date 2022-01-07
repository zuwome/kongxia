//
//  NSString+Qiniu.m
//  Pods
//
//  Created by wlsy on 16/1/24.
//
//

#import "NSString+Qiniu.h"

@implementation NSString (Qiniu)

- (NSURL *)qiniuURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@", self]];
}

- (NSURL *)widthOfQiniuURL:(NSInteger)width webp:(BOOL)isWebp {
    if (isWebp) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/thumbnail/%ldx/format/webp", self,(long)width]];
    } else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageMogr2/thumbnail/%ldx", self,(long)width]];
    }
}

- (NSURL *)widthOfQiniuURL:(NSInteger)width {
    return [self widthOfQiniuURL:width webp:NO];
}


@end
