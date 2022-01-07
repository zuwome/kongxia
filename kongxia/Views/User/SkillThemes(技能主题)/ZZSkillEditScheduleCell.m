//
//  ZZSkillEditScheduleCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillEditScheduleCell.h"
#import "ZZChooseTagCell.h"
#import "SKTagView.h"

@interface ZZSkillEditScheduleCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descText;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) SKTagView *tagView;

@end

@implementation ZZSkillEditScheduleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(15);
        make.height.equalTo(@20);
    }];
    [self.contentView addSubview:self.descText];
    [self.descText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(23);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@25);
    }];
    [self.contentView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.centerY.equalTo(self.titleLabel);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(10);
    }];
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(23);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.height.greaterThanOrEqualTo(@25);
    }];
    
    self.titleLabel.text = @"档期";
    self.descText.text = @"选择你的空闲时间";
    [self.rightBtn setTitle:@"去选择" forState:UIControlStateNormal];
    
    [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.rightBtn.imageView.size.width - 2, 0, self.rightBtn.imageView.size.width + 2)];
    [self.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.rightBtn.titleLabel.bounds.size.width + 2, 0, -self.rightBtn.titleLabel.bounds.size.width - 2)];
}

- (void)setTopicModel:(ZZTopic *)topicModel {
    [super setTopicModel:topicModel];
    ZZSkill *skill = topicModel.skills[0];
    
    [self.tagView removeAllTags];
    
    NSArray *times = !isNullString(skill.time) ? [skill.time componentsSeparatedByString:@","] :@[];
    for (NSString *time in times) {
        SKTag *tag = [SKTag tagWithText:[[ZZSkillThemesHelper shareInstance] scheduleConvertForKey:time]];
        tag.textColor = kBlackColor;
        tag.bgColor = kSunYellow;
        tag.cornerRadius = 2;
        tag.fontSize = 12;
        tag.padding = UIEdgeInsetsMake(5, 8, 5, 8);
        [self.tagView addTag:tag];
    }
    self.tagView.hidden = times.count > 0 ? NO : YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)titleLabel {
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)descText {
    if (nil == _descText) {
        _descText = [[UILabel alloc] init];
        _descText.textColor = RGBCOLOR(190, 190, 190);
        _descText.font = [UIFont systemFontOfSize:15];
    }
    return _descText;
}

- (UIButton *)rightBtn {
    if (nil == _rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _rightBtn.userInteractionEnabled = NO;
        [_rightBtn setTitleColor:RGBCOLOR(190, 190, 190) forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"icon_report_right"] forState:UIControlStateNormal];
    }
    return _rightBtn;
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
