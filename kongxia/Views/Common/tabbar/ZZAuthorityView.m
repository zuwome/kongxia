//
//  ZZAuthorityView.m
//  zuwome
//
//  Created by angBiu on 2017/2/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZAuthorityView.h"

@interface ZZAuthorityView ()

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *localBtn;
@property (nonatomic, strong) UIImageView *locationImgView;
@property (nonatomic, strong) UIButton *notificationBtn;
@property (nonatomic, strong) UIImageView *notificationImgView;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, assign) BOOL touchedLocation;

@end

@implementation ZZAuthorityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _scale = SCREEN_WIDTH / 375.0;
        
        [self addSubview:self.bgBtn];
        self.bgView.hidden = NO;
        self.topView.hidden = NO;
        self.infoLabel.text = @" ";
        self.localBtn.hidden = NO;
        self.notificationBtn.hidden = NO;
        self.sureBtn.hidden = NO;
    }
    
    return self;
}

#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    [self sureBtnClick];
}

- (void)sureBtnClick
{
    self.hidden = YES;
    if (_touchedLocation) {
        [self pushAuthority];
    } else {
        
        
        [self locationAuthority];
    }
}

- (void)localBtnClick
{
    _touchedLocation = YES;
    [self locationAuthority];
}

- (void)notificationBtnClick
{
    [self pushAuthority];
}

- (void)locationAuthority
{
    [[LocationMangers shared] requestLocationAuthorizaitonWithHandler:^(BOOL hasPermission) {
        if (hasPermission) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_LocationConfirm object:nil];
        }
        
        if (!_touchedLocation) {
            [self pushAuthority];
        }
        
        if ([LocationMangers shared].authorizationStatus == kCLAuthorizationStatusDenied || [LocationMangers shared].authorizationStatus == kCLAuthorizationStatusRestricted) {
            _notificationBtn.layer.borderColor = HEXCOLOR(0xB3B3B3).CGColor;
        }
    }];
    _locationImgView.image = [UIImage imageNamed:@"icon_authority_local_p"];
    _localBtn.layer.borderColor = kYellowColor.CGColor;
    [_localBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
}

- (void)pushAuthority
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_AuthorityConfirm object:nil];
    _notificationImgView.image = [UIImage imageNamed:@"icon_authority_notification_p"];
    _notificationBtn.layer.borderColor = kYellowColor.CGColor;
    [_notificationBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
}

#pragma mark - lazyload

- (UIButton *)bgBtn
{
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgBtn.alpha = 0.69;
        _bgBtn.backgroundColor = kBlackTextColor;
    }
    return _bgBtn;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(50*_scale);
            make.right.mas_equalTo(self.mas_right).offset(-50*_scale);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _bgView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = HEXCOLOR(0x3F3A3A);
        [_bgView addSubview:_topView];
        
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_bgView);
            make.height.mas_equalTo(@60);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"请允许我们开启下列权限";
        [_topView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_topView);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(_topView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_cancel_white"];
        imgView.userInteractionEnabled = NO;
        [cancelBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cancelBtn.mas_top).offset(10);
            make.right.mas_equalTo(cancelBtn.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(13, 13));
        }];
    }
    return _topView;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textColor = kGrayContentColor;
        _infoLabel.font = [UIFont systemFontOfSize:14];
        [_bgView addSubview:_infoLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_topView.mas_bottom).offset(12);
        }];
    }
    return _infoLabel;
}

- (UIButton *)localBtn
{
    if (!_localBtn) {
        _localBtn = [[UIButton alloc] init];
        _localBtn.layer.cornerRadius = 18.5;
        _localBtn.layer.borderColor = HEXCOLOR(0xB3B3B3).CGColor;
        _localBtn.layer.borderWidth = 0.5;
        [_localBtn setTitle:@"位置权限" forState:UIControlStateNormal];
        [_localBtn setTitleColor:HEXCOLOR(0x9B9B9B) forState:UIControlStateNormal];
        _localBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_localBtn addTarget:self action:@selector(localBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_localBtn];
        
        [_localBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(25);
            make.right.mas_equalTo(_bgView.mas_right).offset(-25);
            make.top.mas_equalTo(_infoLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(@37);
        }];
        
        _locationImgView = [[UIImageView alloc] init];
        _locationImgView.image = [UIImage imageNamed:@"icon_authority_local_n"];
        _locationImgView.userInteractionEnabled = NO;
        [_localBtn addSubview:_locationImgView];
        
        [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_localBtn.mas_left).offset(26);
            make.centerY.mas_equalTo(_localBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14.5, 22.5));
        }];
    }
    return _localBtn;
}

- (UIButton *)notificationBtn
{
    if (!_notificationBtn) {
        _notificationBtn = [[UIButton alloc] init];
        _notificationBtn.layer.cornerRadius = 18.5;
        _notificationBtn.layer.borderColor = HEXCOLOR(0xB3B3B3).CGColor;
        _notificationBtn.layer.borderWidth = 0.5;
        [_notificationBtn setTitle:@"通知权限" forState:UIControlStateNormal];
        [_notificationBtn setTitleColor:HEXCOLOR(0x9B9B9B) forState:UIControlStateNormal];
        _notificationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_notificationBtn addTarget:self action:@selector(notificationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_notificationBtn];
        
        [_notificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_localBtn.mas_left);
            make.right.mas_equalTo(_localBtn.mas_right);
            make.top.mas_equalTo(_localBtn.mas_bottom).offset(20);
            make.height.mas_equalTo(@37);
        }];
        
        _notificationImgView = [[UIImageView alloc] init];
        _notificationImgView.image = [UIImage imageNamed:@"icon_authority_notification_n"];
        _notificationImgView.userInteractionEnabled = NO;
        [_notificationBtn addSubview:_notificationImgView];
        
        [_notificationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_notificationBtn.mas_left).offset(26);
            make.centerY.mas_equalTo(_notificationBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(18.5, 18.5));
        }];
    }
    return _notificationBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"icon_authority_surebg"] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"一键开启" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_localBtn.mas_left);
            make.right.mas_equalTo(_localBtn.mas_right);
            make.top.mas_equalTo(_notificationBtn.mas_bottom).offset(20);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-15);
            make.height.mas_equalTo(@37);
        }];
    }
    return _sureBtn;
}

@end
