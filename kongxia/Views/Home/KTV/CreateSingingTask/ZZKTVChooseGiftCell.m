//
//  ZZKTVChooseGiftCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVChooseGiftCell.h"
#import "ZZKTVConfig.h"

@interface ZZKTVChooseGiftCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *giftTitleLabel;

@property (nonatomic, strong) UIImageView *giftIconImageView;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation ZZKTVChooseGiftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark - public Method
- (void)configureKTVModel:(ZZKTVModel *)model {
    [_giftIconImageView sd_setImageWithURL:[NSURL URLWithString:model.gift.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    _giftTitleLabel.text = model.gift.name;
}


#pragma mark - UI
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.titleLabel];
    [_bgView addSubview:self.giftTitleLabel];
    [_bgView addSubview:self.giftIconImageView];
    [_bgView addSubview:self.accessoryImageView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.0);
        make.right.equalTo(self.contentView).offset(-10.0);
        make.bottom.top.equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.left.equalTo(_bgView).offset(15.0);
    }];
    
    [_giftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(-45.0);
    }];
    
    [_giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_giftTitleLabel.mas_left).offset(-5.0);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [_accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(-14.0);
        make.size.mas_equalTo(CGSizeMake(6, 12));
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

- (UIImageView *)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = [[UIImageView alloc] init];
        _accessoryImageView.image = [UIImage imageNamed:@"icon_report_right"];
    }
    return _accessoryImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"选择赠送礼物";
    }
    return _titleLabel;
}

- (UILabel *)giftTitleLabel {
    if (!_giftTitleLabel) {
        _giftTitleLabel = [[UILabel alloc] init];
        _giftTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:14.0];
        _giftTitleLabel.textColor = [UIColor blackColor];
        _giftTitleLabel.textAlignment = NSTextAlignmentLeft;
        _giftTitleLabel.text = @"";
    }
    return _giftTitleLabel;
}

- (UIImageView *)giftIconImageView {
    if (!_giftIconImageView) {
        _giftIconImageView = [[UIImageView alloc] init];
    }
    return _giftIconImageView;
}

@end
