//
//  UIView+Twinkle.h
//  Twinkle
//
//  Created by v－ling on 15/9/6.
//  Copyright (c) 2015年 LiuZeChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Twinkle)

- (void)twinkle;
- (void)twinkleWithPointArray:(NSArray *)pointArray;

/**
 闪聊的引导
 */
- (void)openSanTwinkleWithPointArray:(NSArray *)pointArray ;
@end
