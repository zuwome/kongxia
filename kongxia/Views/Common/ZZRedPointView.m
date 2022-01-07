//
//  ZZRedPointView.m
//  zuwome
//
//  Created by angBiu on 16/7/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRedPointView.h"

@implementation ZZRedPointView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 4;
    }
    
    return self;
}

@end
