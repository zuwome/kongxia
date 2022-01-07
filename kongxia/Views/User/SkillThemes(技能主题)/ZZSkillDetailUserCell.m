//
//  ZZSkillDetailUserCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillDetailUserCell.h"
#import "ZZHeadImageView.h"

@interface ZZSkillDetailUserCell ()

@property (nonatomic, strong) ZZHeadImageView *avatar;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UILabel *introduction;
@property (nonatomic, strong) UIButton *attentionBtn;

@end

@implementation ZZSkillDetailUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.leading.equalTo(@15);
        make.top.equalTo(@25);
        make.bottom.equalTo(@-25);
    }];
    
    [self.contentView addSubview:self.username];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_top).offset(10);
        make.leading.equalTo(self.avatar.mas_trailing).offset(12);
        make.height.equalTo(@22);
    }];
    
    [self.contentView addSubview:self.introduction];
    [self.introduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.username.mas_bottom).offset(10);
        make.bottom.equalTo(self.avatar);
        make.leading.equalTo(self.username);
        make.trailing.equalTo(@-15);
    }];
    
    [self.contentView addSubview:self.attentionBtn];
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.size.mas_equalTo(CGSizeMake(68, 32));
        make.leading.equalTo(self.username.mas_trailing).offset(12);
    }];
}

- (void)setUser:(ZZUser *)user {
    [super setUser:user];
    [self.avatar setUser:user width:80 vWidth:12];
    [self.username setText:user.nickname];
    [self.introduction setText:user.bio];
    if ([user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
        self.attentionBtn.hidden = YES;
    } else {
        self.attentionBtn.hidden = NO;
        [self.attentionBtn setSelected:user.follow_status == 0 ? NO : YES];
        [self.attentionBtn setBackgroundColor:user.follow_status == 0 ? kGoldenRod : [UIColor whiteColor]];
        self.attentionBtn.layer.borderWidth = user.follow_status == 0 ? 0 : 1;
        [self.attentionBtn setTitle:user.follow_status == 0 ? @"关注" : (user.follow_status == 1 ? @"已关注" : @"互相关注") forState:(UIControlStateSelected)];
        [self.attentionBtn setTitleEdgeInsets:user.follow_status == 0 ? UIEdgeInsetsMake(0, 2, 0, -2) : UIEdgeInsetsMake(0, -5, 0, 5)];
        [self.attentionBtn setImageEdgeInsets:user.follow_status == 0 ? UIEdgeInsetsMake(0, -2, 0, 2) : UIEdgeInsetsMake(0, 5, 0, -5)];
        [self.attentionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(user.follow_status == 2 ? @84 : @68);
        }];
    }
}

- (void)attentionClick {
    !self.gotoAttent ? : self.gotoAttent();
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -- getter
- (ZZHeadImageView *)avatar {
    if (nil == _avatar) {
        _avatar = [[ZZHeadImageView alloc] init];
        _avatar.userInteractionEnabled = NO;
    }
    return _avatar;
}
- (UILabel *)username {
    if (nil == _username) {
        _username = [[UILabel alloc] init];
        [_username setFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)]];
        [_username setTextColor:kBlackColor];
    }
    return _username;
}
- (UILabel *)introduction {
    if (nil == _introduction) {
        _introduction = [[UILabel alloc] init];
        [_introduction setFont:[UIFont systemFontOfSize:13]];
        [_introduction setTextColor:kGrayTextColor];
        [_introduction setNumberOfLines:2];
    }
    return _introduction;
}
- (UIButton *)attentionBtn {
    if (nil == _attentionBtn) {
        _attentionBtn = [[UIButton alloc] init];
        [_attentionBtn setImage:[UIImage imageNamed:@"icon_attent"] forState:(UIControlStateNormal)];
        [_attentionBtn setImage:[UIImage imageNamed:@"lucency"] forState:(UIControlStateSelected)];
        [_attentionBtn setTitle:@"关注" forState:(UIControlStateNormal)];
        [_attentionBtn setTitle:@"已关注" forState:(UIControlStateSelected)];
        [_attentionBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_attentionBtn setBackgroundColor:kGoldenRod];
        _attentionBtn.layer.cornerRadius = 2;
        _attentionBtn.layer.masksToBounds = YES;
        _attentionBtn.layer.borderColor = kBlackColor.CGColor;
        [_attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
        [_attentionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
        [_attentionBtn addTarget:self action:@selector(attentionClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _attentionBtn;
}

@end
