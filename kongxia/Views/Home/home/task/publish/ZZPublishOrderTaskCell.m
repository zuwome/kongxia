//
//  ZZPublishOrderTaskCell.m
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZPublishOrderTaskCell.h"

@interface ZZPublishOrderTaskCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *liveImgView;
@property (nonatomic, strong) UIImageView *arrowImgView;

@end

@implementation ZZPublishOrderTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.typeLabel.text = @"做什么";
        self.imgView.image = [UIImage imageNamed:@"icon_task_p"];
        self.imgView.hidden = YES;
        
        self.leftLabel.hidden = NO;
        
        if ([ZZUserHelper shareInstance].configModel.skill) {
            self.contentLabel.text = [ZZUserHelper shareInstance].configModel.skill.des;
        } else {
            NSInteger beginPrice = 5;
            NSInteger extraPrice = 2;
            if ([ZZUserHelper shareInstance].configModel.skill) {
                beginPrice = [ZZUserHelper shareInstance].configModel.skill.begin_price;
                extraPrice = [ZZUserHelper shareInstance].configModel.skill.extra_price;
            }
            self.contentLabel.text = [NSString stringWithFormat:@"前2分钟%ld元，每加一分钟%ld元",(long)beginPrice,extraPrice];
        }
        
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

- (void)setData:(ZZSkill *)skill
{
    _liveImgView.hidden = YES;
    _contentLabel.hidden = YES;
    _typeLabel.textColor = kBlackTextColor;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    _arrowImgView.image = [UIImage imageNamed:@"icon_order_right"];
    if (skill.type == 1) {
        _typeLabel.text = skill.name;
    } else if (skill.type == 2) {
        _liveImgView.hidden = NO;
        _contentLabel.hidden = NO;
        _typeLabel.text = skill.name;
    } else {
        _typeLabel.text = @"做什么";
        _typeLabel.textColor = kBlackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
    }
}

#pragma mark -

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.text = @"任务";
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(_typeLabel.mas_centerY);
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
            make.centerY.mas_equalTo(_typeLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
    }
    return _imgView;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = kBlackTextColor;
        _typeLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_typeLabel];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-35);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@55);
        }];
        
        _liveImgView = [[UIImageView alloc] init];
        _liveImgView.image = [UIImage imageNamed:@"icon_livestream_video"];
        _liveImgView.hidden = YES;
        [self.contentView addSubview:_liveImgView];
        
        [_liveImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_typeLabel.mas_left).offset(-12);
            make.centerY.mas_equalTo(_typeLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_order_right"];
        [self.contentView addSubview:_arrowImgView];
        
        [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(_typeLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(7.3, 15));
        }];
    }
    return _typeLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HEXCOLOR(0x9B9B9B);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_typeLabel.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
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
