//
//  ZZRefreshHeader.m
//  zuwome
//
//  Created by wlsy on 16/1/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRefreshHeader.h"

@implementation ZZRefreshHeader

- (void)prepare
{
    [super prepare];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
