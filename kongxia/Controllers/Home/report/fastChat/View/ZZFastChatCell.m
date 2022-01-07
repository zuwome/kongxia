//
//  ZZFastChatCell.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/28.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZFastChatCell.h"
#import "ZZLevelImgView.h"
#import "ZZFastChatModel.h"

@interface ZZFastChatCell ()

@property (nonatomic, strong) UIImageView *headerImageView;//头像
@property (nonatomic, strong) UILabel *highPraise;//好评
@property (nonatomic, strong) UILabel *nickName;//昵称
@property (nonatomic, strong) UIImageView *gender;//性别
@property (nonatomic, strong) UIImageView *realName;//实名
@property (nonatomic, strong) ZZLevelImgView *levelImgView;//等级view
@property (nonatomic, strong) UILabel *distance;//距离 和在线时长
//@property (nonatomic, strong) UILabel *onlineTime;//在线时长
@property (nonatomic, strong) UIImageView *vImageView;
@property (nonatomic, strong) UILabel *skillLabel;//标签技能
@property (nonatomic, strong) UIButton *videoButton;//视频

@property (nonatomic, strong) UILabel *vLabel;

@end

@implementation ZZFastChatCell

+ (NSString *)reuseIdentifier {
    return @"ZZFastChatCell";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZFastChatCell);
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        commonInitSafe(ZZFastChatCell);
    }
    return self;
}

commonInitImplementationSafe(ZZFastChatCell) {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    /*头像相关*/
    self.headerImageView = [UIImageView new];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 4.0f;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;

    [self.contentView addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(@10);
        make.bottom.equalTo(@(-10));
        make.width.equalTo(@90);
    }];
    
    // 后台控制，是否需要显示好评数
    if ([ZZUserHelper shareInstance].configModel.qchat.show_comment) {
        
        UIView *highPraiseBgView = [UIView new];
        highPraiseBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.highPraise = [UILabel new];
        self.highPraise.textColor = [UIColor whiteColor];
        self.highPraise.font = [UIFont systemFontOfSize:11];
        
        UIImageView *loveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icSquareEvaluate"]];

        [self.headerImageView addSubview:highPraiseBgView];
        [highPraiseBgView addSubview:self.highPraise];
        [highPraiseBgView addSubview:loveImageView];

        [highPraiseBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(@0);
            make.height.equalTo(@(20));
        }];

        [self.highPraise mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.centerX.equalTo(highPraiseBgView.mas_centerX).offset(10);
        }];
        
        [loveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.highPraise.mas_leading).offset(-3);
            make.centerY.equalTo(self.highPraise.mas_centerY);
            make.width.height.equalTo(@13);
        }];
    }
    
    /* 具体信息 UI */
    self.nickName = [UILabel new];
    self.nickName.textColor = kBlackColor;
    self.nickName.font = [UIFont systemFontOfSize:14];

    // 2 girl 、1 boy 、width 15
    self.gender = [UIImageView new];
    
    // 实名 icon_identifier 19/14
    self.realName = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_identifier"]];
    
    // 等级 28/14
    self.levelImgView = [ZZLevelImgView new];
    
    UIImageView *locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
    
    // 距离
    self.distance = [UILabel new];
    self.distance.textColor = RGBCOLOR(122, 122, 123);
    self.distance.font = [UIFont systemFontOfSize:12];
    
//    // 在线时长
//    self.onlineTime = [UILabel new];
//    self.onlineTime.textColor = kBlackColor;
//    self.onlineTime.font = [UIFont systemFontOfSize:12];
    
    self.vImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v"]];
    
    self.vLabel = [UILabel new];
    self.vLabel.textColor = RGBCOLOR(122, 122, 123);
    self.vLabel.font = [UIFont systemFontOfSize:12];
    
    self.skillLabel = [UILabel new];
    self.skillLabel.textColor = RGBCOLOR(122, 122, 123);
    self.skillLabel.font = [UIFont systemFontOfSize:12];
    self.skillLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.videoButton setBackgroundImage:[UIImage imageNamed:@"icSquareVideo"] forState:UIControlStateNormal];
    [self.videoButton addTarget:self action:@selector(videoConnectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RGBCOLOR(237, 237, 237);
    
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.gender];
    [self.contentView addSubview:self.realName];
    [self.contentView addSubview:self.levelImgView];
    [self.contentView addSubview:locationImageView];
    [self.contentView addSubview:self.distance];
//    [self.contentView addSubview:self.onlineTime];
    [self.contentView addSubview:self.vImageView];
    [self.contentView addSubview:self.vLabel];
    [self.contentView addSubview:self.skillLabel];
    [self.contentView addSubview:self.videoButton];
    [self.contentView addSubview:lineView];
    
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
    
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickName.mas_bottom).offset(15);
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);
        make.width.equalTo(@9);
        make.height.equalTo(@(11));
    }];
    
    [self.distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationImageView.mas_centerY);
        make.leading.equalTo(locationImageView.mas_trailing).offset(3);
        make.right.greaterThanOrEqualTo(self.videoButton.mas_left).offset(-5);
        make.height.equalTo(@15);
    }];
    
