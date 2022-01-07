//
//  ZZTopicClassifyCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZTopicClassifyCell.h"
#import "SKTagView.h"

@interface ZZTopicClassifyCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *userBtn;    //点击跳转用户资料
@property (nonatomic, strong) UIButton *skillBtn;   //点击跳转技能详情
@property (nonatomic, strong) UIImageView *userIcon;    //用户头像
@property (nonatomic, strong) UILabel *username;    //用户昵称
@property (nonatomic, strong) UIImageView *sexIcon; //性别
@property (nonatomic, strong) ZZLevelImgView *levelIcon;    //等级
@property (nonatomic, strong) UIImageView *vIcon;   //认证
@property (nonatomic, strong) UILabel *userIntro;   //用户介绍
@property (nonatomic, strong) UILabel *skillIntro;  //技能介绍
@property (nonatomic, strong) UILabel *skillName;   //技能名称
@property (nonatomic, strong) UILabel *skillPrice;  //技能价格
@property (nonatomic, strong) UIImageView *skillIcon;   //技能图片
@property (nonatomic, strong) SKTagView *tagView;

@property (nonatomic, strong) UIImageView *distanceIcon;
@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation ZZTopicClassifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.contentView.backgroundColor = kBGColor;
    [self.contentView addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(7, 7, 0, 7));
    }];
    
    [_bgView addSubview:self.userIcon];
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.leading.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_bgView addSubview:self.username];
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_userIcon.mas_trailing).offset(8);
        make.top.equalTo(@10);
        make.height.equalTo(@25);
    }];
    
    [_bgView addSubview:self.sexIcon];
    [_sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_username.mas_trailing).offset(5);
        make.centerY.equalTo(_username);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [_bgView addSubview:self.levelIcon];
    [_levelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 14));
        make.centerY.equalTo(_username);
        make.leading.equalTo(_sexIcon.mas_trailing).offset(5);
    }];
    
    [_bgView addSubview:self.distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_username);
        make.right.equalTo(_bgView).offset(-10);
    }];
    
    [_bgView addSubview:self.distanceIcon];
    [_distanceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_username);
        make.right.equalTo(_distanceLabel.mas_left).offset(-2);
        make.size.mas_equalTo(CGSizeMake(9, 11.0));
    }];
    
    [_bgView addSubview:self.vIcon];
    [_vIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.leading.equalTo(_username);
        make.top.equalTo(_username.mas_bottom).offset(13);
    }];
    
    [_bgView addSubview:self.userIntro];
    [_userIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_vIcon.mas_trailing).offset(5);
        make.centerY.equalTo(_vIcon);
        make.trailing.equalTo(@-15);
    }];
    
    [_bgView addSubview:self.line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.top.equalTo(_userIcon.mas_bottom).offset(10);
    }];
    
    [_bgView addSubview:self.skillIcon];
    [_skillIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 110));
        make.top.equalTo(_line.mas_bottom).offset(15);
        make.trailing.equalTo(@-10);
    }];
    
    [_bgView addSubview:self.skillIntro];
    [_skillIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(_skillIcon);
        make.trailing.equalTo(_skillIcon.mas_leading).offset(-15);
    }];
    
    [_bgView addSubview:self.skillName];
    [_skillName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_skillIntro);
        make.bottom.equalTo(_skillIcon).offset(-10);
        make.height.equalTo(@20);
    }];
    
    [_bgView addSubview:self.skillPrice];
    [_skillPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_skillName.mas_trailing).offset(15);
        make.height.equalTo(@20);
        make.centerY.equalTo(_skillName);
    }];
    
    [_bgView addSubview:self.userBtn];
    [_userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(_userIcon);
        make.trailing.equalTo(_userIntro);
    }];
    
    [_bgView addSubview:self.skillBtn];
    [_skillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(_skillIcon);
        make.leading.equalTo(_skillName);
    }];
    [_bgView addSubview:self.tagView];
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.skillIcon.mas_bottom).offset(10);
        make.leading.equalTo(@13);
        make.trailing.equalTo(@-13);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.trailing.equalTo(@-10);
    }];
}

- (void)setModel:(ZZUserUnderSkillModel *)model {
    // TODO -- 待接口调整在修改
    _model = model;
    ZZUser *user = model.user;
    [_userIcon sd_setImageWithURL:[[user displayAvatar] qiniuURL]];
//    if (user.photos && user.photos.count > 0) {
//        ZZPhoto *firstPhoto = [user.photos firstObject];
//        [_userIcon sd_setImageWithURL:[firstPhoto.url qiniuURL]];
//    } else {
//        [_userIcon sd_setImageWithURL:[user.avatar qiniuURL]];
//    }
    [_username setText:model.user.nickname];
    [_sexIcon setImage:[UIImage imageNamed:model.user.gender == 1 ? @"boy" : @"girl"]];
    [_levelIcon setLevel:user.level];
    if (!user.weibo.verified) {
        _vIcon.hidden = YES;
        _userIntro.text = user.bio;
        [_vIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        [_userIntro mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_vIcon.mas_trailing);
        }];
    } else {
        _vIcon.hidden = NO;
        _userIntro.text = user.weibo.verified_reason;
        [_vIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@13);
        }];
        [_userIntro mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_vIcon.mas_trailing).offset(5);
        }];
    }
    
    if (model.disNum > 50.0) {
        _distanceLabel.text = model.city;
    }
    else {
        _distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",model.disNum];
    }
    
    //技能名称、价格、介绍
    ZZSkill *skill = model.skill;
    NSString *price = skill.price;
    if (skill == nil) {
        _skillName.text = @"";
        _skillPrice.text = @"0元/小时";
        _skillIntro.text = @"";
    } else {
        _skillName.text = skill.name;
        _skillPrice.text = [NSString stringWithFormat:@"%@元/小时",price];
        _skillIntro.text = skill.detail.content;
    }
    //技能图片
    if ([self getPassPhotos:skill.photo].count > 0) {
        ZZPhoto *photo = [[self getPassPhotos:skill.photo] firstObject];
        [self.skillIcon sd_setImageWithURL:[NSURL URLWithString:photo.url]];
    }
    
    [self.tagView removeAllTags];
    for (ZZSkillTag *tagModel in skill.tags) {
        SKTag *tag = [SKTag tagWithText:tagModel.name];
        tag.textColor = kBlackColor;
        tag.bgColor = UIColor.whiteColor;
        tag.cornerRadius = 2;
        tag.fontSize = 12;
        tag.padding = UIEdgeInsetsMake(5, 7, 5, 7);
        tag.borderColor = kGrayLineColor;
        tag.borderWidth = 1;
        [self.tagView addTag:tag];
    }
    
    [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_skillIcon.mas_bottom).offset(skill.tags.count > 0 ? 10 : 0);
    }];
}

