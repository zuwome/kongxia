//
//  ZZWeiChatBaseEvaluation.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZWeiChatBaseEvaluation.h"
@interface ZZWeiChatBaseEvaluation ()<UIGestureRecognizerDelegate>
@end
@implementation ZZWeiChatBaseEvaluation

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.76];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        tap1.delegate = self;
        [self addGestureRecognizer:tap1];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[ZZWeiChatBaseEvaluation class]]){
        return YES;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"ZZWeiChatBaseEvaluation"]) {
        return YES;
    }
    return NO;
}

- (void)showView:(UIViewController *)viewController {
    if (viewController==nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    }else{
    [viewController.view addSubview:self];
    [viewController.view bringSubviewToFront:self];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
    } completion:nil];
}

/**
 消失
 */
- (void)dissMiss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
/**
 消失
 */
- (void)dissMissCurrent {
    [self dissMiss];
}
#pragma mark - 点击消失
- (void)click {
    [self dissMiss];
}
@end
