//
//  TwinkleLayer.m
//  Twinkle
//
//  Created by v－ling on 15/9/6.
//  Copyright (c) 2015年 LiuZeChen. All rights reserved.
//

#import "TwinkleLayer.h"
#import <UIKit/UIKit.h>

static NSString *TwinkleLayerEmitterShapeKey = @"circle";
static NSString *TwinkleLayerEmitterModeKey = @"surface";
static NSString *TwinkleLayerRenderModeKey = @"unordered";
static NSString *TwinkleLayerMagnificationFilter = @"linear";
static NSString *TwinkleLayerMinificationFilter = @"trilinear";

@implementation TwinkleLayer

- (instancetype)initWithShowImageName:(NSString*)imageName {
    if (self = [super init]) {
        [self loadComponentWithShowImageName:imageName];
    }
    return self;
}

- (void)loadComponentWithShowImageName:(NSString*)imageName {
    UIImage *twinkleImage = [UIImage imageNamed:imageName];

    NSArray *emitterCells = @[[[CAEmitterCell alloc]init], [[CAEmitterCell alloc] init]];

    [emitterCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CAEmitterCell *cell = (CAEmitterCell *)obj;
        //产生的频率
        cell.birthRate = 0.5;

        
        //生命周期
        cell.lifetime = 2;
        cell.lifetimeRange = 0;
        cell.emissionRange = (CGFloat)M_PI_4;

        cell.scale = 1;
        cell.scaleRange = 0.7;
        cell.scaleSpeed = 0.6;
        cell.spin = 0;
        cell.spinRange = 0;
        cell.color = [UIColor colorWithWhite:1 alpha:1].CGColor;
        cell.alphaSpeed = -3;
        cell.contents = (__bridge id)(twinkleImage.CGImage);
        cell.magnificationFilter = TwinkleLayerMagnificationFilter;
        cell.minificationFilter = TwinkleLayerMinificationFilter;
        cell.enabled = true;
    }];

    self.emitterCells = emitterCells;

    self.emitterPosition = CGPointMake((self.bounds.size.width * 0.5), (self.bounds.size.height * 0.5));
    self.emitterSize = self.bounds.size;
    self.emitterShape = kCAEmitterLayerPoint;
    self.emitterMode = TwinkleLayerEmitterModeKey;
    self.renderMode = TwinkleLayerRenderModeKey;
}

@end
