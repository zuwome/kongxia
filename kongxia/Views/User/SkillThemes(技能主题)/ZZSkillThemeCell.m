//
//  ZZSkillThemeCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillThemeCell.h"

@interface ZZSkillThemeCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic) UIImageView *rightArrow;

@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation ZZSkillThemeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBCOLOR(247, 247, 247);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setCellType:(SkillThemeType)cellType {
    _cellType = cellType;
    [self createView];
}

- (void)createView {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.cellType == SkillThemeTypeAddTheme) {
        [self.contentView addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
    } else {
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@15);
            make.trailing.bottom.equalTo(@-15);
        }];
        
        [self.bgView addSubview:self.skillLabel];
        [self.skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView);
            make.leading.equalTo(self.bgView).offset(15);
            make.height.equalTo(@21);
        }];
        
        [self.bgView addSubview:self.rightArrow];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(7, 13));
            make.centerY.equalTo(self.bgView);
            make.trailing.equalTo(@-15);
        }];
        
        [self.bgView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView);
            make.trailing.equalTo(self.rightArrow.mas_leading).offset(-15);
            make.leading.equalTo(self.skillLabel.mas_trailing).offset(15);
        }];
        
        [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editThemeClick)]];
    }
}

- (void)setTopicModel:(ZZTopic *)topicModel {
    _topicModel = topicModel;
    ZZSkill *skill = topicModel.skills[0];
    [self.skillLabel setText:skill.name];
    [self.priceLabel setText:[NSString stringWithFormat:@"%@元/小时",skill.price]];
}

- (void)addThemeClick {
    !self.addTheme ? : self.addTheme();
}

- (void)editThemeClick {
    !self.editTheme ? : self.editTheme();
}

#pragma mark -- lazy load
- (UIView *)bgView {
    if (nil == _bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.shadowColor = RGBCOLOR(222, 220, 206).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0, 1);
    }
    return _bgView;
}
- (UILabel *)skillLabel {
    if (nil == _skillLabel) {
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.textColor = [UIColor blackColor];
        _skillLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
    }
    return _skillLabel;
}
- (UILabel *)priceLabel {
    if (nil == _priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = RGBCOLOR(224, 69, 57);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
    }
    return _priceLabel;
}
- (UIButton *)addBtn {
    if (nil == _addBtn) {
        _addBtn = [[UIButton alloc] init];
        _addBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        [_addBtn setTitle:@"+添加技能" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)]];
        [_addBtn addTarget:self action:@selector(addThemeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
- (UIImageView *)rightArrow {
    if (nil == _rightArrow) {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_report_right"]];
    }
    return _rightArrow;
}

@end
