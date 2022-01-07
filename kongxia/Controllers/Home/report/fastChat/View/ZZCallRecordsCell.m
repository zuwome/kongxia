//
//  ZZCallRecordsCell.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZCallRecordsCell.h"
#import "ZZCallRecordsModel.h"

@interface ZZCallRecordsCell ()

@property (nonatomic, strong) UIImageView *headerImageView;//头像
@property (nonatomic, strong) UILabel *nickName;//昵称
@property (nonatomic, strong) UIImageView *gender;//性别
@property (nonatomic, strong) UIImageView *realName;//实名
@property (nonatomic, strong) ZZLevelImgView *levelImgView;//等级view
@property (nonatomic, strong) UIImageView *vImageView;
@property (nonatomic, strong) UILabel *skillLabel;//标签技能
@property (nonatomic, strong) UILabel *statusLabel;//状态 未接听或本次通话1小时等等
@property (nonatomic, strong) UILabel *fromTimeLabel;//距离时长

@property (nonatomic, strong) UILabel *vLabel;

@end

@implementation ZZCallRecordsCell

+ (NSString *)reuseIdentifier {
    return @"ZZCallRecordsCell";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZCallRecordsCell);
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        commonInitSafe(ZZCallRecordsCell);
    }
    return self;
}

commonInitImplementationSafe(ZZCallRecordsCell) {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.headerImageView = [UIImageView new];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 4.0f;

    self.nickName = [UILabel new];
    self.nickName.textColor = kBlackColor;
    self.nickName.font = [UIFont systemFontOfSize:14];

    // 2 girl 、1 boy 、width 15
    self.gender = [UIImageView new];
    
    // 实名 icon_identifier 19/14
    self.realName = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_identifier"]];
    
    // 等级 28/14
    self.levelImgView = [ZZLevelImgView new];

    self.vImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v"]];
    
    self.vLabel = [UILabel new];
    self.vLabel.textColor = RGBCOLOR(122, 122, 123);
    self.vLabel.font = [UIFont systemFontOfSize:12];
    
    self.skillLabel = [UILabel new];
    self.skillLabel.textColor = RGBCOLOR(122, 122, 123);
    self.skillLabel.font = [UIFont systemFontOfSize:12];
    self.skillLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    self.statusLabel = [UILabel new];
    self.statusLabel.textColor = kBlackColor;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    
    self.fromTimeLabel = [UILabel new];
    self.fromTimeLabel.textAlignment = NSTextAlignmentRight;
    self.fromTimeLabel.font = [UIFont systemFontOfSize:12];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RGBCOLOR(237, 237, 237);

    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.gender];
    [self.contentView addSubview:self.realName];
    [self.contentView addSubview:self.levelImgView];
    [self.contentView addSubview:self.vImageView];
    [self.contentView addSubview:self.vLabel];
    [self.contentView addSubview:self.skillLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.fromTimeLabel];
    [self.contentView addSubview:lineView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(@10);
        make.bottom.equalTo(@(-10));
        make.width.equalTo(@90);
    }];

    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_top);
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);
        make.height.equalTo(@16);
    }];
    
    [self.gender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickName.mas_centerY);
        make.leading.equalTo(self.nickName.mas_trailing).offset(5);
        make.width.height.equalTo(@15);
    }];
    
    [self.realName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickName.mas_centerY);
        make.leading.equalTo(self.gender.mas_trailing).offset(5);
        make.width.equalTo(@19);
        make.height.equalTo(@14);
    }];
    
    [self.levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickName.mas_centerY);
        make.leading.equalTo(self.realName.mas_trailing).offset(5);
        make.trailing.lessThanOrEqualTo(@(-10));
        make.width.equalTo(@28);
        make.height.equalTo(@14);
    }];

    [self.vImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickName.mas_bottom).offset(10);
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);
        make.width.height.equalTo(@12);
    }];
    
    [self.vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageView.mas_centerY);
        make.leading.equalTo(self.vImageView.mas_trailing).offset(5);
    }];
    
    [self.skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.vImageView.mas_trailing).offset(5);
        make.centerY.equalTo(self.vImageView.mas_centerY);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@15);
    }];

    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.trailing.equalTo(self.fromTimeLabel.mas_leading).offset(-15);
        make.height.equalTo(@15);
    }];
    
    [self.fromTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@15);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@0.5);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Private methods

- (void)setupWithModel:(ZZCallRecordsModel *)model {
    
    ZZUser *showUser;
    if ([model.room.admin.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        showUser = model.room.user;
    } else {
        showUser = model.room.admin;
    }
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:showUser.avatar] placeholderImage:nil options:(SDWebImageRetryFailed)];
    self.nickName.text = showUser.nickname;

    if (showUser.gender == 2) {
        self.gender.image = [UIImage imageNamed:@"gril"];
    } else if (model.room.user.gender == 1) {
        self.gender.image = [UIImage imageNamed:@"boy"];
    } else {
        self.gender.image = [UIImage new];
    }
    
    if (showUser.realname.status == 2 || showUser.realname_abroad.status == 2) {
        [self.realName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@19);
        }];
    } else {
        [self.realName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    
    [self.levelImgView setLevel:showUser.level];

    // 是否有 v 认证
    BOOL isVerified = showUser.weibo.verified;
    [self.vImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(isVerified ? 12 : 0));
    }];
    
    [self.skillLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        isVerified ?
        make.leading.equalTo(self.vImageView.mas_trailing).offset(5) :
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);
        
        make.centerY.equalTo(self.vImageView.mas_centerY);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@15);
    }];

//    if (showUser.rent.topics.count) {
//
//        ZZTopic *topic = showUser.rent.topics[0];
//        __block NSString *skillString = @"";
//        [topic.skills enumerateObjectsUsingBlock:^(ZZSkill * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            skillString = [NSString stringWithFormat:@"%@ %@", skillString, obj.name];
//        }];
//        self.skillLabel.text = skillString;
//    }
    
    if (showUser.tags_new.count != 0) {
        
        __block NSString *skillString = @"";
        [showUser.tags_new enumerateObjectsUsingBlock:^(ZZUserLabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {//去除第一个空格
                skillString = obj.content;
            } else {
                skillString = [NSString stringWithFormat:@"%@  %@", skillString, obj.content];
            }
        }];
        self.skillLabel.text = skillString;
    }

    self.vLabel.hidden = !isVerified;
    self.vLabel.text = showUser.weibo.verified_reason;
    self.skillLabel.hidden = isVerified;
    
    self.statusLabel.text = model.room.time_text;
    if ([model.room.time_text isEqualToString:@"未接听"]) {
        self.statusLabel.textColor = RGBCOLOR(230, 49, 56);
    } else {
        self.statusLabel.textColor = kBlackColor;
    }
    self.fromTimeLabel.text = model.room.created_at_text;
}

@end
