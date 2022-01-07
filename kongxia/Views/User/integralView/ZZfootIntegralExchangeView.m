//
//  ZZfootIntegralExchangeView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/22.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZfootIntegralExchangeView.h"
@interface ZZfootIntegralExchangeView()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIButton *integralButton;

@end
@implementation ZZfootIntegralExchangeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.integralButton];
    }
    return  self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(4);
        make.bottom.offset(-4);
    }];
    
    [self.integralButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(4);
        make.bottom.offset(-4);
    }];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"IntegralExchangeBG"];
    }
    return _bgImageView;
}

- (UIButton *)integralButton {
    if (!_integralButton) {
        _integralButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_integralButton setTitle:@"自定义数量" forState:UIControlStateNormal];
        [_integralButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _integralButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _integralButton.titleLabel.font = ADaptedFontBoldSize(15);
        [_integralButton addTarget:self action:@selector(integralButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _integralButton;
}
- (void)integralButtonClick:(UIButton *)sender {
    if (self.exChangeBlock) {
        self.exChangeBlock(sender);
    }
}

@end
