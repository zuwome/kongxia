//
//  ZZCircularView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZCircularView.h"

@implementation ZZCircularView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = frame.size.width/2.0f;
        self.layer.masksToBounds = YES;
        self.layer.backgroundColor = RGBCOLOR(130, 130, 130).CGColor;
    }
    return self;
}

- (void)setSelect {
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:[ZZUtils setGradualChangingColor:self fromColor:RGBCOLOR(214, 182, 99) toColor:RGBCOLOR(217, 147, 75) endPoint:CGPointMake(1, 1) locations:@[@0,@1] type:nil]];
}



@end
