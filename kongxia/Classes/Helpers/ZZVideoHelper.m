//
//  ZZVideoHelper.m
//  zuwome
//
//  Created by angBiu on 2017/7/29.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZVideoHelper.h"

#import <AVFoundation/AVFoundation.h>

@implementation ZZVideoHelper

+ (void)checkAuthority:(Authorized)authorized
{
    [self checkCameraAuthority:^(BOOL authorize) {
        if (authorized) {
            authorized(authorize);
        }
    }];
}

+ (void)checkCameraAuthority:(Authorized)authorized
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [self checkAudioAuthority:^(BOOL authorize) {
                        if (authorized) {
                            authorized(authorize);
                        }
                    }];
                } else {
                    if (authorized) {
                        authorized(NO);
                    }
                }
            });
        }];
    } else if ([ZZUtils isAllowCamera]) {
        [self checkAudioAuthority:^(BOOL authorize) {
            if (authorized) {
                authorized(authorize);
            }
        }];
    } else {
        if (authorized) {
            authorized(NO);
        }
    }
}

+ (void)checkAudioAuthority:(Authorized)authorized
{
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioAuthStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    if (authorized) {
                        authorized(YES);
                    }
                } else {
                    if (authorized) {
                        authorized(NO);
                    }
                }
            });
        }];
    } else if ([ZZUtils isAllowAudio]) {
        if (authorized) {
            authorized(YES);
        }
    } else {
        if (authorized) {
            authorized(NO);
        }
    }
}

@end
