//
//  UIViewController+ZZUtils.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "UIViewController+ZZUtils.h"

@implementation UIViewController (ZZUtils)

+ (UIViewController *)currentDisplayViewController {
    __kindof __block UIViewController *viewController = nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
        viewController = [self findCurrentDisplayViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//    });
    return viewController;
}

+ (UIViewController *)findCurrentDisplayViewController:(UIViewController *)rootViewController {
    UIViewController *currentVC;
    
    if ([rootViewController presentedViewController]) {
        // 视图是被presented出来的
        rootViewController = [rootViewController presentedViewController];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self findCurrentDisplayViewController:[(UITabBarController *)rootViewController selectedViewController]];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        // 根视图为UINavigationController
        currentVC = [self findCurrentDisplayViewController:[(UINavigationController *)rootViewController visibleViewController]];
    }
    else {
        // 根视图为非导航类
        currentVC = rootViewController;
    }
    
    return currentVC;
}

- (void)showOKAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   okTitle:(NSString *)okTitle
                   okBlock:(ActionBlock _Nullable)okBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (okBlock)
            okBlock();
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showOKCancelAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       cancelBlock:(ActionBlock)cancelBlock
                           okTitle:(NSString *)okTitle
                           okBlock:(ActionBlock)okBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (okBlock)
            okBlock();
    }];
    [alertController addAction:doneAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        if (cancelBlock)
            cancelBlock();
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
