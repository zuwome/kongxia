//
//  ZZTaskActivityInfoCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskActivityInfoCell.h"
#import "ZZTaskModel.h"
#import "ZZDateHelper.h"

@interface ZZTaskActivityInfoCell ()

@property (nonatomic, strong) UIImageView *infoContentImageView;

@property (nonatomic, strong) UIImageView *themeIconImageView;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UIImageView *contentIconImageView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *priceDetailsIconImageView;

@property (nonatomic, strong) UIImageView *timeIconImageView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *locationIconImageView;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UIImageView *distanceIconImageView;

@property (nonatomic, strong) UILabel *distanceLabel;



@end

@implementation ZZTaskActivityInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)showLocations {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:activityShowLocations:)]) {
        [self.delegate cell:self activityShowLocations:_item.task];
    }
}

- (void)showPrice {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:activityShowPriceDetails:)]) {
        [self.delegate cell:self activityShowPriceDetails:_item.task];
    }
}

- (void)showMore {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:activityShowMoreAction:)]) {
        [self.delegate cell:self activityShowMoreAction:_item];
    }
}

- (void)configureData {
    if (_item.taskType == TaskFree && _item.task.task.isMine && !(_item.task.task.taskStatus == TaskOngoing || _item.task.task.taskStatus == TaskReviewing)) {
        _infoContentImageView.alpha = 0.6;
    }
    else {
        _infoContentImageView.alpha = 1.0;
    }
    
    // 主题
    _themeLabel.text = _item.task.task.skillModel.name;
    
    // 价格
//    NSString *priceStr = [NSString stringWithFormat:@"%@元/%ld小时", _item.task.task.price, (long)_item.task.task.hours];
//    _priceLabel.text = priceStr;

    // 距离
    double distance = _item.task.task.address_city_name.doubleValue;
    if (distance > 50) {
        _distanceLabel.text = _item.task.task.city_name;
    }
    else {
        _distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",distance];
    }

    // 地点
    NSMutableString *address = _item.task.task.address.mutableCopy;
    if ([_item.task.task.city_name isKindOfClass:[NSString class]] && !isNullString(_item.task.task.city_name)) {
        NSLog(@"string:%@",_item.task.task.city_name);
        if ([address hasPrefix:_item.task.task.city_name]) {
            NSRange range = [address rangeOfString:_item.task.task.city_name];
            if (range.location != NSNotFound) {
                [address deleteCharactersInRange:range];
            }
        }
    }
    if ([_item.task.task.city_name isKindOfClass:[NSString class]] && !isNullString(_item.task.task.city_name)) {
        _locationLabel.text = [NSString stringWithFormat:@"%@%@",_item.task.task.city_name, address];
    }
    else {
        _locationLabel.text = _item.task.task.address;
    }

    // 时间
    NSString *date = [[ZZDateHelper shareInstance] showDateStringWithDateString:_item.task.task.dated_at];
    NSArray *dateArr = [date componentsSeparatedByString:@" "];
    if (_item.task.task.dated_at_type == 0 || _item.task.task.dated_at_type == 1) {
        _timeLabel.text = [NSString stringWithFormat:@"%@", date];
    }
    else {
        if (dateArr.count != 3) {
            _timeLabel.text = [NSString stringWithFormat:@"%@", date];
        }
        else {
            NSString *hourDesc = nil;
            // 2=深夜 3=上午  4=中午 5=下午 6=傍晚 7=晚上 8=整天
            if (_item.task.task.dated_at_type == 2) {
                hourDesc = @"深夜";
            }
            else if (_item.task.task.dated_at_type == 3) {
                hourDesc = @"上午";
            }
            else if (_item.task.task.dated_at_type == 4) {
                hourDesc = @"中午";
            }
            else if (_item.task.task.dated_at_type == 5) {
                hourDesc = @"下午";
            }
            else if (_item.task.task.dated_at_type == 6) {
                hourDesc = @"傍晚";
            }
            else if (_item.task.task.dated_at_type == 7) {
                hourDesc = @"晚上";
            }
            else if (_item.task.task.dated_at_type == 8) {
                hourDesc = @"整天";
            }
            _timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", dateArr.firstObject, dateArr[1], hourDesc];
        }
    }
    
//    _priceDetailsIconImageView.hidden = !_item.task.task.isMine;
    
    // 状态
    NSString *statusString = @"更多";
    if (_item.task.task.isMine) {
        switch (_item.task.task.taskStatus) {
            case TaskOngoing: {
                statusString = @"取消发布";
                break;
            }
            case TaskCancel: {
                statusString = @"已取消";
                break;
            }
            case TaskClose: {
                statusString = @"已结束报名";
                break;
            }
            case TaskFinish: {
                statusString = @"已结束";
                break;
            }
            case TaskExpired: {
                statusString = @"已过期";
                break;
            }
            case TaskReported: {
                statusString = @"被举报";
                break;
            }
            case TaskReviewing: {
                statusString = @"审核中";
                break;
            }
            case TaskReviewFail: {
                statusString = @"审核失败";
                break;
            }
            default: {
                break;
            }
        }
        _moreBtn.layer.borderColor = RGBCOLOR(119, 119, 119).CGColor;
        _moreBtn.layer.borderWidth = 1.0;
        _moreBtn.layer.cornerRadius = 15.0;
        [_moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_infoContentImageView).offset(26.0);
            make.right.equalTo(_infoContentImageView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(79, 30));
        }];
    }
    else {
        _moreBtn.layer.borderWidth = 0.0;
        [_moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_themeIconImageView);
            make.right.equalTo(_infoContentImageView).offset(-15.5);
        }];
    }
    _moreBtn.normalTitle = statusString;
    
    // 详情
    if (!isNullString(_item.task.task.brief_text)) {
        _contentLabel.hidden = NO;
        _contentIconImageView.hidden = NO;
        _contentLabel.text = _item.task.task.brief_text;
    }
    else {
        _contentLabel.hidden = YES;
        _contentIconImageView.hidden = YES;
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = ColorClear;
    [self.contentView addSubview:self.infoContentImageView];
    [_infoContentImageView addSubview:self.themeIconImageView];
    [_infoContentImageView addSubview:self.themeLabel];
//    [_infoContentImageView addSubview:self.priceDetailsIconImageView];
    [_infoContentImageView addSubview:self.timeIconImageView];
    [_infoContentImageView addSubview:self.timeLabel];
    [_infoContentImageView addSubview:self.locationIconImageView];
    [_infoContentImageView addSubview:self.locationLabel];
    [_infoContentImageView addSubview:self.distanceIconImageView];
    [_infoContentImageView addSubview:self.distanceLabel];
    [_infoContentImageView addSubview:self.contentIconImageView];
    [_infoContentImageView addSubview:self.contentLabel];
    [_infoContentImageView addSubview:self.moreBtn];
    [self layoutFrames];
}

