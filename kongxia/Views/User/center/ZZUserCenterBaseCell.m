//
//  ZZUserCenterBaseCell.m
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserCenterBaseCell.h"

@interface ZZUserCenterBaseCell ()

@property (nonatomic, strong) UIImageView *popularValueImg;//人气值排名图片
@property (nonatomic, strong) UILabel *popularValueLabel;//人气值排名文字
@property (nonatomic, strong) UILabel *popularValueSubLabel;

@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, strong) UIImageView *orderInfoImageView;

@end

@implementation ZZUserCenterBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.clipsToBounds = YES;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(19);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = kGrayTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
        
        _readPointView = [[UIView alloc] init];
        _readPointView.layer.cornerRadius = 4;
        _readPointView.backgroundColor = kRedColor;
        [self.contentView addSubview:_readPointView];
        
        [_readPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_contentLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        
        _badgeView = [[ZZBadgeView alloc] init];
        _badgeView.cornerRadius = 7.5;
        _badgeView.offset = 5;
        _badgeView.fontSize = 9;
        _badgeView.count = 99;
        [self.contentView addSubview:_badgeView];
        
        [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_contentLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(@15);
        }];
        
        _infoImgView = [[UIImageView alloc] init];
        _infoImgView.image = [UIImage imageNamed:@"icon_user_photoerror"];
        [self.contentView addSubview:_infoImgView];
        
        [_infoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_contentLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 12.5));
        }];
        
        _editImgView = [[UIImageView alloc] init];
        _editImgView.image = [UIImage imageNamed:@"icon_user_edit"];
        [self.contentView addSubview:_editImgView];
        
        [_editImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 16));
        }];
        
        _orderInfoLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kGrayTextColor fontSize:12 text:@"全部"];
        [self.contentView addSubview:_orderInfoLabel];
    
        [_orderInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-33);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _orderInfoImageView = [[UIImageView alloc] init];
        _orderInfoImageView.hidden = YES;
        [self.contentView addSubview:_orderInfoImageView];
        [_orderInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-33);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.equalTo(@13);
        }];
        
        
        [self.contentView addSubview:self.popularValueLabel];
        [self.contentView addSubview:self.popularValueSubLabel];
        [self.contentView addSubview:self.popularValueImg];
        
        [self.popularValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
   
        [self.popularValueImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.popularValueLabel.mas_left).offset(-5);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(13);
            make.width.mas_equalTo(31);
        }];
        
        [_popularValueSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.popularValueImg.mas_left).offset(-5);
            make.centerY.mas_equalTo(0);
        }];
        
        [self.contentView addSubview:self.redIntegralView];
        [self.redIntegralView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.left.equalTo(self.titleLabel.mas_right).offset(3);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    return self;
}

- (void)setRedDot:(NSInteger)number {
    if (number == -1 || number == 0) {
        [_redView removeFromSuperview];
        _redView = nil;
        return;
    }
    
    if (!_redView) {
        [self addSubview:self.redView];
    }
    
    NSString *numberStr = [NSString stringWithFormat:@"%ld",(long)number];
    if (number > 99) {
        numberStr = @"99+";
    }
    _redLabel.text = numberStr;
    [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_titleLabel.mas_right).offset(15.0);
        make.height.equalTo(@15.0);
    }];
    _redView.layer.cornerRadius = 7.5;
    _redView.layer.masksToBounds = YES;
}

