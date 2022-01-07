//
//  ZZRentDynamicTextCell.m
//  zuwome
//
//  Created by angBiu on 2017/2/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRentDynamicTextCell.h"

@implementation ZZRentDynamicTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createViews];
    }
    
    return self;
}

- (void)createViews
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@0.5);
    }];
    
    self.typeImgView.hidden = NO;
    self.contentLabel.text = @"回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元";
    self.timeLabel.text = @" 15分钟前";
}

- (void)setData:(ZZMessageAttentDynamicModel *)model
{
    _timeLabel.text = model.created_at_text;
    _contentLabel.text = model.content;
    if ([model.type isEqualToString:@"city_change"]) {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_city"];
    } else if ([model.type isEqualToString:@"rp_add"] || [model.type isEqualToString:@"rp_take"] || [model.type isEqualToString:@"sys_rp_add"]) {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_packet"];
    } else {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_register"];
    }
}

#pragma mark - lazyload

- (UIImageView *)typeImgView
{
    if (!_typeImgView) {
        _typeImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_typeImgView];
        
        [_typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(12);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_typeImgView.mas_centerX);
            make.top.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(@1.5);
        }];
        
        [self.contentView bringSubviewToFront:_typeImgView];
    }
    return _typeImgView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeImgView.mas_right).offset(10);
            make.top.mas_equalTo(_typeImgView.mas_top).offset(3);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
    }
    return _contentLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLabel.mas_left);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(3);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
    }
    return _timeLabel;
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
