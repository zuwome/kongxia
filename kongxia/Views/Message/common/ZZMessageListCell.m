//
//  ZZMessageListCell.m
//  zuwome
//
//  Created by angBiu on 16/7/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageListCell.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZChatPacketModel.h"
#import "ZZChatOrderInfoModel.h"
#import "ZZChatOrderNotifyModel.h"
#import "ZZMessageListCellLocationView.h"
#import "ZZDateHelper.h"
#import "ZZChatUtil.h"

@implementation ZZMessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(self.mas_top);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.height.mas_equalTo(@0.5);
        }];
        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_imgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:_imgView.bounds.size];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = _imgView.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _imgView.layer.mask = maskLayer;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kBGColor;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = kBGColor;
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _unreadCountLabel = [[UILabel alloc] init];
        _unreadCountLabel.textAlignment = NSTextAlignmentCenter;
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.font = [UIFont systemFontOfSize:10];
        _unreadCountLabel.backgroundColor = kRedPointColor;
        _unreadCountLabel.text = @"1";
        _unreadCountLabel.layer.cornerRadius = 8;
        _unreadCountLabel.clipsToBounds = YES;
        _unreadCountLabel.hidden = YES;
        [self addSubview:_unreadCountLabel];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_top);
            make.left.mas_equalTo(_imgView.mas_right).offset(15);
        }];
        
        _levelImgView = [[ZZLevelImgView alloc] init];
        [self addSubview:_levelImgView];
        
        [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 14));
        }];
        
        _statusLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0xfd5f66) fontSize:11 text:@""];
        _statusLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_statusLabel];
        [self addSubview:self.imagePivChatView];
        self.imagePivChatView.hidden = YES;
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_levelImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        }];
        
        [self.imagePivChatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_statusLabel);
        }];
        
        _locationView = [[ZZMessageListCellLocationView alloc] init];
        [self addSubview:_locationView];
        
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentLabel];
        
        [_locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.bottom.mas_equalTo(_imgView.mas_bottom);
            make.height.equalTo(@18);
            make.width.equalTo(@0);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_locationView.mas_right).offset(8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-60);
            make.bottom.mas_equalTo(_imgView.mas_bottom);
        }];
        [_unreadCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_contentLabel.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = kGrayContentColor;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(_titleLabel.mas_centerY);
        }];
    }
    
    return self;
}

- (UIImageView *)imagePivChatView {
    if (!_imagePivChatView) {
        _imagePivChatView = [[UIImageView alloc]init];
        _imagePivChatView.image = [UIImage imageNamed:@"icPaychatTip"];
    }
    return _imagePivChatView;
}

- (void)setData:(RCConversation *)model userInfo:(ZZUserInfoModel *)userInfo
{
    [_levelImgView setLevel:userInfo.level];
    self.imagePivChatView.hidden = YES;

    if (userInfo) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:nil];
        _titleLabel.text = userInfo.nickname;
        if ([userInfo.uid isEqualToString:kMmemejunUid]) {
            _titleLabel.textColor = kYellowColor;
        } else {
            _titleLabel.textColor = kBlackTextColor;
        }
       NSString *statusLabelTitle = [userInfo.order_status_text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (isNullString(statusLabelTitle)==NO) {
            _statusLabel.text = statusLabelTitle;
        }
        else if ([ZZChatUtil isUpdatePrivChatMessage:model.lastestMessage] && [model.targetId isEqualToString:model.senderUserId]) {
            _statusLabel.text = @"";
            self.imagePivChatView.hidden = NO;
        }
        else {
            _statusLabel.text = @"";
        }
        _timeLabel.text = [[ZZDateHelper shareInstance] ConvertChatMessageTime:model.sentTime];
        if (model.unreadMessageCount) {
            _unreadCountLabel.hidden = NO;
            if (model.unreadMessageCount > 99) {
                _unreadCountLabel.text = @"99";
            } else {
                _unreadCountLabel.text = [NSString stringWithFormat:@"%i",model.unreadMessageCount];
            }
        } else {
            _unreadCountLabel.hidden = YES;
        }
        
        CGFloat nameWidth = [ZZUtils widthForCellWithText:_titleLabel.text fontSize:15];
        CGFloat timeWidth = [ZZUtils widthForCellWithText:_timeLabel.text fontSize:11];
        CGFloat statusWidth = [ZZUtils widthForCellWithText:_statusLabel.text fontSize:15];
        CGFloat maxWidth = SCREEN_WIDTH - 15 - 40 - 15 - 10 - statusWidth - 15 - timeWidth - 10;
        if (nameWidth > maxWidth) {
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(maxWidth);
            }];
        } else {
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(nameWidth);
            }];
        }
    } else {
        _imgView.image = nil;
        _titleLabel.text = @" ";
        _statusLabel.text = @"";
        _unreadCountLabel.hidden = YES;
    }

    id string = [ZZChatUtil getMessageListContent:model userInfo:userInfo];
    if ([string isKindOfClass:[NSString class]]) {
        _contentLabel.text = string;
        _contentLabel.textColor = kGrayContentColor;
    } else {
        _contentLabel.attributedText = string;
    }
    
    [_locationView configureUserInfo:userInfo];
    
    [_locationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(_locationView.totalWidth));
    }];
    
}

- (void)layoutSubviews
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            subView.backgroundColor = kRedColor;
            for (UIButton *btn in subView.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    [btn setTitle:@"" forState:UIControlStateNormal];
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:btn.bounds];
                    imgView.contentMode = UIViewContentModeCenter;
                    imgView.image = [UIImage imageNamed:@"icon_chat_delete"];
                    imgView.userInteractionEnabled = NO;
                    [btn addSubview:imgView];
                }
            }
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
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

