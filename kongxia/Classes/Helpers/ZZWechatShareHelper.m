//
//  ZZWechatShareHelper.m
//  kongxia
//
//  Created by qiming xiao on 2020/10/6.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZWechatShareHelper.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation ZZWechatShareHelper

+ (void)shareImage:(UIImage *)image controller:(UIViewController *)viewController {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
    imageObject.shareImage = image;
    messageObject.shareObject = imageObject;
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:viewController completion:^(id result, NSError *error) {
        if (!error) {
            NSLog(@"PY_分享快照成功");
            [ZZHUD showTaskInfoWithStatus:@"分享成功"];
        }else{
            [ZZHUD showTastInfoErrorWithString:error.domain];
        }
    }];
}

@end
