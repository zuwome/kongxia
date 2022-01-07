//
//  ZZAllTopicsCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/10.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZAllTopicsCell.h"

@interface ZZAllTopicsCell ()

@property (nonatomic) UIImageView *icon;
@property (nonatomic) UILabel *name;
@property (nonatomic) UILabel *summary;
@property (nonatomic) UIView *separateLine;
@property (nonatomic) UIImageView *rightArrow;

@end

@implementation ZZAllTopicsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)configureData:(ZZSkill *)skill {
    _name.text = skill.name;
//    _summary.text = catalog.summary;
    [_icon sd_setImageWithURL:[NSURL URLWithString:skill.selected_img]];
    
    if ([skill.catalog isKindOfClass: [NSDictionary class]]) {
        _summary.text = skill.catalog[@"summary"];
    }
}


- (void)createUI {
    _rightArrow = [[UIImageView alloc] init];
    _rightArrow.image = [UIImage imageNamed:@"icon_report_right"];
    [self.contentView addSubview:_rightArrow];
    [_rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(@-15);
        make.size.mas_equalTo(CGSizeMake(7, 13));
    }];
    
    _icon = [[UIImageView alloc] init];
    _icon.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    _name = [[UILabel alloc] init];
    _name.textColor = kBlackColor;
    _name.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
    [self.contentView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_icon.mas_trailing).offset(8);
        make.top.equalTo(_icon);
        make.trailing.equalTo(_rightArrow.mas_leading).offset(-15);
        make.height.equalTo(_icon);
    }];
    
    _separateLine = [[UIView alloc] init];
    _separateLine.backgroundColor = kGoldenRod;
    _separateLine.clipsToBounds = YES;
    _separateLine.layer.cornerRadius = 1;
    [self.contentView addSubview:_separateLine];
    [_separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_icon);
        make.top.equalTo(_icon.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(55, 2));
    }];
    
    _summary = [[UILabel alloc] init];
    _summary.numberOfLines = 0;
    _summary.textColor = kBrownishGreyColor;
    _summary.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_summary];
    [_summary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_icon);
        make.trailing.equalTo(_rightArrow.mas_leading).offset(-15);
        make.top.equalTo(_separateLine.mas_bottom).offset(12);
        make.bottom.equalTo(@-15);
        make.height.greaterThanOrEqualTo(@20);
    }];
}

- (void)setCatalog:(ZZHomeCatalogModel *)catalog {
    _catalog = catalog;
    _name.text = catalog.name;
    _summary.text = catalog.summary;
    [_icon sd_setImageWithURL:[NSURL URLWithString:catalog.indexUrl]];
}

@end
