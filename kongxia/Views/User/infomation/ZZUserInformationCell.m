//
//  ZZUserInformationCell.m
//  zuwome
//
//  Created by angBiu on 16/6/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserInformationCell.h"
#import "ZZUser.h"
#import "ZZUserLabel.h"
#import "ZZUserHelper.h"
#import "ZZRedPointView.h"

@implementation ZZUserInformationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(@15);
        }];
        
        CGFloat titleWidth = [ZZUtils widthForCellWithText:@"哈哈哈哈" fontSize:15];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBrownishGreyColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(titleWidth);
        }];
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:_arrowImgView];
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 17));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowImgView.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
        }];
        
        _redPointView = [[ZZRedPointView alloc] init];
        _redPointView.layer.cornerRadius = 5;
        _redPointView.backgroundColor = [UIColor redColor];
        _redPointView.hidden = YES;
        [self.contentView addSubview:_redPointView];
        [_redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowImgView.mas_left).offset(-8);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    return self;
}

- (void)data:(ZZUser *)user indexPath:(NSIndexPath *)indexPath {
    _arrowImgView.hidden = NO;
    _redPointView.hidden = YES;
    _contentLabel.textColor = kBlackTextColor;
    NSString *reuseIdentifier = [self reuseIdentifier];
    if ([reuseIdentifier isEqualToString:@"base"]) {
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                _imgView.image = [UIImage imageNamed:@"icYonghumingWo"];
                _titleLabel.text = @"用户名";
                _contentLabel.text = user.nickname?user.nickname:@" ";
            }
            else if (indexPath.row == 1) {
                _imgView.image = [UIImage imageNamed:@"icNianlingJibenziliao"];
                _titleLabel.text = @"年龄";
                if (user.birthday) {
                    _contentLabel.text = [NSString stringWithFormat:@"%ld岁", user.age];
                }
//                if ([ZZUtils isIdentifierAuthority:user] && user.birthday) {
//                    _arrowImgView.hidden = YES;
//                    _contentLabel.textColor = kGrayTextColor;
//                }
            }
            else if (indexPath.row == 2) {
                _imgView.image = [UIImage imageNamed:@"icShengaoJibenziliao"];
                _titleLabel.text = @"身高";
                _contentLabel.text = user.height?[NSString stringWithFormat:@"%dcm",user.height]:@" ";
            }
            else if (indexPath.row == 3) {
                _imgView.image = [UIImage imageNamed:@"icTizhongJibenziliao"];
                _titleLabel.text = @"体重";
                _contentLabel.text = user.weight?[NSString stringWithFormat:@"%dkg",user.weight]:@" ";
                if (user.weight == kSecretWeight) {
                    _contentLabel.text = @"保密";
                }
            }
        }
        else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                _imgView.image = [UIImage imageNamed:@"icZiwojieshaoWo"];
                _titleLabel.text = @"自我介绍";
                _contentLabel.text = user.bio?user.bio:@" ";
            }
            else if (indexPath.row == 1) {
                _imgView.image = [UIImage imageNamed:@"icZhiyeJibenziliao"];
                _titleLabel.text = @"职业";
                if (user.works_new.count) {
                    [user.works_new enumerateObjectsUsingBlock:^(ZZUserLabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == 0) {
                            _contentLabel.text = label.content;
                        } else {
                            _contentLabel.text = [NSString stringWithFormat:@"%@ %@",_contentLabel.text,label.content];
                        }
                    }];
                } else {
                    if (![ZZUserHelper shareInstance].userFirstJob) {
                        _redPointView.hidden = NO;
                    }
                }
            }
            else if (indexPath.row == 2) {
                _imgView.image = [UIImage imageNamed:@"icChangzhudiJibenziliao"];
                _titleLabel.text = @"常住地";
                
                NSMutableString *address = (user.address.city ?: @" ").mutableCopy;
                if (!isNullString(address) && !isNullString(user.address.province)) {
                    [address insertString:user.address.province atIndex:0];
                }
                _contentLabel.text = address.copy;
            }
        }
    }
    
}

- (void)setData:(ZZUser *)user indexPath:(NSIndexPath *)indexPath {
    _arrowImgView.hidden = NO;
    _redPointView.hidden = YES;
    _contentLabel.textColor = kBlackTextColor;
    
    NSString *reuseIdentifier = [self reuseIdentifier];
    if ([reuseIdentifier isEqualToString:@"base"]) {    // 个人编辑页
        switch (indexPath.row) {
            case 2: {
                _imgView.image = [UIImage imageNamed:@"icYonghumingWo"];
                _titleLabel.text = @"用户名";
                _contentLabel.text = user.nickname?user.nickname:@" ";
            } break;
            case 3: {
                _imgView.image = [UIImage imageNamed:@"icZiwojieshaoWo"];
                _titleLabel.text = @"自我介绍";
                _contentLabel.text = user.bio?user.bio:@" ";
            } break;
            case 6: {
                _imgView.image = [UIImage imageNamed:@"icJibenziliaoWo"];
                _titleLabel.text = @"基本资料";
            } break;
            default: {
                _imgView.image = [UIImage imageNamed:@"icZiwojieshaoWo"];
                _titleLabel.text = @"自我介绍";
                _contentLabel.text = user.bio?user.bio:@" ";
            } break;
        }
    }
    else if ([reuseIdentifier isEqualToString:@"basicInfoCell"]) {     //个人基本资料
        switch (indexPath.row) {
            case 0: {
                _imgView.image = [UIImage imageNamed:@"icNianlingJibenziliao"];
                _titleLabel.text = @"年龄";
                if (user.birthday) {
                    _contentLabel.text = [NSString stringWithFormat:@"%ld岁", user.age];
                }
                if ([ZZUtils isIdentifierAuthority:user] && user.birthday) {
                    _arrowImgView.hidden = YES;
                    _contentLabel.textColor = kGrayTextColor;
                }
            } break;
            case 1: {
                _imgView.image = [UIImage imageNamed:@"icChangzhudiJibenziliao"];
                _titleLabel.text = @"常住地";
                _contentLabel.text = user.address.city?user.address.city:@" ";
            } break;
            case 2: {
                _imgView.image = [UIImage imageNamed:@"icShengaoJibenziliao"];
                _titleLabel.text = @"身高";
                _contentLabel.text = user.height?[NSString stringWithFormat:@"%dcm",user.height]:@" ";
            } break;
            case 3: {
                _imgView.image = [UIImage imageNamed:@"icTizhongJibenziliao"];
                _titleLabel.text = @"体重";
                _contentLabel.text = user.weight?[NSString stringWithFormat:@"%dkg",user.weight]:@" ";
                if (user.weight == kSecretWeight) {
                    _contentLabel.text = @"保密";
                }
            } break;
            case 4: {
                _imgView.image = [UIImage imageNamed:@"icZhiyeJibenziliao"];
                _titleLabel.text = @"职业";
                if (user.works_new.count) {
                    [user.works_new enumerateObjectsUsingBlock:^(ZZUserLabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == 0) {
                            _contentLabel.text = label.content;
                        } else {
                            _contentLabel.text = [NSString stringWithFormat:@"%@ %@",_contentLabel.text,label.content];
                        }
                    }];
                } else {
                    if (![ZZUserHelper shareInstance].userFirstJob) {
                        _redPointView.hidden = NO;
                    }
                }
            } break;
            default: break;
        }
    }
}

@end
