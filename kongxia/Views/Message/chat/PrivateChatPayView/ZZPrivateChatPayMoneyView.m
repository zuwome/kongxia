//
//  ZZPrivateChatPayMoneyView.m
//  zuwome
//
//  Created by 潘杨 on 2018/4/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPrivateChatPayMoneyView.h"
#import "CABasicAnimation+Ext.h"
@interface ZZPrivateChatPayMoneyView()
@end
@implementation ZZPrivateChatPayMoneyView

-(instancetype)initWithFrame:(CGRect)frame ImageName:(NSString *)imageName {
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:imageName];
    }
    return self;
}




/**
每个金币的掉落时间

 @param fromPoint 开始的位置
 @param toPoint  结束的位置
 @param repeat 重复次数
 */
- (void)addFallingAnimationWithFromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint repeat:(float)repeat {
 
    [self.layer addAnimation:[CABasicAnimation animtionFromCGPoint:fromPoint toPoint:toPoint andTime:0.3 repeatCount:repeat] forKey:nil];
  
    
    [NSObject asyncWaitingWithTime:0.3*repeat completeBlock:^{
        //动画结束后从当前界面移除
        [self removeFromSuperview];
    }];
}


/**
 扩散效果

 @param repeat 扩散的次数
 */
- (void)AddSpreadAnimationWithRepeat:(float)repeat {
 
    CABasicAnimation*zoomAnimation =   [CABasicAnimation animaltionToscale:@1 toValue:@1.5 durTimes:0.5 repeat:repeat ];
    
    CABasicAnimation*flashingAnimation =  [CABasicAnimation opacityForever_Animation:0.5 repeatCount:repeat];
    [self.layer addAnimation:zoomAnimation forKey:nil];
    [self.layer addAnimation:flashingAnimation forKey:nil];
    [NSObject asyncWaitingWithTime:0.5*repeat completeBlock:^{
        //动画结束后从当前界面移除
        [self removeFromSuperview];
    }];

}


- (void)addAnimationWithFromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint endPoint:(CGPoint)endPoint andFirstTime:(float)firstTime andSecondTime:(float)secondTime waitTime:(float) waitTime waitScalTime:(float)scalTime {
    //缩放
    [self.layer addAnimation:[CABasicAnimation animaltionToscale:@0 toValue:@1.2 durTimes:scalTime repeat:1 ] forKey:nil];
    //平移
    [self.layer addAnimation:[CABasicAnimation animtionFromCGPoint:fromPoint toPoint:toPoint andTime:firstTime] forKey:nil];
    [NSObject asyncWaitingWithTime:firstTime-scalTime completeBlock:^{
            //缩放
        [self.layer addAnimation:[CABasicAnimation animaltionToscale:@1.2 toValue:@1 durTimes:scalTime repeat:1 ] forKey:nil];
    }];
    [NSObject asyncWaitingWithTime:firstTime+waitTime completeBlock:^{
            //平移
        [self.layer addAnimation:[CABasicAnimation animtionFromCGPoint:toPoint toPoint:endPoint andTime:secondTime] forKey:nil];
        
    }];
    
    [NSObject asyncWaitingWithTime:firstTime+secondTime completeBlock:^{
        //动画结束后从当前界面移除
        [self removeFromSuperview];
    }];
}
@end
