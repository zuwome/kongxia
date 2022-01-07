//
//  UIViewController+ZZUtils.h
//  zuwome
//
//  Created by qiming xiao on 2019/1/22.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ActionBlock)(void);

@interface UIViewController (ZZUtils)

+ (__kindof UIViewController *)currentDisplayViewController;

- (void)showOKCancelAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       cancelBlock:(_Nullable ActionBlock)cancelBlock
                           okTitle:(NSString *)okTitle
                           okBlock:(_Nullable ActionBlock)okBlock;

- (void)showOKAlertWithTitle:(NSString *)title
                     message:(NSString *)message
                     okTitle:(NSString *)okTitle
                     okBlock:(_Nullable ActionBlock)okBlock;

@end

NS_ASSUME_NONNULL_END
