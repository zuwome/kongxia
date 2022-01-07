//
//  ZZSkillDetailScheduleCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillDetailScheduleCell.h"

@interface ZZSkillDetailScheduleCell ()

@property (nonatomic, strong) UILabel *scheduleLab;

@end

@implementation ZZSkillDetailScheduleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.scheduleLab];
    [self.scheduleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-15);
        make.top.leading.equalTo(@15);
        make.height.equalTo(@20);
    }];
}

- (void)setTopicModel:(ZZTopic *)topicModel {
    ZZSkill *skill = topicModel.skills[0];
    NSMutableArray *time = [NSMutableArray array];
    NSArray *schedule = [skill.time componentsSeparatedByString:@","];
    for (NSString *key in schedule) {
        if ([key integerValue] < 4) {
            [time addObject:[[ZZSkillThemesHelper shareInstance] scheduleConvertForKey:key]];
        }
    }
    self.scheduleLab.text = [time componentsJoinedByString:@"、"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UILabel *)scheduleLab {
    if (nil == _scheduleLab) {
        _scheduleLab = [[UILabel alloc] init];
        _scheduleLab.textColor = kBlackColor;
        _scheduleLab.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
    }
    return _scheduleLab;
}

@end
