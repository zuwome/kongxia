//
//  ZZGradientView.m
//  zuwome
//
//  Created by angBiu on 2017/4/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZGradientView.h"

@implementation ZZGradientView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXCOLOR(0xffe462);
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)showTime:(NSTimeInterval)duration
{
    [self createMask];
    [self iPhoneFadeWithDuration:duration];
}

- (void)createMask
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = @[(id)[UIColor clearColor].CGColor,(id)HEXCOLOR(0xffe462).CGColor,(id)[UIColor clearColor].CGColor];
    layer.locations = @[@(0.4),@(0.5),@(0.6)];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    self.layer.mask = layer;
    
    layer.position = CGPointMake(-self.bounds.size.width/4.0, self.bounds.size.height/2.0);
}

- (void)iPhoneFadeWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.translation.x";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(self.bounds.size.width+self.bounds.size.width/2.0);
    basicAnimation.duration = duration;
    basicAnimation.repeatCount = 2;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.layer.mask addAnimation:basicAnimation forKey:nil];
}

@end
