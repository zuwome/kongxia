//
//  ZZTotalContributionBgView.m
//  zuwome
//
//  Created by angBiu on 2016/10/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTotalContributionBgView.h"

@implementation ZZTotalContributionBgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _topLevelImgView = [[UIImageView alloc] init];
        _topLevelImgView.image = [UIImage imageNamed:@"icon_user_contribution_level2"];
        [self addSubview:_topLevelImgView];
        
        [_topLevelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        _headImgView = [[ZZHeadImageView alloc] init];
        _headImgView.headImgView.image = [UIImage imageNamed:@"icon_contribution_default"];
        _headImgView.headImgView.layer.cornerRadius = 37;
        _headImgView.clipsToBounds = YES;
        _headImgView.userInteractionEnabled = YES;
        [self addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topLevelImgView.mas_bottom).offset(12);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(74, 74));
        }];
        
        UIView *nameBgView = [[UIView alloc] init];
        [self addSubview:nameBgView];
        
        [nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_headImgView.mas_bottom).offset(12);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = kGrayContentColor;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.text = @"求占";
        [nameBgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(nameBgView);
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        [nameBgView addSubview:_levelImgView];
        
        _attentView = [[ZZAttentView alloc] init];
        _attentView.fontSize = 12;
        _attentView.hidden = YES;
        [self addSubview:_attentView];
        
        [_attentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameBgView.mas_bottom).offset(12);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(58, 21));
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        WeakSelf;
        _headImgView.touchHead = ^{
            [weakSelf headImgViewClick];
        };
    }
    
    return self;
}

- (void)setData:(ZZUser *)user
{
    _attentView.user = user;
    _attentView.listFollow_status = user.follow_status;
    [_headImgView setUser:user width:74 vWidth:12];
    _nameLabel.text = user.nickname;
    
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.superview.mas_left);
        make.top.mas_equalTo(_nameLabel.superview.mas_top);
        make.bottom.mas_equalTo(_nameLabel.superview.mas_bottom);
    }];
    
    [_levelImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
        make.right.mas_equalTo(_nameLabel.superview.mas_right);
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 14));
    }];
    
    CGFloat maxWidth = (SCREEN_WIDTH - 30)/3 - 6 - 5 - 30;
    CGFloat nameWidth = [ZZUtils widthForCellWithText:_nameLabel.text fontSize:13];
    if (nameWidth > maxWidth) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
    
    [_levelImgView setLevel:user.level];
}

- (void)setAnonymousStatus
{
    _attentView.hidden = YES;
    _levelImgView.hidden = YES;
    CGFloat maxWidth = (SCREEN_WIDTH - 30)/3 - 6;
    
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(maxWidth);
    }];
}

#pragma mark - UIButtonMethod

- (void)headImgViewClick
{
    if (_touchHead) {
        _touchHead();
    }
}

@end
