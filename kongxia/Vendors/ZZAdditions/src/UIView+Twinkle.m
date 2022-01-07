//
//  UIView+Twinkle.m
//  Twinkle
//
//  Created by v－ling on 15/9/6.
//  Copyright (c) 2015年 LiuZeChen. All rights reserved.
//

#import "UIView+Twinkle.h"
#import "TwinkleLayer.h"
#import "TwinkleLayer+Anim.h"

@implementation UIView (Twinkle)

- (void)twinkle {

    NSMutableArray *twinkleLayers = [NSMutableArray array];

    UInt32 lowerBound = 4;
    UInt8 count = (UInt8)(lowerBound);

    for (int i = 0; i < count; i++) {
        TwinkleLayer *twinkleLayer = [[TwinkleLayer alloc] initWithShowImageName:@"video_chatStar3"];

        CGFloat x = arc4random_uniform((UInt32)self.layer.bounds.size.width);
        CGFloat y = arc4random_uniform((UInt32)self.layer.bounds.size.height);

        twinkleLayer.position = CGPointMake(x, y);
        twinkleLayer.opacity = 0;
        [twinkleLayers addObject:twinkleLayer];
        [self.layer addSublayer:twinkleLayer];
        [twinkleLayer addFadeInOutAnimation:CACurrentMediaTime() + (CFTimeInterval)0.15 *(i)];
    }

    [twinkleLayers removeAllObjects];
}
- (void)twinkleWithPointArray:(NSArray *)pointArray {
    NSMutableArray *twinkleLayers = [NSMutableArray array];
    for (int i = 0; i < pointArray.count; i++) {
        TwinkleLayer *twinkleLayer = [[TwinkleLayer alloc] initWithShowImageName:@"video_chatStar3"];
        NSValue *value = pointArray[i];
        CGPoint point = [value CGPointValue];
        CGFloat x = (UInt32)self.layer.bounds.size.width*point.x;
        CGFloat y = (UInt32)self.layer.bounds.size.height*point.y;
        twinkleLayer.position = CGPointMake(x, y);
        twinkleLayer.opacity = 0;
        [twinkleLayers addObject:twinkleLayer];
        [self.layer addSublayer:twinkleLayer];
        
        [twinkleLayer addFadeInOutAnimation:CACurrentMediaTime() + (CFTimeInterval)0.15 *(i)];
    }
    
    [twinkleLayers removeAllObjects];
}

- (void)openSanTwinkleWithPointArray:(NSArray *)pointArray {
    NSMutableArray *twinkleLayers = [NSMutableArray array];
    for (int i = 0; i < pointArray.count; i++) {
        TwinkleLayer *twinkleLayer = [[TwinkleLayer alloc] initWithShowImageName:@"OpenSanChatNewAdd_user_star"];
        NSValue *value = pointArray[i];
        CGPoint point = [value CGPointValue];
        twinkleLayer.position = point;
        twinkleLayer.opacity = 0;
        [twinkleLayers addObject:twinkleLayer];
        [self.layer addSublayer:twinkleLayer];
        
        [twinkleLayer addFadeInOutAnimation:CACurrentMediaTime() + (CFTimeInterval)10 *(i)];
    }
    
    [twinkleLayers removeAllObjects];
}

@end
