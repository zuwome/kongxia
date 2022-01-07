//
//  ZZHomeTitleLabel.m
//  zuwome
//
//  Created by angBiu on 16/7/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeTitleLabel.h"

@implementation ZZHomeTitleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = HEXCOLOR(0x3F3A3A);
//        self.scale = 0.0;
        [self setViewScale:0.0];
    }
    return self;
}

- (void)setViewScale:(CGFloat)scale
{
//    _scale = scale;
    
//    self.textColor = kBlackTextColor;
    CGFloat minScale = 0.85;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

///** 通过scale的改变改变多种参数 */
//- (void)setScale:(CGFloat)scale
//{
//    _scale = scale;
//    
//    self.textColor = kBlackTextColor;
//    CGFloat minScale = 0.85;
//    CGFloat trueScale = minScale + (1-minScale)*scale;
//    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
//}

@end
