//
//  ZZColorCycleView.m
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZColorCycleView.h"

@interface ZZColorCycleView ()

@property (nonatomic, strong) CAShapeLayer *aLayer;
@property (nonatomic, strong) CALayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *animateLayer;

@end

@implementation ZZColorCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setIsColor:(BOOL)isColor
{
    _isColor = isColor;
    if (_aLayer) {
        [_aLayer removeFromSuperlayer];
    }
    if (_grayLayer) {
        [_grayLayer removeFromSuperlayer];
    }
    if (_gradientLayer) {
        [_gradientLayer removeFromSuperlayer];
    }
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
//    if (progress<0) {
//        _grayLayer.strokeEnd = 0;
//    } else if (progress < 1) {
        _grayLayer.strokeEnd = progress;
//    }
}

- (void)setStartProgress:(CGFloat)startProgress
{
    _startProgress = startProgress;
//    if (startProgress < 0) {
//        _grayLayer.strokeStart = 0;
//    } else if (startProgress < 1) {
        _grayLayer.strokeStart = startProgress;
//    }
}

- (void)drawRect:(CGRect)rect
{
    [_gradientLayer removeFromSuperlayer];
    [_grayLayer removeFromSuperlayer];
    [_aLayer removeFromSuperlayer];
    
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    _aLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, height/2) radius:width/2-2.5 startAngle:-M_PI_2 endAngle:(-M_PI_2+2*M_PI) clockwise:YES];
    
    _aLayer.strokeColor = kBGColor.CGColor;
    _aLayer.lineWidth = 2.5;
    _aLayer.fillColor =  [UIColor clearColor].CGColor;
//    layer.lineCap = kCALineCapRound;
    _aLayer.path = path.CGPath;
    [self.layer addSublayer:_aLayer];
    
    if (_animateLayer) {
        _grayLayer = _animateLayer;
    } else {
        _grayLayer = [CAShapeLayer layer];
    }
    _grayLayer.strokeColor = HEXCOLOR(0xf22f52).CGColor;
    _grayLayer.lineWidth = 2.5;
    _grayLayer.fillColor =  [UIColor clearColor].CGColor;
//    _grayLayer.lineCap = kCALineCapRound;
    _grayLayer.path = path.CGPath;
    [self.layer addSublayer:_grayLayer];
    
    _grayLayer.strokeEnd = _progress;
    
    if (_isColor) {
        _gradientLayer = [CALayer layer];
        //渐变色
        CAGradientLayer *colorLayer = [CAGradientLayer layer];
        colorLayer.frame = CGRectMake(0, 0, width, height);
        colorLayer.locations = @[@0.3, @0.9, @1];
        colorLayer.colors = @[(id)HEXCOLOR(0xFAD961).CGColor, (id)HEXCOLOR(0xF76B1C).CGColor];
        [_gradientLayer addSublayer:colorLayer];
        
        [_gradientLayer setMask:_grayLayer];
        [self.layer addSublayer:_gradientLayer];
    }
}

- (void)setAnimate:(BOOL)animate
{
    _animate = animate;
    if (animate) {
        _animateLayer = [CAShapeLayer layer];
        CABasicAnimation *endAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        endAnima.duration = 3.0f;
        endAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        endAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        endAnima.toValue = [NSNumber numberWithFloat:1.0f];
        endAnima.fillMode = kCAFillModeForwards;
        endAnima.beginTime = 0.0;
        
        CABasicAnimation *startAnima = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        startAnima.duration = 1.5f;
        startAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        startAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        startAnima.toValue = [NSNumber numberWithFloat:1.0f];
        startAnima.fillMode = kCAFillModeForwards;
        startAnima.beginTime = 1.5;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[endAnima,startAnima];
        group.duration = 3.0f;
        group.removedOnCompletion = NO;
        group.repeatCount = HUGE_VALF;
        [_animateLayer addAnimation:group forKey:@"group"];
    }
}

@end
