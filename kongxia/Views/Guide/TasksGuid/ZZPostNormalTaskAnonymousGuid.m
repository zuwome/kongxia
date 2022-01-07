//
//  ZZPostNormalTaskAnonymousGuid.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/29.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostNormalTaskAnonymousGuid.h"

@interface ZZPostNormalTaskAnonymousGuid ()

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) CGRect rect;

@end

@implementation ZZPostNormalTaskAnonymousGuid

+ (instancetype)showInRect:(CGRect)rect {
    ZZPostNormalTaskAnonymousGuid *guidView = [[ZZPostNormalTaskAnonymousGuid alloc] initWithRect:rect];
    [[UIApplication sharedApplication].keyWindow addSubview:guidView];
    return guidView;
}

- (instancetype)initWithRect:(CGRect)rect {
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    if (self) {
        _rect = rect;
        [self layout];
    }
    return self;
}

- (void)hide {
    [self removeAllSubviews];
    [self removeFromSuperview];
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.coverView];
    [self addSubview:self.imageView];
    [self addSubview:self.confirmBtn];
    
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-80);
        make.size.mas_equalTo(CGSizeMake(83, 32));
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset((_rect.origin.y + _rect.size.height) - 152.5 + 12);
        make.left.equalTo(self).offset((_rect.origin.x + _rect.size.width) - 210.0 + 10);
        make.size.mas_equalTo(CGSizeMake(210, 152.5));
    }];
}

#pragma mark - getters and setters
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = RGBACOLOR(0, 0, 0, 0.74);
    }
    return _coverView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"postNormalTaskHidden"];
    }
    return _imageView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalTitle = @"知道了";
        _confirmBtn.normalTitleColor = ColorWhite;
        _confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        _confirmBtn.backgroundColor = RGBACOLOR(255, 255, 255, 0.24);
        _confirmBtn.layer.borderColor = ColorWhite.CGColor;
        _confirmBtn.layer.borderWidth = 1.5;
        _confirmBtn.layer.cornerRadius = 16.0;
        [_confirmBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
@end
