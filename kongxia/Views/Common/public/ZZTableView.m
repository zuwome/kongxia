//
//  ZZTableView.m
//  zuwome
//
//  Created by angBiu on 2016/11/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTableView.h"

@implementation ZZTableView

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self setFirstResponderWithView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

- (UIView *)setFirstResponderWithView:(UIView *)view
{
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self setFirstResponderWithView:childView];
        if ( result ) return result;
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchTableView) {
        _touchTableView();
    }
    [super touchesBegan:touches withEvent:event];
}

@end
