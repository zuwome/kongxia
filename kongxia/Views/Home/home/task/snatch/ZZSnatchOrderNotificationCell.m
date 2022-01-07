//
//  ZZSnatchOrderNotificationCell.m
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSnatchOrderNotificationCell.h"

@interface ZZSnatchOrderNotificationCell ()


@end

@implementation ZZSnatchOrderNotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = kBGColor;
        
        self.shadowView = [UIView new];
        self.shadowView.backgroundColor = kBGColor;
        _shadowView.layer.shadowColor = RGBCOLOR(190, 190, 190).CGColor;//阴影颜色
        _shadowView.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
        _shadowView.layer.shadowOpacity = 0.5;//不透明度
        _shadowView.layer.shadowRadius = 2.0f;
        _shadowView.layer.cornerRadius = 3.0f;
        [self.contentView addSubview:self.shadowView];
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@5);
            make.trailing.equalTo(@(-5));
            make.top.equalTo(@0);
            make.bottom.equalTo(@(-5));
        }];
        
        UIView *bgWhiteView = [UIView new];
        bgWhiteView.backgroundColor = [UIColor whiteColor];
        bgWhiteView.layer.masksToBounds = YES;
        bgWhiteView.layer.cornerRadius = 3.0f;
        
        [self.contentView addSubview:bgWhiteView];
        [bgWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@5);
            make.trailing.equalTo(@(-5));
            make.top.equalTo(@0);
            make.bottom.equalTo(@(-5));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"开启新发布通告通知";
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(13);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0xADADB1);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.text = @"随时报名新发布通告 轻松赚钱";
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-13);
        }];
        
        _aSwitch = [[UISwitch alloc] init];
        _aSwitch.onTintColor = kYellowColor;
        [_aSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_aSwitch];
        
        [_aSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(@30);
        }];
    }
    
    return self;
}

- (void)switchDidChange:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:type:on:)]) {
        [self.delegate cell:self type:_type on:sender.isOn];
    }
}

@end
