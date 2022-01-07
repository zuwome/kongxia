//
//  ZZPrivateDiffusionView.h
//  zuwome
//
//  Created by 潘杨 on 2018/4/18.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 扩散的图
 */
@interface ZZPrivateDiffusionView : UIView
/**
 扩散效果
 
 @param repeat 扩散的次数
 */
- (void)addSpreadAnimationWithRepeat:(float)repeat;
/**
 飞溅效果
 
 @param repeat 扩散的次数
 */
- (void)addSplashAnimationWithRepeat:(float)repeat fromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
@end
