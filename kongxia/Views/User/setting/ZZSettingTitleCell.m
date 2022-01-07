//
//  ZZSettingTitleCell.m
//  zuwome
//
//  Created by angBiu on 16/9/5.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSettingTitleCell.h"

@implementation ZZSettingTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 17));
        }];
    }
    
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _lineView.hidden = NO;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    _titleLabel.text = @"账号和安全";
                }
                    break;
                case 1:
                {
                    _titleLabel.text = @"行程安全";
                    _lineView.hidden = YES;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    _titleLabel.text = @"新消息提醒";
                }
                    break;
                case 1:
                {
                    _titleLabel.text = @"隐私";
                }
                    break;
                case 2:
                {
                    _titleLabel.text = @"通用";
                    _lineView.hidden = YES;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    _titleLabel.text = @"尊享客服微信";
                }
                    break;
                case 1:
                {
                    _titleLabel.text = @"关于空虾";
                }
                    break;
//                case 2:
//                {
//                    _titleLabel.text = @"帮助和反馈";
//                }
//                    break;
                case 2:
                {
                    _titleLabel.text = @"免责声明";
                }
                    break;
                case 3:
                {
                    _titleLabel.text = @"应用评分";
                    _lineView.hidden = YES;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
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
