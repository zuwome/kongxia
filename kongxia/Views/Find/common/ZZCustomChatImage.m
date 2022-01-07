//
//  ZZCustomChatImage.m
//  zuwome
//
//  Created by 潘杨 on 2018/4/23.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZCustomChatImage.h"

@implementation ZZCustomChatImage



- (void)drawInboundsRight:(CGRect )recent {
    [self.layer.mask removeFromSuperlayer];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:recent byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = recent;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)drawInboundsleft:(CGRect)recent {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:recent byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    设置大小
    maskLayer.frame = recent;
//    设置图形样子
    maskLayer.path = maskPath.CGPath;
    [self.layer.mask removeFromSuperlayer];

    self.layer.mask = maskLayer;
    self.contentMode = UIViewContentModeScaleAspectFill;
}
@end
