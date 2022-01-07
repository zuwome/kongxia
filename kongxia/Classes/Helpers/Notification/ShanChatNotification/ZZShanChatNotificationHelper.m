//
//  ZZShanChatNotificationHelper.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
// 闪聊的推送  一、推送到闪聊列表  二、提示开通闪聊

#import "ZZShanChatNotificationHelper.h"
#import "ZZLiveStreamHelper.h"
@implementation ZZShanChatNotificationHelper

+ (void)localPushNotificationMessageDic:(NSDictionary*)dic tabbarViewController:(UITabBarController *)tabbarVC{
    
    
    NSString *viewControllerName = dic[@"viewControllerName"];
    NSLog(@"PY_当前跳转的试图控制器_%@",viewControllerName);
    Class vcClass =  NSClassFromString(viewControllerName);
    if (!vcClass) {
        NSLog(@"PY_推送的消息跳转错误 %@",vcClass);
        return;
    }
    UINavigationController *navCtl = [tabbarVC selectedViewController];
    if ([[navCtl.viewControllers lastObject] isKindOfClass:[vcClass class]]) {
        return;
    }
    //别人正在视频电话就不要凑热闹了
    if ([ZZLiveStreamHelper sharedInstance].isBusy) {
         NSLog(@"PY_接受type== 201 但是对方视频电话忙碌中 就不要凑热闹了");
        return;
    }
    for (UIViewController *oldVC in navCtl.viewControllers) {
        if ([oldVC isKindOfClass:[vcClass class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
            [navCtl popToViewController:oldVC animated:YES];
            });
            return;
        }
    }
    UIViewController *viewController= [(UIViewController *)[vcClass alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [navCtl pushViewController:viewController animated:YES];
    });
}
@end
