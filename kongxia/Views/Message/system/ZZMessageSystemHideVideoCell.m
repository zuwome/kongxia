//
//  ZZMessageSystemHideVideo.m
//  zuwome
//
//  Created by 潘杨 on 2018/2/6.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZMessageSystemHideVideoCell.h"
#import "ZZSystemMessageModel.h"

@implementation ZZMessageSystemHideVideoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kBGColor;
        
        UIView *timeBgView = [[UIView alloc] init];
        timeBgView.backgroundColor = HEXCOLOR(0xD8D8D8);
        timeBgView.layer.cornerRadius = 2;
        [self.contentView addSubview:timeBgView];
        
        [timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(12);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.height.equalTo(@20);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = HEXCOLOR(0xD8D8D8);
        [timeBgView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeBgView.mas_top).offset(2);
            make.bottom.mas_equalTo(timeBgView.mas_bottom).offset(-2);
            make.left.mas_equalTo(timeBgView.mas_left).offset(5);
            make.right.mas_equalTo(timeBgView.mas_right).offset(-5);
        }];
        
        _headImgView = [[UIImageView alloc] init];
        _headImgView.clipsToBounds = NO;
        _headImgView.layer.cornerRadius = 18;
        _headImgView.contentMode = UIViewContentModeScaleToFill;
        _headImgView.image = [UIImage imageNamed:@"icon_chat_system"];
        _headImgView.backgroundColor = kBGColor;
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.top.mas_equalTo(timeBgView.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.contentMode = UIViewContentModeScaleToFill;
        UIImage *img = [UIImage imageNamed:@"icon_message_system_bubble"];
        _bgImgView.image = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
        [self.contentView addSubview:_bgImgView];
        
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(4);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-40);
            make.top.mas_equalTo(_headImgView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];

        _contentImgView = [[UIImageView alloc] init];
        _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImgView.image = [UIImage imageNamed:@"system_contentImgView"];
        _contentImgView.clipsToBounds = YES;
        [_bgImgView addSubview:_contentImgView];
        
        [_contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
            make.top.mas_equalTo(_bgImgView.mas_top).offset(20);
            make.width.mas_equalTo(51);
            make.height.mas_equalTo(51);
//            make.bottom.mas_equalTo(_bgImgView.mas_bottom).offset(-20);
        }];
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor whiteColor];
        [_bgImgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentImgView.mas_right).offset(10);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_contentImgView);
        }];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColor.whiteColor;
        
        [_bgImgView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentImgView.mas_left);
            make.top.mas_equalTo(_contentImgView.mas_bottom).offset(20);
            make.right.mas_equalTo(_bgImgView.mas_right);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setData:(ZZSystemMessageModel *)model {
    if (isNullString(model.message.created_at_text)) {
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@0);
        }];
    }
    else {
        _timeLabel.text = model.message.created_at_text;
    }
    _contentLabel.text = model.message.content;
    
//  全站隐藏
    if ([model.message.type isEqualToString:@"video_hide"]) {
        NSString *coverUrl = [NSString stringWithFormat:@"%@",model.message.cover_url];
        [_contentImgView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
    }
   else if ([model.message.type isEqualToString:@"mcoin_recharge_cancel"]) {
       _contentImgView.image = [UIImage imageNamed:@"system_contentImgView"];
    }
   else if ([model.message.type isEqualToString:@"qchat_pass"]) {
       _contentImgView.image = [UIImage imageNamed:@"icon_icFastChat"];

   }
   else if ([model.message.type isEqualToString:@"to_wechatseen_bad_comment"]) {
       _contentImgView.image = [UIImage imageNamed:@"icCpXtxx"];
   }
   else if ([model.message.type isEqualToString:@"from_wechatseen_report_ok"]) {
       // 用户查看微信举报成功用户
       _contentImgView.image = [UIImage imageNamed:@"icDyqXtxx"];
   }
   else if ([model.message.type isEqualToString:@"pd_give"]) {
       // 用户查看微信举报成功用户
       _contentImgView.image = [UIImage imageNamed:@"icMebiJfdh"];
   }
   else if ([model.message.type isEqualToString:@"order_xdf"]) {
       // 下单费
       _contentImgView.image = [UIImage imageNamed:@"icMebiJfdh"];
   }
   else if ([model.message.type isEqualToString:@"bio_msg"]) {
       // 下单费
       _contentImgView.image = [UIImage imageNamed:@"icWenzi"];
   }
    else if ([model.message.type isEqualToString:@"nickname_msg"]) {
        // 下单费
        _contentImgView.image = [UIImage imageNamed:@"icWenzi"];
    }
    CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
    if (height < 60) {
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentImgView.mas_right).offset(10);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_contentImgView);
        }];
        
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentImgView.mas_left);
            make.top.mas_equalTo(_contentImgView.mas_bottom).offset(20);
            make.right.mas_equalTo(_bgImgView.mas_right);
            make.bottom.equalTo(_bgImgView);
            make.height.equalTo(@0.5);
        }];
    }
    else {
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentImgView);
            make.left.mas_equalTo(_contentImgView.mas_right).offset(10);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-10);
        }];
        
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(20);
            make.right.mas_equalTo(_bgImgView.mas_right);
            make.bottom.equalTo(_bgImgView);
            make.height.equalTo(@0.5);
        }];
    }
}


@end
