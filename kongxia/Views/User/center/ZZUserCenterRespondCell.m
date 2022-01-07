//
//  ZZUserCentRespondCell.m
//  zuwome
//
//  Created by angBiu on 2017/4/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserCenterRespondCell.h"

@implementation ZZUserCenterRespondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.readView.titleLaebl.text = @"浏览数";
        self.appointmentView.titleLaebl.text = @"预约数";
        self.respondPercentView.titleLaebl.text = @"响应率";
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:arrowImgView];
        
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 12.5));
        }];
    }
    
    return self;
}

- (void)setData:(ZZUser *)user
{
    _readView.contentLabel.text = [NSString stringWithFormat:@"%ld",user.last_days.bebrowsed_count];
    _appointmentView.contentLabel.text = [NSString stringWithFormat:@"%ld",user.last_days.beordered_count];
    _respondPercentView.contentLabel.text = [NSString stringWithFormat:@"%ld%%",user.last_days.order_respond_rate];
}

#pragma mark - 

- (ZZUserCenterRespondItemView *)readView
{
    if (!_readView) {
        _readView = [[ZZUserCenterRespondItemView alloc] init];
        _readView.contentLabel.text = @"20";
        [self.contentView addSubview:_readView];
        
        [_readView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/3.0);
        }];
    }
    return _readView;
}

- (ZZUserCenterRespondItemView *)appointmentView
{
    if (!_appointmentView) {
        _appointmentView = [[ZZUserCenterRespondItemView alloc] init];
        _appointmentView.contentLabel.text = @"20";
        [self.contentView addSubview:_appointmentView];
        
        [_appointmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.mas_equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/3.0);
        }];
    }
    return _appointmentView;
}

- (ZZUserCenterRespondItemView *)respondPercentView
{
    if (!_respondPercentView) {
        _respondPercentView = [[ZZUserCenterRespondItemView alloc] init];
        _respondPercentView.contentLabel.text = @"20";
        [self.contentView addSubview:_respondPercentView];
        
        [_respondPercentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/3.0);
        }];
    }
    return _respondPercentView;
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
