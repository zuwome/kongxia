//
//  ZZMyCommissionViews.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZMyCommissionViews.h"
#import "ZZCommissionListModel.h"

@interface MyCommissionHeaderView ()<CommissionHeaderViewDelegate>

@property (nonatomic, strong) CommissionHeaderView *todayIncomView;

@property (nonatomic, strong) CommissionTotalInComeView *totalIncomView;

@end

@implementation MyCommissionHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - public Method
- (void)configureIcomes:(ZZCommissionListModel *)model {
    [_totalIncomView configureIcomes:model];
    [_todayIncomView configureIcomes:model];
}

#pragma mark - CommissionHeaderViewDelegate
- (void)header:(CommissionHeaderView *)header enablePush:(BOOL)enablePush {
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:enablePush:)]) {
        [self.delegate header:self enablePush:enablePush];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    
    [self addSubview:self.totalIncomView];
    [self addSubview:self.todayIncomView];
    
    [_todayIncomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@44);
    }];
    
    [_totalIncomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_todayIncomView.mas_bottom);
        make.height.equalTo(@101);
    }];
}

#pragma mark - getters and setters
- (CommissionHeaderView *)todayIncomView {
    if (!_todayIncomView) {
        _todayIncomView = [[CommissionHeaderView alloc] init];
        _todayIncomView.delegate = self;
    }
    return _todayIncomView;
}

- (CommissionTotalInComeView *)totalIncomView {
    if (!_totalIncomView) {
        _totalIncomView = [[CommissionTotalInComeView alloc] init];
    }
    return _totalIncomView;
}


@end



#pragma mark - CommissionHeaderView
@interface CommissionHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UISwitch *notificationSwitch;

@end

@implementation CommissionHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureIcomes:(ZZCommissionListModel *)model {
    _subTitleLabel.text = @"分红通知";
    
    NSArray *today = model.todayData;
    if ([today isKindOfClass: [NSArray class]] && today.count > 0) {
        NSDictionary *todayDic = (NSDictionary *)today.firstObject;
        if ([todayDic isKindOfClass: [NSDictionary class]]) {
            _titleLabel.text = [NSString stringWithFormat:@"今日分红¥%.2f", todayDic[@"total_money"] ? [todayDic[@"total_money"] doubleValue] : 0];
        }
    }
    
    _notificationSwitch.on = (model.invite_push == 0);
}

#pragma mark - response method
- (void)enablePush:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:enablePush:)]) {
        [self.delegate header:self enablePush:sender.isOn];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.notificationSwitch];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    
    [_notificationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_notificationSwitch.mas_left).offset(-8);
    }];
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _titleLabel.text = @"今日分红¥0";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = RGBCOLOR(102, 102, 102);
        _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _subTitleLabel.text = @"分红通知";
    }
    return _subTitleLabel;
}

- (UISwitch *)notificationSwitch {
    if (!_notificationSwitch) {
        _notificationSwitch = [[UISwitch alloc] init];
        _notificationSwitch.onTintColor = kYellowColor;
        
        [_notificationSwitch addTarget:self action:@selector(enablePush:) forControlEvents:UIControlEventValueChanged];
    }
    return _notificationSwitch;
}

@end


#pragma mark - CommissionTotalInComeView
@interface  CommissionTotalInComeView ()

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation CommissionTotalInComeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureIcomes:(ZZCommissionListModel *)model {
    NSArray *all = model.allData;
    if ([all isKindOfClass: [NSArray class]] && all.count > 0) {
        NSDictionary *totalDic = (NSDictionary *)all.firstObject;
        if ([totalDic isKindOfClass: [NSDictionary class]]) {
            _subTitleLabel.text = [NSString stringWithFormat:@"¥%.2f", totalDic[@"total_money"] ? [totalDic[@"total_money"] doubleValue] : 0];
        }
    }
}

#pragma mark Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.iconImageView];

    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.left.equalTo(_iconImageView.mas_right).offset(8);
    }];
    
}

#pragma mark getters and setters
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _subTitleLabel.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-M" size:40];
        _subTitleLabel.text = @"¥0";
    }
    return _subTitleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icHhrfh"];
    }
    return _iconImageView;
}

@end


#pragma mark - CommissionScrollHeaderView
@interface CommissionScrollHeaderView ()

@property (nonatomic, strong) UILabel *incomedLabel;

@property (nonatomic, strong) UILabel *incomeDetailLabel;

@property (nonatomic, strong) UILabel *invitedLabel;

@property (nonatomic, strong) UIView *navigatorBar;

@end

