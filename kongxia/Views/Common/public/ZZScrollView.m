//
//  ZZScrollView.m
//  zuwome
//
//  Created by angBiu on 16/9/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZScrollView.h"

@implementation ZZScrollView

//一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self panBack:gestureRecognizer]) {
        return YES;
    }
//    if (gestureRecognizer.state != 0) {
//        return YES;
//    }
    return NO;
}

//location_X可自己定义,其代表的是滑动返回距左边的有效长度
- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer
{
    int location_X = 50;
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            NSInteger count = location.x /SCREEN_WIDTH;
            if (point.x > 0 && location.x < count*SCREEN_WIDTH + location_X) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    
    return YES;
    
}
@end
