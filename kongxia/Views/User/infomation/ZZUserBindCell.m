//
//  ZZUserBindCell.m
//  zuwome
//
//  Created by angBiu on 16/6/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserBindCell.h"
#import "ZZUser.h"
#import "ZZRedPointView.h"
#import "ZZUserHelper.h"

@implementation ZZUserBindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icZhanghaobangdingWo"];
        _imgView.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBrownishGreyColor;
        _titleLabel.text = @"账号绑定";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(14);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:_arrowImgView];
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 17));
        }];
        
        _wbImgView = [[UIImageView alloc] init];
        _wbImgView.image = [UIImage imageNamed:@"icon_user_wb_n"];
        [self.contentView addSubview:_wbImgView];
        [_wbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowImgView.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 12));
        }];
        
        _qqImgView = [[UIImageView alloc] init];
        _qqImgView.image = [UIImage imageNamed:@"icon_user_qq_n"];
        [self.contentView addSubview:_qqImgView];
        [_qqImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_wbImgView.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12, 13));
        }];
        
        _wxImgView = [[UIImageView alloc] init];
        _wxImgView.image = [UIImage imageNamed:@"icon_user_wx_n"];
        [self.contentView addSubview:_wxImgView];
        [_wxImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_qqImgView.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(16, 13));
        }];
        
        _phoneImgView = [[UIImageView alloc] init];
        _phoneImgView.image = [UIImage imageNamed:@"icon_user_phone_n"];
        [self.contentView addSubview:_phoneImgView];
        [_phoneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_wxImgView.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(9, 13.5));
        }];
        
        _redPointView = [[ZZRedPointView alloc] init];
        [self.contentView addSubview:_redPointView];
        [_redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_phoneImgView.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    return self;
}

- (void)setUser:(ZZUser *)user {
    if (isNullString(user.phone)) {
        _phoneImgView.image = [UIImage imageNamed:@"icon_user_phone_n"];
    } else {
        _phoneImgView.image = [UIImage imageNamed:@"icon_user_phone_p"];
    }
    if (user.weibo.uid) {
        _wbImgView.image = [UIImage imageNamed:@"icon_user_wb_p"];
    } else {
        _wbImgView.image = [UIImage imageNamed:@"icon_user_wb_n"];
    }
    if (user.wechat.unionid) {
        _wxImgView.image = [UIImage imageNamed:@"icon_user_wx_p"];
    } else {
        _wxImgView.image = [UIImage imageNamed:@"icon_user_wx_n"];
    }
    if (user.qq.openid) {
        _qqImgView.image = [UIImage imageNamed:@"icon_user_qq_p"];
    } else {
        _qqImgView.image = [UIImage imageNamed:@"icon_user_qq_n"];
    }
    if (![ZZUserHelper shareInstance].userFirstWB && !user.weibo.uid) {
        _redPointView.hidden = NO;
    } else {
        _redPointView.hidden = YES;
    }
}

@end
