//
//  UIBarButtonItem+CustomButton.m
//  Cosmetic
//
//  Created by 余天龙 on 16/4/21.
//  Copyright © 2016年 YuTianLong. All rights reserved.
//

#import "UIBarButtonItem+CustomButton.h"

@implementation UIBarButtonItem (CustomButton)

+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                target:(id)target
                              selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)barButtonItemWithImage:(UIImage *)image
                                target:(id)target
                              selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)updateButtonTitle:(NSString *)title {
    UIButton *button = (UIButton *)self.customView;
    if (button) {
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (UIButton *)customButton {
    UIButton *button = self.customView;
    if ([button isKindOfClass:[UIButton class]]) {
        return button;
    } else {
        return nil;
    }
}

@end
