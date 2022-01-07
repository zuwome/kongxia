//
//  ZZRentInfoView.m
//  zuwome
//
//  Created by angBiu on 16/8/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentInfoView.h"

@implementation ZZRentInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    
    return self;
}

@end
