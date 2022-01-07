//
//  ZZWXHideAlertView.m
//  zuwome
//
//  Created by angBiu on 2017/6/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZWXHideAlertView.h"

@interface ZZWXHideAlertView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation ZZWXHideAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *coverView = [[UIView alloc] initWithFrame:frame];
        coverView.backgroundColor = HEXACOLOR(0x000000, 0.6);
        [self addSubview:coverView];
        
        self.bgView.layer.cornerRadius = 4.5;
        self.titleLabel.text = @"微信号将隐藏";
        self.imgView.image = [UIImage imageNamed:@"icon_wx_hide_alert"];
        self.contentLabel.attributedText = [ZZUtils setLineSpace:@"您尚未填写您的微信号，其他人将无法查看您的微信号，您也将无法获取收益" space:5 fontSize:13 color:HEXACOLOR(0x000000, 0.5)];
        [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)cancelBtnClick
{
    [self removeFromSuperview];
}

- (void)sureBtnClick
{
    if (_touchSure) {
        _touchSure();
    }
    [self cancelBtnClick];
}

- (void)editBtnClick
{
    if (_touchEidt) {
        _touchEidt();
    }
    [self cancelBtnClick];
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(35);
            make.right.mas_equalTo(self.mas_right).offset(-35);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HEXCOLOR(0x3F3A3A);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_bgView.mas_top).offset(20);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_wx_hide_alert"];
        [_bgView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(136.5, 74));
        }];
    }
    return _imgView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = HEXACOLOR(0x000000, 0.5);
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(15);
        }];
    }
    return _contentLabel;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确认隐藏" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureBtn.backgroundColor = HEXCOLOR(0xD7D7D7);
        _sureBtn.layer.cornerRadius = 4;
        [_bgView addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(12);
            make.right.mas_equalTo(_bgView.mas_centerX).offset(-7);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(18);
            make.height.mas_equalTo(@38);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-15);
        }];
        
        _sureBtn.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        _sureBtn.layer.shadowOffset = CGSizeMake(0, 1);
        _sureBtn.layer.shadowOpacity = 0.9;
        _sureBtn.layer.shadowRadius = 1;
    }
    return _sureBtn;
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setTitle:@"继续编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:HEXCOLOR(0x3F3A3A) forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _editBtn.backgroundColor = kYellowColor;
        _editBtn.layer.cornerRadius = 4;
        [_bgView addSubview:_editBtn];
        
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_centerX).offset(7);
            make.right.mas_equalTo(_bgView.mas_right).offset(-12);
            make.top.mas_equalTo(_sureBtn.mas_top);
            make.height.mas_equalTo(@38);
        }];
        
        _editBtn.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        _editBtn.layer.shadowOffset = CGSizeMake(0, 1);
        _editBtn.layer.shadowOpacity = 0.9;
        _editBtn.layer.shadowRadius = 1;
    }
    return _editBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_bgView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(_bgView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UIImageView *cancelImgView = [[UIImageView alloc] init];
        cancelImgView.image = [UIImage imageNamed:@"icon_home_refresh_cancel"];
        cancelImgView.userInteractionEnabled = NO;
        [_cancelBtn addSubview:cancelImgView];
        
        [cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_cancelBtn.mas_top).offset(6);
            make.right.mas_equalTo(_cancelBtn.mas_right).offset(-6);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _cancelBtn;
}

@end
