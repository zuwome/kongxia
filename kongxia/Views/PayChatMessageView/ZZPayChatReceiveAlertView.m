//
//  ZZPayChatReceiveAlertView.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPayChatReceiveAlertView.h"
@interface ZZPayChatReceiveAlertView()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *detailLab;
@property (nonatomic,strong) UIButton *iKnowButton;

@end
@implementation ZZPayChatReceiveAlertView

+ (void)showAlertView {
    NSString *stringKey = [NSString stringWithFormat:@"FirstInto_ZZPayChatReceiveAlertView"];
    NSString *string = [ZZKeyValueStore getValueWithKey:stringKey];
    if (!string) {
        [[[ZZPayChatReceiveAlertView alloc]init] showAlertView];
        [ZZKeyValueStore saveValue:@"FirstInto_ZZPayChatReceiveAlertView" key:stringKey];
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
    [self.bgView addSubview:self.closeButton];
    [self.bgView addSubview:self.detailLab];
    [self.bgView addSubview:self.iKnowButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-32.5);
        make.left.offset(32.5);
        make.centerY.equalTo(self);
        make.height.equalTo(self.bgView.mas_width).multipliedBy(224/310.f);
    }];
 
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.right.top.offset(0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_top);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.width.equalTo(self.imageView.mas_height).multipliedBy(161/95.0f);
        make.bottom.equalTo(self.detailLab.mas_top).offset(-15);
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(22.5);
        make.right.offset(-22.5);
        make.height.equalTo(@80);
        make.bottom.equalTo(self.iKnowButton.mas_top).offset(-14);
    }];
    
    [self.iKnowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@44);
        make.width.equalTo(self.iKnowButton.mas_height).multipliedBy(184/44.0f);
        make.centerX.equalTo(self);
        make.bottom.offset(-15);
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

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"picPayChatPop_receive"];
    }
    return _imageView;
}
- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc]init];
        _detailLab.numberOfLines = 0;
        _detailLab.textColor = [UIColor blackColor];
        _detailLab.font = CustomFont(15);
        _detailLab.text = [ZZUserHelper shareInstance].configModel.priceConfig.text_chat[@"tip_of_user"]; //@"您开启了私信收益功能，收到每条私信获得1张私信卡，24小时内回复领取私信卡可获得0.1元收益";
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
        [_iKnowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _iKnowButton;
}

@end
