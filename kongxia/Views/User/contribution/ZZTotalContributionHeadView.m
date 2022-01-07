//
//  ZZTotalContributionHeadView.m
//  zuwome
//
//  Created by angBiu on 16/10/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTotalContributionHeadView.h"

@implementation ZZTotalContributionHeadView
{
    NSMutableArray              *_tempArray;
    NSInteger                   _type;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kYellowColor;
        CGFloat scale = SCREEN_WIDTH / 375.0;
        
        UIImageView *topBgImgView = [[UIImageView alloc] init];
        topBgImgView.image = [UIImage imageNamed:@"icon_user_contribution_bg"];
        [self addSubview:topBgImgView];
        
        [topBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(313*scale);
        }];
        
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.font = [UIFont systemFontOfSize:21];
//        _totalLabel.text = @"￥ 333.00";
        [self addSubview:_totalLabel];
        
        [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_top).offset(54*scale);
        }];
        
        UIImageView *levelBgImgView = [[UIImageView alloc] init];
        levelBgImgView.image = [UIImage imageNamed:@"icon_user_contribution_levelbg"];
        levelBgImgView.userInteractionEnabled = YES;
        [self addSubview:levelBgImgView];
        
        [levelBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(170*scale);
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(@245);
        }];
        
        WeakSelf;
        CGFloat width = (SCREEN_WIDTH - 30)/3;
        
        _firBgView = [[ZZTotalContributionBgView alloc] init];
        _firBgView.topLevelImgView.image = [UIImage imageNamed:@"icon_user_contribution_level1"];
        [levelBgImgView addSubview:_firBgView];
        
        [_firBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(levelBgImgView.mas_centerX);
            make.top.mas_equalTo(levelBgImgView.mas_top).offset(12);
            make.width.mas_equalTo(width);
        }];
        
        _firMoneyLabel = [[UILabel alloc] init];
        _firMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _firMoneyLabel.textColor = kRedTextColor;
        _firMoneyLabel.font = [UIFont systemFontOfSize:18];
        _firMoneyLabel.text = @"¥18888.80";
        [levelBgImgView addSubview:_firMoneyLabel];
        
        [_firMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_firBgView.mas_centerX);
            make.bottom.mas_equalTo(levelBgImgView.mas_bottom).offset(-15);
            make.width.mas_equalTo(width - 6);
        }];
        
        _secBgView = [[ZZTotalContributionBgView alloc] init];
        _secBgView.topLevelImgView.image = [UIImage imageNamed:@"icon_user_contribution_level2"];
        [levelBgImgView addSubview:_secBgView];
        
        [_secBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(levelBgImgView.mas_left);
            make.top.mas_equalTo(levelBgImgView.mas_top).offset(32);
            make.width.mas_equalTo(width);
        }];
        
        _secMoneyLabel = [[UILabel alloc] init];
        _secMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _secMoneyLabel.textColor = kRedTextColor;
        _secMoneyLabel.font = [UIFont systemFontOfSize:15];
        [levelBgImgView addSubview:_secMoneyLabel];
        
        [_secMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_secBgView.mas_centerX);
            make.centerY.mas_equalTo(_firMoneyLabel.mas_centerY);
            make.width.mas_equalTo(width - 6);
        }];
        
        _thiBgView = [[ZZTotalContributionBgView alloc] init];
        _thiBgView.topLevelImgView.image = [UIImage imageNamed:@"icon_user_contribution_level3"];
        [levelBgImgView addSubview:_thiBgView];
        
        [_thiBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(levelBgImgView.mas_right);
            make.top.mas_equalTo(_secBgView.mas_top);
            make.width.mas_equalTo(width);
        }];
        
        _thiMoneyLabel = [[UILabel alloc] init];
        _thiMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _thiMoneyLabel.textColor = kRedTextColor;
        _thiMoneyLabel.font = [UIFont systemFontOfSize:15];
        [levelBgImgView addSubview:_thiMoneyLabel];
        
        [_thiMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_thiBgView.mas_centerX);
            make.centerY.mas_equalTo(_firMoneyLabel.mas_centerY);
            make.width.mas_equalTo(width - 6);
        }];
        
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor whiteColor];
        [levelBgImgView addSubview:_coverView];
        
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(levelBgImgView.mas_left);
            make.right.mas_equalTo(levelBgImgView.mas_right);
            make.bottom.mas_equalTo(levelBgImgView.mas_bottom);
            make.height.mas_equalTo(@5);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [levelBgImgView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(levelBgImgView.mas_left);
            make.right.mas_equalTo(levelBgImgView.mas_right);
            make.bottom.mas_equalTo(levelBgImgView.mas_bottom);
            make.height.mas_equalTo(@1);
        }];
        
        _firBgView.touchHead = ^{
            [weakSelf headImgViewClick:0];
        };
        _firBgView.attentView.touchAttent = ^{
            [weakSelf attentWithIndex:0];
        };
        
        _secBgView.touchHead = ^{
            [weakSelf headImgViewClick:1];
        };
        _secBgView.attentView.touchAttent = ^{
            [weakSelf attentWithIndex:1];
        };
        
        _thiBgView.touchHead = ^{
            [weakSelf headImgViewClick:2];
        };
        _thiBgView.attentView.touchAttent = ^{
            [weakSelf attentWithIndex:2];
        };
        
    }
    
    return self;
}

