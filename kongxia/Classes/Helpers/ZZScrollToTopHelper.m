//
//  ZZScrollToTopHelper.m
//  zuwome
//
//  Created by angBiu on 16/9/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZScrollToTopHelper.h"

@implementation ZZScrollToTopHelper

+ (void)scrollViewScrollToTop
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)statusBarWindowClick
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (BOOL)isShowingOnKeyWindow:(UIView *)view
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect newFrame = [keyWindow convertRect:view.frame fromView:view.superview];
    CGRect winBounds = keyWindow.bounds;
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    return !view.isHidden && view.alpha > 0.01 && view.window == keyWindow && intersects;
}

+ (void)searchScrollViewInView:(UIView *)supView
{
    for (UIScrollView *subView in supView.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]] &&
            [self isShowingOnKeyWindow:supView] &&
            ![subView isKindOfClass:NSClassFromString(@"UIPickerTableView")] &&
            ![subView isKindOfClass:NSClassFromString(@"ESCycleScroll")]) {
            //添加UIPickerTableView的判断，防止点击状态栏时，选择器也发生滚动，添加后可阻止选择器滚动，
            //添加ESCycleScroll的判断，防止点击状态栏时，首页banner受到影响
            CGPoint offset = subView.contentOffset;
            offset.y = -subView.contentInset.top;
            [subView setContentOffset:offset animated:YES];
        }
        [self searchScrollViewInView:subView];
    }
}
@end
