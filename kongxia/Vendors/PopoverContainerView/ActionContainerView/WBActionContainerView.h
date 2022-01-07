//
//  WBActionContainerView.h
//  Whistle
//
//  Created by ZhangAo on 15/7/22.
//  Copyright (c) 2015年 BookSir. All rights reserved.
//

#import "WBPopoverContainerView.h"

@interface WBActionContainerView : WBPopoverContainerView

- (instancetype)initWithView:(UIView *)view forHeight:(CGFloat)height;

- (instancetype)initWithViewController:(UIViewController *)viewController forHeight:(CGFloat)height;

@end
