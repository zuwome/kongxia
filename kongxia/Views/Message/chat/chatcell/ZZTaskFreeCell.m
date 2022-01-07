//
//  ZZTaskFreeCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/13.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskFreeCell.h"
#import "ZZChatTaskFreeModel.h"
#import "ZZTaskModel.h"
@interface ZZTaskFreeCell ()

@property (nonatomic, strong) UIView *infoContentView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) ZZChatBaseModel *model;

@property (nonatomic, strong) ZZTask *taskModel;

@end

@implementation ZZTaskFreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - public Method
- (void)configureModel:(ZZChatBaseModel *)model userAvatar:(NSString *)userAvatar {
    _model = model;
    
    if (![_model.message.content isKindOfClass:[ZZChatTaskFreeModel class]]) {
        return;
    }
    
    ZZChatTaskFreeModel *freeModel = (ZZChatTaskFreeModel *)_model.message.content;
    if (!freeModel.pdg || ![freeModel.pdg isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    _taskModel = [ZZTask yy_modelWithDictionary:freeModel.pdg];
    NSString *avatar = userAvatar;
    if ([freeModel.pdg[@"from"] isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        avatar = [ZZUserHelper shareInstance].loginer.displayAvatar;
    }
    
    [_userIconImageView sd_setImageWithURL:[NSURL URLWithString:avatar] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *roundImage = [image imageAddCornerWithRadius:55 / 2 andSize:CGSizeMake(55, 55)];
        _userIconImageView.image = roundImage;
    }];

    // 主题名称
    _themeLabel.text = _taskModel.skillModel.name;

    // 时间
    NSString *date = [[ZZDateHelper shareInstance] showDateStringWithDateString:_taskModel.dated_at];
    NSArray *dateArr = [date componentsSeparatedByString:@" "];
    if (_taskModel.dated_at_type == 0 || _taskModel.dated_at_type == 1) {
        _timeLabel.text = [NSString stringWithFormat:@"%@", date];
    }
    else {
        if (dateArr.count != 3) {
            _timeLabel.text = [NSString stringWithFormat:@"%@", date];
        }
        else {
            NSString *hourDesc = nil;
            // 2=深夜 3=上午  4=中午 5=下午 6=傍晚 7=晚上 8=整天
            if (_taskModel.dated_at_type == 2) {
                hourDesc = @"深夜";
            }
            else if (_taskModel.dated_at_type == 3) {
                hourDesc = @"上午";
            }
            else if (_taskModel.dated_at_type == 4) {
                hourDesc = @"中午";
            }
            else if (_taskModel.dated_at_type == 5) {
                hourDesc = @"下午";
            }
            else if (_taskModel.dated_at_type == 6) {
                hourDesc = @"傍晚";
            }
            else if (_taskModel.dated_at_type == 7) {
                hourDesc = @"晚上";
            }
            else if (_taskModel.dated_at_type == 8) {
                hourDesc = @"整天";
            }
            _timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", dateArr.firstObject, dateArr[1], hourDesc];
        }
    }

    // 地点
    NSMutableString *address = _taskModel.address.mutableCopy;
    if ([_taskModel.city_name isKindOfClass:[NSString class]] && !isNullString(_taskModel.city_name)) {
        if ([address hasPrefix:_taskModel.city_name]) {
            NSRange range = [address rangeOfString:_taskModel.city_name];
            if (range.location != NSNotFound) {
                [address deleteCharactersInRange:range];
            }
        }
    }
    if ([_taskModel.city_name isKindOfClass:[NSString class]] && !isNullString(_taskModel.city_name)) {
        _locationLabel.text = [NSString stringWithFormat:@"%@%@",_taskModel.city_name, address];
    }
    else {
        _locationLabel.text = _taskModel.address;
    }
    
}

#pragma mark - response method
- (void)selectActions {
    if (_taskModel.taskStatus != TaskOngoing && _taskModel.taskStatus != TaskClose) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelect:)]) {
        [self.delegate cell:self didSelect:_taskModel];
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
    
    [_infoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16.5);
        make.right.equalTo(self).offset(-16.5);
        make.height.equalTo(@85.0);
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
}

#pragma mark - getters and setters
- (UIView *)infoContentView {
    if (!_infoContentView) {
        _infoContentView = [[UIView alloc] init];
        _infoContentView.backgroundColor = UIColor.whiteColor;
        _infoContentView.layer.cornerRadius = 4;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectActions)];
        [_infoContentView addGestureRecognizer:tap];
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
        _themeLabel.text = @"";
    }
    return _themeLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGBCOLOR(102, 102, 102);
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"";
    }
    return _timeLabel;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = RGBCOLOR(153, 153, 153);
        _locationLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _locationLabel.text = @"";
    }
    return _locationLabel;
}

@end

