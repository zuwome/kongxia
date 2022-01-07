//
//  ZZUserShouldNotHideView.m
//  kongxia
//
//  Created by qiming xiao on 2019/9/18.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZUserShouldNotHideView.h"

@interface ZZUserShouldNotHideView ()

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation ZZUserShouldNotHideView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - response method
- (void)cancel {
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (void)confirm {
    if (_comfireBlock) {
        _comfireBlock();
    }
}

#pragma mark - Layout
- (void)layout {
    
    UIView *bgview = [[UIView alloc] init];
    bgview.backgroundColor = UIColor.blackColor;
    bgview.layer.cornerRadius = 6;
    bgview.alpha = 0.7;
    [self addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.titleLabel];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(37, 37));
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(65, 28));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_cancelBtn.mas_right);
        make.right.equalTo(_confirmBtn.mas_left).offset(-15.0);
    }];
}

#pragma mark - getters and setters
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.normalImage = [UIImage imageNamed:@"icGuanbi_white"];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.normalTitle = @"去上线";
        _confirmBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        
        _confirmBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _confirmBtn.layer.cornerRadius = 15;
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"您为隐身状态，他人将无法在平台看到您，会错失很多收益并流失人气值哦";
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    }
    return _titleLabel;
}

@end
