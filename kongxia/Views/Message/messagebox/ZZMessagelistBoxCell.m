//
//  ZZMessagelistBoxCell.m
//  zuwome
//
//  Created by angBiu on 2017/6/22.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZMessagelistBoxCell.h"

@implementation ZZMessagelistBoxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(@0.5);
        }];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.cornerRadius = 20;
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kBGColor;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_top);
            make.left.mas_equalTo(_imgView.mas_right).offset(15);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-40);
            make.bottom.mas_equalTo(_imgView.mas_bottom);
        }];
        
        _unreadCountLabel = [[UILabel alloc] init];
        _unreadCountLabel.textAlignment = NSTextAlignmentCenter;
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.font = [UIFont systemFontOfSize:10];
        _unreadCountLabel.backgroundColor = kRedPointColor;
        _unreadCountLabel.layer.cornerRadius = 8;
        _unreadCountLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadCountLabel];
        
        [_unreadCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(_contentLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    
    return self;
}

- (void)setData
{
    _imgView.image = [UIImage imageNamed:@"icon_messagebox"];
    ZZMessageBoxConfigModel *model = [ZZUserHelper shareInstance].unreadModel.say_hi;
    _titleLabel.text = [NSString stringWithFormat:@"有%ld个人和你打招呼",model.user_count > 8 ? 8 : model.user_count];
    _contentLabel.text = model.content;
    if ([model.videoMessageType isEqualToString:@"视屏挂断的消息"]) {
        _contentLabel.text = @"[视屏通话]";
    }
    _timeLabel.text = model.latest_at_text;
    
    CGFloat timeWidth = [ZZUtils widthForCellWithText:_timeLabel.text fontSize:11];
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(timeWidth);
    }];
    if (model.count == 0) {
        _unreadCountLabel.hidden = YES;
    } else {
        _unreadCountLabel.hidden = NO;
        if (model.count > 8) {
            _unreadCountLabel.text = @"8";
        } else {
            _unreadCountLabel.text = [NSString stringWithFormat:@"%ld",model.count];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        _unreadCountLabel.backgroundColor = kRedColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        _unreadCountLabel.backgroundColor = kRedColor;
    }
}

@end
