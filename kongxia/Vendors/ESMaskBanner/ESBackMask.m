//
//  ESBackMask.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ESBackMask.h"

@interface ESBackMask ()

@property (nonatomic, assign) CGFloat maskRadius;

@property (nonatomic, assign) ESMaskDirection maskDirection;

@end

@implementation ESBackMask

- (void)setMaskRadius:(CGFloat)maskRadius direction:(ESMaskDirection)maskDirection {
    _maskRadius = maskRadius;
    _maskDirection = maskDirection;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor clearColor];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (_maskDirection == ESMaskDirectionLeft) {
        CGContextAddArc(ctx, self.center.x - rect.size.width/2, self.center.y, _maskRadius, 0, M_PI * 2, NO);
    } else {
        CGContextAddArc(ctx, self.center.x + rect.size.width/2, self.center.y, _maskRadius, 0, M_PI * 2, NO);
    }
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);
}

@end
