//
//  ZZRentOrderTimeCell.m
//  zuwome
//
//  Created by angBiu on 16/6/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentOrderTimeCell.h"
#import "ZZOrder.h"
#import "ZZDateHelper.h"

@implementation ZZRentOrderTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEXCOLOR(0x999999);
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15.0];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(7, 14));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = HEXCOLOR(0x3F3A3A);
        _contentLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15.0];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_arrowImgView.mas_left).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(237, 237, 237);
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(15.0);
            make.right.equalTo(self).offset(15.0);
            make.height.equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void)setTask:(ZZTaskModel *)task indexPath:(NSIndexPath *)indexPath {
    _titleLabel.textColor = ColorHex(3f3a3a);
    _contentLabel.textColor = ColorHex(999999);
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    if (indexPath.row == 0) {
        _arrowImgView.hidden = YES;
        _titleLabel.text = @"开始时间";
        _contentLabel.text = [[ZZDateHelper shareInstance] showDateStringWithDateString:task.task.dated_at];;
    }
    else {
        _arrowImgView.hidden = YES;
        _titleLabel.text = @"时长";
        _contentLabel.text = task.task.hours ? [NSString stringWithFormat:@"%ld小时", (long)task.task.hours] : @" ";
    }
}

- (void)setOrder:(ZZOrder *)order indexPath:(NSIndexPath *)indexPath {
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_arrowImgView.mas_left).offset(-15);
    }];
    _contentLabel.textColor = ColorHex(3F3A3A);
    _arrowImgView.hidden = NO;
    if (indexPath.row == 1) {
        _titleLabel.text = @"开始时间";
        _contentLabel.text = @"";
        if (order.dated_at_type != 1) {
            
            if ([order.selectDate isEqualToString:@"今天"] || [order.selectDate isEqualToString:@"明天"] || [order.selectDate isEqualToString:@"后天"] ) {
                NSString *timeString = [[ZZDateHelper shareInstance] getDetailDateStringWithDate:order.dated_at];
                _contentLabel.text = [NSString stringWithFormat:@"%@ , %@", order.selectDate, timeString];
            } else {
                if (order.dated_at) {
                    _contentLabel.text = [[ZZDateHelper shareInstance] getDateStringWithDate:order.dated_at];
                }
            }
        } else {
            _contentLabel.text = [NSString stringWithFormat:@"尽快, %@之前", [[ZZDateHelper shareInstance] getDetailDateStringWithDate:[[ZZDateHelper shareInstance] getNextHours:4]]];
        }
    } else {
        _titleLabel.text = @"时长";
        _contentLabel.text =  order.hours?[NSString stringWithFormat:@"%d小时", order.hours]:@" ";
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
