//
//  ZZRentOrderLocationCell.m
//  zuwome
//
//  Created by angBiu on 16/6/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentOrderLocationCell.h"
#import "ZZOrder.h"
#import "ZZTasks.h"

@interface ZZRentOrderLocationCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *locationImgView;

@property (nonatomic, strong) UITextField *locationTF;

@property (nonatomic, strong) UIButton *downBtn;

@property (nonatomic, strong) UIView *seperateLine;

@end

@implementation ZZRentOrderLocationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - response method
- (void)downBtnClick {
    _downBtn.selected = !_downBtn.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellShowRecommendLocation:)]) {
        [self.delegate cellShowRecommendLocation:self];
    }
}

- (void)locationBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellShowMap:)]) {
        [self.delegate cellShowMap:self];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.locationImgView];
    [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(40);
    }];
    
    [self.contentView addSubview:self.downBtn];
    [_downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(50);
    }];
    
    [self.contentView addSubview:self.locationTF];
    [_locationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_locationImgView.mas_right);
        make.right.mas_equalTo(_downBtn.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.contentView addSubview:self.seperateLine];
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(0.5));
    }];
    
    UIButton *locationBtn = [[UIButton alloc] init];
    [locationBtn addTarget:self action:@selector(locationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:locationBtn];
    
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(_locationTF.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark - getters and setters
- (void)setOrder:(ZZOrder *)order {
    _titleLabel.text = order.city.name;
    if (order.address) {
        _locationTF.text = order.address;
    }
    _downBtn.hidden = NO;
    CGFloat width = [NSString findWidthForText:order.city.name havingWidth:SCREEN_WIDTH andFont:self.titleLabel.font];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

- (void)setTask:(ZZTaskModel *)task {
    _task = task;
    _titleLabel.text = task.task.city_name;
    _locationTF.text = task.task.address;
    _downBtn.hidden = YES;
    CGFloat width = [NSString findWidthForText:task.task.city_name havingWidth:SCREEN_WIDTH andFont:self.titleLabel.font];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    _locationTF.textAlignment = NSTextAlignmentRight;
    [_locationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_locationImgView.mas_right);
        make.right.mas_equalTo(self).offset(-15.0);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    }
    return _titleLabel;
}

- (UIImageView *)locationImgView {
    if (!_locationImgView) {
        _locationImgView = [[UIImageView alloc] init];
        _locationImgView.contentMode = UIViewContentModeCenter;
        _locationImgView.image = [UIImage imageNamed:@"rentDiDian"];
    }
    return _locationImgView;
}

- (UIButton *)downBtn {
    if (!_downBtn) {
        _downBtn = [[UIButton alloc] init];
        _downBtn.normalImage = [UIImage imageNamed:@"btn_rent_dropdown_black"];
        _downBtn.selectedImage = [UIImage imageNamed:@"btn_rent_dropUp_black"];
        [_downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downBtn;
}

- (UITextField *)locationTF {
    if (!_locationTF) {
        _locationTF = [[UITextField alloc] init];
        _locationTF.textColor = kBlackTextColor;
        _locationTF.textAlignment = NSTextAlignmentLeft;
        _locationTF.font = [UIFont systemFontOfSize:15];
        _locationTF.placeholder = @"请选择公众场合";
        _locationTF.delegate = self;
    }
    return _locationTF;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _seperateLine;
}

@end
