//
//  ZZMessageListCellLocationView.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/11.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZMessageListCellLocationView.h"
#import "ZZMessageBoxModel.h"

@interface ZZMessageListCellLocationView ()

@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation ZZMessageListCellLocationView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureUserInfo:(ZZUserInfoModel *)userInfo {
    double distance = -1;
    if (userInfo.loc.count == 2) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[userInfo.loc.lastObject doubleValue] longitude:[userInfo.loc.firstObject doubleValue]];
        distance = [ZZUtils calculateLocation:location toMy:[ZZUserHelper shareInstance].location];
    }
    
    if (distance == -1) {
        _totalWidth = 0.0;
        return;
    }
    
    if (distance >= 50) {
        _locationLabel.text = userInfo.city;
    }
    else {
        _locationLabel.text = [NSString stringWithFormat:@"%.2fkm", distance];
    }
    
    double titleWidth = [NSString findWidthForText:_locationLabel.text
                                       havingWidth:SCREEN_WIDTH
                                           andFont:_locationLabel.font];
    
    if (titleWidth == 0) {
        _totalWidth = 0.0;
    }
    else {
        _totalWidth = 5.0 + titleWidth + 5;
    }
}

- (void)configureUser:(ZZMessageBoxModel *)boxModel {
    double distance = -1;
    if (boxModel.say_hi_total.from.loc.count == 2) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[boxModel.say_hi_total.from.loc.lastObject doubleValue] longitude:[boxModel.say_hi_total.from.loc.firstObject doubleValue]];
        distance = [ZZUtils calculateLocation:location toMy:[ZZUserHelper shareInstance].location];
    }

    if (distance == -1) {
        _totalWidth = 0.0;
        return;
    }

    if (distance >= 50) {
        if (isNullString(boxModel.say_hi_total.from.address.city)) {
            _totalWidth = 0.0;
            return;
        }
        _locationLabel.text = boxModel.say_hi_total.from.rent.city.name;
    }
    else {
        _locationLabel.text = [NSString stringWithFormat:@"%.2fkm", distance];
    }

    double titleWidth = [NSString findWidthForText:_locationLabel.text havingWidth:SCREEN_WIDTH andFont:_locationLabel.font];
    
    if (titleWidth == 0) {
        _totalWidth = 0.0;
    }
    else {
        _totalWidth = 5.0 + titleWidth + 5;
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(246, 246, 246);
    self.layer.cornerRadius = 8.8;
    [self addSubview:self.locationLabel];
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
}

#pragma mark - getters and setters
- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        _locationLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _locationLabel;
}
@end
