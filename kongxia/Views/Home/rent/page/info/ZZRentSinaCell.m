//
//  ZZRentSinaCell.m
//  zuwome
//
//  Created by angBiu on 16/8/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentSinaCell.h"

@implementation ZZRentSinaCell {
    UIView *_bgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleToFill;
        _imgView.image = [UIImage imageNamed:@"icWeiboChakanziliao"];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBrownishGreyColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"微博";
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        _headImgView = [[UIImageView alloc] init];
        _headImgView.contentMode = UIViewContentModeScaleToFill;
        _headImgView.layer.cornerRadius = 12;
        _headImgView.clipsToBounds = YES;
        [_bgView addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bgView.mas_centerY);
            make.left.mas_equalTo(_bgView.mas_left);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = kGoldenRod;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_bgView.mas_centerY);
            make.right.mas_equalTo(_bgView.mas_right);
        }];
        
        _sinaImgView = [[UIImageView alloc] init];
        _sinaImgView.contentMode = UIViewContentModeScaleToFill;
        _sinaImgView.image = [UIImage imageNamed:@"icon_rent_link"];
        [self.contentView addSubview:_sinaImgView];
        [_sinaImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(22, 19));
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(_sinaImgView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@0.5);
        }];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setData:(ZZUser *)user {
    _nameLabel.text = user.weibo.userName;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:user.weibo.iconURL]];
    CGFloat nameWidth = [ZZUtils widthForCellWithText:user.weibo.userName fontSize:15];
    CGFloat maxWidth = SCREEN_WIDTH - 85*2;
    if (nameWidth+5+24 > maxWidth) {
        nameWidth = maxWidth - 5 - 24;
    }
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(nameWidth);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
