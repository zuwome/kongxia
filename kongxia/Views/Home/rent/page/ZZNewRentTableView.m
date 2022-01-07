//
//  ZZNewRentTableView.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/9.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewRentTableView.h"

@implementation ZZNewRentTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //防止冲突 1.与ZZScrollView 2.与ZZRentCollectionView 3.与自定义侧滑手势
    if ([otherGestureRecognizer.view isKindOfClass:[ZZScrollView class]] ||
        [otherGestureRecognizer.view isKindOfClass:[ZZRentCollectionView class]] ||
        ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![NSStringFromClass([otherGestureRecognizer class]) isEqualToString:@"UIScrollViewPanGestureRecognizer"])) {
        return NO;
    }
    return YES;
}

@end
