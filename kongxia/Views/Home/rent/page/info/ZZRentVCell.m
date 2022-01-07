//
//  ZZRentVCell.m
//  zuwome
//
//  Created by angBiu on 16/6/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentVCell.h"

@implementation ZZRentVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"v"];
        _imgView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(2);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBrownishGreyColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.equalTo(_imgView.mas_centerY);
            make.height.equalTo(@20);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(_titleLabel.mas_right);
            make.height.mas_equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setData:(ZZUser *)user {
    _titleLabel.text = [NSString stringWithFormat:@"认证：%@",user.weibo.verified_reason];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
