//
//  WXSTransitionManager+CustomAnimation.h
//  zuwome
//
//  Created by angBiu on 16/10/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "WXSTransitionManager.h"

@interface WXSTransitionManager (CustomAnimation)

- (void)zoomNextAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)zoomBackWithContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
