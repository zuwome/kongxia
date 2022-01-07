//
//  ZZOrderFirstGuideView.m
//  zuwome
//
//  Created by angBiu on 16/9/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderFirstGuideView.h"

@implementation ZZOrderFirstGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kBlackTextColor;
        bgView.alpha = 0.85;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleToFill;
        
        UIImage *image = nil;
        if (ISiPhone4) {
            image = [UIImage imageNamed:@"icon_order_guide_0"];
        } else if (ISiPhone5) {
            image = [UIImage imageNamed:@"icon_order_guide_1"];
        } else {
            image = [UIImage imageNamed:@"icon_order_guide_2"];
        }
        imgView.image = image;
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    return self;
}

- (void)btnClick
{
    [self removeFromSuperview];
}

@end
