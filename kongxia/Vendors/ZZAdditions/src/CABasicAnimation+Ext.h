//
//  CABasicAnimation+Ext.h
//  CABasicAnimation_Ext_Demo
//
//  Created by admin on 16/6/28.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface CABasicAnimation (Ext)

/**
 闪烁
 */
+ (CABasicAnimation *)opacityForever_Animation:(float)time repeatCount:(NSInteger)repeatCount;
/**
 *  forever twinkling  永久闪烁的动画
 *
 *  @param time   time duration 持续时间
 *
 *  @return self   返回当前类
 */
+ (CABasicAnimation *)opacityForever_Animation:(float)time;

/**
 *  移动动画
 *
 *  @param time
 *  @param fromPoint 起点
 *  @param toPoint  终点
 *
 *  @return
 */
+(CABasicAnimation *)animtionFromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint andTime:(float)time;

/**
 *  缩放动画
 *
 *  @param fromValue
 *  @param tovalue
 *  @param time
 *  @param repeatTimes
 *
 *  @return
 */
+(CABasicAnimation *)animaltionToscale:(NSNumber *)fromValue toValue:( NSNumber *)tovalue durTimes:(float)time repeat:(float)repeatTimes;

/**
 移动动画
 */
+(CABasicAnimation *)animtionFromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint andTime:(float)time repeatCount:(NSInteger )repeatCount;


/**
  转圈的动画
 */
+ (CABasicAnimation *)popRotationAnimation;

/**
 绕中心180° 翻转
 */
+(CABasicAnimation *)flipAnimation;

/**
 抖动动画
 @param repeatCount 抖动次数
 */
+(CAKeyframeAnimation *)jitterAnimaitionRepeatCount:(NSInteger )repeatCount;
@end
