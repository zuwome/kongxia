//
//  ZZHomeUserCell.m
//  zuwome
//
//  Created by angBiu on 16/7/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeUserCell.h"

@interface ZZHomeUserCell ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZHomeUserCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
//        self.layer.shouldRasterize = YES;
//        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 3;
        _bgView.clipsToBounds = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kGrayTextColor;
        _imgView.clipsToBounds = YES;
        [_bgView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(_bgView);
            make.height.equalTo(_bgView.mas_width);
        }];
        
        _wxBgView = [[UIImageView alloc] init];
        _wxBgView.hidden = YES;
        [_bgView addSubview:_wxBgView];
        [_wxBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(_imgView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _statusView = [[ZZHomeStatusView alloc] init];
        _statusView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_statusView];
        [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_imgView.mas_right).offset(-5);
            make.top.mas_equalTo(_imgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(26, 26));
        }];
        
        UIImageView *shadowImgView = [[UIImageView alloc] init];
        shadowImgView.image = [UIImage imageNamed:@"photoShadow"];
        shadowImgView.contentMode = UIViewContentModeScaleToFill;
        [_bgView addSubview:shadowImgView];
        [shadowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_left);
            make.right.mas_equalTo(_imgView.mas_right);
            make.bottom.mas_equalTo(_imgView.mas_bottom);
            make.height.mas_equalTo(@42);
        }];
        
        _vImgView = [[UIImageView alloc] init];
        _vImgView.image = [UIImage imageNamed:@"v"];
        _vImgView.contentMode = UIViewContentModeScaleToFill;
        [_bgView addSubview:_vImgView];
        [_vImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_imgView.mas_bottom).offset(-8);
            make.left.mas_equalTo(_imgView.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        _vLabel = [[UILabel alloc] init];
        _vLabel.textAlignment = NSTextAlignmentLeft;
        _vLabel.textColor = [UIColor whiteColor];
        _vLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_vLabel];
        [_vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_vImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_vImgView.mas_centerY);
            make.right.mas_equalTo(_imgView.mas_right).offset(-10);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackColor;
        _nameLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
//        _nameLabel.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(10);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-20);
            make.height.equalTo(@20);
        }];
        
        _sexImgView = [[UIImageView alloc] init];
        _sexImgView.contentMode = UIViewContentModeLeft;
//        _sexImgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_sexImgView];
        [_sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
//        _levelImgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_levelImgView];
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
            make.leading.greaterThanOrEqualTo(_sexImgView.mas_trailing).offset(5);
        }];
        
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.textAlignment = NSTextAlignmentLeft;
        _skillLabel.textColor = kBrownishGreyColor;
        _skillLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
//        _skillLabel.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_skillLabel];
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.bottom.mas_equalTo(_nameLabel.mas_top).offset(-15);
        }];
        
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = kBrownishGreyColor;
        _moneyLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];
//        _moneyLabel.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_skillLabel.mas_right).offset(5);
            make.right.mas_equalTo(_bgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_skillLabel.mas_centerY);
            make.width.equalTo(@65);
        }];
        
        _skillIntroduce = [[UILabel alloc] init];
        _skillIntroduce.textColor = kBlackColor;
        _skillIntroduce.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightBold)];
        _skillIntroduce.numberOfLines = 3;
        [_bgView addSubview:_skillIntroduce];
        [_skillIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView.mas_bottom).offset(10);
            make.leading.equalTo(@10);
            make.trailing.equalTo(@-10);
            make.bottom.lessThanOrEqualTo(_skillLabel.mas_top).offset(-10);
        }];
    }
    return self;
}

- (void)setModel:(ZZHomeRecommendDetailModel *)model {
    ZZUser *user = model.user;
    //头像
//    if (user.photos && user.photos.count > 0) {
//        ZZPhoto *firstPhoto = [user.photos firstObject];
//        [_imgView sd_setImageWithURL:[firstPhoto.url qiniuURL]];
//    } else {
        [_imgView sd_setImageWithURL:[user.avatar qiniuURL]];
//    }
    //认证标识
    _vImgView.hidden = user.weibo.verified ? NO : YES;
    _vLabel.hidden = user.weibo.verified ? NO : YES;
    _vLabel.text = user.weibo.verified_reason;
    //微信
    _wxBgView.hidden = YES;
    //新人
    [_statusView setUser:user type:1];
    [_statusView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 21));
    }];
    //昵称
    _nameLabel.text = user.nickname;

    CGFloat nameWidth = [ZZUtils widthForCellWithText:user.nickname fontSize:15];
    CGFloat maxWidth = (SCREEN_WIDTH - 5)/2 - 10 - 5 - 15 - 5 - 30 - 10;
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MIN(maxWidth, nameWidth));
    }];
    //性别
    if (user.gender == 2) {
        _sexImgView.image = [UIImage imageNamed:@"girl"];
    } else if (user.gender == 1) {
        _sexImgView.image = [UIImage imageNamed:@"boy"];
    } else {
        _sexImgView.image = [UIImage new];
    }
    //等级
    [_levelImgView setLevel:user.level];
    //技能名称、价格、介绍
    ZZSkill *cheapestSkill = [ZZHomeModel getMostCheapSkill:user.rent.topics];
//    ZZSkill *mostCheapSkill = [ZZHomeModel getMostCheapSkill:user.rent.topics];
    
    NSString *price = cheapestSkill.price;//[ZZHomeModel getMostCheapSkillPrice:user.rent.topics];
    if (cheapestSkill == nil) {
        _skillLabel.text = @"";
        _moneyLabel.text = @"0元/小时";
        _skillIntroduce.text = @"";
        [_skillIntroduce mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView.mas_bottom);
        }];
    } else {
        _skillLabel.text = cheapestSkill.name;
        _moneyLabel.text = [NSString stringWithFormat:@"%@元/小时",price];
        CGFloat priceWidth = [ZZUtils widthForCellWithText:_moneyLabel.text fontSize:15];
        [_moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(priceWidth));
        }];
        _skillIntroduce.text = cheapestSkill.detail.content;
        [_skillIntroduce mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView.mas_bottom).offset(10);
        }];
    }
}

- (void)setupWithIndePath:(NSIndexPath *)indexPath {
    if (![ZZUserHelper shareInstance].isLogin) {
        return;
    }
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        _wxBgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_icNo%ld", indexPath.row + 1]];
        _wxBgView.hidden = NO;
    }
}

- (ZZHomeFirstWxGuide *)firstWxGuideView {
    if (!_firstWxGuideView) {
        CGFloat width = (SCREEN_WIDTH - 15)/2.0;
        _firstWxGuideView = [[ZZHomeFirstWxGuide alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    }
    return _firstWxGuideView;
}

@end
