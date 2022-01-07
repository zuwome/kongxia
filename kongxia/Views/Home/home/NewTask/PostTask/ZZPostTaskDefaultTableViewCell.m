//
//  ZZPostTaskDefaultTableViewCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/18.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskDefaultTableViewCell.h"
#import "ZZPostTaskViewModel.h"

@interface ZZPostTaskDefaultTableViewCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *line;

@end

@implementation ZZPostTaskDefaultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconImageView.image = [UIImage imageNamed:_cellModel.icon];
    
    _titleLabel.text = _cellModel.subTitle;
    
    BOOL didHaveContent = NO;
    switch (_cellModel.type) {
        case postTheme: {
            NSString *theme = (NSString *)_cellModel.data;
            if (!isNullString(theme)) {
                _titleLabel.text = theme;
                didHaveContent = YES;
            }
            break;
        }
        case postLocation: {
            
            NSString *location = (NSString *)_cellModel.data;
            if (!isNullString(location)) {
                _titleLabel.text = location;
                didHaveContent = YES;
            }
            break;
        }
        case postTime: {
            
            NSString *time = (NSString *)_cellModel.data;
            if (!isNullString(time)) {
                _titleLabel.text = time;
                didHaveContent = YES;
            }
            break;
        }
        case postDuration: {
            NSString *time = (NSString *)_cellModel.data;
            if (!isNullString(time)) {
                _titleLabel.text = time;
                didHaveContent = YES;
            }
            
            break;
        }
        case postPrice: {
            NSString *price = (NSString *)_cellModel.data;
            if (!isNullString(price)) {
                _titleLabel.text = price;
                didHaveContent = YES;
            }

            break;
        }
        default: {
            break;
        }
    }
    
    if (didHaveContent) {
        _titleLabel.textColor = UIColor.blackColor;
    }
    else {
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
    }
}

#pragma mark - UI
- (void)layout {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.iconImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.accessoryImageView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.leading.equalTo(_bgView).offset(14.0);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(5.0);
        make.centerY.equalTo(_bgView);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(-15.0);
        make.left.equalTo(_bgView).offset(15.0);
        make.height.equalTo(@0.5);
    }];
    
    [_accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView);
        make.right.equalTo(_bgView).offset(-14.0);
        make.size.mas_equalTo(CGSizeMake(6, 12));
    }];
}

#pragma mark - Getter&Setter
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
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
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _line;
}

@end
