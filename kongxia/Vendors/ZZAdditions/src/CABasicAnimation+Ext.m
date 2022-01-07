//
//  CABasicAnimation+Ext.m
//  CABasicAnimation_Ext_Demo
//
//  Created by admin on 16/6/28.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "CABasicAnimation+Ext.h"

@implementation CABasicAnimation (Ext)

/**
 闪烁
 */
+ (CABasicAnimation *)opacityForever_Animation:(float)time repeatCount:(NSInteger)repeatCount {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @1.f;
    animation.toValue = @0;
    animation.autoreverses = NO;
    animation.duration = time;
    animation.repeatCount = repeatCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return animation;
}
/**
 闪烁
 */
+ (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @1.f;
    animation.toValue = @0;
    animation.autoreverses = YES;
    animation.duration = time;
//    animation.repeatCount = MAXFLOAT;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //定义动画的样式 渐入式
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    return animation;
}


/**
 平移
 */
+(CABasicAnimation *)animtionFromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint andTime:(float)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.duration = time;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
+(CABasicAnimation *)animtionFromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint andTime:(float)time repeatCount:(NSInteger )repeatCount{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.duration = time;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = repeatCount;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;

    return animation;
}
/**
 缩放
 */
+(CABasicAnimation *)animaltionToscale:(NSNumber *)fromValue toValue:( NSNumber *)tovalue durTimes:(float)time repeat:(float)repeatTimes{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = fromValue;
    animation. toValue = tovalue;
    animation. autoreverses = NO;//此处改为YES 效果会不一样哦
    animation. repeatCount = repeatTimes;
    animation. duration = time;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return  animation;
}

/**
  转圈的动画

 @param sender 需要旋转的view
 */
+ (CABasicAnimation *)popRotationAnimation
{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:M_PI *2];
    animation.duration = 1.5f;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 500;
    return animation;
}

/**
 绕中心180° 翻转

 */
+(CABasicAnimation *)flipAnimation {
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    anima.toValue = [NSNumber numberWithFloat:M_PI*2];
    anima.duration = 2.0f;
    
    return anima;
}



/**
 抖动动画

 @param repeatCount 抖动次数
 */
+(CAKeyframeAnimation *)jitterAnimaitionRepeatCount:(NSInteger )repeatCount {
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];//在这里
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*20];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*20];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*20];
    anima.values = @[value1,value2,value3];
    anima.repeatCount = repeatCount;
    anima.duration = 0.3;
    return anima;
}


@end
