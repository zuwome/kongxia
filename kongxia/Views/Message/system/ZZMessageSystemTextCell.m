//
//  ZZMessageSystemTextCell.m
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageSystemTextCell.h"

#import "ZZSystemMessageModel.h"

@interface ZZMessageSystemTextCell()

@property (nonatomic, strong) ZZSystemMessageModel *model;

@end

@implementation ZZMessageSystemTextCell

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
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];

        if (fontFirst ==nil) {
            _titleLabel.font = [UIFont systemFontOfSize:15];
        }else{
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15]
            ;}
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [_bgImgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgImgView.mas_top).offset(10);
            make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-10);

        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor whiteColor];
        [_bgImgView addSubview:_contentLabel];
        
        [_contentLabel setContentHuggingPriority:(UILayoutPriorityDefaultHigh + 1) forAxis:(UILayoutConstraintAxisVertical)];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgImgView.mas_left).offset(15);
            make.top.mas_equalTo(_titleLabel.mas_bottom);
            make.right.mas_equalTo(_bgImgView.mas_right).offset(-5);
            make.bottom.mas_equalTo(_bgImgView.mas_bottom).offset(-10);
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
    _titleLabel.text = model.message.title;
    _contentLabel.text = model.message.content;
    if (model.message.title == nil) {
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_top);
        }];
    }
    else {
        
        [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom);
        }];
    }
    
    if ([model.message.type isEqualToString:@"order_send_kfwx"]) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.message.content];
        [attr addAttribute:NSForegroundColorAttributeName value:kBlackTextColor range:NSMakeRange(0, model.message.content.length)];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, model.message.content.length)];
        
        NSRange wechatRange = [model.message.content rangeOfString:model.message.link];
        if (wechatRange.location != NSNotFound) {
            [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:wechatRange];
            [attr addAttribute:NSUnderlineColorAttributeName value:RGBCOLOR(74, 144, 226) range:wechatRange];
            [attr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(74, 144, 226) range:wechatRange];
        }
        _contentLabel.attributedText = attr;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pasteWechat)];
        [_contentLabel addGestureRecognizer:tap];
    }
    else {
        NSArray<__kindof UIGestureRecognizer *> *newges = _contentLabel.gestureRecognizers;
        [newges enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_contentLabel removeGestureRecognizer:obj];
        }];
    }
}

@end