- (void)layoutFrames {
    [_infoContentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(7.0);
        make.right.equalTo(self.contentView).offset(-7.0);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [_themeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoContentImageView).offset(15.0);
        make.top.equalTo(_infoContentImageView).offset(37.0);
        make.size.mas_equalTo(CGSizeMake(13.0, 13.0));
    }];
    
    [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_themeIconImageView);
        make.left.equalTo(_themeIconImageView.mas_right).offset(13.0);
        make.width.equalTo(@(217));
    }];
    
    [_timeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_themeIconImageView);
        make.size.mas_equalTo(CGSizeMake(7.0, 7.0));
        make.top.equalTo(_themeIconImageView.mas_bottom).offset(30.0);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeIconImageView);
        make.left.equalTo(_timeIconImageView.mas_right).offset(13.0);
        make.width.equalTo(@(217));
    }];
    
    [_locationIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_themeIconImageView);
        make.size.mas_equalTo(CGSizeMake(7.0, 7.0));
        make.top.equalTo(_timeIconImageView.mas_bottom).offset(30.0);
    }];
    
    CGFloat maxDistanceWidth = [NSString findWidthForText:[NSString stringWithFormat:@"%.2fkm",50.00] havingWidth:SCREEN_WIDTH andFont:_distanceLabel.font];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_locationIconImageView);
        make.right.equalTo(_infoContentImageView).offset(-11.0);
        make.width.lessThanOrEqualTo(@(maxDistanceWidth)).priorityHigh();
    }];
    
    [_distanceIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_distanceLabel);
        make.right.equalTo(_distanceLabel.mas_left).offset(-6.0);
        make.size.mas_equalTo(CGSizeMake(20.0, 15.0));
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeIconImageView.mas_bottom).offset(25.0);
        make.right.equalTo(_distanceIconImageView.mas_left).offset(-13.0);
        make.left.equalTo(_locationIconImageView.mas_right).offset(13.0);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_locationLabel.mas_bottom).offset(16.0);
        make.left.equalTo(_contentIconImageView.mas_right).offset(13.0);
        make.right.equalTo(_infoContentImageView.mas_right).offset(-15.0);
        make.bottom.equalTo(_infoContentImageView).offset(-18.0);
    }];
    
    [_contentIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_locationIconImageView);
        make.size.mas_equalTo(CGSizeMake(7.0, 7.0));
        make.top.equalTo(_contentLabel).offset(6.0);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_themeIconImageView);
        make.right.equalTo(_infoContentImageView).offset(-15.5);
    }];
}

