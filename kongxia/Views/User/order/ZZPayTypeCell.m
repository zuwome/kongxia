//
//  ZZPayTypeCell.m
//  zuwome
//
//  Created by angBiu on 16/8/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPayTypeCell.h"

@implementation ZZPayTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(20);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(45);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _selectImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_selectImgView];
        
        [_selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    
    return self;
}

- (void)setDataIndexPath:(NSIndexPath *)indexPath selectIndex:(NSInteger)index
{
    switch (indexPath.row) {
        case 0:
        {
            ZZUser *user = [ZZUserHelper shareInstance].loginer;
            _imgView.image = [UIImage imageNamed:@"oQianBao"];
            if (user.balance) {
                CGFloat money = [user.balance floatValue];
                _titleLabel.text = [NSString stringWithFormat:@"钱包支付 (%.2f元可用)",money];
            } else {
                
                _titleLabel.text = [NSString stringWithFormat:@"钱包支付"];
            }
        }
            break;
        case 1:
        {
            _imgView.image = [UIImage imageNamed:@"oWechat"];
            _titleLabel.text = [NSString stringWithFormat:@"微信支付"];
        }
            break;
        case 2:
        {
            _imgView.image = [UIImage imageNamed:@"oAlipay"];
            _titleLabel.text = [NSString stringWithFormat:@"支付宝支付"];
        }
            break;
        default:
            break;
    }
    
    if (indexPath.row == index) {
        _selectImgView.image = [UIImage imageNamed:@"btn_report_p"];
    } else {
        _selectImgView.image = [UIImage imageNamed:@"btn_report_n"];
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