- (NSArray *)getPassPhotos:(NSArray *)photos {
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (ZZPhoto *photo in photos) {
        if (photo.status != 0) {    // 0表示不通过 1 待审核 2审核通过
            [tmpArray addObject:photo];
        }
    }
    return [tmpArray copy];
}

- (void)userBtnClick {
    !self.gotoUserInfo ? : self.gotoUserInfo(self.model.user);
}

- (void)skillBtnClick {
    //TODO -- 待接口修改返回技能
    ZZTopic *topic = [[ZZTopic alloc] init];
    topic.skills = (NSMutableArray<ZZSkill> *)[NSMutableArray arrayWithObject:self.model.skill];
    topic.price = self.model.skill.price;
    !self.gotoSkillDetail ? : self.gotoSkillDetail(self.model.user, topic);
}

- (UIView *)bgView {
    if (nil == _bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)line {
    if (nil == _line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kBGColor;
    }
    return _line;
}

- (UIButton *)userBtn {
    if (nil == _userBtn) {
        _userBtn = [[UIButton alloc] init];
        _userBtn.backgroundColor = [UIColor clearColor];
        [_userBtn addTarget:self action:@selector(userBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _userBtn;
}

- (UIButton *)skillBtn {
    if (nil == _skillBtn) {
        _skillBtn = [[UIButton alloc] init];
        _skillBtn.backgroundColor = [UIColor clearColor];
        [_skillBtn addTarget:self action:@selector(skillBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _skillBtn;
}

- (UIImageView *)userIcon {
    if (nil == _userIcon) {
        _userIcon = [[UIImageView alloc] init];
        _userIcon.layer.cornerRadius = 30;
        _userIcon.clipsToBounds = YES;
    }
    return _userIcon;
}

- (UILabel *)username {
    if (nil == _username) {
        _username = [[UILabel alloc] init];
        _username.textColor = kBlackColor;
        _username.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightBold)];
    }
    return _username;
}

- (UIImageView *)sexIcon {
    if (nil == _sexIcon) {
        _sexIcon = [[UIImageView alloc] init];
    }
    return _sexIcon;
}

- (ZZLevelImgView *)levelIcon {
    if (nil == _levelIcon) {
        _levelIcon = [[ZZLevelImgView alloc] init];
    }
    return _levelIcon;
}

- (UIImageView *)vIcon {
    if (nil == _vIcon) {
        _vIcon = [[UIImageView alloc] init];
        _vIcon.image = [UIImage imageNamed:@"v"];
        _vIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _vIcon;
}

- (UILabel *)userIntro {
    if (nil == _userIntro) {
        _userIntro = [[UILabel alloc] init];
        _userIntro.textColor = kGrayTextColor;
        _userIntro.font = [UIFont systemFontOfSize:14];
    }
    return _userIntro;
}

- (UILabel *)skillIntro {
    if (nil == _skillIntro) {
        _skillIntro = [[UILabel alloc] init];
        _skillIntro.textColor = kBlackColor;
        _skillIntro.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _skillIntro.numberOfLines = 3;
    }
    return _skillIntro;
}

- (UILabel *)skillName {
    if (nil == _skillName) {
        _skillName = [[UILabel alloc] init];
        _skillName.textColor = kBrownishGreyColor;
        _skillName.font = [UIFont systemFontOfSize:15];
    }
    return _skillName;
}

- (UILabel *)skillPrice {
    if (nil == _skillPrice) {
        _skillPrice = [[UILabel alloc] init];
        _skillPrice.textColor = kReddishPink;
        _skillPrice.font = [UIFont systemFontOfSize:15];
    }
    return _skillPrice;
}

- (UIImageView *)skillIcon {
    if (nil == _skillIcon) {
        _skillIcon = [[UIImageView alloc] init];
    }
    return _skillIcon;
}

- (SKTagView *)tagView {
    if (nil == _tagView) {
        _tagView = [[SKTagView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _tagView.lineSpacing = 5;
        _tagView.interitemSpacing = 5;
        _tagView.preferredMaxLayoutWidth = SCREEN_WIDTH - 40;
    }
    return _tagView;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textColor = kBrownishGreyColor;
        _distanceLabel.font = [UIFont systemFontOfSize:12];
    }
    return _distanceLabel;
}

- (UIImageView *)distanceIcon {
    if (!_distanceIcon) {
        _distanceIcon = [[UIImageView alloc] init];
        _distanceIcon.image = [UIImage imageNamed:@"icQiangdanXianxiaLocationCopy2"];
    }
    return _distanceIcon;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
