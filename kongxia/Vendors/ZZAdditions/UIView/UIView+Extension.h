//
//  UIView+Extension.h
//  YLYForIos
//
//  Created by YuTianLong on 2017/8/14.
//  Copyright © 2017年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ViewDirection) {
    ViewDirectionTop,
    ViewDirectionBottom,
    ViewDirectionLeft,
    ViewDirectionRight,
};

@interface UIView (Extension)

- (void)showFPSLabel;

- (id)loadViewForXibWithName:(NSString *)xibName;   // 加载指定 xib 文件

- (void)loadCurrentViewForXibAndAddSubview;            // 加载当前 xib 文件并添加到视图

- (void)addBottomLine:(UIColor *)color inRect:(CGRect)rect;

- (void)addBorderAtDirection:(ViewDirection)direction color:(UIColor *)color borderWidth:(CGFloat)width;

- (void)dlj_addRounderCornerWithRadius:(CGFloat)radius size:(CGSize)size;

- (UIImage *)snapShot;

@end
