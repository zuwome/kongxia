//
//  ZZKTVChooseSongsCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVChooseSongsCell.h"

@interface ZZKTVChooseSongsCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation ZZKTVChooseSongsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.iconImageView];
    [_bgView addSubview:self.titleLabel];
    [_bgView addSubview:self.subTitleLabel];
    [_bgView addSubview:self.accessoryImageView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.0);
        make.right.equalTo(self.contentView).offset(-10.0);
        make.bottom.top.equalTo(self.contentView);
    }];
    
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView).offset(21);
        make.left.equalTo(_bgView).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView).offset(21);
        make.left.equalTo(_iconImageView.mas_right).offset(8.0);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5.0);
        make.left.equalTo(_iconImageView.mas_right).offset(8.0);
    }];
    
    [_accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(-14.0);
        make.size.mas_equalTo(CGSizeMake(6, 12));
    }];
}


#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 3;
    }
    return _bgView;
}

- (UIImageView *)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = [[UIImageView alloc] init];
        _accessoryImageView.image = [UIImage imageNamed:@"icon_report_right"];
    }
    return _accessoryImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icHuatongFqchp"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择歌曲";
        _titleLabel.font = ADaptedFontSCBoldSize(16);
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"达人唱歌成功即可领取1个礼物";
        _subTitleLabel.font = ADaptedFontMediumSize(15);
        _subTitleLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _subTitleLabel;
}

@end
