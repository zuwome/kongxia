//
//  ZZRecordEditionLocationView.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRecordEditionLocationView.h"
@interface ZZRecordEditionLocationView()
@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *deleteButton;//删除重选
@property (nonatomic, strong) UIImageView *locationImageView;//定位图标
@end
@implementation ZZRecordEditionLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        [self addSubview:self.locationImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.clickButton];
        [self addSubview:self.deleteButton];
        _isNoTop = YES;
        [self settingConstraints];
    }
    
    return self;
}
- (void)btnClick
{
    [MobClick event:Event_click_record_topic_location];
    if (_tapSelf) {
        _tapSelf();
    }
}
- (void)setTitleLabelString:(NSString *)titleLabelString {

    _isNoTop = NO;
    _titleLabelString = titleLabelString;
    self.titleLabel.text = titleLabelString;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-40);
    }];
    self.deleteButton.hidden = NO;
}

/**
 删除按钮
 */
- (void)delegateButtionClick {
    _isNoTop = YES;

    self.deleteButton.hidden = YES;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-5);
    }];
    if (self.delegateButtionCallback) {
        self.delegateButtionCallback();
    }
}


#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"你在哪里?";
    }
    return _titleLabel;
}
- (NSString *)loc_name {
    if (!self.isNoTop) {
        return _titleLabel.text;
    }
    return nil;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.alpha = 0.19;
        _bgView.layer.cornerRadius = 3;
    }
    return _bgView;
    
}
- (UIButton *)clickButton {
    if (!_clickButton) {
        _clickButton = [[UIButton alloc] init];
        
        [_clickButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(delegateButtionClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"icVideoEditHuatiDelete"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView  = [[UIImageView alloc]init];
        _locationImageView.image = [UIImage imageNamed:@"icVideoEditLocation"];
    }
    return _locationImageView;
}
#pragma mark - 设置约束

- (void)settingConstraints {
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.mas_width);
        make.centerX.mas_equalTo(self);
        make.top.bottom.offset(0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bgView.mas_centerY);
        make.left.mas_equalTo(self.locationImageView.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bgView.mas_centerY);
        make.left.mas_equalTo(self.bgView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabel.mas_right);
        make.left.offset(0);
        make.top.bottom.offset(0);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}


@end
