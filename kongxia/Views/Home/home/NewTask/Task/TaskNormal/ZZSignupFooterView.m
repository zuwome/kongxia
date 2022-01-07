//
//  ZZSignupFooterView.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/29.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSignupFooterView.h"

@implementation ZZSignupFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.descriptLabel1];
    [self addSubview:self.descriptLabel2];
    [self addSubview:self.descriptLabel3];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-15.0);
    }];
    
    [_descriptLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(12);
        make.right.equalTo(self).offset(-15.0);
    }];
    
    [_descriptLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_descriptLabel1.mas_bottom).offset(8);
        make.right.equalTo(self).offset(-15.0);
    }];
    
    [_descriptLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_descriptLabel2.mas_bottom).offset(8);
        make.right.equalTo(self).offset(-15.0);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"提高通告报名小Tip:";
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
        _titleLabel.font = CustomFont(13);
    }
    return _titleLabel;
}

- (UILabel *)descriptLabel1 {
    if (!_descriptLabel1) {
        _descriptLabel1 = [[UILabel alloc] init];
        _descriptLabel1.text = @"1 去沟通对你的通告有兴趣的达人，Ta在期待你的主动";
        _descriptLabel1.textColor = RGBCOLOR(153, 153, 153);
        _descriptLabel1.font = CustomFont(14);
    }
    return _descriptLabel1;
}

- (UILabel *)descriptLabel2 {
    if (!_descriptLabel2) {
        _descriptLabel2 = [[UILabel alloc] init];
        _descriptLabel2.text = @"2 选择大家比较感兴趣的通告地点，如网红打卡圣地等";
        _descriptLabel2.textColor = RGBCOLOR(153, 153, 153);
        _descriptLabel2.font = CustomFont(14);
    }
    return _descriptLabel2;
}

- (UILabel *)descriptLabel3 {
    if (!_descriptLabel3) {
        _descriptLabel3 = [[UILabel alloc] init];
        _descriptLabel3.text = @"3 金额越高，报名达人会越积极，您的选择就越多哦";
        _descriptLabel3.textColor = RGBCOLOR(153, 153, 153);
        _descriptLabel3.font = CustomFont(14);
    }
    return _descriptLabel3;
}

@end
