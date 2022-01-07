//
//  ZZTimelineCell.m
//  zuwome
//
//  Created by wlsy on 16/1/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTimelineCell.h"
#import "ZZMessage.h"

@implementation ZZTimelineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _cycleView = [[UIView alloc] init];
        _cycleView.backgroundColor = [UIColor whiteColor];
        _cycleView.layer.cornerRadius = 3.5;
        _cycleView.clipsToBounds = YES;
        [self.contentView addSubview:_cycleView];
        
        [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_left).offset(28);
            make.top.mas_equalTo(self.contentView.mas_top).offset(3);
            make.size.mas_equalTo(CGSizeMake(7, 7));
        }];
        
        _cycleImgView = [[UIImageView alloc] init];
        _cycleImgView.image = [UIImage imageNamed:@"icon_order_cycle"];
        _cycleImgView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_cycleImgView];
        
        [_cycleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_cycleView.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_top).offset(3);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_cycleImgView.mas_bottom);
            make.centerX.mas_equalTo(_cycleView.mas_centerX);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(3);
            make.width.mas_equalTo(1);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(45);
            make.top.mas_equalTo(self.contentView.mas_top);
        }];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.font = [UIFont systemFontOfSize:13];
        _infoLabel.numberOfLines = 0;
        [self.contentView addSubview:_infoLabel];
        
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(_timeLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-35);
        }];
    }
    
    return self;
}

- (void)setMessage:(ZZMessage *)message indexPath:(NSIndexPath *)indexPath count:(NSInteger)count
{
    if (indexPath.row == 0) {
        [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_cycleImgView.mas_bottom);
        }];
        _cycleImgView.hidden = NO;
        _cycleView.hidden = YES;
    } else {
        [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_cycleView.mas_bottom);
        }];
        _cycleImgView.hidden = YES;
        _cycleView.hidden = NO;
    }
    if (indexPath.row == count-1) {
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
    self.timeLabel.text = [message dateString];
    self.infoLabel.text = message.content;
}

- (void)setMessage:(ZZMessage *)message
{
    self.timeLabel.text = [message dateString];
    self.infoLabel.text = message.content;
}

@end
