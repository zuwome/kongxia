//
//  ZZListScrollView.m
//  zuwome
//
//  Created by angBiu on 16/9/30.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZListScrollView.h"

@implementation ZZListScrollView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer.state != 0) {
        return YES;
     } else {
        return NO;
    }
}

@end
