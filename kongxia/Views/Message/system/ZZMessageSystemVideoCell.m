//
//  ZZMessageSystemVideoCell.m
//  zuwome
//
//  Created by YuTianLong on 2017/11/28.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZMessageSystemVideoCell.h"

#import "ZZSystemMessageModel.h"

@implementation ZZMessageSystemVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
//            make.center.equalTo(timeBgView);
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
        
//        CGFloat height = (SCREEN_WIDTH - 90)/900 * 500;
        _contentImgView = [[UIImageView alloc] init];
        _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImgView.backgroundColor = kBGColor;
        _contentImgView.image = [UIImage imageNamed:@"icon_icShipin"];
        _contentImgView.clipsToBounds = YES;
        [_bgImgView addSubview:_contentImgView];
        
        [_contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
            make.top.mas_equalTo(_bgImgView.mas_top).offset(10);
            make.width.mas_equalTo(51);
            make.height.mas_equalTo(51);
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
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-5);
            make.top.mas_equalTo(_contentImgView);
        }];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = kLineViewColor;
        
        [_bgImgView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentImgView.mas_left);
            make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
            make.right.mas_equalTo(_bgImgView.mas_right);
            make.height.equalTo(@0.5);
        }];
        
        //icon_icSubmitAgain
        self.againLabel = [UILabel new];
        _againLabel.text = @"重新提交";
        _againLabel.textAlignment = NSTextAlignmentLeft;
        _againLabel.textColor = RGBCOLOR(74, 144, 226);
        _againLabel.font = [UIFont systemFontOfSize:14];
        
        [_bgImgView addSubview:_againLabel];
