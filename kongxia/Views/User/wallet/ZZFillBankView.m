//
//  ZZFillBankView.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZFillBankView.h"
@interface ZZFillBankView()

/**
 提现的保障说明
 */
@property (nonatomic,strong) UILabel *ensureLab;

/**
 提现的保障图片
 */
@property (nonatomic,strong) UIImageView *ensureImageView;

@end
@implementation ZZFillBankView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tiXianButton];
        [self addSubview:self.ensureLab];
        [self addSubview:self.ensureImageView];

    }
    return self;
}
- (UIButton *)tiXianButton {
    if (!_tiXianButton) {
        _tiXianButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tiXianButton addTarget:self action:@selector(tixianClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tiXianButton setTitle:@"确认提现" forState:UIControlStateNormal];
        _tiXianButton.titleLabel.font = CustomFont(15);
        [_tiXianButton setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        _tiXianButton.layer.cornerRadius = 3.5;
        _tiXianButton.layer.shadowOpacity = 0.5;//不透明度
        _tiXianButton.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
        _tiXianButton.layer.shadowColor = RGBCOLOR(216, 216, 216).CGColor;//阴影颜色
        _tiXianButton.enabled = NO;
        [_tiXianButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        _tiXianButton.backgroundColor = RGBCOLOR(216, 216, 216);
        
        
    }
    return _tiXianButton;
}
- (void)tixianClick:(UIButton *)sender {

    if (self.goToTixian) {
        self.goToTixian(sender);
    }
}
- (UILabel *)ensureLab  {
    if (!_ensureLab) {
        _ensureLab = [[UILabel alloc]init];
        _ensureLab.text = @"账户安全保障中";
        _ensureLab.textColor = RGBCOLOR(161, 161, 161);
        _ensureLab.font = CustomFont(12);
        _ensureLab.textAlignment = NSTextAlignmentCenter;
    }
    return _ensureLab;
}
- (UIImageView *)ensureImageView {
    if (!_ensureImageView) {
        _ensureImageView = [[UIImageView alloc]init];
        _ensureImageView.contentMode =  UIViewContentModeScaleAspectFit;
        _ensureImageView.image = [UIImage imageNamed:@"icEnsureWhitdraw"];
    }
    return _ensureImageView;
}
/**
 当前提现按钮是否可以点击
 
 @param isEnable 是否可以点击
 */
- (void)changeTiXianButtonStateIsEnable:(BOOL) isEnable {
    self.tiXianButton.enabled = isEnable;
    if (isEnable) {
        self.tiXianButton.backgroundColor = RGBCOLOR(244, 203, 7);
    }else{
        self.tiXianButton.backgroundColor = RGBCOLOR(216, 216, 216);
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.tiXianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7.5);
        make.right.offset(-7.5);
        make.top.offset(0);
        make.height.equalTo(@50);
    }];
    
    [self.ensureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.tiXianButton.mas_bottom).offset(7);
        make.height.equalTo(@20);
    }];
    
    [self.ensureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ensureLab.mas_left).offset(-5);
        make.centerY.equalTo(self.ensureLab.mas_centerY);
        make.height.equalTo(@11);
    }];
    
}
@end
