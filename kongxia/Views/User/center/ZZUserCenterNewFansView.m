//
//  ZZUserCenterNewFansView.m
//  zuwome
//
//  Created by angBiu on 2016/10/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserCenterNewFansView.h"

@implementation ZZUserCenterNewFansView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [[UIImage imageNamed:@"icon_user_newfans_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 10, 10)];
        [self addSubview:bgImgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIView *titleBgView = [[UIView alloc] init];
        [self addSubview:titleBgView];
        
        [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-3);
            make.top.mas_equalTo(self.mas_top).offset(5);
        }];
        
        _titleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:HEXCOLOR(0x3F3A3A) fontSize:12 text:@""];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(10);
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.centerY.mas_equalTo(titleBgView.mas_centerY);
        }];
    }
    
    return self;
}

@end
