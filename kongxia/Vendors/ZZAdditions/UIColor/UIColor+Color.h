//
//  UIColor+ColorExtension.h
//  ZXartApp
//
//  Created by mac  on 2016/12/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ColorHex(_hex_) [UIColor colorUsingHexString:((__bridge NSString *)CFSTR(#_hex_))]

#define ColorRandomized [UIColor randomColor]
#define ColorBlack  [UIColor blackColor]
#define ColorRed    [UIColor redColor]
#define ColorGreen  [UIColor greenColor]
#define ColorYellow [UIColor yellowColor]
#define ColorClear  [UIColor clearColor]
#define ColorWhite  [UIColor whiteColor]

/**
 *  background Color use very light gray
 */
#define ColorBackGround ColorHex(f2f3f6)

@interface UIColor (Color)

/**
 * 将UIColor变换为UIImage
 **/
- (UIImage *)createImageWithRect:(CGRect)rect roundedCornersSize:(CGFloat)cornerRadius;

#pragma mark - HEX
/**
 *  利用HEX获取颜色
 *
 *  @param hexString 颜色
 *
 *  @return UIColor
 */
+ (UIColor *)colorUsingHexString:(NSString *)hexString;

/**
 *  利用HEX获取颜色
 *
 *  @param hexString 颜色
 *
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorUsingHexString:(NSString *)hexString alpah:(CGFloat)alpha;

/**
 *  获取颜色的HEX值(only works in RGBColor)
 *
 *  @return NSString
 */
- (NSString *)hexString;

#pragma mark - RGB
/**
 *  利用RGB获取颜色
 *
 *  @param red 红色
 *
 *  @param green 绿色
 *
 *  @param blue 蓝色
 *
 *  @return UIColor
 */
+ (UIColor *)colorUsingRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue;

/**
 *  利用RGB获取颜色
 *
 *  @param red 红色
 *
 *  @param green 绿色
 *
 *  @param blue 蓝色
 *
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorUsingRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha;

/**
 *  生成随机数 RGB
 */
+ (UIColor *)randomColor;

#pragma mark - HSB
/**
 *  生成随机数 HSB
 */
+ (UIColor *)randomColorUsingHSB;

/**
 *  生成随机数 HSB
 */
+ (UIColor *)randomColorUsingHSBWithSBLocked;



@end
