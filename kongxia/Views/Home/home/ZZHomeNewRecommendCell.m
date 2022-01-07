//
//  ZZHomeNewRecommendCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/7/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZHomeNewRecommendCell.h"
#import "ZZSkill.h"
@interface ZZHomeNewRecommendCell ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation ZZHomeNewRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.userInteractionEnabled = YES;
        self.backgroundColor = RGBCOLOR(245, 245, 245);
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 3;
        _bgView.clipsToBounds = YES;
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10.0);
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(10.0);
            make.right.equalTo(self).offset(-10.0);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kGrayTextColor;
        _imgView.clipsToBounds = YES;
        _imgView.userInteractionEnabled = YES;
        [_bgView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_bgView);
            make.width.equalTo(@125);
        }];
        
        _statusView = [[ZZHomeStatusView alloc] init];
        _statusView.backgroundColor = [UIColor clearColor];
        _statusView.userInteractionEnabled = YES;
        [_bgView addSubview:_statusView];
        [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_left).offset(5);
            make.top.mas_equalTo(_imgView.mas_top).offset(5);
            make.size.mas_equalTo(CGSizeMake(27, 16));
        }];
        
        UIImageView *shadowImgView = [[UIImageView alloc] init];
        shadowImgView.image = [UIImage imageNamed:@"photoShadow"];
        shadowImgView.contentMode = UIViewContentModeScaleToFill;
        shadowImgView.userInteractionEnabled = YES;
        [_bgView addSubview:shadowImgView];
        [shadowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_imgView);
            make.height.mas_equalTo(@42);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.userInteractionEnabled = YES;
        [_bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(5);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-6.5);
            make.width.lessThanOrEqualTo(@64);
        }];
        
        _sexImgView = [[UIImageView alloc] init];
        _sexImgView.contentMode = UIViewContentModeLeft;
        _sexImgView.userInteractionEnabled = YES;
        [_bgView addSubview:_sexImgView];
        [_sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        _levelImgView.userInteractionEnabled = YES;
        [_bgView addSubview:_levelImgView];
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(26, 13));
        }];
        
        _skillIntroduce = [[UILabel alloc] init];
        _skillIntroduce.textColor = kBlackColor;
        _skillIntroduce.userInteractionEnabled = YES;
        _skillIntroduce.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _skillIntroduce.numberOfLines = 3;
        [_bgView addSubview:_skillIntroduce];
        [_skillIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgView.mas_right).offset(10);
            make.top.equalTo(_bgView).offset(10.0);
            make.right.equalTo(_bgView).offset(-10);
            make.height.lessThanOrEqualTo(@55);
        }];
        
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.userInteractionEnabled = YES;
        _skillLabel.textAlignment = NSTextAlignmentLeft;
        _skillLabel.textColor = kBrownishGreyColor;
        _skillLabel.font = [UIFont systemFontOfSize:13];;
        [_bgView addSubview:_skillLabel];
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(145);
            make.bottom.mas_equalTo(_bgView).offset(-10);
        }];

        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.userInteractionEnabled = YES;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = kBrownishGreyColor;
        _moneyLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightMedium)];

        [_bgView addSubview:_moneyLabel];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgView.mas_right).offset(-10);
            make.bottom.mas_equalTo(_bgView).offset(-10);
        }];

        _vImgView = [[UIImageView alloc] init];
        _vImgView.userInteractionEnabled = YES;
        _vImgView.image = [UIImage imageNamed:@"v"];
        _vImgView.contentMode = UIViewContentModeScaleToFill;
        [_bgView addSubview:_vImgView];
        [_vImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_skillLabel.mas_top).offset(-6);
            make.left.mas_equalTo(_skillLabel);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];

        _vLabel = [[UILabel alloc] init];
        _vLabel.userInteractionEnabled = YES;
        _vLabel.textAlignment = NSTextAlignmentLeft;
        _vLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_vLabel];
        [_vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_vImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_vImgView.mas_centerY);
            make.right.mas_equalTo(_bgView.mas_right).offset(-10);
        }];

    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taps:)];
    [self.contentView addGestureRecognizer:tap];
    return self;
}

- (void)taps:(UITapGestureRecognizer *)recoginzier {
    if (_delegate && [_delegate respondsToSelector:@selector(cellTapped:model:)]){
        [_delegate cellTapped:self model:_model];
    }
}

- (void)setModel:(ZZHomeRecommendDetailModel *)model {
    _model = model;
    ZZUser *user = model.user;
    
    //头像
    [_imgView sd_setImageWithURL:[user.avatar qiniuURL]];
    
    //认证标识
    _vImgView.hidden = user.weibo.verified ? NO : YES;
    _vLabel.hidden = user.weibo.verified ? NO : YES;
    _vLabel.text = user.weibo.verified_reason;
    
    //微信
    _wxBgView.hidden = YES;
    
    //新人
    [_statusView setUser:user type:3];
    
    //昵称
    _nameLabel.text = user.nickname;
    
    //性别
    if (user.gender == 2) {
        _sexImgView.image = [UIImage imageNamed:@"girl"];
    }
    else if (user.gender == 1) {
        _sexImgView.image = [UIImage imageNamed:@"boy"];
    }
    else {
        _sexImgView.image = [UIImage new];
    }
    
    //等级
    [_levelImgView setLevel:user.level];
    
    // 技能名称、价格、介绍
    ZZSkill *cheapestSkill = [ZZHomeModel getMostCheapSkill:user.rent.topics];
    NSString *price = cheapestSkill.price;//[ZZHomeModel getMostCheapSkillPrice:user.rent.topics];
    if (cheapestSkill == nil) {
        _skillLabel.text = @" ";
        _moneyLabel.text = @"0元/小时";
        _skillIntroduce.text = @" ";
    }
    else {
        _skillLabel.text = cheapestSkill.name;
        _moneyLabel.text = [NSString stringWithFormat:@"%@元/小时",price];
        
        _skillIntroduce.text = nil;
        if (isNullString(cheapestSkill.detail.content)) {
            if (cheapestSkill.tags.count != 0) {
                NSMutableString *tagsStr = [[NSMutableString alloc] init];
                [cheapestSkill.tags enumerateObjectsUsingBlock:^(ZZSkillTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tagsStr appendString:[NSString stringWithFormat:@"#%@ ", obj.tagname]];
                }];
                
                _skillIntroduce.text = tagsStr.copy;
            }
        }
        else {
            _skillIntroduce.text = cheapestSkill.detail.content;
        }
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
    //    else if (indexPath.row == 1) {
    //        _wxBgView.image = [UIImage imageNamed:@"icon_icNo2"];
    //    } else if (indexPath.row == 2) {
    //        _wxBgView.image = [UIImage imageNamed:@"icon_icNo3"];
    //    } else if (indexPath.row == 3) {
    //        _wxBgView.image = [UIImage imageNamed:@"icon_icNo4"];
    //    }
}

//- (ZZHomeFirstWxGuide *)firstWxGuideView {
//    if (!_firstWxGuideView) {
//        CGFloat width = (SCREEN_WIDTH - 15)/2.0;
//        _firstWxGuideView = [[ZZHomeFirstWxGuide alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//    }
//    return _firstWxGuideView;
//}

@end
