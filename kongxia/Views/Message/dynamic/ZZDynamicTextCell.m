//
//  ZZDynamicTextCell.m
//  zuwome
//
//  Created by angBiu on 2017/2/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZDynamicTextCell.h"

@implementation ZZDynamicTextCell

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
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@0.5);
    }];
    
    WeakSelf;
    self.headImgView.touchHead = ^{
        [weakSelf headImgClick];
    };
    self.typeImgView.hidden = NO;
    self.nameLabel.text = @"潇洒电线杆电线杆电线杆";
    [self.levelImgView setLevel:1];
    self.timeLabel.text = @" 15分钟前";
    self.contentLabel.text = @"回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元回答了1个么么答，获得打赏1000元";
}

- (void)setData:(ZZMessageAttentDynamicModel *)model
{
    [_headImgView setUser:model.from width:38 vWidth:8];
    _nameLabel.text = model.from.nickname;
    _timeLabel.text = model.created_at_text;
    _contentLabel.text = model.content;
    [_levelImgView setLevel:model.from.level];
    if ([model.type isEqualToString:@"city_change"]) {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_city"];
    } else if ([model.type isEqualToString:@"rp_add"] || [model.type isEqualToString:@"rp_take"] || [model.type isEqualToString:@"sys_rp_add"]) {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_packet"];
    } else {
        _typeImgView.image = [UIImage imageNamed:@"icon_dynamic_register"];
    }
    
    CGFloat timeWidth = [ZZUtils widthForCellWithText:_timeLabel.text fontSize:11];
    CGFloat maxWidth = SCREEN_WIDTH - 10 - 38 - 3 - 30 - 8 - 5 - 30 - 5 - timeWidth - 10;
    CGFloat nameWidth = [ZZUtils widthForCellWithText:_nameLabel.text fontSize:13];
    if (nameWidth>maxWidth) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
    }
    if (model.star == 1) {
        self.recommendView.hidden = NO;
        [self.recommendView viewAnimation];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-30);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10-55);
        }];
    } else {
        self.recommendView.hidden = YES;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
    }
}

#pragma mark - UIButtonMethod

- (void)headImgClick
{
    if (_touchHead) {
        _touchHead();
    }
}

#pragma mark - lazyload

- (ZZHeadImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[ZZHeadImageView alloc] init];
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
    }
    return _headImgView;
}

- (UIImageView *)typeImgView
{
    if (!_typeImgView) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(18);
            make.top.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(@1.5);
        }];
        
        _typeImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_typeImgView];
        
        [_typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(lineView.mas_centerX);
            make.centerY.mas_equalTo(_headImgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return _typeImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kYellowColor;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeImgView.mas_right).offset(8);
            make.top.mas_equalTo(_headImgView.mas_top);
        }];
    }
    return _nameLabel;
}

- (ZZLevelImgView *)levelImgView
{
    if (!_levelImgView) {
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self.contentView addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
    }
    return _levelImgView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        }];
    }
    return _timeLabel;
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
            make.left.mas_equalTo(_nameLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
    }
    return _contentLabel;
}

- (ZZDynamicRecomendView *)recommendView
{
    if (!_recommendView) {
        _recommendView = [[ZZDynamicRecomendView alloc] init];
        [self.contentView addSubview:_recommendView];
        
        [_recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
    }
    return _recommendView;
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