- (void)setData:(NSMutableArray *)array model:(ZZTotalContributionModel *)model
{
    _totalLabel.text = [NSString stringWithFormat:@"￥%@",model.get_hb_price_total];
    _tempArray = array;
    _type = 1;
    for (int i=0; i<array.count; i++) {
        ZZTotalTipListModel *listModel = array[i];
        
        if (i == 0) {
            [_firBgView setData:listModel.tip_total.from];
            _firMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",listModel.tip_total.price];
        }
        if (i == 1) {
            _secMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",listModel.tip_total.price];
            
            [_secBgView setData:listModel.tip_total.from];
        }
        if (i == 2) {
            _thiMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",listModel.tip_total.price];
            
            [_thiBgView setData:listModel.tip_total.from];
        }
    }
    
    if (array.count > 3) {
        _lineView.hidden = NO;
    } else {
        _lineView.hidden = YES;
    }
}

- (void)setMMDData:(NSMutableArray *)array model:(ZZMMDTipModel *)model
{
    _tempArray = array;
    _type = 2;
//    _totalLabel.text = [NSString stringWithFormat:@"￥%@",model.get_hb_price_total];
    for (int i=0; i<array.count; i++) {
        ZZMMDTipListModel *listModel = array[i];
        
        if (i == 0) {
            //            [_firBgView setData:listModel.tip.from];
            _firBgView.headImgView.isAnonymous = listModel.tip.is_anonymous;
            _firMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",listModel.tip.price];
            if (listModel.tip.is_anonymous) {
                [_firBgView setAnonymousStatus];
                _firBgView.nameLabel.text = listModel.tip.from.nickname;
                [_firBgView.headImgView setUser:listModel.tip.from width:74 vWidth:12];
            } else {
                [_firBgView setData:listModel.tip.from];
            }
        }
        if (i == 1) {
            _secMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",listModel.tip.price];
            _secBgView.headImgView.isAnonymous = listModel.tip.is_anonymous;
            if (listModel.tip.is_anonymous) {
                [_secBgView setAnonymousStatus];
                _secBgView.nameLabel.text = listModel.tip.from.nickname;
                [_secBgView.headImgView setUser:listModel.tip.from width:74 vWidth:12];
            } else {
                [_secBgView setData:listModel.tip.from];
            }
        }
        if (i == 2) {
            _thiMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",listModel.tip.price];
            _thiBgView.headImgView.isAnonymous = listModel.tip.is_anonymous;
            if (listModel.tip.is_anonymous) {
                [_thiBgView setAnonymousStatus];
                _thiBgView.nameLabel.text = listModel.tip.from.nickname;
                [_thiBgView.headImgView setUser:listModel.tip.from width:74 vWidth:12];
            } else {
                [_thiBgView setData:listModel.tip.from];
            }
        }
    }
    
    if (array.count > 3) {
        _lineView.hidden = NO;
    } else {
        _lineView.hidden = YES;
    }
}

#pragma mark - 

- (void)headImgViewClick:(NSInteger)index
{
    if (index >= _tempArray.count) {
        return;
    }
    if (_type == 1) {
        ZZTotalTipListModel *listModel = _tempArray[index];
        if (_touchHead) {
            _touchHead(listModel.tip_total.from.uid);
        }
    } else {
        ZZMMDTipListModel *listModel = _tempArray[index];
        if (_touchHead) {
            _touchHead(listModel.tip.from.uid);
        }
    }
}

- (void)attentWithIndex:(NSInteger)index
{
    if ([ZZUtils isBan]) {
        return;
    }
    
    ZZUser *user = nil;
    if (_type == 1) {
        ZZTotalTipListModel *listModel = _tempArray[index];
        user = listModel.tip_total.from;
    } else {
        ZZMMDTipListModel *listModel = _tempArray[index];
        user = listModel.tip.from;
    }
    
    [MobClick event:Event_user_detail_follow];
    if (user.follow_status == 0) {
        [user followWithUid:user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"关注成功"];
                user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                switch (index) {
                    case 0:
                    {
                        _firBgView.attentView.listFollow_status = user.follow_status;
                    }
                        break;
                    case 1:
                    {
                        _secBgView.attentView.listFollow_status = user.follow_status;
                    }
                        break;
                    case 2:
                    {
                        _thiBgView.attentView.listFollow_status = user.follow_status;
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
    } else {
        [user unfollowWithUid:user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"已取消关注"];
                user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                switch (index) {
                    case 0:
                    {
                        _firBgView.attentView.listFollow_status = user.follow_status;
                    }
                        break;
                    case 1:
                    {
                        _secBgView.attentView.listFollow_status = user.follow_status;
                    }
                        break;
                    case 2:
                    {
                        _thiBgView.attentView.listFollow_status = user.follow_status;
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
    }
}

@end
