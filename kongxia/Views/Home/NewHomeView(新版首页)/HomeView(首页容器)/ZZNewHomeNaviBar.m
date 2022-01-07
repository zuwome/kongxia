//
//  ZZNewHomeNaviBar.m
//  naviTest
//
//  Created by MaoMinghui on 2018/8/15.
//  Copyright © 2018年 lql. All rights reserved.
//

#import "ZZNewHomeNaviBar.h"

@interface ZZNewHomeNaviBar ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIImage *leftBtnImage;
@property (nonatomic, strong) UIImage *rightBtnImage;

@end

@implementation ZZNewHomeNaviBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_bottom).offset(-22);
        make.leading.equalTo(@15);
        make.height.equalTo(@20);
    }];
    
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_bottom).offset(-22);
        make.trailing.equalTo(@0);
        make.height.equalTo(@20);
        make.width.equalTo(@45);
    }];
}

- (void)leftClick {
    !self.touchLocation ? : self.touchLocation();
}

- (void)rightClick {
    !self.touchSearch ? : self.touchSearch();
}

- (void)setCityName:(NSString *)cityName {
    _cityName = cityName;
    [self.leftBtn setTitle:cityName forState:(UIControlStateNormal)];
}

- (void)resetBtnStyle:(float)scale {
    if (scale > 0.5) {
        [self.leftBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [self.leftBtn setImage:[self image:self.leftBtnImage Color:kBlackColor] forState:(UIControlStateNormal)];
        [self.rightBtn setImage:[self image:self.rightBtnImage Color:kBlackColor] forState:(UIControlStateNormal)];
    } else {
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.leftBtn setImage:[self image:self.leftBtnImage Color:[UIColor whiteColor]] forState:(UIControlStateNormal)];
        [self.rightBtn setImage:[self image:self.rightBtnImage Color:[UIColor whiteColor]] forState:(UIControlStateNormal)];
    }
    self.bgView.alpha = scale;
}

- (UIImage *)image:(UIImage *)image Color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIView *)bgView {
    if (nil == _bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kYellowColor;
        _bgView.alpha = 0;
    }
    return _bgView;
}
- (UIButton *)leftBtn {
    if (nil == _leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitle:@"全国" forState:(UIControlStateNormal)];
        [_leftBtn setImage:self.leftBtnImage forState:(UIControlStateNormal)];
        [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn {
    if (nil == _rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setImage:self.rightBtnImage forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightBtn;
}

- (UIImage *)leftBtnImage {
    if (nil == _leftBtnImage) {
        _leftBtnImage = [UIImage imageNamed:@"homeTriangleDown"];
    }
    return _leftBtnImage;
}

- (UIImage *)rightBtnImage {
    if (nil == _rightBtnImage) {
        _rightBtnImage = [UIImage imageNamed:@"iconGuideHeadSearch"];
    }
    return _rightBtnImage;
}

@end
