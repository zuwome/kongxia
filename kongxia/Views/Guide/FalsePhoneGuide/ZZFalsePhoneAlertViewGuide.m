//
//  ZZFalsePhoneAlertView.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZFalsePhoneAlertViewGuide.h"
@interface ZZFalsePhoneAlertViewGuide()
@property (nonatomic,strong) UIView      *showBackGroundView;
@property (nonatomic,strong) UIImageView *showBackImageView;
@property (nonatomic,strong) UILabel     *tiShiLab;
@property (nonatomic,strong) UILabel      *promptLab;
@property (nonatomic,strong) UIButton    *sureButton;
@property (nonatomic,strong) UILabel     *iphoneNumber;
@property (nonatomic,copy)   dispatch_block_t sureButtonCallBack;
@end
@implementation ZZFalsePhoneAlertViewGuide

/**
 当第一次点击虚假进行拨打的时候弹出
 */
+ (void)showAlertViewGuideViewWhenFirstIntoSureBack:(void(^)(void))sureButtonCallBack {
   
    [[[ZZFalsePhoneAlertViewGuide alloc]init] showAlertViewGuideViewWhenFirstIntoSureBack:^{
        if (sureButtonCallBack) {
            sureButtonCallBack();
        }
    }];
}

- (void)showAlertViewGuideViewWhenFirstIntoSureBack:(void(^)(void))sureButtonCallBack {
    if (sureButtonCallBack) {
       self.sureButtonCallBack = sureButtonCallBack;
    }
    [self setUI];
    [self showView:[UIApplication sharedApplication].keyWindow.rootViewController];
}

#pragma mark - 布局UI并且设置约束
- (void)setUI {
    [self addSubview:self.showBackGroundView];

    [self.showBackGroundView addSubview:self.showBackImageView];
    [self.showBackGroundView addSubview:self.tiShiLab];
    [self.showBackGroundView addSubview:self.promptLab];
    [self.showBackGroundView addSubview:self.sureButton];
    [self.showBackGroundView addSubview:self.iphoneNumber];
    [self setUpTheConstraints];
}
- (void)setUpTheConstraints {
    
    [self.showBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(250), AdaptedHeight(300)));
    }];
    
    [self.showBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.mas_equalTo(AdaptedHeight(118));
    }];
    [self.iphoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.showBackGroundView.mas_centerX);
        make.bottom.mas_equalTo(self.showBackImageView.mas_bottom).with.offset(-AdaptedHeight(27));
    }];
    [self.tiShiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.mas_equalTo(self.showBackImageView.mas_bottom).with.offset(AdaptedHeight(13.5));
        make.height.mas_equalTo(AdaptedHeight(50));
    }];
    
    [self.promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
      make.top.mas_equalTo(self.tiShiLab.mas_bottom).with.offset(AdaptedHeight(15));
        make.height.mas_equalTo(AdaptedHeight(46));
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(AdaptedHeight(44));
    }];
}

#pragma mark - Lazy loading
- (UIView *)showBackGroundView {
    if (!_showBackGroundView) {
        _showBackGroundView = [[UIView alloc]initWithFrame:CGRectZero];
        _showBackGroundView.backgroundColor = [UIColor whiteColor];
        _showBackGroundView.clipsToBounds = YES;
        _showBackGroundView.layer.cornerRadius = 3;
    }
    return _showBackGroundView;
}
- (UIImageView *)showBackImageView {
    if (!_showBackImageView) {
        _showBackImageView = [[UIImageView alloc]init];
        _showBackImageView.image = [UIImage imageNamed:@"picVirtualPhonePopup"];
    }
    return _showBackImageView;
}

- (UILabel *)iphoneNumber {
    if (!_iphoneNumber) {
        _iphoneNumber = [[UILabel alloc]init];
        _iphoneNumber.textColor = RGBCOLOR(255, 255, 255);
        _iphoneNumber.font = [UIFont systemFontOfSize:13];
        _iphoneNumber.textAlignment = NSTextAlignmentCenter;
        _iphoneNumber.text = @"137********";
    }
    return _iphoneNumber;
}
-(UILabel *)tiShiLab {
    if (!_tiShiLab) {
        _tiShiLab = [[UILabel alloc]init];
        _tiShiLab.text = @"您将通过“虚拟号”与对方联系请放心使用";
        _tiShiLab.textAlignment = NSTextAlignmentCenter;
        _tiShiLab.textColor = kBlackColor;
        UIFont *font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        if (font) {
            _tiShiLab.font = font;
        }else{
            _tiShiLab.font = [UIFont systemFontOfSize:17];
        }
        _tiShiLab.numberOfLines = 0;
    }
    return _tiShiLab;
}

- (UILabel *)promptLab {
    if (!_promptLab) {
        _promptLab = [[UILabel alloc]init];
        _promptLab.textColor = RGBACOLOR(0, 0, 0, 0.49);
        _promptLab.text = @"为保证服务质量，接听电话期间\n您的通话将被录音";
        _promptLab.numberOfLines = 0 ;
        _promptLab.textAlignment = NSTextAlignmentCenter;
        _promptLab.font = [UIFont systemFontOfSize:15];
    }
    return _promptLab;
}
- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = RGBACOLOR(244, 203, 7, 1);
        [_sureButton setTitle:@"知道了" forState:UIControlStateNormal];
        [_sureButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (void)sureButtonClick {
    [self dissMiss];
}
- (void)dissMiss {
    if (self.sureButtonCallBack) {
        self.sureButtonCallBack();
    }
    [super dissMiss];
    
}

@end
