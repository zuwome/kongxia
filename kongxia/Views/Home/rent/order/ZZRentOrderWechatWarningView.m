//
//  ZZRentOrderWechatWarningView.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRentOrderWechatWarningView.h"

@interface ZZRentOrderWechatWarningView ()

@property (nonatomic,   copy) NSString *content;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) WechatWarningView *warningView;

@end

@implementation ZZRentOrderWechatWarningView

+ (instancetype)showWithTitle:(NSString *)title cancleBlock:(void (^)(void))cancelBlock {
    ZZRentOrderWechatWarningView *wcWarningView = [[ZZRentOrderWechatWarningView alloc] initWithTitle:title];
    wcWarningView.cancelBlock = cancelBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:wcWarningView];
    [wcWarningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    [wcWarningView show];
    return wcWarningView;
}

+ (instancetype)show {
    ZZRentOrderWechatWarningView *wcWarningView = [[ZZRentOrderWechatWarningView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:wcWarningView];
    [wcWarningView show];
    return wcWarningView;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _content = title;
        [self layout];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        [_warningView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
        }];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        [_warningView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@(SCREEN_HEIGHT + _warningView.bounds.size.height * 0.5));
        }];
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_warningView removeFromSuperview];
        
        _bgView = nil;
        _warningView = nil;
        [self removeFromSuperview];
        _cancelBlock = nil;
    }];
}

- (void)ok {
    [self hide];
}

- (void)cancel {
    if (_cancelBlock) {
        _cancelBlock();
    }
    [self hide];
}

#pragma mark UI
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.warningView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_warningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(@(SCREEN_HEIGHT + _warningView.bounds.size.height * 0.5));
        make.width.equalTo(@312);
    }];
}

#pragma mark Setter&Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (WechatWarningView *)warningView {
    if (!_warningView) {
        _warningView = [[WechatWarningView alloc] init];
        _warningView.contentLabel.text = _content;
        [_warningView.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [_warningView.okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    }
    return _warningView;
}
@end

#pragma mark - WechatWarningView
@interface WechatWarningView ()

@end

@implementation WechatWarningView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark UI
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 6;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.okBtn];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(25.0);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(170.0, 114.0));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).offset(94.0);
        make.left.equalTo(self).offset(52.0);
        make.right.equalTo(self).offset(-20.0);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(13.0);
        make.leading.equalTo(self).offset(15.0);
        make.bottom.equalTo(self).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(133.0, 44.0));
    }];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cancelBtn);
        make.trailing.equalTo(self).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(133.0, 44.0));
    }];
}

#pragma mark Setter&Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17.0 weight:(UIFontWeightBold)];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"确认放弃优享邀约服务？";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
        _contentLabel.textColor = RGBCOLOR(102, 102, 102);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"nil";
    }
    return _contentLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"pic"];
    }
    return _iconImageView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.backgroundColor = RGBCOLOR(216, 216, 216);
        [_cancelBtn setTitle:@"确认放弃" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _cancelBtn.layer.cornerRadius = 3;
    }
    return _cancelBtn;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [[UIButton alloc] init];
        _okBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        [_okBtn setTitle:@"我要优享" forState:UIControlStateNormal];
        [_okBtn setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _okBtn.layer.cornerRadius = 3;
    }
    return _okBtn;
}

@end
