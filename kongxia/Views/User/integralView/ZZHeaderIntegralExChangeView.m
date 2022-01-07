//
//  ZZHeaderIntegralExChangeView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/22.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZHeaderIntegralExChangeView.h"

@interface ZZHeaderIntegralExChangeView()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *allIntegralLab;
@property (nonatomic,strong) UIView *bgView;

@end
@implementation ZZHeaderIntegralExChangeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HEXCOLOR(0xF8f8f8);
        [self addSubview:self.bgView];
        self.bgView.backgroundColor = RGBCOLOR(237, 224, 170);
        [self.bgView addSubview:self.imageView];
        [self.bgView addSubview:self.allIntegralLab];

    }
    return self;
}

- (void)setIntegral:(NSInteger)integral {
    if (_integral != integral ) {
        _integral = integral;
        self.allIntegralLab.text  = [NSString stringWithFormat:@"积分余额：%ld积分",self.integral];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
   
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset(0);
        make.bottom.offset(-7);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(19);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16.5, 15));
    }];

    [self.allIntegralLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(4);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.right.offset(-15);
    }];
}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
    }
    return _bgView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"icJifenCard"];
    }
    return _imageView;
}

- (UILabel *)allIntegralLab {
    if (!_allIntegralLab) {
        _allIntegralLab = [[UILabel alloc]init];
        _allIntegralLab.textColor = kBlackColor;
        _allIntegralLab.textAlignment = NSTextAlignmentLeft;
        _allIntegralLab.font = ADaptedFontMediumSize(15);
        _allIntegralLab.text  = [NSString stringWithFormat:@"积分余额：0积分"];

    }
    return _allIntegralLab;
}

@end
