//
//  UIView+Common.m
//  ShareTest
//
//  Created by w_app_01 on 13-12-28.
//  Copyright (c) 2013年 wcn_001. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (WCNCommon)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)removeAllSubviews
{
	while (self.subviews.count)
    {
		UIView *child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

@end
