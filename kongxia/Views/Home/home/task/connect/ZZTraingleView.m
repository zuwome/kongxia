//
//  ZZTraingleView.m
//  zuwome
//
//  Created by angBiu on 2017/7/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTraingleView.h"

@implementation ZZTraingleView

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.width, 0)];
    [path addLineToPoint:CGPointMake(self.width/2, self.height)];
    [path closePath];
    [kYellowColor setFill];
    [path fill];
}

@end
