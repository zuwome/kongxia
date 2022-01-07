//
//  ZZHomeFirstWxGuide.m
//  zuwome
//
//  Created by angBiu on 2017/6/2.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZHomeFirstWxGuide.h"

@implementation ZZHomeFirstWxGuide

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = HEXACOLOR(0x000000, 0.6);
        [self addSubview:coverView];
        
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_home_wx_guide"];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(28);
            make.left.mas_equalTo(self.mas_left).offset(22);
            make.size.mas_equalTo(CGSizeMake(135.5*scale, 103.5*scale));
        }];
    }
    
    return self;
}

@end
