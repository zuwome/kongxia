//
//  ZZTaskInfoCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskInfoCell.h"
#import "ZZTaskModel.h"
#import "ZZDateHelper.h"

@interface ZZTaskInfoCell ()

@property (nonatomic, strong) UIImageView *themeIconImageView;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UIImageView *priceIconImageView;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIImageView *priceDetailsIconImageView;

@property (nonatomic, strong) UIImageView *timeIconImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *locationIconImageView;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UIImageView *distanceIconImageView;

@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) UIImageView *tagsIconImageView;

@property (nonatomic, strong) UILabel *tagsLabel;

@end


@implementation ZZTaskInfoCell

+ (NSString *)cellIdentifier {
    return @"ZZTaskInfoCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    if ([_item isKindOfClass: [TaskInfoItem class]]) {
        TaskInfoItem *item = (TaskInfoItem *)_item;
        _themeLabel.text = item.task.task.skillModel.name;
        
        double price = [item.task.task.price doubleValue];
        NSString *priceStr = [NSString stringWithFormat:@"%ld小时 共%.0f元", (long)item.task.task.hours, price];
        
        _priceLabel.text = priceStr;
        
        NSMutableString *address = item.task.task.address.mutableCopy;
        if ([item.task.task.city_name isKindOfClass:[NSString class]] && !isNullString(item.task.task.city_name)) {
            NSLog(@"string:%@",item.task.task.city_name);
            if ([address hasPrefix:item.task.task.city_name]) {
                NSRange range = [address rangeOfString:item.task.task.city_name];
                [address deleteCharactersInRange:range];
            }
        }
        if ([item.task.task.city_name isKindOfClass:[NSString class]] && !isNullString(item.task.task.city_name)) {
            _locationLabel.text = [NSString stringWithFormat:@"%@%@",item.task.task.city_name, address];
        }
        else {
            _locationLabel.text = item.task.task.address;
        }
        
        double distance = item.task.task.address_city_name.doubleValue;

        CGFloat maxDistanceWidth = [NSString findWidthForText:[NSString stringWithFormat:@"%.2fkm",50.00] havingWidth:SCREEN_WIDTH andFont:_distanceLabel.font] + 1;
        CGFloat distanceWidth = [NSString findWidthForText:[NSString stringWithFormat:@"%.2fkm",distance] havingWidth:SCREEN_WIDTH andFont:_distanceLabel.font];
        if (distance >= 50) {
            _distanceLabel.text = isNullString(_item.task.task.city_name) ? [NSString stringWithFormat:@"%.2fkm",distance] : _item.task.task.city_name;
        }
        else {
            _distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",distance];
        }
        [_distanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(distanceWidth > maxDistanceWidth ? maxDistanceWidth : distanceWidth));
        }];
        
        _timeLabel.text = [NSString stringWithFormat:@"%@", [[ZZDateHelper shareInstance] showDateStringWithDateString:item.task.task.dated_at]];
        
        _priceDetailsIconImageView.hidden = !_item.task.task.isMine;
        
        if (_item.task.task.tags.count == 0) {
            _tagsIconImageView.hidden = YES;
            _tagsLabel.hidden = YES;
            
            [_tagsIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.1);
            }];
            
            [_priceIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_tagsIconImageView.mas_bottom).offset(0.0);
            }];
        }
        else {
            _tagsIconImageView.hidden = NO;
            _tagsLabel.hidden = NO;
            
            [_tagsIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@22);
            }];
            
            [_priceIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_tagsIconImageView.mas_bottom).offset(15.0);
            }];
            
            NSMutableString *tagsStr = @"".mutableCopy;
            [_item.task.task.tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!isNullString(obj)) {
                    [tagsStr appendFormat: @"#%@ ", obj];
                }
            }];
            _tagsLabel.text = tagsStr.copy;
        }
    }
}

- (void)showLocations {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showLocations:)]) {
        [self.delegate cell:self showLocations:_item.task];
    }
}

- (void)showPrice {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showPriceDetails:)]) {
        [self.delegate cell:self showPriceDetails:_item.task];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(252, 252, 252);
    [self.contentView addSubview:self.themeIconImageView];
    [self.contentView addSubview:self.themeLabel];
    [self.contentView addSubview:self.tagsIconImageView];
    [self.contentView addSubview:self.tagsLabel];
    [self.contentView addSubview:self.priceIconImageView];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.priceDetailsIconImageView];
    [self.contentView addSubview:self.timeIconImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.locationIconImageView];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.distanceIconImageView];
    [self.contentView addSubview:self.distanceLabel];
    
    [self layoutFrames];
}

