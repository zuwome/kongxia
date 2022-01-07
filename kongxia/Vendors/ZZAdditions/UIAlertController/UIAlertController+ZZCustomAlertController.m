//
//  UIAlertController+ZZCustomAlertController.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "UIAlertController+ZZCustomAlertController.h"

@implementation UIAlertController (ZZCustomAlertController)
+ (UIViewController *)findAppreciatedRootVC {
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if ([rootVC presentedViewController] != nil) {
        rootVC = rootVC.presentedViewController;
    }
    return rootVC;
}

+ (void)presentActionControllerWithTitle:(NSString *)title
                                 actions:(NSArray<UIAlertAction *> *)actions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    for (UIAlertAction *action in actions) {
        [alertController addAction:action];
    }
    [[self findAppreciatedRootVC] presentViewController:alertController animated:YES completion:nil];
}


@end
