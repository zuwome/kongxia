//
//  ZZKTVSingingTaskSingedUserHeaderView.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/3.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVSingingTaskSingedUserHeaderView.h"

@interface ZZKTVSingingTaskSingedUserHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation ZZKTVSingingTaskSingedUserHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    _titleLabel.text = [NSString stringWithFormat:@"共%ld个%@", _taskModel.gift_count, _taskModel.gift.name];
    _subTitleLabel.text = [NSString stringWithFormat:@"已领取%ld/%ld个", (_taskModel.gift_count - _taskModel.gift_last_count), _taskModel.gift_count];
}


#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(245, 245, 245);
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15.0);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_titleLabel.mas_right).offset(15.0);
    }];
}


#pragma mark - getters and setters
- (void)setTaskModel:(ZZKTVModel *)taskModel {
    _taskModel = taskModel;
    [self configureData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"共16个抱抱熊";
        _titleLabel.font = ADaptedFontMediumSize(14);
        _titleLabel.textColor = RGBCOLOR(102, 102, 102);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"已领取 2/16个";
        _subTitleLabel.font = ADaptedFontMediumSize(14);
        _subTitleLabel.textColor = RGBCOLOR(153, 153, 153);
    }
    return _subTitleLabel;
}

@end
