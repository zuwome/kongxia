//
//  ZZWechatWarningView.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZWechatReviewToast.h"

@interface ZZWechatReviewToast()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) ToastWarningView *warningView;

@property (nonatomic, copy) void(^cancelBlock)(void);

@property (nonatomic, copy) void(^reviewBlock)(void);

@property (nonatomic, copy) void(^okBlock)(void);
@end

@implementation ZZWechatReviewToast

+ (instancetype)showWithCancelBlock:(void (^)(void))cancelBlock
                        reviewBlock:(void (^)(void))reviewBlock
                            okBlock:(void (^)(void))okBlock {
    ZZWechatReviewToast *wcWarningView = [[ZZWechatReviewToast alloc] init];
    wcWarningView.cancelBlock = cancelBlock;
    wcWarningView.reviewBlock = reviewBlock;
    wcWarningView.okBlock = okBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:wcWarningView];
    [wcWarningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    [wcWarningView show];
    return wcWarningView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)cancel {
    if (_cancelBlock) {
        _cancelBlock();
    }
    [self hide];
}

- (void)review {
    if (_reviewBlock) {
        _reviewBlock();
    }
    [self hide];
}

- (void)ok {
    if (_okBlock) {
        _okBlock();
    }
    [self hide];
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
        _reviewBlock = nil;
        _okBlock = nil;
    }];
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
        make.width.equalTo(@285);
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

- (ToastWarningView *)warningView {
    if (!_warningView) {
        _warningView = [[ToastWarningView alloc] init];
        [_warningView.cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [_warningView.okButton addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
        [_warningView.reviewButton addTarget:self action:@selector(review) forControlEvents:UIControlEventTouchUpInside];
    }
    return _warningView;
}

@end

@interface ToastWarningView ()



@end

@implementation ToastWarningView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - UI
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 6;
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.reviewButton];
    [self addSubview:self.okButton];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(46, 50));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(22.5);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_iconImageView.mas_bottom).offset(18.0);
        make.left.right.equalTo(self);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom).offset(11.0);
        make.left.equalTo(self).offset(37.5);
        make.right.equalTo(self).offset(-20.0);
    }];
    
    [_reviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(22.0);
        make.leading.equalTo(self).offset(18.0);
        make.bottom.equalTo(self).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(118.0, 44.0));
    }];
    
    [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_reviewButton);
        make.trailing.equalTo(self).offset(-18.0);
        make.size.mas_equalTo(CGSizeMake(118.0, 44.0));
    }];
}

#pragma mark - Setter&Getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"picTishiNegative"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"温馨提示";
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"差评前，可以先和对方沟通一下";
        _subTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _subTitleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _subTitleLabel;
}

- (UIButton *)reviewButton {
    if (!_reviewButton) {
        _reviewButton = [[UIButton alloc] init];
        [_reviewButton setTitle:@"继续差评" forState:UIControlStateNormal];
        [_reviewButton setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        _reviewButton.backgroundColor = RGBCOLOR(216, 216, 216);
        _reviewButton.layer.cornerRadius = 4.0;
        _reviewButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _reviewButton;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [[UIButton alloc] init];
        [_okButton setTitle:@"立即沟通" forState:UIControlStateNormal];
        [_okButton setTitleColor:RGBCOLOR(63, 58, 58) forState:UIControlStateNormal];
        _okButton.backgroundColor = RGBCOLOR(244, 203, 7);
        _okButton.layer.cornerRadius = 4.0;
        _okButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _okButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

@end
