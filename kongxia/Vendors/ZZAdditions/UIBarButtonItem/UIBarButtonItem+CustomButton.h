//
//  UIBarButtonItem+CustomButton.h
//  Cosmetic
//
//  Created by 余天龙 on 16/4/21.
//  Copyright © 2016年 YuTianLong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomButton)

+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                target:(id)target
                              selector:(SEL)selector;

+ (instancetype)barButtonItemWithImage:(UIImage *)image
                                target:(id)target
                              selector:(SEL)selector;

- (void)updateButtonTitle:(NSString *)title;

- (UIButton *)customButton;

@end