- (void)layoutFrames {
    [_themeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(18.0);
        make.left.equalTo(self.contentView).offset(13.0);
        make.size.mas_equalTo(CGSizeMake(22.0, 22.0));
    }];
    
    [_tagsIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_themeIconImageView.mas_bottom).offset(15.0);
        make.centerX.equalTo(_themeIconImageView);
        make.width.equalTo(@22.0);
        make.height.equalTo(@22.0);
    }];
    
    [_priceIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tagsIconImageView.mas_bottom).offset(15.0);
        make.centerX.equalTo(_themeIconImageView);
        make.size.mas_equalTo(CGSizeMake(22.0, 22.0));
    }];
    
    [_timeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceIconImageView.mas_bottom).offset(15.0);
        make.centerX.equalTo(_themeIconImageView);
        make.size.mas_equalTo(CGSizeMake(22.0, 22.0));
    }];
    
    [_locationIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeIconImageView.mas_bottom).offset(15.0);
        make.centerX.equalTo(_themeIconImageView);
        make.size.mas_equalTo(CGSizeMake(22.0, 22.0));
    }];
    
    [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_themeIconImageView.mas_right).offset(10.0);
        make.centerY.equalTo(_themeIconImageView);
        make.right.equalTo(self.contentView).offset(-13.0);
    }];
    
    [_tagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tagsIconImageView.mas_right).offset(10.0);
        make.centerY.equalTo(_tagsIconImageView);
        make.right.equalTo(self.contentView).offset(-13.0);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceIconImageView.mas_right).offset(10.0);
        make.centerY.equalTo(_priceIconImageView);
        make.width.lessThanOrEqualTo(@217);
    }];
    
    [_priceDetailsIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLabel.mas_right).offset(10.0);
        make.centerY.equalTo(_priceLabel);
        make.size.mas_equalTo(CGSizeMake(15.0, 15.0));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeIconImageView.mas_right).offset(10.0);
        make.centerY.equalTo(_timeIconImageView);
        make.width.lessThanOrEqualTo(@217);
    }];
    
    CGFloat maxDistanceWidth = [NSString findWidthForText:[NSString stringWithFormat:@"%.2fkm",50.00] havingWidth:SCREEN_WIDTH andFont:_distanceLabel.font] + 1;
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.0);
        make.centerY.equalTo(_locationIconImageView);
        make.width.lessThanOrEqualTo(@(maxDistanceWidth));
    }];
    
    [_distanceIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_distanceLabel.mas_left).offset(-5.0);
        make.centerY.equalTo(_locationIconImageView);
        make.size.mas_equalTo(CGSizeMake(20.0, 15.0));
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_locationIconImageView.mas_right).offset(10.0);
        make.top.equalTo(_locationIconImageView).offset(-0.5);
        make.right.equalTo(_distanceIconImageView.mas_left).offset(-10.0);
        make.bottom.equalTo(self.contentView).offset(-18.0);
    }];
}

#pragma mark - Getter&Setter
- (void)setItem:(TaskItem *)item {
    _item = item;
    [self configureData];
}

- (UILabel *)themeLabel {
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = CustomFont(15.0);
        _themeLabel.text = @"探店";
        _themeLabel.textColor = ColorHex(999999);
    }
    return _themeLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = CustomFont(15.0);
        _priceLabel.text = @"0.00";
        _priceLabel.textColor = ColorHex(999999);
        _priceLabel.userInteractionEnabled = YES;
        
    }
    return _priceLabel;
}

- (UIImageView *)priceDetailsIconImageView {
    if (!_priceDetailsIconImageView) {
        _priceDetailsIconImageView = [[UIImageView alloc] init];
        _priceDetailsIconImageView.image = [UIImage imageNamed:@"icDetails"];
        _priceDetailsIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPrice)];
        [_priceDetailsIconImageView addGestureRecognizer:tap];
    }
    return _priceDetailsIconImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = CustomFont(15.0);
        _timeLabel.text = @"now";
        _timeLabel.textColor = ColorHex(999999);
    }
    return _timeLabel;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = CustomFont(15.0);
        _locationLabel.text = @"nininininini";
        _locationLabel.textColor = ColorHex(999999);
        _locationLabel.userInteractionEnabled = YES;
        _locationLabel.numberOfLines = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocations)];
        [_locationLabel addGestureRecognizer:tap];
    }
    return _locationLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = CustomFont(15.0);
        _distanceLabel.text = @"999.99km";
        _distanceLabel.textColor = ColorHex(999999);
        _distanceLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocations)];
        [_distanceLabel addGestureRecognizer:tap];
    }
    return _distanceLabel;
}

- (UILabel *)tagsLabel {
    if (!_tagsLabel) {
        _tagsLabel = [[UILabel alloc] init];
        _tagsLabel.font = CustomFont(15.0);
        _tagsLabel.text = @"#111";
        _tagsLabel.textColor = ColorHex(999999);
        _tagsLabel.numberOfLines = 0;
    }
    return _tagsLabel;
}

- (UIImageView *)themeIconImageView {
    if (!_themeIconImageView) {
        _themeIconImageView = [[UIImageView alloc] init];
        _themeIconImageView.image = [UIImage imageNamed:@"icZtYy"];
        _themeIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _themeIconImageView;
}

- (UIImageView *)priceIconImageView {
    if (!_priceIconImageView) {
        _priceIconImageView = [[UIImageView alloc] init];
        _priceIconImageView.image = [UIImage imageNamed:@"icJeYy"];
        _priceIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _priceIconImageView;
}

- (UIImageView *)timeIconImageView {
    if (!_timeIconImageView) {
        _timeIconImageView = [[UIImageView alloc] init];
        _timeIconImageView.image = [UIImage imageNamed:@"icRqYy"];
        _timeIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _timeIconImageView;
}

- (UIImageView *)locationIconImageView {
    if (!_locationIconImageView) {
        _locationIconImageView = [[UIImageView alloc] init];
        _locationIconImageView.image = [UIImage imageNamed:@"icDdYy"];
        _locationIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _locationIconImageView;
}

- (UIImageView *)distanceIconImageView {
    if (!_distanceIconImageView) {
        _distanceIconImageView = [[UIImageView alloc] init];
        _distanceIconImageView.image = [UIImage imageNamed:@"icQiangdanXianxiaLocationCopy"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocations)];
        [_distanceIconImageView addGestureRecognizer:tap];
    }
    return _distanceIconImageView;
}

- (UIImageView *)tagsIconImageView {
    if (!_tagsIconImageView) {
        _tagsIconImageView = [[UIImageView alloc] init];
        _tagsIconImageView.image = [UIImage imageNamed:@"icBiaoqian"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocations)];
        [_tagsIconImageView addGestureRecognizer:tap];
    }
    return _tagsIconImageView;
}


@end