- (void)setData:(ZZUser *)user indexPath:(NSIndexPath *)indexPath hideRedPoint:(BOOL)hide {
    self.index = indexPath;
    _contentLabel.hidden = YES;
    _readPointView.hidden = YES;
    _badgeView.hidden = YES;
    _lineView.hidden = NO;
    _orderInfoLabel.hidden = YES;
    _arrowImgView.hidden = YES;
    _editImgView.hidden = YES;
    _infoImgView.hidden = YES;
    self.rentInfoImgView.hidden = YES;
    _popularValueImg.hidden = YES;
    _popularValueLabel.hidden = YES;
    _popularValueSubLabel.hidden = YES;
    _redIntegralView.hidden = YES;
    _rentInfoImgView.hidden = YES;
    
    _imgView.image = nil;
    _titleLabel.text = nil;
    _orderInfoImageView.image = nil;
    switch (indexPath.section) {
        case 1: {
            _titleLabel.text = @"我的档期";
            _imgView.image = [UIImage imageNamed:@"user_info_icDangqi"];
            _arrowImgView.hidden = NO;
            _orderInfoLabel.hidden = NO;
            _orderInfoLabel.text = @"全部";
            _orderInfoLabel.textColor = kGrayTextColor;
        } break;
        case 2: {
            _imgView.image = [UIImage imageNamed:@"user_info_icDaren"];
            _editImgView.hidden = NO;
            _orderInfoLabel.hidden = YES;
            _orderInfoImageView.hidden = NO;
            _orderInfoLabel.textColor = kYellowColor;
            if (user.banStatus) {
                _orderInfoLabel.text = @"去申请";
                _titleLabel.text = @"申请达人";
                _rentInfoImgView.hidden = NO;
            }
            else {
                switch (user.rent.status) {
                    // 0、未出租 1、待审核 2、已上架 3、已下架
                    case 0: {
                        _orderInfoLabel.text = @"去申请";
                        _titleLabel.text = @"申请达人";
                        _rentInfoImgView.hidden = NO;
                        _orderInfoImageView.image = [UIImage imageNamed:@"qushenqing"];
                        break;
                    }
                    case 1: {
                        _orderInfoLabel.text = @"待审核";
                        _titleLabel.text = @"申请达人";
                        _orderInfoImageView.image = [UIImage imageNamed:@"daishenhe"];
                        break;
                    }
                    case 2: {
                        _titleLabel.text = @"我是达人";
                        if (user.rent.show) {
                            _orderInfoLabel.text = @"修改达人信息";
                            _orderInfoImageView.image = [UIImage imageNamed:@"xiugaidarenxinxi"];
                        }
                        else {
                            _orderInfoLabel.text = @"隐身中";
                            _orderInfoImageView.image = [UIImage imageNamed:@"yinshenzhong"];
                        }
                        break;
                    }
                    case 3: {
                        _orderInfoLabel.text = @"隐身中";
                        _titleLabel.text = @"我是达人";
                        _orderInfoImageView.image = [UIImage imageNamed:@"yinshenzhong"];
                        break;
                    }
                    default: break;
                }
            }
        } break;
        case 3: {
            switch (indexPath.row) {
                case 0: {
                    _titleLabel.text = @"人气值";
                    _imgView.image = [UIImage imageNamed:@"user_info_icRenqizhi"];
                    _popularValueImg.hidden = NO;
                    _popularValueLabel.hidden = NO;
                    _popularValueLabel.text = [ZZUserHelper shareInstance].loginer.rank;
                    _popularValueSubLabel.hidden = NO;
                } break;
                case 1: {
                    _titleLabel.text = @"邀请好友";
                    _imgView.image = [UIImage imageNamed:@"icKxhhr"];
                    _contentLabel.hidden = NO;
                    _contentLabel.text = @"获得现金分红";
                    if (user.totalCommissionIncome != 0) {
                        _contentLabel.text = [NSString stringWithFormat:@"获得现金分红￥%.2f", user.totalCommissionIncome];
                    }
                    _contentLabel.textColor = RGBCOLOR(254, 66, 70);
                } break;
                case 2: {
                    _titleLabel.text = @"我的钱包";
                    _imgView.image = [UIImage imageNamed:@"user_info_ic"];
                } break;
                case 3: {
                    _titleLabel.text = @"我的微信";
                    _imgView.image = [UIImage imageNamed:@"user_info_icWeixin"];
                    _contentLabel.hidden = NO;
                    if ([ZZUserHelper shareInstance].configModel.hide_see_wechat_at_userdetail) {
                        _contentLabel.text = @"";
                    } else {
                        if (user.have_wechat_no) {
                            _contentLabel.text = [NSString stringWithFormat:@"￥%@",[ZZUtils dealAccuracyNumber:user.money_get_by_wechat_no]];;
                        } else {
                            _contentLabel.text = @"填微信 得收益";
                        }
                    }     
                    _contentLabel.textColor = RGBCOLOR(254, 66, 70);
                } break;
                    case 4: {
                        _titleLabel.text = @"我的点唱Party";
                        _imgView.image = [UIImage imageNamed:@"icWdchp"];
                        break;
                    }
                case 5: {
                    _titleLabel.text = @"我的视频";
                    _imgView.image = [UIImage imageNamed:@"user_info_icShipin"];
                    NSInteger count = [ZZUserHelper shareInstance].unreadModel.my_answer_mmd_count;
                    NSString *key = [NSString stringWithFormat:@"%@%@",[ZZStoreKey sharedInstance].uploadFailureVideo,[ZZUserHelper shareInstance].loginerId];
                    NSArray *array = [ZZKeyValueStore getValueWithKey:key tableName:kTableName_VideoSave];
                    if (array.count != 0) {
                        _infoImgView.hidden = NO;
                    } else if (count) {
                        _badgeView.count = count;
                        _badgeView.hidden = NO;
                    }
                    if ([ZZUserHelper shareInstance].unreadModel.my_ask_mmd || [ZZUserHelper shareInstance].unreadModel.my_answer_mmd) {
                        self.readPointView.hidden = NO;
                    } else {
                        self.readPointView.hidden = YES;
                    }
                } break;
                
                case 6: {
                    _titleLabel.text = @"实名认证";
                    _imgView.image = [UIImage imageNamed:@"user_info_icShiming"];
                } break;
                case 8: {
                    _titleLabel.text = @"在线客服";
                    _imgView.image = [UIImage imageNamed:@"icon_messagelist_server"];
                } break;
                case 9: {
                    _titleLabel.text = @"帮助中心";
                    _imgView.image = [UIImage imageNamed:@"user_info_icBangzhu"];
                } break;
                case 7: {
                    _titleLabel.text = @"高级客服经理";
                    _imgView.image = [UIImage imageNamed:@"user_info_icBangzhu"];
                } break;
                default: break;
            }
        } break;
        default: break;
    }
}

