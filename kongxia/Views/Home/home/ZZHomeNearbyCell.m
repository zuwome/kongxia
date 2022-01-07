//
//  ZZHomeNearbyCell.m
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeNearbyCell.h"
#import "ZZHomeModel.h"

@implementation ZZHomeNearbyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = kBGColor;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 3;
        bgView.clipsToBounds = YES;
        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kGrayTextColor;
        _imgView.clipsToBounds = YES;
        [bgView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_top);
            make.left.mas_equalTo(bgView.mas_left);
            make.bottom.mas_equalTo(bgView.mas_bottom);
            make.width.mas_equalTo(@124);
        }];
        
        _wxBgView = [[UIImageView alloc] init];
        _wxBgView.image = [UIImage imageNamed:@"icon_home_triangle"];
        [bgView addSubview:_wxBgView];
        
        [_wxBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(_imgView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        UIImageView *wxImgView = [[UIImageView alloc] init];
        wxImgView.image = [UIImage imageNamed:@"icon_wx_wx_n"];
        [_wxBgView addSubview:wxImgView];
        
        [wxImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_wxBgView.mas_left).offset(3);
            make.top.mas_equalTo(_wxBgView.mas_top).offset(3);
            make.size.mas_equalTo(CGSizeMake(17, 14));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(10);
            make.top.mas_equalTo(bgView.mas_top).offset(10);
        }];
        
        _sexImgView = [[UIImageView alloc] init];
        _sexImgView.contentMode = UIViewContentModeLeft;
        _sexImgView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_sexImgView];
        
        [_sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _identifierImgView = [[UIImageView alloc] init];
        _identifierImgView.image = [UIImage imageNamed:@"icon_identifier"];
        _identifierImgView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_identifierImgView];
        
        [_identifierImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 15));
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        _levelImgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(30);
            make.centerY.mas_equalTo(_identifierImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        _statusView = [[ZZHomeStatusView alloc] init];
        _statusView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_statusView];
        
        [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-8);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        _vImgView = [[UIImageView alloc] init];
        _vImgView.image = [UIImage imageNamed:@"v"];
        _vImgView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_vImgView];
        
        [_vImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        _vLabel = [[UILabel alloc] init];
        _vLabel.textAlignment = NSTextAlignmentLeft;
        _vLabel.textColor = kGrayTextColor;
        _vLabel.font = [UIFont systemFontOfSize:12];
        _vLabel.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_vLabel];
        
        [_vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_vImgView.mas_right).offset(3);
            make.centerY.mas_equalTo(_vImgView.mas_centerY);
            make.right.mas_equalTo(_statusView.mas_left).offset(-5);
        }];
        
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.textAlignment = NSTextAlignmentLeft;
        _skillLabel.textColor = kGrayTextColor;
        _skillLabel.font = [UIFont systemFontOfSize:12];
        _skillLabel.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_skillLabel];
        
        [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-10);
        }];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textAlignment = NSTextAlignmentRight;
        _locationLabel.textColor = kGrayTextColor;
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_locationLabel];
        
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_skillLabel.mas_centerY);
        }];
        
        _locationImgView = [[UIImageView alloc] init];
        _locationImgView.image = [UIImage imageNamed:@"location"];
        _locationImgView.contentMode = UIViewContentModeScaleToFill;
        _locationImgView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_locationImgView];
        
        [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_locationLabel.mas_left).offset(-3);
            make.centerY.mas_equalTo(_locationLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 11));
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

- (void)setModel:(ZZHomeNearbyModel *)model
{
    _model = model;
    ZZUser *user = model.user;
    _nameLabel.text = user.nickname;
    _vImgView.hidden = user.weibo.verified?NO:YES;
    _vLabel.hidden = user.weibo.verified?NO:YES;
    _vLabel.text = user.weibo.verified_reason;
    if (!isNullString(user.avatar)) {
        [ZZUtils imageLoadAnimation:_imgView imageUrl:[user.avatar qiniuURL]];
    }

    if (user.have_wechat_no) {
        _wxBgView.hidden = NO;
    } else {
        _wxBgView.hidden = YES;
    }
    
    if (user.gender == 2) {
        _sexImgView.image = [UIImage imageNamed:@"girl"];
    } else if (user.gender == 1) {
        _sexImgView.image = [UIImage imageNamed:@"boy"];
    } else {
        _sexImgView.image = [UIImage new];
    }
    
    CGFloat nameMaxWidth = SCREEN_WIDTH - 20 - 124 - 10 - 20 - 25 - 10 - 5 - 30;
    
    if ([ZZUtils isIdentifierAuthority:user]) {
        _identifierImgView.hidden = NO;
        [_levelImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(30);
        }];
    } else {
        _identifierImgView.hidden = YES;
        [_levelImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(5);
        }];
        nameMaxWidth = nameMaxWidth + 25;
    }
    
    [_levelImgView setLevel:user.level];
    
    [_statusView setUser:user type:1];
    if (user.mark.is_new_rent || user.mark.is_flighted_user || user.mark.is_short_distance_user) {
        [_statusView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36, 21));
        }];
        nameMaxWidth = nameMaxWidth - 41;
    }
    
    CGFloat nameWidth = [ZZUtils widthForCellWithText:_nameLabel.text fontSize:14];
    if (nameWidth > nameMaxWidth) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameMaxWidth);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
    
    _locationLabel.text = model.distance;
    
    if (user.rent.topics.count) {
        ZZTopic *topic = user.rent.topics[0];
        _skillLabel.text = [topic title];
    }
    
    CGFloat locationWidth = [ZZUtils widthForCellWithText:_locationLabel.text fontSize:12];
    CGFloat width = SCREEN_WIDTH - 20 - 124 - 10 - 10 - 3 - 8 - 10 - locationWidth;
    
    if (user.rent.topics.count) {
        ZZTopic *topic = user.rent.topics[0];
        
        BOOL multipleTopic = user.rent.topics.count > 1;
        
        __block NSString *pastString;
        [topic.skills enumerateObjectsUsingBlock:^(ZZSkill *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                _skillLabel.text = obj.name;
                pastString = [NSString stringWithFormat:@"%@...",_skillLabel.text];
                if (multipleTopic && topic.skills.count == 1) {
                    if (width >= [ZZUtils widthForCellWithText:pastString fontSize:12]) {
                        _skillLabel.text = pastString;
                    }
                }
            } else {
                NSString *eStr = [NSString stringWithFormat:@"%@...",_skillLabel.text];
                NSString *string = [NSString stringWithFormat:@"%@、%@",_skillLabel.text,obj.name];
                if (width >= [ZZUtils widthForCellWithText:eStr fontSize:12]) {
                    pastString = eStr;
                }
                if (width >= [ZZUtils widthForCellWithText:string fontSize:12]) {
                    _skillLabel.text = string;
                    if (multipleTopic && topic.skills.count - 1 == idx) {
                        NSString *tempStr = [NSString stringWithFormat:@"%@...",string];
                        if (width >= [ZZUtils widthForCellWithText:tempStr fontSize:12]) {
                            _skillLabel.text = tempStr;
                        } else {
                            _skillLabel.text = pastString;
                        }
                    }
                } else {
                    if (idx < topic.skills.count) {
                        NSString *tempStr = [NSString stringWithFormat:@"%@...",string];
                        if (width >= [ZZUtils widthForCellWithText:tempStr fontSize:12]) {
                            _skillLabel.text = tempStr;
                        } else {
                            _skillLabel.text = pastString;
                        }
                    } else {
                        _skillLabel.text = pastString;
                    }
                    *stop = YES;
                }
            }
        }];
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
