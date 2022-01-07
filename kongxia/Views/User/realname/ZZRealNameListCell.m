//
//  ZZRealNameListCell.m
//  zuwome
//
//  Created by angBiu on 16/7/7.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRealNameListCell.h"
#import "ZZOrder.h"

@implementation ZZRealNameListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = kBGColor;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 3;
        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(12);
            make.left.mas_equalTo(self.contentView.mas_left).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        _logoImgView = [[UIImageView alloc] init];
        _logoImgView.contentMode = UIViewContentModeLeft;
        [bgView addSubview:_logoImgView];
        
        [_logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(25);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 68));
        }];
        
        _idImgView = [[UIImageView alloc] init];
        _idImgView.image = [UIImage imageNamed:@"icon_identifier"];
        [bgView addSubview:_idImgView];
        
        [_idImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(95);
            make.top.mas_equalTo(_logoImgView.mas_top);
            make.size.mas_equalTo(CGSizeMake(20, 15));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_idImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_idImgView.mas_centerY);
        }];
        
        _rzLabel = [[UILabel alloc] init];
        _rzLabel.textAlignment = NSTextAlignmentRight;
        _rzLabel.textColor = kGrayTextColor;
        _rzLabel.font = [UIFont systemFontOfSize:11];
        [bgView addSubview:_rzLabel];
        
        [_rzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_idImgView.mas_centerY);
        }];
        
        _rzImgView = [[UIImageView alloc] init];
        [bgView addSubview:_rzImgView];
        
        [_rzImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_rzLabel.mas_left).offset(-3);
            make.centerY.mas_equalTo(_rzLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(11, 11));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kGrayTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        [bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_logoImgView.mas_bottom);
            make.left.mas_equalTo(_idImgView.mas_left);
            make.right.mas_equalTo(_rzLabel.mas_right);
        }];
        
        bgView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        bgView.layer.shadowOffset = CGSizeMake(0, 1);
        bgView.layer.shadowOpacity = 0.9;
        bgView.layer.shadowRadius = 1;
    }
    
    return self;
}

- (void)setUer:(ZZUser *)user IndexPath:(NSIndexPath *)indexPath
{
    BOOL showRealName = NO;
    if (indexPath.row == 0) {
//        _logoImgView.image = [UIImage imageNamed:@"icon_realname_zhima"];
//        _titleLabel.text = @"芝麻信用认证";
//        _rzImgView.image = [UIImage imageNamed:@"icon_realname_rz_n"];
//        _contentLabel.text = @"绑定芝麻信用即可获得实名认证，提现交易安全便捷";
//        _rzLabel.text = @"未认证";
//        
//        if (user.zmxy.openid) {
//            _rzImgView.image = [UIImage imageNamed:@"icon_realname_rz_p"];
//            _rzLabel.text = @"已认证";
//        } else {
//            _rzImgView.image = [UIImage imageNamed:@"icon_realname_rz_n"];
//            _rzLabel.text = @"未认证";
//        }
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        return;
    } else if (indexPath.row == 1) {
        if (user.realname.status == 2 || user.realname_abroad.status != 2) {
            showRealName = YES;
        }
    }
    if (showRealName) {
        _logoImgView.image = [UIImage imageNamed:@"icon_realname_realname"];
        _titleLabel.text = @"身份信息认证";
        _contentLabel.text = @"持有大陆通用身份证的用户可通过此方式获得实名认证";
        
        if ([ZZUtils isIdentifierAuthority:user]) {
            _rzImgView.image = [UIImage imageNamed:@"icon_realname_rz_p"];
            _rzLabel.text = @"已认证";
        } else {
            _rzImgView.image = [UIImage imageNamed:@"icon_realname_rz_n"];
            _rzLabel.text = @"未认证";
        }
    } else {
        _logoImgView.image = [UIImage imageNamed:@"icon_realname_notmainland"];
        if (SCREEN_WIDTH < 350) {
            _titleLabel.text = @"港澳台及海外用户";
        } else {
            _titleLabel.text = @"港澳台及海外用户认证";
        }
        _contentLabel.text = @"无大陆通用身份证的用户可通过此方式获得实名认证";
        
        if (user.realname_abroad.status == 2) {
            _rzImgView.image = [UIImage imageNamed:@"icon_realname_rz_p"];
            _rzLabel.text = @"已认证";
        } else {
            _rzImgView.image = [UIImage imageNamed:@"icon_realname_rz_n"];
            _rzLabel.text = @"未认证";
        }
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
