//
//  ZZTranigleView.m
//  zuwome
//
//  Created by angBiu on 2017/8/21.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTranigleView.h"

@implementation ZZTranigleView

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (_isUp) {
        [path moveToPoint:CGPointMake(0, 2.5)];
        [path addLineToPoint:CGPointMake(3.5, 0)];
        [path addLineToPoint:CGPointMake(7, 2.5)];
    } else {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(3.5, 2.5)];
        [path addLineToPoint:CGPointMake(7, 0)];
    }
    [path closePath];
    [path stroke];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = kYellowColor.CGColor;
    layer.lineWidth = 5;
    layer.fillColor =  [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapSquare;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
}

- (void)setIsUp:(BOOL)isUp
{
    _isUp = isUp;
    
    [self setNeedsDisplay];
}

@end
