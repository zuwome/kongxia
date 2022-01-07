//
//  ZZChatTaskView.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/26.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatTaskView.h"
#import "ZZTasks.h"
#import "ZZDateHelper.h"

@interface ZZChatTaskView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *actionLabel;

@property (nonatomic, strong) UILabel *signupLabel;

@property (nonatomic, strong) UILabel *signupDescLabel;

@property (nonatomic, strong) UILabel *skillLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation ZZChatTaskView

- (instancetype)initWithTaskDic:(NSDictionary *)task {
    self = [super init];
    if (self) {
        _task = task;
        [self layout];
        [self configureData];
    }
    return self;
}

- (void)configureData {
    
    NSString *name = _task[@"pd"][@"skill"][@"name"];
    if ([name isKindOfClass:[NSString class]] && !isNullString(name)) {
        NSString *skillString = [NSString stringWithFormat:@"项目：%@",name];
        _skillLabel.attributedText = [self getAttributedStringWithString:skillString range:[skillString rangeOfString:name]];
    }
    
    NSString *time = _task[@"pd"][@"dated_at"];
    if ([time isKindOfClass:[NSString class]] && !isNullString(time)) {
        NSString *timeDate = [[ZZDateHelper shareInstance] showDateStringWithDateString:time];
        NSString *timeString = [NSString stringWithFormat:@"时间：%@", timeDate];
        _timeLabel.attributedText = [self getAttributedStringWithString:timeString range:[timeString rangeOfString:[NSString stringWithFormat:@"%@",timeDate]]];
    }
    
    NSNumber *totalPrice = _task[@"pd"][@"total_price"];
    NSNumber *hours = _task[@"pd"][@"hours"];
    if (totalPrice && hours) {
        NSString *moneyStr = [NSString stringWithFormat:@"金额：%@小时 共%@元",hours, totalPrice];
        NSRange range = [moneyStr rangeOfString:[NSString stringWithFormat:@"%@元",totalPrice]];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [string addAttribute:NSForegroundColorAttributeName value:kRedTextColor range:range];
        _moneyLabel.attributedText = string;
    }
    
    NSMutableString *address = [_task[@"pd"][@"address"] mutableCopy];
    NSString *city_name = _task[@"pd"][@"city_name"];
    if ([address isKindOfClass:[NSMutableString class]] && !isNullString(address) && [city_name isKindOfClass:[NSString class]] && !isNullString(city_name)) {
        if ([address hasPrefix:_task[@"pd"][@"city_name"]]) {
            NSRange range = [address rangeOfString:_task[@"pd"][@"city_name"]];
            [address deleteCharactersInRange:range];
        }
        
        NSString *adressFull = nil;
        if ([city_name isKindOfClass:[NSString class]] && !isNullString(city_name)) {
            adressFull = [NSString stringWithFormat:@"%@%@",_task[@"pd"][@"city_name"], address];
        }
        else {
            adressFull = address.copy;
        }
        
        NSString *localString = [NSString stringWithFormat:@"地点：%@",adressFull];
        _locationLabel.attributedText = [self getAttributedStringWithString:localString range:[localString rangeOfString:adressFull]];
    }
    
    if ([_task[@"user"] isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        // 用户放
        _actionLabel.hidden = YES;
        _signupLabel.hidden = NO;
        _signupDescLabel.hidden = NO;
    }
    else if ([_task[@"pd_owner"] isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        _actionLabel.hidden = NO;
        _signupLabel.hidden = YES;
        _signupDescLabel.hidden = YES;
    }
    else {
        _actionLabel.hidden = YES;
        _signupLabel.hidden = YES;
        _signupDescLabel.hidden = YES;
    }
}

- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string range:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    if (range.location == NSNotFound) {
        return attributedString;
    }
    [attributedString addAttribute:NSForegroundColorAttributeName value:kGrayContentColor range:range];
    return attributedString;
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.actionLabel];
    
    [_actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(92.5, 28.5));
    }];

    _skillLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:12 text:@""];
    [self addSubview:_skillLabel];
    
    [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(8);
    }];
    
    _timeLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:12 text:@""];
    [self addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_skillLabel.mas_left);
        make.top.mas_equalTo(_skillLabel.mas_bottom).offset(5);
    }];
    
    _locationLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:12 text:@""];
    [self addSubview:_locationLabel];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_skillLabel.mas_left);
        make.right.equalTo(_actionLabel.mas_left).offset(-5);
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(5);
    }];
    
    _moneyLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:12 text:@""];
    [self addSubview:_moneyLabel];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_skillLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(_locationLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
    }];
    
    [self addSubview:self.signupLabel];
    [self addSubview:self.signupDescLabel];
    
    [_signupDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self).offset(5);
    }];
    
    [_signupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerX.equalTo(_signupDescLabel);
        make.bottom.equalTo(_signupDescLabel.mas_top).offset(-5);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        _titleLabel.text = @"TA报名了您发布的邀约";
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
    }
    return _titleLabel;
}

- (UILabel *)signupLabel {
    if (!_signupLabel) {
        _signupLabel = [[UILabel alloc] init];
        _signupLabel.font = CustomFont(12);
        _signupLabel.text = @"已报名";
        _signupLabel.textColor = ColorBlack;
        _signupLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _signupLabel;
}

- (UILabel *)signupDescLabel {
    if (!_signupDescLabel) {
        _signupDescLabel = [[UILabel alloc] init];
        _signupDescLabel.font = CustomFont(12);
        _signupDescLabel.text = @"等待对方确认";
        _signupDescLabel.textColor = kRedTextColor;
        _signupDescLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _signupDescLabel;
}

- (UILabel *)actionLabel {
    if (!_actionLabel) {
        _actionLabel = [[UILabel alloc] init];
        _actionLabel.font = CustomFont(13);
        _actionLabel.text = @"马上选TA";
        _actionLabel.textColor = ColorBlack;
        _actionLabel.backgroundColor = RGBCOLOR(244, 203, 7);
        _actionLabel.textAlignment = NSTextAlignmentCenter;
        _actionLabel.layer.cornerRadius = 2;
        _actionLabel.clipsToBounds = YES;
        
        _actionLabel.hidden = YES;
    }
    return _actionLabel;
}

@end
