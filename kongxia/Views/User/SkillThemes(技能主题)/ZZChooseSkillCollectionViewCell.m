//
//  ZZChooseSkillCollectionViewCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChooseSkillCollectionViewCell.h"

@interface ZZChooseSkillCollectionViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *skillIcon;
@property (nonatomic, strong) UILabel *skillTitle;
@property (nonatomic, strong) UILabel *skillSubTitle;

@end

@implementation ZZChooseSkillCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.bgView addSubview:self.skillIcon];
    [self.skillIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(18);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.bgView addSubview:self.skillTitle];
    [self.skillTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.skillIcon.mas_bottom).offset(15);
        make.height.equalTo(@20);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-10);
    }];
    
    [self.bgView addSubview:self.skillSubTitle];
    [self.skillSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView).offset(10);
        make.trailing.equalTo(self.bgView).offset(-10);
        make.top.equalTo(self.skillTitle.mas_bottom).offset(7);
        make.height.equalTo(@28);
    }];
}

- (void)configureData:(ZZSkill *)skill {
    self.skillTitle.text = skill.name;
    [self.skillIcon sd_setImageWithURL:[NSURL URLWithString:skill.selected_img]];
    if ([skill.catalog isKindOfClass: [NSDictionary class]]) {
        self.skillSubTitle.text = skill.catalog[@"summary"];
    }
}

- (void)setTopicData:(ZZTopic *)topicData {
    _topicData = topicData;
    ZZSkill *skillModel = topicData.skills[0];
    if (skillModel) {
        [self.skillIcon sd_setImageWithURL:[NSURL URLWithString:skillModel.url] placeholderImage:[UIImage imageNamed:@"icQingganzixunZhuti"]];
        [self.skillTitle setText:skillModel.name];
        [self.skillSubTitle setText:skillModel.content];
    }
}

- (UIView *)bgView {
    if (nil == _bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.shadowColor = RGBACOLOR(221, 221, 221, 0.5).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0, 0);
        _bgView.layer.shadowOpacity = 1;
    }
    return _bgView;
}

- (UIImageView *)skillIcon {
    if (nil == _skillIcon) {
        _skillIcon = [[UIImageView alloc] init];
        _skillIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _skillIcon;
}

- (UILabel *)skillTitle {
    if (nil == _skillTitle) {
        _skillTitle = [[UILabel alloc] init];
        [_skillTitle setTextColor:RGBCOLOR(63, 58, 58)];
        [_skillTitle setFont:[UIFont systemFontOfSize:13]];
        [_skillTitle setTextAlignment:(NSTextAlignmentCenter)];
    }
    return _skillTitle;
}

- (UILabel *)skillSubTitle {
    if (nil == _skillSubTitle) {
        _skillSubTitle = [[UILabel alloc] init];
        [_skillSubTitle setTextColor:RGBCOLOR(102, 102, 102)];
        [_skillSubTitle setFont:[UIFont systemFontOfSize:11]];
        [_skillSubTitle setTextAlignment:(NSTextAlignmentCenter)];
        [_skillSubTitle setNumberOfLines:2];
    }
    return _skillSubTitle;
}

@end
