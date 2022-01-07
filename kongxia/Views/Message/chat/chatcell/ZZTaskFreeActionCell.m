//
//  ZZTaskFreeActionCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/12.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskFreeActionCell.h"
#import "ZZSkill.h"

@interface ZZTaskFreeActionCell ()

@property (nonatomic, strong) UIView *infoContentView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *actionBtn;

@end

@implementation ZZTaskFreeActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configure {
    if (![_info isKindOfClass:[ZZTaskModel class]]) {
        return;
    }
    
    ZZTaskModel *model = _info;
    
    [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:model.from.displayAvatar] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:55 / 2 andSize:CGSizeMake(55, 55)];
        _userIconImageView.image = roundImage;
    }];
    
    // 主题名称
    _themeLabel.text = model.task.skillModel.name;
    
    // 时间
    NSString *date = [[ZZDateHelper shareInstance] showDateStringWithDateString:model.task.dated_at];
    NSArray *dateArr = [date componentsSeparatedByString:@" "];
    if (model.task.dated_at_type == 0 || model.task.dated_at_type == 1) {
        _timeLabel.text = [NSString stringWithFormat:@"%@", date];
    }
    else {
        if (dateArr.count != 3) {
            _timeLabel.text = [NSString stringWithFormat:@"%@", date];
        }
        else {
            NSString *hourDesc = nil;
            // 2=深夜 3=上午  4=中午 5=下午 6=傍晚 7=晚上 8=整天
            if (model.task.dated_at_type == 2) {
                hourDesc = @"深夜";
            }
            else if (model.task.dated_at_type == 3) {
                hourDesc = @"上午";
            }
            else if (model.task.dated_at_type == 4) {
                hourDesc = @"中午";
            }
            else if (model.task.dated_at_type == 5) {
                hourDesc = @"下午";
            }
            else if (model.task.dated_at_type == 6) {
                hourDesc = @"傍晚";
            }
            else if (model.task.dated_at_type == 7) {
                hourDesc = @"晚上";
            }
            else if (model.task.dated_at_type == 8) {
                hourDesc = @"整天";
            }
            _timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", dateArr.firstObject, dateArr[1], hourDesc];
        }
    }
    
    // 地点
    NSMutableString *address = model.task.address.mutableCopy;
    if ([model.task.city_name isKindOfClass:[NSString class]] && !isNullString(model.task.city_name)) {
        if ([address hasPrefix:model.task.city_name]) {
            NSRange range = [address rangeOfString:model.task.city_name];
            if (range.location != NSNotFound) {
                [address deleteCharactersInRange:range];
            }
        }
    }
    if ([model.task.city_name isKindOfClass:[NSString class]] && !isNullString(model.task.city_name)) {
        _locationLabel.text = [NSString stringWithFormat:@"%@%@",model.task.city_name, address];
    }
    else {
        _locationLabel.text = model.task.address;
    }

}

#pragma mark - response method
- (void)btnAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSend:)]) {
        [self.delegate cell:self didSend:(ZZTaskModel *)_info];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self addSubview:self.infoContentView];
    [_infoContentView addSubview:self.userIconImageView];
    [_infoContentView addSubview:self.themeLabel];
    [_infoContentView addSubview:self.timeLabel];
    [_infoContentView addSubview:self.locationLabel];
    [_infoContentView addSubview:self.line];
    [_infoContentView addSubview:self.descLabel];
    [_infoContentView addSubview:self.actionBtn];
    
    [_infoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16.5);
        make.right.equalTo(self).offset(-16.5);
        make.height.equalTo(@124.0);
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_infoContentView).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(55.0, 55.0));
    }];
    
    [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(7);
        make.top.equalTo(_infoContentView).offset(18.0);
        
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_themeLabel);
        make.right.equalTo(_infoContentView).offset(-15);
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_themeLabel);
        make.top.equalTo(_themeLabel.mas_bottom).offset(6.5);
        make.right.equalTo(_infoContentView).offset(-15);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoContentView).offset(15);
        make.top.equalTo(_userIconImageView.mas_bottom).offset(8);
        make.right.equalTo(_infoContentView).offset(-15);
        make.height.equalTo(@1);
    }];

    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoContentView).offset(15);
        make.top.equalTo(_line.mas_bottom).offset(10);
    }];

    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_descLabel);
        make.right.equalTo(_infoContentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(51.5, 25));
    }];
    
}

#pragma mark - getters and setters
- (void)setInfo:(id)info {
    _info = info;
    [self configure];
}

- (UIView *)infoContentView {
    if (!_infoContentView) {
        _infoContentView = [[UIView alloc] init];
        _infoContentView.backgroundColor = UIColor.whiteColor;
        _infoContentView.layer.cornerRadius = 4;
    }
    return _infoContentView;
}

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
    }
    return _userIconImageView;
}

- (UILabel *)themeLabel {
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.textColor = RGBCOLOR(63, 58, 58);
        _themeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _themeLabel.text = @"打炮";
    }
    return _themeLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGBCOLOR(102, 102, 102);
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"2018-10-10";
    }
    return _timeLabel;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = RGBCOLOR(153, 153, 153);
        _locationLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _locationLabel.text = @"万寿北路50号602";
    }
    return _locationLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    return _line;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = RGBCOLOR(102, 102, 102);
        _descLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _descLabel.text = @"嗨，我对你的活动很感兴趣";
    }
    return _descLabel;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] init];
        _actionBtn.normalTitle = @"发送";
        _actionBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _actionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _actionBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _actionBtn.layer.cornerRadius = 14.0;
        [_actionBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

@end
