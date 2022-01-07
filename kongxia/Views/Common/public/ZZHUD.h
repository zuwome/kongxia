//
//  ZZHUD.h
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface ZZHUD : SVProgressHUD

+ (void)showTaskInfoWithStatus:(NSString *)status;
+ (void)showTaskInfoStyleLightWithStatus:(NSString *)status;//白色的
+ (void)showTaskInfoWithStatus:(NSString *)status time:(CGFloat)time;
+ (void)showTastInfoWithString:(NSString *)string  ;
+ (void)showTastInfoErrorWithString:(NSString *)string  ;
+ (void)showTastInfoNomalWithString:(NSString *)string callBack:(void(^)(void))callBack ;
+ (void)showTaskInfoWithSuccessStatus:(NSString *)status time:(CGFloat)time;

@end
