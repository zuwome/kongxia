//
//  ZZKTVChooseGenderCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVChooseGenderCell.h"
#import "ZZKTVConfig.h"

@interface ZZKTVChooseGenderCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *maleBtn;

@property (nonatomic, strong) UIButton *femaleBtn;

@property (nonatomic, strong) UIButton *hideBtn;

@end

@implementation ZZKTVChooseGenderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark - public Method
- (void)configureKTVModel:(ZZKTVModel *)model {
    if (model.gender == 1) {
        // 男的
        _maleBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _femaleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _hideBtn.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    else if (model.gender == 2) {
        _femaleBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _maleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _hideBtn.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    else if (model.gender == 3) {
        _hideBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _maleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _femaleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    else {
        _hideBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _maleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _femaleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
    }
}


#pragma mark - response method
- (void)chooseGender:(UIButton *)sender {
    
    if (sender.tag == 1) {
        // 男的
        _maleBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _femaleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _hideBtn.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    else if (sender.tag == 2) {
        _femaleBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _maleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _hideBtn.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    else {
        _hideBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _maleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _femaleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:chooseGender:)]) {
        [self.delegate cell:self chooseGender:sender.tag];
    }
}


#pragma mark - UI
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.titleLabel];
    [_bgView addSubview:self.maleBtn];
    [_bgView addSubview:self.femaleBtn];
    [_bgView addSubview:self.hideBtn];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.0);
        make.right.equalTo(self.contentView).offset(-10.0);
        make.bottom.top.equalTo(self.contentView);
    }];
    
    [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(- 15.0);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
    }];
    
    [_maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_hideBtn);
        make.right.equalTo(_hideBtn.mas_left).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
    }];
    
    [_femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_hideBtn);
        make.right.equalTo(_maleBtn.mas_left).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.left.equalTo(_bgView).offset(15.0);
    }];
}

#pragma mark - Getter&Setter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 3;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ADaptedFontSCBoldSize(16.0);
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.text = @"领取礼物的达人性别";
    }
    return _titleLabel;
}

- (UIButton *)maleBtn {
    if (!_maleBtn) {
        _maleBtn = [[UIButton alloc] init];
        [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
        [_maleBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_maleBtn addTarget:self action:@selector(chooseGender:) forControlEvents:UIControlEventTouchUpInside];
        _maleBtn.titleLabel.font = ADaptedFontMediumSize(15);
        _maleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _maleBtn.layer.cornerRadius = 20;
        _maleBtn.tag = 1;
    }
    return _maleBtn;
}

- (UIButton *)femaleBtn {
    if (!_femaleBtn) {
        _femaleBtn = [[UIButton alloc] init];
        [_femaleBtn setTitle:@"女" forState:UIControlStateNormal];
        [_femaleBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_femaleBtn addTarget:self action:@selector(chooseGender:) forControlEvents:UIControlEventTouchUpInside];
        _femaleBtn.titleLabel.font = ADaptedFontMediumSize(15);
        _femaleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _femaleBtn.layer.cornerRadius = 20;
        _femaleBtn.tag = 2;
    }
    return _femaleBtn;
}

- (UIButton *)hideBtn {
    if (!_hideBtn) {
        _hideBtn = [[UIButton alloc] init];
        [_hideBtn setTitle:@"不限" forState:UIControlStateNormal];
        [_hideBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_hideBtn addTarget:self action:@selector(chooseGender:) forControlEvents:UIControlEventTouchUpInside];
        _hideBtn.titleLabel.font = ADaptedFontMediumSize(15);
        _hideBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _hideBtn.layer.cornerRadius = 20;
        _hideBtn.tag = 3;
    }
    return _hideBtn;
}


@end
