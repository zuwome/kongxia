//
//  ZZMemedaHeadView.m
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMemedaHeadView.h"

@implementation ZZMemedaHeadView
{
    UIView                  *_vBgView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.image = [UIImage imageNamed:@"icon_rent_memeda_bg"];
        [self addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(@84);
        }];
        
        _headImgView = [[UIImageView alloc] init];
        _headImgView.backgroundColor = kBGColor;
        _headImgView.contentMode = UIViewContentModeScaleToFill;
        _headImgView.clipsToBounds = YES;
        _headImgView.layer.cornerRadius = 37;
        [self addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(imgView.mas_bottom);
            make.centerX.mas_equalTo(imgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(74, 74));
        }];
        
        UIView *nameBgView = [[UIView alloc] init];
        nameBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:nameBgView];
        
        [nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(10);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = kBlackTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.text = @"文静静静";
        [nameBgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameBgView.mas_left);
            make.top.mas_equalTo(nameBgView.mas_top);
            make.bottom.mas_equalTo(nameBgView.mas_bottom);
        }];
        
        _identifierImgView = [[UIImageView alloc] init];
        _identifierImgView.image = [UIImage imageNamed:@"icon_identifier"];
        _identifierImgView.contentMode = UIViewContentModeScaleToFill;
        [nameBgView addSubview:_identifierImgView];
        
        [_identifierImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.right.mas_equalTo(nameBgView.mas_right);
            make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
            make.size.mas_equalTo(CGSizeMake(20, 15));
        }];
        
        _memehaoLabel = [[UILabel alloc] init];
        _memehaoLabel.textAlignment = NSTextAlignmentCenter;
        _memehaoLabel.textColor = kBlackTextColor;
        _memehaoLabel.font = [UIFont systemFontOfSize:13];
        _memehaoLabel.text = @"么么号：1231234";
        [self addSubview:_memehaoLabel];
        
        [_memehaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(nameBgView.mas_bottom).offset(5);
        }];
        
        _signLabel = [[UILabel alloc] init];
        _signLabel.textAlignment = NSTextAlignmentCenter;
        _signLabel.textColor = kBlackTextColor;
        _signLabel.font = [UIFont systemFontOfSize:12];
        _signLabel.numberOfLines = 0;
        _signLabel.text = @"我设置了好看的人才能租我我设置了好看的人我设置了好咯骄傲";
        [self addSubview:_signLabel];
        
        _vBgView = [[UIView alloc] init];
        _vBgView.backgroundColor = [UIColor whiteColor];
        _vBgView.clipsToBounds = YES;
        [self addSubview:_vBgView];
        
        _vLabel = [[UILabel alloc] init];
        _vLabel.textAlignment = NSTextAlignmentCenter;
        _vLabel.textColor = kBlackTextColor;
        _vLabel.font = [UIFont systemFontOfSize:12];
        _vLabel.numberOfLines = 0;
        [_vBgView addSubview:_vLabel];
        
        [_vLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_vBgView.mas_top);
            make.left.mas_equalTo(_vBgView.mas_left);
            make.right.mas_equalTo(_vBgView.mas_right);
            make.bottom.mas_equalTo(_vBgView.mas_bottom);
        }];
        
        _vImgView = [[UIImageView alloc] init];
        _vImgView.contentMode = UIViewContentModeScaleToFill;
        _vImgView.image = [UIImage imageNamed:@"v"];
        [_vBgView addSubview:_vImgView];
        
        [_vImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_vLabel.mas_left);
            make.top.mas_equalTo(_vBgView.mas_top);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    
    return self;
}

- (void)setData:(ZZUser *)user
{
    __weak typeof(self)weakSelf = self;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[user displayAvatar]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.shareImg = image;
    }];
    _nameLabel.text = user.nickname;
    if ([ZZUtils isIdentifierAuthority:user]) {
        _identifierImgView.hidden = NO;
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_identifierImgView.mas_left).offset(-8);
        }];
    } else {
        _identifierImgView.hidden = YES;
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_nameLabel.superview.mas_right);
        }];
    }
    
    _memehaoLabel.text = [NSString stringWithFormat:@"么么号：%@",user.ZWMId];
    
    if (user.weibo.verified && !isNullString(user.weibo.verified_reason)) {
        _signLabel.hidden = YES;
        _vBgView.hidden = NO;
        _vLabel.text = [NSString stringWithFormat:@"       认证：%@",user.weibo.verified_reason];
        
        CGFloat width = [ZZUtils widthForCellWithText:_vLabel.text fontSize:12];
        if (width > SCREEN_WIDTH - 30) {
            width = SCREEN_WIDTH - 30;
        }
        CGFloat height = [ZZUtils heightForCellWithText:_vLabel.text fontSize:12 labelWidth:SCREEN_WIDTH - 30];
        [_vBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_memehaoLabel.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(width, height + 4));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-25);
        }];
    } else if (!isNullString(user.bio)) {
        _signLabel.hidden = NO;
        _vBgView.hidden = YES;
        _signLabel.text = user.bio;
        [_signLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_memehaoLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(SCREEN_WIDTH - 30);
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-25);
        }];
    } else {
        _signLabel.hidden = YES;
        _vBgView.hidden = YES;
        
        [_memehaoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).offset(-25);
        }];
    }
}

@end
