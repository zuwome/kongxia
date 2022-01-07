//
//  ZZSettingTitleSwitchCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/15.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZSettingTitleSwitchCell.h"

@interface ZZSettingTitleSwitchCell ()

@end

@implementation ZZSettingTitleSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - UI
- (void)layout {
    [self addSubview:self.titleLabel];
    [self addSubview:self.settingSwitch];
    [self addSubview:self.lineView];
    
    [_settingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(@30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(13.0);
        make.bottom.equalTo(self).offset(-13.0);
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(_settingSwitch.mas_left).offset(-15.0);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
}

#pragma mark - Setter&Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"屏蔽手机联系人";
    }
    return _titleLabel;
}

- (UISwitch *)settingSwitch {
    if (!_settingSwitch) {
        _settingSwitch = [[UISwitch alloc] init];
        _settingSwitch.onTintColor = kYellowColor;
    }
    return _settingSwitch;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
    }
    return _lineView;
}

@end