//    [self.onlineTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(locationImageView.mas_centerY);
//        make.leading.equalTo(self.distance.mas_trailing).offset(5).priorityHigh();
//        make.height.equalTo(@15);
//    }];
    
    [self.vImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);
        make.width.height.equalTo(@12);
    }];
    
    [self.vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageView.mas_centerY);
        make.leading.equalTo(self.vImageView.mas_trailing).offset(5);
        make.right.offset(-15);
    }];
    
    [self.skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.vImageView.mas_trailing).offset(5);
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@15);
    }];
    
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImageView.mas_centerY);
        make.trailing.equalTo(@0);
        make.width.equalTo(@71);
        make.height.equalTo(@32);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
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

- (void)setupWithModel:(ZZFastChatModel *)model {
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[model.user displayAvatar]] placeholderImage:nil options:(SDWebImageRetryFailed)];
    self.highPraise.text = [NSString stringWithFormat:@"%@好评", [model.user.link_mic_good_comments_count integerValue] > 999 ? @"999+" : model.user.link_mic_good_comments_count];
    
    self.nickName.text = model.user.nickname;
    
    if (model.user.gender == 2) {
        self.gender.image = [UIImage imageNamed:@"girl"];
    } else if (model.user.gender == 1) {
        self.gender.image = [UIImage imageNamed:@"boy"];
    } else {
        self.gender.image = [UIImage new];
    }
    
    if (model.user.realname.status == 2 || model.user.realname_abroad.status == 2) {
        [self.realName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@19);
        }];
    } else {
        
        [self.realName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    [self.levelImgView setLevel:model.user.level];

//    self.distance.text = model.distance;
 
    self.distance.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSString *showTitle= [NSString stringWithFormat:@"%@ %@", model.distance,model.user.lastLoginAtText];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:showTitle];
    NSRange range_LineTime = [showTitle rangeOfString:model.user.lastLoginAtText];

    [attrString addAttribute:NSForegroundColorAttributeName value:kBlackColor range:NSMakeRange(range_LineTime.location, range_LineTime.length)];
    [self.distance setAttributedText:attrString];

    // 是否有 v 认证
    BOOL isVerified = model.user.weibo.verified;
    [self.vImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(isVerified ? 12 : 0));
    }];

    self.vLabel.text = model.user.weibo.verified_reason;
    self.vLabel.hidden = !isVerified;
    [self.skillLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        isVerified ?
        make.leading.equalTo(self.vImageView.mas_trailing).offset(5) :
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);

        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@15);
    }];
    
    // 兴趣爱好
    if (model.user.works_new.count != 0) {
        __block NSString *skillString = @"";
        [model.user.works_new enumerateObjectsUsingBlock:^(ZZUserLabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {//去除第一个空格
                if (!isNullString(obj.alias)) {
                    skillString = [NSString stringWithFormat:@"%@", obj.alias];
                } else {
                    skillString = [NSString stringWithFormat:@"%@", obj.content];
                }
            } else if (idx <= 2) {
                if (!isNullString(obj.alias)) {
                    skillString = [NSString stringWithFormat:@"%@  %@", skillString, obj.alias];
                } else {
                    skillString = [NSString stringWithFormat:@"%@  %@", skillString, obj.content];
                }
            }
        }];
        self.skillLabel.text = skillString;
    } else {
        self.skillLabel.text = @"";
    }
    
    self.skillLabel.hidden = isVerified;

    if (![ZZUserHelper shareInstance].isLogin) {
        self.videoButton.hidden = NO;
    } else {
        self.videoButton.hidden = [model.user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid];
    }
}

- (IBAction)videoConnectClick:(UIButton *)sender {
    BLOCK_SAFE_CALLS(self.fastChatBlock);
}

@end
