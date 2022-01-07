//
//  ZZARRentAlertView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZARRentAlertView.h"
@interface ZZARRentAlertView ()
/**
 背景
 */
@property(nonatomic,strong) UIView *bgView;
/**
 image
 */
@property(nonatomic,strong) UIImageView *imageView;
/**
 关闭
 */
@property(nonatomic,strong) UIButton *closeButton;
/**
 title
 */
@property(nonatomic,strong) UILabel *titleLab;


@end
@implementation ZZARRentAlertView



- (void)showAlertView {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setUpUI];
    [self showView:nil];
}
/**
 设置UI
 */
- (void)setUpUI {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.imageView];
    [self.bgView addSubview:self.closeButton];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.detailTitleLab];
    [self.bgView addSubview:self.sureButton];
    [self.bgView addSubview:self.seeButton];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(AdaptedWidth(310)));
        make.height.equalTo(self.bgView.mas_width).multipliedBy(235.5f/310);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.centerY.equalTo(self.bgView.mas_top).offset(18);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(7.5);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    [self.detailTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY).offset(10);
        make.left.offset(29);
        make.right.offset(-29);
        
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.seeButton.mas_centerY);
        make.height.equalTo(@44);
        make.width.equalTo(@(AdaptedWidth(135)));
        make.right.offset(-15);

    }];
    
    [self.seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.sureButton);
        make.width.equalTo(@(AdaptedWidth(135)));
        make.bottom.equalTo(@(-14.5));
        make.left.offset(15);

    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 6;
    }
    return _bgView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"ar_icNoticePopup"];
    }
    return _imageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"open_Notification_icClose"] forState:UIControlStateNormal];
    }
    return _closeButton;
}
- (void)closeButtonClick {
    [self dissMissCurrent];
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = ADaptedFontSCBoldSize(16);
        _titleLab.textColor = kBlackColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"提示";
    }
    return _titleLab;
}

- (UILabel *)detailTitleLab {
    if (!_detailTitleLab) {
        _detailTitleLab = [[UILabel alloc]init];
        _detailTitleLab.font = CustomFont(14);
        _detailTitleLab.textColor = kBlackColor;
        _detailTitleLab.textAlignment = NSTextAlignmentCenter;
        _detailTitleLab.numberOfLines = 0;
        _detailTitleLab.text = @"若对方未回复私信可尝试在邀约页面拨打电话，更容易联系上对方，是否确认申请退款？";
        [UILabel changeLineSpaceForLabel:_detailTitleLab WithSpace:5];
    }
    return _detailTitleLab;
}

-(UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.backgroundColor = RGBCOLOR(216, 216, 216);
        [_sureButton setTitle:@"确认退款" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = CustomFont(15);
        _sureButton.layer.cornerRadius = 4;
        [_sureButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    }
    return _sureButton;
}

- (void)sureClick {
    if (self.sureBlock) {
        self.sureBlock();
    }
    [self closeButtonClick];
}

- (UIButton *)seeButton {
    if (!_seeButton) {
        _seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seeButton addTarget:self action:@selector(seeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _seeButton.backgroundColor = RGBCOLOR(244, 203, 7);
        [_seeButton setTitle:@"联系看看" forState:UIControlStateNormal];
        _seeButton.titleLabel.font = CustomFont(15);
        _seeButton.layer.cornerRadius = 4;
        [_seeButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    }
    return _seeButton;
}

- (void)seeButtonClick {
    if (self.seeBlock) {
        self.seeBlock();
    }
    [self dissMissCurrent];
}
@end
