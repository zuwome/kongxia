//
//  ZZHUD.m
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHUD.h"

@implementation ZZHUD

+ (void)showTaskInfoStyleLightWithStatus:(NSString *)status
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [self showInfoWithStatus:status];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    });
}
+ (void)showTaskInfoWithStatus:(NSString *)status
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [self showInfoWithStatus:status];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    });
}
+ (void)showTaskInfoWithSuccessStatus:(NSString *)status time:(CGFloat)time {
    [self showSuccessWithStatus:status];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    });
}

+ (void)showTaskInfoWithStatus:(NSString *)status time:(CGFloat)time {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [self showInfoWithStatus:status];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    });
}
+ (void)showTastInfoNomalWithString:(NSString *)string callBack:(void(^)(void))callBack      {
        
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setImageViewSize:CGSizeMake(60, 60)];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD setForegroundColor:HEXCOLOR(0x3f3a3a)];
//    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"picTishiNegative"]];

//    [SVProgressHUD showErrorWithStatus:@"请把内容控制在100字以内"];
//    [SVProgressHUD setStatus:<#(nullable NSString *)#>];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showImage:[UIImage imageNamed:@"picTishiNegative"] status:string];
    });

    
//    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"picTishiNegative"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD setForegroundColor:[UIColor blackColor]];

        [SVProgressHUD setImageViewSize:CGSizeMake(28, 28)];
        if (callBack) {
            callBack();
        }
    });
}

+ (void)showTastInfoWithString:(NSString *)string        {
    [SVProgressHUD showSuccessWithStatus:string];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
+ (void)showTastInfoErrorWithString:(NSString *)string {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showErrorWithStatus:string];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
@end
