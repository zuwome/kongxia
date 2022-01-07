//
//  ZZHomeRecommendCell.m
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeRefreshCell.h"
#import "ZZHomeModel.h"

@implementation ZZHomeRefreshCell

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
        [bgView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sexImgView.mas_right).offset(30);
            make.centerY.mas_equalTo(_identifierImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        _vImgView = [[UIImageView alloc] init];
        _vImgView.image = [UIImage imageNamed:@"v"];
        _vImgView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_vImgView];
        
        [_vImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(12, 12));
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
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
        }];
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(35, 40));
        }];
        
        UIImageView *cancelImgView = [[UIImageView alloc] init];
        cancelImgView.image = [UIImage imageNamed:@"icon_home_refresh_cancel"];
        cancelImgView.userInteractionEnabled = NO;
        [bgView addSubview:cancelImgView];
        
        [cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.right.mas_equalTo(bgView.mas_right).offset(-8);
            make.size.mas_equalTo(CGSizeMake(10, 10));
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
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = kGrayTextColor;
        _priceLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:_priceLabel];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_skillLabel.mas_centerY);
        }];
        
        _locationImgView = [[UIImageView alloc] init];
        _locationImgView.image = [UIImage imageNamed:@"location"];
        _locationImgView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_locationImgView];
        
        [_locationImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_skillLabel.mas_top).offset(-10);
            make.left.mas_equalTo(_skillLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(8, 11));
        }];
        
        _statusView = [[ZZHomeStatusView alloc] init];
        _statusView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_statusView];
        
        [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-8);
            make.centerY.mas_equalTo(_locationImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textAlignment = NSTextAlignmentLeft;
        _locationLabel.textColor = kBlackTextColor;
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:_locationLabel];
        
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_locationImgView.mas_right).offset(3);
            make.centerY.mas_equalTo(_locationImgView.mas_centerY);
            make.right.mas_equalTo(_statusView.mas_left).offset(-8);
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

- (void)cancelBtnClick
{
    if (_touchCancel) {
        _touchCancel();
    }
}

#pragma mark -

- (void)setModel:(ZZHomeNearbyModel *)model
{
    _model = model;
    ZZUser *user = model.user;
    _nameLabel.text = user.nickname;
    _vImgView.hidden = user.weibo.verified?NO:YES;
    _vLabel.hidden = user.weibo.verified?NO:YES;
    _vLabel.text = user.weibo.verified_reason;
    
//    if (user.photos && user.photos.count > 0) {
//        ZZPhoto *firstPhoto = [user.photos firstObject];
//        [ZZUtils imageLoadAnimation:_imgView imageUrl:[firstPhoto.url qiniuURL]];
//    } else {
        [ZZUtils imageLoadAnimation:_imgView imageUrl:[user.avatar qiniuURL]];
//    }
    
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
    
    CGFloat nameMaxWidth = SCREEN_WIDTH - 20 - 124 - 10 - 20 - 25 - 10 - 5 - 30 - 30;
    
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
    
    // 技能名称、价格、介绍
    ZZSkill *cheapestSkill = [ZZHomeModel getMostCheapSkill:user.rent.topics];
    NSString *price = cheapestSkill.price;
    if (cheapestSkill == nil) {
        _skillLabel.text = @" ";
        _priceLabel.text = @" ";
    }
    else {
        _skillLabel.text = cheapestSkill.name;
        _priceLabel.text = [NSString stringWithFormat:@"￥%@/起",price];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
