//
//  UIImage+Additions.h
//  mouke
//
//  Created by wlsy on 13-12-13.
//  Copyright (c) 2013年 mou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)
+ (UIImage *)shootView:(UIView *)view;

- (UIImage *)imageWithBurnTint:(UIColor *)color;
- (UIImage *)blurOnImageWithRadius:(CGFloat)blurRadius;

- (UIColor *)averageColor;
- (UIImage *)circleImage;

+ (CGRect)convertRectFrom:(CGRect)imageRect imageSize:(CGSize)imageSize detectRect:(CGRect)detectRect;

+ (UIImage *)getImageResourceForName:(NSString *)name;

@end
