//
//  ZZSexImgView.m
//  zuwome
//
//  Created by angBiu on 2017/1/16.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSexImgView.h"

@implementation ZZSexImgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

- (void)setGender:(int)gender
{
    if (gender == 2) {
        self.image = [UIImage imageNamed:@"girl"];
    } else if (gender == 1) {
        self.image = [UIImage imageNamed:@"boy"];
    } else {
        self.image = [UIImage new];
    }
}

@end