//        [_againLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_lineView.mas_bottom).offset(5);
//            make.left.mas_equalTo(_contentImgView.mas_left);
//            make.height.greaterThanOrEqualTo(@25);
//            make.bottom.mas_equalTo(_bgImgView.mas_bottom).offset(-5);
//        }];
        
        UIImageView *arrowImageView = [UIImageView new];
        arrowImageView.image = [UIImage imageNamed:@"icon_icSubmitAgain"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        arrowImageView.clipsToBounds = YES;
        [_bgImgView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_againLabel.mas_centerY);
            make.height.mas_equalTo(25);
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
    
    _contentImgView.hidden = NO;
    
    if ([model.message.type isEqualToString:@"id_photo_unpass"]
        || [model.message.type isEqualToString:@"upload_id_photo"]
        || ([model.message.type isEqualToString:@"system"] && model.message.media_type == 3)) {
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:12]];
        if (height < 36) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
    }
    
    if ([model.message.type isEqualToString:@"base_video"]) {
        _contentImgView.image = [UIImage imageNamed:@"icon_icShipin"];
        _againLabel.text = @"重新提交";
    }
    else if ([model.message.type isEqualToString:@"rent_expired"]) {
        _contentImgView.image = [UIImage imageNamed:@"icService"];
        _againLabel.text = @"立即续费";
    }
    else if ([model.message.type isEqualToString:@"qchat_unpass"]) {
        _contentImgView.image = [UIImage imageNamed:@"icon_icFastChat"];
        _againLabel.text = @"重新申请";
    }
    else if ([model.message.type isEqualToString:@"video_hot"]) {
        NSString *coverUrl = [NSString stringWithFormat:@"%@",model.message.cover_url];
        [_contentImgView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
        _againLabel.text = @"立即查看";
    }
    else if ([model.message.type isEqualToString:@"withdraw_fail"]) {
        _contentImgView.image = [UIImage imageNamed:@"icAccountBalanceBig"];
        _againLabel.text = @"查看帮助中心";
        
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:12]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
    }
    else if ([model.message.type isEqualToString:@"score_expired"]||[model.message.type isEqualToString:@"score_expired_soon"]) {
        //积分即将过期,与积分过期
        _contentImgView.image = [UIImage imageNamed:@"systemMessage_jiFen"];
        _againLabel.text = @"立即查看";
    }
    else if ([model.message.type isEqualToString:@"id_photo_unpass"]  || [model.message.type isEqualToString:@"upload_id_photo"]) {
        _contentImgView.image = [UIImage imageNamed:@"IDPhotoIcon"];
        _againLabel.text = @"去上传";
    }
    else if ([model.message.type isEqualToString:@"to_order"] ||
             [model.message.type isEqualToString:@"rent_success"]) {
        _contentImgView.hidden = YES;
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgImgView).offset(15);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-5);
            make.top.mas_equalTo(_contentImgView);
        }];
        
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentImgView.mas_left);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
            make.right.mas_equalTo(_bgImgView.mas_right);
            make.height.equalTo(@0.5);
        }];
        _againLabel.text = @"邀约流程";
    }
    else if ([model.message.type isEqualToString:@"see_user_guide"]) {
        _contentImgView.hidden = YES;
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgImgView).offset(15);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-5);
            make.top.mas_equalTo(_contentImgView);
        }];
        _againLabel.text = @"立即查看新手指南";
    }
    else if ([model.message.type isEqualToString:@"apply_rent"]) {
        // 1.申请达人
        NSString *coverUrl = [NSString stringWithFormat:@"%@",model.message.img];
        [_contentImgView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
        _againLabel.text = @"申请达人";
    }
    else if ([model.message.type isEqualToString:@"re_upload"]) {
        // 2/6.重新上传
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:12]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        NSString *coverUrl = [NSString stringWithFormat:@"%@",model.message.img];
        [_contentImgView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
        _againLabel.text = @"重新上传";
    }
    else if ([model.message.type isEqualToString:@"fill_info"]) {
        // 4.去完善资料
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:12]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        _contentImgView.image = [UIImage imageNamed:@"icTxshtgXtxx"];
        _againLabel.text = @"去完善资料";
    }
    else if ([model.message.type isEqualToString:@"upload_photo"]) {
        // 5.去上传(只有在人工审核的情况下才会发送该消息)

//        NSString *coverUrl = [NSString stringWithFormat:@"%@",model.message.cover_url];
//        [_contentImgView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:12]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        _contentImgView.image = [UIImage imageNamed:@"icTxshsbXtxx"];
        _againLabel.text = @"去上传";
    }
    else if ([model.message.type isEqualToString:@"to_show"]) {
        // 7.去上架(只有在人工审核的情况下才会发送该消息): 出租状态在隐身中，头像提交人工审核的用户.
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icYsXtxx"];
        _againLabel.text = @"去上架";
    }
    else if ([model.message.type isEqualToString:@"to_wechatseen_48"]) {
        // 用户查看后48小时双方无操作，则提示24小时内内确认  达人
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icCkwxXtxx"];
        _againLabel.text = @"确认添加";
    }
    else if ([model.message.type isEqualToString:@"from_wechatseen_48"]) {
        // 用户查看后48小时双方无操作，则提示24小时内内确认。 用户
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icCkwxXtxx"];
        _againLabel.text = @"去确认";
    }
    else if ([model.message.type isEqualToString:@"to_ok_wechatseen_24"]) {
        // 达人确认添加后24小时，提示用户24小时内确认   用户
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icCkwxXtxx"];
        _againLabel.text = @"去确认";
    }
    else if ([model.message.type isEqualToString:@"to_wechatseen_report"]) {
        // 达人被举报通知达人
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icWxhjbXtxx"];
        _againLabel.text = @"查看详情";
    }
    else if ([model.message.type isEqualToString:@"to_wechatseen_report_ok"]) {
        // 达人被举报成功通知达人
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icWxhjbXtxx"];
        _againLabel.text = @"查看详情";
    }
    else if ([model.message.type isEqualToString:@"pd_before_30minute"]) {
        // 邀约时间开始时间前30分钟
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icYaoyueXtxx"];
        _againLabel.text = @"查看详情";
    }
    else if ([model.message.type isEqualToString:@"pdg_before30_minute"]) {
        // 活动自动过期
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"group43"];
        _againLabel.text = @"查看详情";
    }
    else if ([model.message.type isEqualToString:@"pdg_start"]) {
        // 活动生成邀约
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"group43"];
        _againLabel.text = @"查看详情";
    }
    else if ([model.message.type isEqualToString:@"pd_four_refund"]) {
            // 无人报名自动结束
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"group43"];
        _againLabel.text = @"查看详情";
    }
    else if ([model.message.type isEqualToString:@"skill_nopass_photo_msg"]) {
        // 技能不合格通知类型
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icTupianShenghe"];
        _againLabel.text = @"重新上传";
    }
    else if ([model.message.type isEqualToString:@"skill_photo_msg"]) {
        //  技能系统消息
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icTupianShenghe"];
        _againLabel.text = @"查看详情";
    }
    else if ([model.message.type isEqualToString:@"skill_nopass_content_msg"]) {
        // 技能文字不合格通知类型
        CGFloat height = [NSString findHeightForText:model.message.content havingWidth:198 andFont:[UIFont systemFontOfSize:15]];
        if (height < 34) {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_contentImgView.mas_left);
                make.top.mas_equalTo(_contentImgView.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        else {
            [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
                make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
                make.right.mas_equalTo(_bgImgView.mas_right);
                make.height.equalTo(@0.5);
            }];
        }
        
        _contentImgView.image = [UIImage imageNamed:@"icTupianShenghe"];
        _againLabel.text = @"查看详情";
    }
    [_againLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.mas_bottom).offset(5);
        make.left.mas_equalTo(_contentImgView.mas_left);
        make.height.equalTo(@25);
        make.bottom.mas_equalTo(_bgImgView.mas_bottom).offset(-5);
    }];

}

@end
