//
//  ZZSkillDetailPriceCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillDetailPriceCell.h"
#import "SKTagView.h"

@interface ZZSkillDetailPriceCell ()

@property (nonatomic, strong) UILabel *skillLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) SKTagView *tagView;

@end

@implementation ZZSkillDetailPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.priceLab];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(@-15);
        make.height.equalTo(@22);
        make.width.greaterThanOrEqualTo(@90);
    }];
    
    [self.contentView addSubview:self.skillLab];
    [self.skillLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLab);
        make.leading.equalTo(@15);
        make.height.equalTo(@22);
        make.trailing.equalTo(self.priceLab.mas_leading).offset(-15);
    }];
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.skillLab.mas_bottom).offset(10);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@-15);
    }];
}

- (void)setTopicModel:(ZZTopic *)topicModel {
    ZZSkill *skill = topicModel.skills[0];
    self.skillLab.text = skill.name;
    self.priceLab.text = [NSString stringWithFormat:@"%@元/小时",topicModel.price];

    [self.tagView removeAllTags];
    for (ZZSkillTag *tagModel in skill.tags) {
        SKTag *tag = [SKTag tagWithText:tagModel.name];
        tag.textColor = kBlackColor;
        tag.bgColor = kSunYellow;
        tag.cornerRadius = 2;
        tag.fontSize = 12;
        tag.padding = UIEdgeInsetsMake(5, 8, 5, 8);
        [self.tagView addTag:tag];
    }
    
    [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.skillLab.mas_bottom).offset(skill.tags.count > 0 ? 10 : 0);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)skillLab {
    if (nil == _skillLab) {
        _skillLab = [[UILabel alloc] init];
        _skillLab.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
        _skillLab.textColor = kBlackColor;
    }
    return _skillLab;
}
- (UILabel *)priceLab {
    if (nil == _priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightBold)];
        _priceLab.textColor = kGoldenRod;
        _priceLab.textAlignment = NSTextAlignmentRight;
    }
    return _priceLab;
}
- (SKTagView *)tagView {
    if (nil == _tagView) {
        _tagView = [[SKTagView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _tagView.lineSpacing = 5;
        _tagView.interitemSpacing = 5;
        _tagView.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
    }
    return _tagView;
}

@end
