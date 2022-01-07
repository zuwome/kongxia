//
//  ZZNewHomeTableView.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/17.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeTableView.h"

@implementation ZZNewHomeTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[ESCycleScroll class]]) {
        return NO;
    }
    return YES;
}

@end
