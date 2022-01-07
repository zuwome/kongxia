//
//  UILabel+Extension.h
//  zuwome
//
//  Created by YuTianLong on 2017/10/27.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


/**
 带首行缩进的

 @param lineSpacing 行间距
 @param firstLineHeadIndent 首行缩进字符个数
 @param fontOfSize 字号
 @param textColor 字体颜色
 @param text 字符串内容
 @param label 在哪个LB上面使用该特性
 */
+(void)settingLabelTextAttributesWithLineSpacing:(CGFloat)lineSpacing FirstLineHeadIndent:(CGFloat)firstLineHeadIndent FontOfSize:(CGFloat)fontOfSize TextColor:(UIColor *)textColor text:(NSString *)text AddLabel:(UILabel *)label;

- (void)setLineHeight:(CGFloat)lineHeight;

@end