@implementation CommissionScrollHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark public Method
- (void)offetSet:(CGFloat)offsetX {
    CGFloat currentOffset = 0.0;
    CGFloat gap = _invitedLabel.center.x - _incomedLabel.center.x;
    if (offsetX >= 0 && offsetX <= SCREEN_WIDTH) {
        gap = _incomeDetailLabel.center.x - _incomedLabel.center.x ;
        currentOffset = (gap / SCREEN_WIDTH) * offsetX;
    }
    else {
        gap = _invitedLabel.center.x - _incomeDetailLabel.center.x ;
        currentOffset = (gap / SCREEN_WIDTH) * (offsetX - SCREEN_WIDTH) + (_incomeDetailLabel.center.x - _incomedLabel.center.x);
    }

    [_navigatorBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_incomedLabel).offset(currentOffset);
    }];
    
    if (offsetX == 0) {
        _incomedLabel.font = [UIFont boldSystemFontOfSize:15];
        
        _incomeDetailLabel.font = [UIFont systemFontOfSize:15.0];
        _invitedLabel.font = [UIFont systemFontOfSize:15.0];
    }
    else if (offsetX == SCREEN_WIDTH) {
        _incomeDetailLabel.font = [UIFont boldSystemFontOfSize:15];
        
        _incomedLabel.font = [UIFont systemFontOfSize:15.0];
        _invitedLabel.font = [UIFont systemFontOfSize:15.0];
    }
    else if (offsetX == SCREEN_WIDTH * 2) {
        _invitedLabel.font = [UIFont boldSystemFontOfSize:15];
        
        _incomedLabel.font = [UIFont systemFontOfSize:15.0];
        _incomeDetailLabel.font = [UIFont systemFontOfSize:15.0];
    }
}

#pragma mark response method
- (void)select:(UITapGestureRecognizer *)recoginzier {
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:select:)]) {
        [self.delegate header:self select:recoginzier.view.tag];
    }
}

#pragma mark Layout
- (void)layout {
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.incomedLabel];
    [self addSubview:self.incomeDetailLabel];
    [self addSubview:self.invitedLabel];
    [self addSubview:self.navigatorBar];
    
    [_incomedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15.0);
    }];
    
    [_incomeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_incomedLabel.mas_right).offset(32.0);
    }];
    
    [_invitedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_incomeDetailLabel.mas_right).offset(32.0);
    }];
    
    [_navigatorBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_incomedLabel);
        make.top.equalTo(_incomedLabel.mas_bottom).offset(1);
        make.width.equalTo(@(20));
        make.height.equalTo(@3.0);
    }];
}

#pragma mark getters and setters
- (UIView *)navigatorBar {
    if (!_navigatorBar) {
        _navigatorBar = [[UIView alloc] init];
        _navigatorBar.backgroundColor = kGoldenRod;
        _navigatorBar.layer.cornerRadius = 1.5;
    }
    return _navigatorBar;
}

- (UILabel *)incomedLabel {
    if (!_incomedLabel) {
        _incomedLabel = [[UILabel alloc] init];
        _incomedLabel.textColor = RGBCOLOR(102, 102, 102);
        _incomedLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _incomedLabel.text = @"已入账";
        _incomedLabel.textAlignment = NSTextAlignmentCenter;
        _incomedLabel.tag = 0;
        _incomedLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_incomedLabel addGestureRecognizer:tap];
    }
    return _incomedLabel;
}

- (UILabel *)incomeDetailLabel {
    if (!_incomeDetailLabel) {
        _incomeDetailLabel = [[UILabel alloc] init];
        _incomeDetailLabel.textColor = RGBCOLOR(102, 102, 102);
        _incomeDetailLabel.font = [UIFont systemFontOfSize:15.0];
        _incomeDetailLabel.text = @"分红详情";
        _incomeDetailLabel.textAlignment = NSTextAlignmentCenter;
        _incomeDetailLabel.tag = 1;
        _incomeDetailLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_incomeDetailLabel addGestureRecognizer:tap];
    }
    return _incomeDetailLabel;
}

- (UILabel *)invitedLabel {
    if (!_invitedLabel) {
        _invitedLabel = [[UILabel alloc] init];
        _invitedLabel.textColor = RGBCOLOR(102, 102, 102);
        _invitedLabel.font = [UIFont systemFontOfSize:15.0];
        _invitedLabel.text = @"已邀请成功";
        _invitedLabel.textAlignment = NSTextAlignmentCenter;
        _invitedLabel.tag = 2;
        _invitedLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_invitedLabel addGestureRecognizer:tap];
    }
    return _invitedLabel;
}
@end
