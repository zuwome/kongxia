//
//  ZZPublishOrderLocationCell.m
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPublishOrderNormalCell.h"

#import "ZZDateHelper.h"

@interface ZZPublishOrderNormalCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;

@end

@implementation ZZPublishOrderNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.imgView.hidden = YES;
        self.leftLabel.hidden = NO;
        self.contentLabel.text = @"不限地区";
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void)setData:(NSIndexPath *)indexPath skill:(ZZSkill *)skill param:(NSDictionary *)param
{
    _arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 2:
        {
            if (skill.type) {
                _imgView.image = [UIImage imageNamed:@"icon_task_location_p"];
                self.leftLabel.text = @"任务地点";
                NSString *location = @"";
                if (skill.type == 1) {//线下
                    location = [param objectForKey:@"address"];
                    if (isNullString(location)) {
                        self.leftLabel.textColor = RGBCOLOR(181, 181, 181);
                    } else {
                        self.leftLabel.textColor = [UIColor blackColor];
                    }
                } else {//线上
                    NSString *region = [param objectForKey:@"region"];
                    if ([region isEqualToString:@"3"]) {
                        location = @"不限地区";
                    } else if ([region isEqualToString:@"2"]) {
                        location = @"附近";
                    } else {
                        location = region;
                    }
                    self.leftLabel.textColor = [UIColor blackColor];
                }
                if (isNullString(location)) {
                    _contentLabel.text = @"地点";
                    _contentLabel.textColor = HEXCOLOR(0xbbbbbb);
                } else {
                    _contentLabel.text = location;
                    _contentLabel.textColor = kBlackTextColor;
                    _arrowImgView.image = [UIImage imageNamed:@"icon_order_right"];
                    self.selectionStyle = UITableViewCellSelectionStyleDefault;
                }
            } else {
                _imgView.image = [UIImage imageNamed:@"icon_task_location_n"];
                self.leftLabel.text = @"任务地点";
                _contentLabel.text = @"地点";
                _contentLabel.textColor = HEXCOLOR(0xbbbbbb);
            }
        }
            break;
        case 3:
        {
            if (skill.type == 1) {
                _imgView.image = [UIImage imageNamed:@"icon_task_time_p"];
            } else {
                _imgView.image = [UIImage imageNamed:@"icon_task_time_n"];
            }
            self.leftLabel.text = @"时间";
            NSString *hourString = [NSString stringWithFormat:@"%@小时",[param objectForKey:@"hours"]];;
            NSInteger hour = [[param objectForKey:@"hours"] integerValue];
            if (hour == 0) {
                _contentLabel.text = @"时间";
                _contentLabel.textColor = HEXCOLOR(0xbbbbbb);
                self.leftLabel.textColor = RGBCOLOR(181, 181, 181);
            } else {
                _contentLabel.textColor = kBlackTextColor;
                NSInteger type = [[param objectForKey:@"dated_at_type"] integerValue];
                NSString *dateString = @"";
                if (type != 1) {
                    NSDate *date = [[ZZDateHelper shareInstance] getDateWithDateString:[param objectForKey:@"dated_at"]];
                    if (date) {
                        dateString = [[ZZDateHelper shareInstance] getDateStringWithDate:date];
                    }
                } else {
                    dateString = [NSString stringWithFormat:@"%@(%@)前",kOrderQuickTimeString,[[ZZDateHelper shareInstance] getDetailDateStringWithDate:[[ZZDateHelper shareInstance] getNextHours:2]]];
                }
                NSString *sumString = [NSString stringWithFormat:@"%@,%@",dateString,hourString];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sumString];
                [attributedString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:[sumString rangeOfString:hourString]];
                _contentLabel.attributedText = attributedString;
                _arrowImgView.image = [UIImage imageNamed:@"icon_order_right"];
                self.selectionStyle = UITableViewCellSelectionStyleDefault;
                
                self.leftLabel.textColor = [UIColor blackColor];
            }
        }
            break;
        case 4:
        {
            if (skill.type == 1) {
                _imgView.image = [UIImage imageNamed:@"icon_task_money_p"];
            } else {
                _imgView.image = [UIImage imageNamed:@"icon_task_money_n"];
            }
            self.leftLabel.text = @"金额";
            CGFloat price = [[param objectForKey:@"price"] floatValue];
            if (price == 0) {
                _contentLabel.text = @"金额";
                _contentLabel.textColor = HEXCOLOR(0xbbbbbb);
                self.leftLabel.textColor = RGBCOLOR(181, 181, 181);
            } else {
                _contentLabel.text = [NSString stringWithFormat:@"%@元/每人",[param objectForKey:@"price"]];
                _contentLabel.textColor = kBlackTextColor;
                _arrowImgView.image = [UIImage imageNamed:@"icon_order_right"];
                self.selectionStyle = UITableViewCellSelectionStyleDefault;
                
                self.leftLabel.textColor = [UIColor blackColor];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -

-(UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.textColor = RGBCOLOR(181, 181, 181);
        _leftLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:_leftLabel];
        
        [_leftLabel setContentHuggingPriority:(UILayoutPriorityDefaultHigh + 1) forAxis:(UILayoutConstraintAxisHorizontal)];
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _leftLabel;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(@22);
        }];
    }
    return _imgView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_order_right"];
        [self.contentView addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(7.3, 15));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowImgView.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.leftLabel.mas_right).offset(24);
        }];
    }
    return _contentLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
