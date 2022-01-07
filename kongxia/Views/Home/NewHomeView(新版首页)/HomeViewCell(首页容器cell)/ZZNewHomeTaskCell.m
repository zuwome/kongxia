//
//  ZZNewHomeTaskCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/2.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZNewHomeTaskCell.h"
#import "ZZDateHelper.h"

@interface ZZNewHomeTaskCell ()

@property (nonatomic, strong) UILabel *taskTitleLble;

@property (nonatomic, strong) UILabel *singupLabel;

@property (nonatomic, strong) UIButton *signupButton;

@property (nonatomic, strong) ZZHeadImageView *userIconImageView;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *skillLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) UIImageView *distanceIconImageView;

@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation ZZNewHomeTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)signup {
    if (self.signupCallback) {
        self.signupCallback(self.taskModel);
    }
}

- (void)showLocations {
    if (self.showLocationsCallback) {
        self.showLocationsCallback(self.taskModel);
    }
}

- (void)configure:(ZZTask *)model {
    self.taskModel = model;
//    [_userIconImageView setUser:self.taskModel.from width:60.0 vWidth:12];
    [_userIconImageView setUser:self.taskModel.from anonymousAvatar:self.taskModel.anonymous_avatar width:60.0 vWidth:12];
    _userNameLabel.text = self.taskModel.from.nickname;
    
    _skillLabel.text = [NSString stringWithFormat:@"主题：%@", self.taskModel.skillModel.name];
    _priceLabel.text = [NSString stringWithFormat:@"金额：%ld小时 共%@元", (long)self.taskModel.hours, self.taskModel.price];
    _timeLabel.text = [NSString stringWithFormat:@"时间：%@", [[ZZDateHelper shareInstance] showDateStringWithDateString:self.taskModel.dated_at]];
    _locationLabel.text = [NSString stringWithFormat:@"地点：%@%@",self.taskModel.city_name, self.taskModel.address];
    
    double distance = self.taskModel.address_city_name.doubleValue;
    if (distance > 50) {
        _distanceLabel.text = self.taskModel.city_name;
    }
    else {
        _distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",distance];
    }
}

- (void)layout {
    self.backgroundColor = RGBCOLOR(254, 253, 245);
    
    [self.contentView addSubview:self.taskTitleLble];
    [self.contentView addSubview:self.singupLabel];
    [self.contentView addSubview:self.signupButton];
    [self.contentView addSubview:self.userIconImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.skillLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.distanceIconImageView];
    [self.contentView addSubview:self.distanceLabel];
    
    [_taskTitleLble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15.0);
    }];
    
    [_singupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_taskTitleLble);
        make.right.equalTo(self.contentView).offset(-20.0);
        make.width.equalTo(@(80));
    }];
    
    [_signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.left.equalTo(_singupLabel).offset(-20);
        make.bottom.equalTo(_singupLabel).offset(20);
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.top.equalTo(_taskTitleLble.mas_bottom).offset(17.0);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconImageView.mas_bottom).offset(11.0);
        make.left.equalTo(_userIconImageView);
        make.bottom.equalTo(self.contentView).offset(-15.0);
    }];
    
    [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconImageView).offset(-8.0);
        make.left.equalTo(_userIconImageView.mas_right).offset(8);
        make.width.lessThanOrEqualTo(@(220));
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_skillLabel.mas_bottom).offset(4.0);
        make.left.equalTo(_userIconImageView.mas_right).offset(8);
        make.width.lessThanOrEqualTo(@(220));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_bottom).offset(4.0);
        make.left.equalTo(_userIconImageView.mas_right).offset(8);
        make.width.lessThanOrEqualTo(@(220));
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(4.0);
        make.left.equalTo(_userIconImageView.mas_right).offset(8);
        make.width.lessThanOrEqualTo(@(180));
    }];
    
    [_distanceIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_locationLabel.mas_right).offset(21);
        make.centerY.equalTo(_locationLabel);
        make.size.mas_equalTo(CGSizeMake(20.0, 15.0));
    }];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_distanceIconImageView);
        make.left.equalTo(_distanceIconImageView.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-15.0);
    }];
}

#pragma mark - getters and setters
- (UILabel *)taskTitleLble {
    if (!_taskTitleLble) {
        _taskTitleLble = [[UILabel alloc] init];
        _taskTitleLble.text = @"推荐通告";
        _taskTitleLble.font = [UIFont boldSystemFontOfSize:15.0];// [UIFont systemFontOfSize:18 weight:(UIFontWeightBold)];;
        _taskTitleLble.textColor = RGBCOLOR(63, 58, 58);
    }
    return _taskTitleLble;
}

- (UILabel *)singupLabel {
    if (!_singupLabel) {
        _singupLabel = [[UILabel alloc] init];
        _singupLabel.font = [UIFont systemFontOfSize:13.0];
        _singupLabel.textColor = RGBCOLOR(153, 153, 153);
        _singupLabel.textAlignment = NSTextAlignmentCenter;
        _singupLabel.userInteractionEnabled = YES;
        
        //设置富文本
        NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:@"查看详情"];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName,
                                       RGBCOLOR(63, 58, 58),NSForegroundColorAttributeName,nil];
        [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
        
        //添加图片
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"invalidName11"];
        attach.bounds = CGRectMake(5, -2, 6, 12);
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeStr1 appendAttributedString:attributeStr2];
        _singupLabel.attributedText = attributeStr1;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signup)];
//        [_singupLabel addGestureRecognizer:tap];
    }
    return _singupLabel;
}

- (UIButton *)signupButton {
    if (!_signupButton) {
        _signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signupButton.backgroundColor = UIColor.clearColor;
        [_signupButton addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signupButton;
}

- (ZZHeadImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[ZZHeadImageView alloc] init];
    }
    return _userIconImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = @"推荐通告";
        _userNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13.0];
        _userNameLabel.textColor = RGBCOLOR(102, 102, 102);
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLabel;
}

- (UILabel *)skillLabel {
    if (!_skillLabel) {
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.text = @"主题：运动";
        _skillLabel.font = CustomFont(12.0);
        _skillLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _skillLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"金额：1200元/2小时";
        _priceLabel.font = CustomFont(12.0);
        _priceLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _priceLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"时间：2019-05-08 16：40";
        _timeLabel.font = CustomFont(12.0);
        _timeLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _timeLabel;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.text = @"地点：厦门市鹭江道89号沙县大…";
        _locationLabel.font = CustomFont(12.0);
        _locationLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _locationLabel;
}

- (UIImageView *)distanceIconImageView {
    if (!_distanceIconImageView) {
        _distanceIconImageView = [[UIImageView alloc] init];
        _distanceIconImageView.image = [UIImage imageNamed:@"icQiangdanXianxiaLocationCopy"];
    }
    return _distanceIconImageView;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = CustomFont(12.0);
        _distanceLabel.text = @"99.99KM";
        _distanceLabel.textColor = RGBCOLOR(102, 102, 102);
        _distanceLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocations)];
        [_distanceLabel addGestureRecognizer:tap];
    }
    return _distanceLabel;
}

@end
