//
//  ZZSystemToolsManager.m
//  zuwome
//
//  Created by YuTianLong on 2017/10/21.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZSystemToolsManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <CoreLocation/CoreLocation.h>

@interface ZZSystemToolsManager ()

@end

@implementation ZZSystemToolsManager

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

- (BOOL)isOpenSystemNotification {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
        return NO;
    }
    return YES;
}

- (BOOL)isPhotoPermissions {
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}



- (BOOL)isCameraPermissions {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        return NO;
    }
    return YES;
}


@end
