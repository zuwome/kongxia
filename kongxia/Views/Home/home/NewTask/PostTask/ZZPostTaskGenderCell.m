//
//  ZZPostTaskGenderCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskGenderCell.h"
#import "ZZPostTaskViewModel.h"

@interface ZZPostTaskGenderCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *maleBtn;

@property (nonatomic, strong) UIButton *femaleBtn;

@property (nonatomic, strong) UIButton *hideBtn;

@property (nonatomic, strong) UIView *line;

@end

@implementation ZZPostTaskGenderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)chooseGender:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:chooseGender:)]) {
        [self.delegate cell:self chooseGender:sender.tag];
    }
}

- (void)configureData {
        _titleLabel.text = _cellModel.title;
        
        _femaleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _maleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _hideBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        
    NSNumber *genderNum = (NSNumber *)_cellModel.data;
    if (genderNum && [genderNum isKindOfClass:[NSNumber class]]) {
        NSInteger gender = [genderNum intValue];
        if (gender == 1) {
            _maleBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        }
        else if (gender == 2) {
            _femaleBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        }
        else {
            _hideBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        }
    }
        
}

#pragma mark - UI
- (void)layout {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.maleBtn];
    [self.contentView addSubview:self.femaleBtn];
    [self.contentView addSubview:self.hideBtn];
    [self.contentView addSubview:self.line];
    
    [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(13.0);
//        make.bottom.equalTo(self).offset(-13.0);
        make.right.equalTo(self).offset(- 15.0);
        make.size.mas_equalTo(CGSizeMake(45.0, 45.0));
    }];
    
    [_maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_hideBtn);
        make.right.equalTo(_hideBtn.mas_left).offset(- 20.0);
        make.size.mas_equalTo(CGSizeMake(45.0, 45.0));
    }];
    
    [_femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_hideBtn);
        make.right.equalTo(_maleBtn.mas_left).offset(- 20.0);
        make.size.mas_equalTo(CGSizeMake(45.0, 45.0));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_hideBtn);
        make.left.equalTo(self).offset(15.0);
    }];

    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-15.0);
        make.left.equalTo(self).offset(15.0);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - Getter&Setter
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIButton *)maleBtn {
    if (!_maleBtn) {
        _maleBtn = [[UIButton alloc] init];
        [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
        [_maleBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_maleBtn addTarget:self action:@selector(chooseGender:) forControlEvents:UIControlEventTouchUpInside];
        _maleBtn.titleLabel.font = CustomFont(16);
        _maleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _maleBtn.layer.cornerRadius = 22.5;
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
        _femaleBtn.titleLabel.font = CustomFont(16);
        _femaleBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _femaleBtn.layer.cornerRadius = 22.5;
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
        _hideBtn.titleLabel.font = CustomFont(16);
        _hideBtn.backgroundColor = RGBCOLOR(245, 245, 245);
        _hideBtn.layer.cornerRadius = 22.5;
        _hideBtn.tag = 3;
    }
    return _hideBtn;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _line;
}

@end
