//
//  ZZPostFreeDefaultCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/15.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostFreeThemeCell.h"
#import "ZZPostTaskViewModel.h"
#import "ZZSkill.h"
@interface ZZPostFreeThemeCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *line;

@end

@implementation ZZPostFreeThemeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    self.accessoryType = _cellModel.accessoryType;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZZSkill *skill = (ZZSkill *)_cellModel.data;
    if (skill) {
        _titleLabel.text = skill.name;
        [_iconImageView sd_setImageWithURL: [NSURL URLWithString:skill.selected_img]];
    }
    else {
        _titleLabel.text = _cellModel.subTitle;
    }
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.line];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(10.0);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.left.equalTo(_iconImageView.mas_right).offset(4.0);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-15.0);
        make.left.equalTo(self).offset(15.0);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - Getter&Setter
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icYundong"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _line;
}

@end


