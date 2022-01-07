//
//  ZZSpreadView.m
//  zuwome
//
//  Created by angBiu on 2017/5/4.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSpreadView.h"
#import <QuartzCore/QuartzCore.h>

@interface ZZSpreadView ()

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@end

@implementation ZZSpreadView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self initLayer];
}

- (void)initLayer
{
    self.clipsToBounds = NO;
    self.userInteractionEnabled = NO;
    
    CAEmitterCell *emitter = [CAEmitterCell emitterCell];
    emitter.contents                = (id)[UIImage imageNamed: @"icon_tabbar_shine"].CGImage;
    emitter.name                    = @"explosion";
    emitter.alphaRange              = 0.2f;
    emitter.alphaSpeed              = -1.f;
    emitter.lifetime                = 0.7f;
    emitter.lifetimeRange           = 0.3f;
    emitter.birthRate               = 0;
    emitter.velocity                = 40.0f;
    emitter.velocityRange           = 10.0f;
    emitter.emissionRange           = M_PI_4;
    emitter.scale                   = 0.05f;
    emitter.scaleRange              = 0.02;
    
    _emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.name              = @"emitterLayer";
    _emitterLayer.emitterShape      = kCAEmitterLayerCircle;
    _emitterLayer.emitterMode       = kCAEmitterLayerOutline;
    _emitterLayer.emitterPosition   = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    _emitterLayer.emitterSize       = CGSizeMake(25, 0);
    _emitterLayer.renderMode        = kCAEmitterLayerOldestFirst;
    _emitterLayer.masksToBounds     = NO;
    _emitterLayer.emitterCells      = @[emitter];
    _emitterLayer.frame             = [UIScreen mainScreen].bounds;
    
    [self.layer addSublayer: _emitterLayer];
    _emitterLayer.emitterPosition   = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}

- (void)animate
{
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        self.emitterLayer.beginTime = CACurrentMediaTime();
        CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath: @"emitterCells.explosion.birthRate"];
        ani.fromValue = @0;
        ani.toValue = @500;
        [_emitterLayer addAnimation: ani forKey: nil];
    });
}

@end
