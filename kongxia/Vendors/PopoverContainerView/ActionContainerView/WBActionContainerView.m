//
//  WBActionContainerView.m
//  Whistle
//
//  Created by ZhangAo on 15/7/22.
//  Copyright (c) 2015年 BookSir. All rights reserved.
//

#import "WBActionContainerView.h"
//#import "DKFoundation.h"

@implementation WBActionContainerView

- (instancetype)initWithView:(UIView *)view forHeight:(CGFloat)height {
    self = [super initWithView:view];
    if (self) {
		self.customView.width = self.width;
//        self.customView.height = MIN(height, self.height * 0.65);
        self.customView.height = height;
    }
    
    return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController forHeight:(CGFloat)height {
    self = [self initWithViewController:viewController];
    
    return self;
}

@end
