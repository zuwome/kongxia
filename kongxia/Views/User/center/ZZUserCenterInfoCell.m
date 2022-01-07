//
//  ZZUserCentInfoCell.m
//  zuwome
//
//  Created by angBiu on 16/10/10.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserCenterInfoCell.h"

@interface ZZUserCenterInfoCell ()

@property (nonatomic, strong) UIImageView *badgeImageView;  // Top前四显示的徽章

@end

@implementation ZZUserCenterInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        _headImgView.userInteractionEnabled = NO;
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.size.mas_equalTo(CGSizeMake(62, 62));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
        
        _identifierImgView = [[UIImageView alloc] init];
        _identifierImgView.image = [UIImage imageNamed:@"icon_identifier"];
        [self.contentView addSubview:_identifierImgView];
        
        [_identifierImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 15));
        }];
        
        self.badgeImageView = [UIImageView new];
        self.badgeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(badgeImageViewAction)];
        [self.badgeImageView addGestureRecognizer:tap];
        [self.contentView addSubview:self.badgeImageView];
        [self.badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.left.equalTo(_nameLabel.mas_right).offset(30);
            make.width.mas_equalTo(51);
            make.height.mas_equalTo(16);
        }];
        
        _memehaoLabel = [[UILabel alloc] init];
        _memehaoLabel.textAlignment = NSTextAlignmentLeft;
        _memehaoLabel.textColor = kBlackTextColor;
        _memehaoLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_memehaoLabel];
        
        _vLabel = [[UILabel alloc] init];
        _vLabel.textAlignment = NSTextAlignmentLeft;
        _vLabel.textColor = kBlackTextColor;
        _vLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_vLabel];
        
        [_vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_headImgView.mas_bottom);
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-30);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.image = [UIImage imageNamed:@"icGengduo_user"];
        [self.contentView addSubview:arrowImgView];
        
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 17));
        }];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"编辑";
        _subTitleLabel.textColor = kBlackTextColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-40);
        }];
    }
    
    return self;
}

- (void)badgeImageViewAction {
    if (_delegate && [_delegate respondsToSelector:@selector(cellWithRealFaceAction:)]) {
        [_delegate cellWithRealFaceAction:self];
    }
}

- (void)setData:(ZZUser *)user {
    _vLabel.hidden = NO;
    if (user.weibo.verified) {
        _vLabel.text = user.weibo.verified_reason;
    } else if (!isNullString(user.bio)) {
        _vLabel.text = user.bio;
    } else {
        _vLabel.hidden = YES;
    }
    
    if (_vLabel.hidden) {
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
            make.bottom.mas_equalTo(_headImgView.mas_centerY).offset(-7);
        }];
        [_memehaoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(14);
        }];
    } else {
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
        [_memehaoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.centerY.mas_equalTo(_headImgView.mas_centerY);
        }];
    }

    [_headImgView setUser:user width:62 vWidth:12];
    
    
    _nameLabel.text = user.nickname;
    CGFloat nameWidth = [ZZUtils widthForCellWithText:user.nickname fontSize:17];
    CGFloat maxWidth = SCREEN_WIDTH - 15 - 68 - 15 - 5 - 20 - 30;
    if ([ZZUtils isIdentifierAuthority:user]) {
        _identifierImgView.hidden = NO;
    } else {
        _identifierImgView.hidden = YES;
        maxWidth = maxWidth + 25;
    }
    
    if ([user isFaceVerified] && [user didHaveRealAvatar]) {
        _badgeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icZhenshitouxiangWode"]];
    }
    else {
        _badgeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icZstxHuizhi"]];
    }
    
    if (_identifierImgView.hidden) {
        [_badgeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(5);
        }];
    }
    else {
        [_badgeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(30);
        }];
    }
    
    if (nameWidth > maxWidth) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
    
    _memehaoLabel.text = [NSString stringWithFormat:@"么么号：%@",user.ZWMId];
    
}

- (UILabel *)percentLabel {
    if (!_percentLabel) {
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:arrowImgView];
        
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 17));
        }];
        
//        UIView *bgView = [[UIView alloc] init];
//        bgView.backgroundColor = HEXACOLOR(0xF4CB07, 0.25);
//        bgView.layer.cornerRadius = 10;
//        [self.contentView addSubview:bgView];
//        
//        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.contentView.mas_centerY);
//            make.right.mas_equalTo(arrowImgView.mas_left).offset(-8);
//            make.height.mas_equalTo(@20);
//        }];
//        
//        _percentLabel = [[UILabel alloc] init];
//        _percentLabel.textAlignment = NSTextAlignmentCenter;
//        _percentLabel.textColor = kBlackTextColor;
//        _percentLabel.font = [UIFont systemFontOfSize:12];
//        [bgView addSubview:_percentLabel];
//        
//        [_percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(bgView.mas_left).offset(8);
//            make.right.mas_equalTo(bgView.mas_right).offset(-8);
//            make.centerY.mas_equalTo(bgView.mas_centerY);
//        }];
    }
    return _percentLabel;
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
