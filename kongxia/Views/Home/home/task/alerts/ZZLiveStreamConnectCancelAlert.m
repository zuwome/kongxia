//
//  ZZLiveStreamConnectCancelAlert.m
//  zuwome
//
//  Created by angBiu on 2017/7/24.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamConnectCancelAlert.h"

@interface ZZLiveStreamConnectCancelAlert ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *waitBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation ZZLiveStreamConnectCancelAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = HEXACOLOR(0x000000, 0.85);
        
        self.bgView.backgroundColor = HEXCOLOR(0x3C3C3E);
    }
    
    return self;
}

- (void)leftBtnClick
{
    [self removeFromSuperview];
}

- (void)rightBtnClick
{
    [self removeFromSuperview];
    if (_touchCancel) {
        _touchCancel();
    }
}

#pragma mark -

- (UIView *)bgView
{
    if (!_bgView) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        if (scale>1) {
            scale = 1;
        }
        
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(317*scale);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_livestream_connecting"];
        [_bgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_bgView.mas_top).offset(30);
            make.size.mas_equalTo(CGSizeMake(270.5*scale, 137.5*scale));
        }];
        
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setTitle:@"再等等" forState:UIControlStateNormal];
        [leftBtn setTitleColor:HEXCOLOR(0x3f3a3a) forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        leftBtn.layer.cornerRadius = 3;
        leftBtn.backgroundColor = kYellowColor;
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-10);
            make.top.mas_equalTo(imgView.mas_bottom).offset(22);
            make.height.mas_equalTo(@44);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-18);
        }];
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setTitle:@"确认取消" forState:UIControlStateNormal];
        [rightBtn setTitleColor:HEXCOLOR(0x3f3a3a) forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        rightBtn.layer.cornerRadius = 3;
        rightBtn.backgroundColor = HEXCOLOR(0xd8d8d8);
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:rightBtn];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_centerX).offset(10);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.top.bottom.mas_equalTo(leftBtn);
        }];
        
    }
    return _bgView;
}

@end
