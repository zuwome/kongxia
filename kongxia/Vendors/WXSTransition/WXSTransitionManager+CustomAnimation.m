//
//  WXSTransitionManager+CustomAnimation.m
//  zuwome
//
//  Created by angBiu on 16/10/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "WXSTransitionManager+CustomAnimation.h"

@implementation WXSTransitionManager (CustomAnimation)

- (void)zoomNextAnimationWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.tempView = nil;
    self.tempView = [self.startView snapshotViewAfterScreenUpdates:NO];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:self.tempView];
    
    self.tempView.frame = [self.startView convertRect:self.startView.bounds toView:containerView];
    toVC.view.alpha = 0;
    fromVC.view.alpha = 1;
    
    __weak typeof(self)weakSelf = self;
    void(^AnimationBlock)(void) = ^(){
        weakSelf.tempView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        toVC.view.alpha = 1;
    };
    
    void(^AnimationCompletion)(void) = ^(void){
        weakSelf.tempView.hidden = YES;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    };
    
    //开始做动画
    [UIView animateWithDuration:self.animationTime delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        AnimationBlock();
    } completion:^(BOOL finished) {
        AnimationCompletion();
    }];
}

- (void)zoomBackWithContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    self.tempView.hidden = NO;
    [containerView insertSubview:toVC.view atIndex:0];
    
    __weak typeof(self)weakSelf = self;
    CGRect rect = [self.startView convertRect:self.startView.bounds toView:containerView];
    void(^AnimationBlock)(void) = ^(){
        weakSelf.tempView.frame = rect;
        fromVC.view.alpha = 0;
    };
    
    void(^AnimationCompletion)(void) = ^(void){
        toVC.view.alpha = 1;
        toVC.view.hidden = NO;
        if ([transitionContext transitionWasCancelled]) {
            weakSelf.tempView.hidden = YES;
            fromVC.view.alpha = 1;
            fromVC.view.hidden = NO;
            [transitionContext completeTransition:NO];
        }else{
            [weakSelf.tempView removeFromSuperview];
            [fromVC.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }
    };
    
    //开始做动画
    [UIView animateWithDuration:self.animationTime delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        AnimationBlock();
    } completion:^(BOOL finished) {
        AnimationCompletion();
    }];
    
    self.willEndInteractiveBlock  = ^(BOOL success){
        if (success) {
            [weakSelf.tempView removeFromSuperview];
        }else{
            weakSelf.tempView.hidden = YES;
        }
    };
}

@end