#pragma mark - Getter&Setter
- (void)setItem:(TaskActivityInfoItem *)item {
    _item = item;
    [self configureData];
}

- (UIImageView *)infoContentImageView {
    if (!_infoContentImageView) {
        _infoContentImageView = [[UIImageView alloc] init];
        _infoContentImageView.userInteractionEnabled = YES;
        _infoContentImageView.image = [[UIImage imageNamed:@"combinedShape"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
    }
    return _infoContentImageView;
}

- (UILabel *)themeLabel {
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _themeLabel.text = @"探店";
        _themeLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _themeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = CustomFont(15.0);
        _contentLabel.text = @"0.00";
        _contentLabel.textColor = ColorHex(999999);
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 45 - 22);
        [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _contentLabel;
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
        
        _locationLabel.preferredMaxLayoutWidth = (217);
        [_locationLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
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

- (UIImageView *)themeIconImageView {
    if (!_themeIconImageView) {
        _themeIconImageView = [[UIImageView alloc] init];
        _themeIconImageView.backgroundColor = RGBCOLOR(244, 203, 7);
        _themeIconImageView.layer.cornerRadius = 6.5;
    }
    return _themeIconImageView;
}

- (UIImageView *)contentIconImageView {
    if (!_contentIconImageView) {
        _contentIconImageView = [[UIImageView alloc] init];
        _contentIconImageView.backgroundColor = RGBCOLOR(204, 204, 204);
        _contentIconImageView.layer.cornerRadius = 3.5;
    }
    return _contentIconImageView;
}

- (UIImageView *)timeIconImageView {
    if (!_timeIconImageView) {
        _timeIconImageView = [[UIImageView alloc] init];
        _timeIconImageView.backgroundColor = RGBCOLOR(204, 204, 204);
        _timeIconImageView.layer.cornerRadius = 3.5;
    }
    return _timeIconImageView;
}

- (UIImageView *)locationIconImageView {
    if (!_locationIconImageView) {
        _locationIconImageView = [[UIImageView alloc] init];
        _locationIconImageView.backgroundColor = RGBCOLOR(204, 204, 204);
        _locationIconImageView.layer.cornerRadius = 3.5;
    }
    return _locationIconImageView;
}

- (UIImageView *)distanceIconImageView {
    if (!_distanceIconImageView) {
        _distanceIconImageView = [[UIImageView alloc] init];
        _distanceIconImageView.userInteractionEnabled = YES;
        _distanceIconImageView.image = [UIImage imageNamed:@"icQiangdanXianxiaLocationCopy"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocations)];
        [_distanceIconImageView addGestureRecognizer:tap];
    }
    return _distanceIconImageView;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:RGBCOLOR(153, 153, 154) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = CustomFont(12.0);
        [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

@end
