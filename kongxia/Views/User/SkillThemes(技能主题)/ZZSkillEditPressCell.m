//
//  ZZSkillEditPressCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillEditPressCell.h"

@interface ZZSkillEditPressCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descText;
@property (nonatomic, strong) UIButton *rightBtn;
//audit fail
@property (nonatomic, strong) UIView *failView;
@property (nonatomic, strong) UIImageView *failIcon;
@property (nonatomic, strong) UILabel *failLab;

@end

@implementation ZZSkillEditPressCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellType:(SkillEditCellType)cellType {
    super.cellType = cellType;
    [self createView];
}

- (void)setTopicModel:(ZZTopic *)topicModel {
    super.topicModel = topicModel;
    if (self.cellType == PressCellTypeText) {
        ZZSkill *model = topicModel.skills[0];
        if (!isNullString(model.detail.content)) {
            [self.descText setText:model.detail.content];
            [self.descText setTextColor:kBrownishGreyColor];
        } else {
            [self.descText setText:@"可以介绍你擅长或热爱的领域，或取得的小成就，可以为他人提供哪些帮助？"];
            [self.descText setTextColor:RGBCOLOR(190, 190, 190)];
        }
        
        [_descText mas_updateConstraints:^(MASConstraintMaker *make) {
            if (model.detail.status == 0) { //文字审核不通过
                make.top.equalTo(self.failView.mas_bottom).offset(23);
            } else {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(23);
            }
        }];
        self.failView.hidden = model.detail.status == 0 ? NO : YES;
    }
}

- (void)createView {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(15);
        make.height.equalTo(@20);
    }];
    
    if (self.cellType == PressCellTypeText) {   //文字介绍审核不通过提示
        [self.contentView addSubview:self.failView];
        [self.failView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(23);
            make.leading.equalTo(@15);
            make.trailing.equalTo(@-15);
            make.height.equalTo(@16);
        }];
        [self.failView addSubview:self.failIcon];
        [self.failIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.centerY.equalTo(self.failView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        [self.failView addSubview:self.failLab];
        [self.failLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@0);
            make.centerY.equalTo(self.failView);
            make.leading.equalTo(self.failIcon.mas_trailing).offset(4);
        }];
        self.failView.hidden = YES;
    }
    
    [self.contentView addSubview:self.descText];
    [self.descText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(23).priority(500);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
//        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    [self.contentView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.centerY.equalTo(self.titleLabel);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(10);
    }];
    
    switch (self.cellType) {
        case PressCellTypeText: {
            self.titleLabel.text = @"文字介绍";
            self.descText.text = @"可以介绍你擅长或热爱的领域，或取得的小成就，可以为他人提供哪些帮助？";
            [self.rightBtn setTitle:@"去填写" forState:UIControlStateNormal];
        } break;
        case PressCellTypeImage: {
            self.titleLabel.text = @"技能图片";
            self.descText.text = @"上传与技能相关的高质量照片，让大家更清楚的了解你的技能";
            [self.rightBtn setTitle:@"去上传" forState:UIControlStateNormal];
        } break;
        default: break;
    }
    [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.rightBtn.imageView.size.width - 2, 0, self.rightBtn.imageView.size.width + 2)];
    [self.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.rightBtn.titleLabel.bounds.size.width + 2, 0, -self.rightBtn.titleLabel.bounds.size.width - 2)];
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
        _descText.numberOfLines = 0;
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

- (UIView *)failView {
    if (nil == _failView) {
        _failView = [[UIView alloc] init];
    }
    return _failView;
}

- (UIImageView *)failIcon {
    if (nil == _failIcon) {
        _failIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icWarning"]];
        _failIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _failIcon;
}

- (UILabel *)failLab {
    if (nil == _failLab) {
        _failLab = [[UILabel alloc] init];
        _failLab.text = @"审核失败，请重新编辑！";
        _failLab.textColor = kRedColor;
        _failLab.font = [UIFont systemFontOfSize:11];
    }
    return _failLab;
}

@end
