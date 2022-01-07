//
//  ZZPostTaskThmemeCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskThmemeCell.h"
#import "ZZPostTaskViewModel.h"
#import "ZZPostTaskCellModel.h"

@interface ZZPostTaskThmemeCell()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation ZZPostTaskThmemeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconImageView.image = [UIImage imageNamed:_cellModel.icon];
    
    ZZSkill *skill = (ZZSkill *)_cellModel.data;
    if (skill) {
        _titleLabel.text = skill.name;
        [_iconImageView sd_setImageWithURL: [NSURL URLWithString:skill.selected_img]];
    }
}

#pragma mark - response method
- (void)action:(UITapGestureRecognizer *)recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(themeCellChooseTags:)]) {
        [self.delegate themeCellChooseTags:self];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(247, 247, 247);
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(30.0, 30.0));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_iconImageView.mas_right).offset(4);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
}

#pragma mark - getters and setters
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"icJutiweizhi"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.0];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);

    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont boldSystemFontOfSize:15];
        _subTitleLabel.textColor = kGoldenRod;
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.text = @"添加标签描述通告信息";
        
        _subTitleLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)];
        [_subTitleLabel addGestureRecognizer:tap];
    }
    return _subTitleLabel;
}

@end
