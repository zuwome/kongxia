//
//  ZZPayChatMessageSendAlertView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/24.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPayChatMessageSendAlertView.h"
@interface ZZPayChatMessageSendAlertView()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *detailLab;
@property (nonatomic,strong) UIButton *iKnowButton;
@property (nonatomic,strong) UILabel *instructionsLab;

@end
@implementation ZZPayChatMessageSendAlertView

+ (void)showAlertView {
    NSString *stringKey = [NSString stringWithFormat:@"FirstInto_ZZPayChatMessageSendAlertView"];
    NSString *string = [ZZKeyValueStore getValueWithKey:stringKey];
    if (!string) {
        [[[ZZPayChatMessageSendAlertView alloc]init] showAlertView];
        [ZZKeyValueStore saveValue:@"FirstInto_ZZPayChatMessageSendAlertView" key:stringKey];
    }
}
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
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.closeButton];
    [self.bgView addSubview:self.detailLab];
    [self.bgView addSubview:self.iKnowButton];
    [self.bgView addSubview:self.instructionsLab];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-32.5);
        make.left.offset(32.5);
        make.centerY.equalTo(self);
        make.height.equalTo(self.bgView.mas_width).multipliedBy(270.5/310.f);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-80);
        make.left.offset(80);
        make.top.offset(0);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.top.offset(0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(0);
        make.centerX.equalTo(self);
        make.width.equalTo(self.imageView.mas_height).multipliedBy(114/68.0);
        make.bottom.equalTo(self.detailLab.mas_top).offset(-8);
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(22.5);
        make.right.offset(-22.5);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.iKnowButton.mas_top).offset(-8);
    }];
    
    [self.iKnowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@44);
        make.centerX.equalTo(self);
        make.width.equalTo(self.iKnowButton.mas_height).multipliedBy(202/44.0f);
        make.bottom.equalTo(self.instructionsLab.mas_top).offset(-5);
    }];
    
    [self.instructionsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.equalTo(@21);
        make.bottom.offset(-9);
    }];
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = 6;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"icClose_bold"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickDissMiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)clickDissMiss {
    [self dissMissCurrent];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"私信咨询";
        _titleLab.font = ADaptedFontBoldSize(17);
        _titleLab.textColor = kBlackColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"picPayChatPop_send"];
    }
    return _imageView;
}
- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc]init];
        _detailLab.numberOfLines = 0;
        _detailLab.textColor = [UIColor blackColor];
        _detailLab.font = CustomFont(15);
        _detailLab.text = [ZZUserHelper shareInstance].configModel.priceConfig.text_chat[@"tip_of_admin"];//@"为了提高沟通效率，发送每条私信向对方赠送1张私信卡";
        _detailLab.textAlignment = NSTextAlignmentCenter;
        [UILabel changeLineSpaceForLabel:_detailLab WithSpace:5];
    }
    return _detailLab;
}

- (UIButton *)iKnowButton {
    if (!_iKnowButton) {
        _iKnowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iKnowButton addTarget:self action:@selector(clickDissMiss) forControlEvents:UIControlEventTouchUpInside];
        _iKnowButton.layer.cornerRadius = 22;
        _iKnowButton.backgroundColor = kYellowColor;
        [_iKnowButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [_iKnowButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    }
    return _iKnowButton;
}

-(UILabel *)instructionsLab {
    if (!_instructionsLab) {
        _instructionsLab = [[UILabel alloc]init];
        _instructionsLab.textAlignment = NSTextAlignmentCenter;
        _instructionsLab.textColor = RGBCOLOR(122, 122, 122);
        _instructionsLab.text = @"1张私信卡=2么币";
        _instructionsLab.font = CustomFont(12);
    }
    return _instructionsLab;
}

@end
