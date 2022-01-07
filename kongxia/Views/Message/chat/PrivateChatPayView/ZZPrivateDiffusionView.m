//
//  ZZPrivateDiffusionView.m
//  zuwome
//
//  Created by 潘杨 on 2018/4/18.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPrivateDiffusionView.h"
#import "CABasicAnimation+Ext.h"

@implementation ZZPrivateDiffusionView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(243, 186, 4);
        self.layer.cornerRadius = frame.size.width/2.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
    
}
/**
 扩散效果

 @param repeat 扩散的次数
 */
- (void)addSpreadAnimationWithRepeat:(float)repeat {
    CABasicAnimation*zoomAnimation =   [CABasicAnimation animaltionToscale:@1 toValue:@1.5 durTimes:0.3 repeat:repeat ];

    CABasicAnimation*flashingAnimation =  [CABasicAnimation opacityForever_Animation:0.3 repeatCount:repeat];
    [self.layer addAnimation:zoomAnimation forKey:nil];
    [self.layer addAnimation:flashingAnimation forKey:nil];
    [NSObject asyncWaitingWithTime:0.3*repeat completeBlock:^{
        //动画结束后从当前界面移除
        [self removeFromSuperview];
    }];
    
}
/**
 飞溅效果
 
 @param repeat 扩散的次数
 */
- (void)addSplashAnimationWithRepeat:(float)repeat fromCGPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
    CABasicAnimation*zoomAnimation =   [CABasicAnimation animaltionToscale:@2 toValue:@0 durTimes:0.4 repeat:repeat ];
    CABasicAnimation *mvoeAnimation = [CABasicAnimation animtionFromCGPoint:fromPoint toPoint:toPoint andTime:0.4 repeatCount:1];
    CABasicAnimation*flashingAnimation =  [CABasicAnimation opacityForever_Animation:0.4 repeatCount:repeat];
    [self.layer addAnimation:zoomAnimation forKey:nil];
    [self.layer addAnimation:mvoeAnimation forKey:nil];

    [self.layer addAnimation:flashingAnimation forKey:nil];
    [NSObject asyncWaitingWithTime:0.4*repeat completeBlock:^{
        //动画结束后从当前界面移除
        [self removeFromSuperview];
    }];
    
}
@end