#pragma mark - lazyload

- (UIImageView *)rentInfoImgView {
    if (!_rentInfoImgView) {
        _rentInfoImgView = [[UIImageView alloc] init];
        _rentInfoImgView.image = [UIImage imageNamed:@"icon_user_rent_upinfo"];
        [self.contentView addSubview:_rentInfoImgView];
        
        [_rentInfoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(3);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50.5, 16));
        }];
    }
    return _rentInfoImgView;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        _readPointView.backgroundColor = kRedColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _readPointView.backgroundColor = kRedColor;
    }
}

#pragma mark - Lazy loading
//人气值的图片
- (UIImageView *)popularValueImg {
    if (!_popularValueImg) {
        _popularValueImg = [[UIImageView alloc]init];
        _popularValueImg.hidden = YES;
        _popularValueImg.image = [UIImage imageNamed:@"icTop"];
    }
    return _popularValueImg;
}

/**
 人气值排名数值
 */
- (UILabel *)popularValueLabel {
    if (!_popularValueLabel) {
        _popularValueLabel = [[UILabel alloc]init];
        _popularValueLabel.font = [UIFont fontWithName:@"Futura-Medium" size:15];
        _popularValueLabel.textAlignment = NSTextAlignmentCenter;
        _popularValueLabel.hidden = YES;
        _popularValueLabel.text = @"暂无数据";
        _popularValueLabel.textColor = HEXCOLOR(0x3f3f3a);
    }
    return _popularValueLabel;
}

/**
 人气值排名数值
 */
- (UILabel *)popularValueSubLabel {
    if (!_popularValueSubLabel) {
        _popularValueSubLabel = [[UILabel alloc]init];
        _popularValueSubLabel.font = [UIFont fontWithName:@"Futura-Medium" size:15];
        _popularValueSubLabel.textAlignment = NSTextAlignmentCenter;
        _popularValueSubLabel.hidden = YES;
        _popularValueSubLabel.text = @"同城排名";
        _popularValueSubLabel.textColor = HEXCOLOR(0x3f3f3a);
    }
    return _popularValueSubLabel;
}

/**
 积分提醒小红点

 */
- (UIView *)redIntegralView {
    if (!_redIntegralView) {
        _redIntegralView = [[UIView alloc]init];
        _redIntegralView.layer.cornerRadius = 4;
        _redIntegralView.hidden = YES;
        _redIntegralView.backgroundColor = [UIColor redColor];
    }
    return _redIntegralView;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = UIColor.redColor;
        
        _redLabel = [[UILabel alloc] init];
        _redLabel.font = [UIFont systemFontOfSize:12];
        _redLabel.textColor = [UIColor whiteColor];
        _redLabel.textAlignment = NSTextAlignmentCenter;
        [_redView addSubview:_redLabel];
        [_redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_redView);
            make.left.equalTo(_redView).offset(5.0);
            make.right.equalTo(_redView).offset(-5.0);
        }];
    }
    return _redView;
}

@end
