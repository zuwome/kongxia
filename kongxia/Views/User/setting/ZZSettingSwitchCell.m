//
//  ZZSettingContactCell.m
//  zuwome
//
//  Created by angBiu on 16/9/5.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSettingSwitchCell.h"

@implementation ZZSettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"屏蔽手机联系人";
        [bgView addSubview:_titleLabel];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.offset(0);
            make.height.equalTo(@50);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(15);
            make.top.mas_equalTo(@5);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBCOLOR(161, 161, 161);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.hidden = YES;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.equalTo(@-5);
        }];
        
        _settingSwitch = [[UISwitch alloc] init];
        _settingSwitch.onTintColor = kYellowColor;
        [bgView addSubview:_settingSwitch];
        
        [_settingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-15);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.height.mas_equalTo(@30);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        self.contentView.backgroundColor = HEXCOLOR(0xf5f5f5);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
