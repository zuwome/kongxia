//
//  ZZChatNotificationCell.m
//  zuwome
//
//  Created by angBiu on 16/10/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatNotificationCell.h"

#import "ZZDateHelper.h"
#import "ZZChatReportModel.h"
#import "ZZChatSelectionModel.h"

#import "ZZUploader.h"
#import "ZZChatUtil.h"

@implementation ZZChatNotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF0F0F0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _timeView = [[ZZChatTimeView alloc] init];
        [self.contentView addSubview:_timeView];
        
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@30);
        }];
        
        _bgView = [[UIView alloc] init];
//        _bgView.backgroundColor = kGrayTextColor;
        _bgView.layer.cornerRadius = 3;
        [self.contentView addSubview:_bgView];
        
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = HEXCOLOR(0x7a7a7b);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        _contentLabel.delegate = self;
        _contentLabel.highlightedTextColor = [UIColor blueColor];
        _contentLabel.linkAttributes = @{(NSString*)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        _contentLabel.activeLinkAttributes = @{(NSString *)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
        _contentLabel.userInteractionEnabled = YES;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left);
            make.right.mas_equalTo(_bgView.mas_right);
            make.top.mas_equalTo(_bgView.mas_top);
            make.bottom.mas_equalTo(_bgView.mas_bottom);
        }];
    }
    return self;
}

- (void)setData:(ZZChatBaseModel *)model name:(NSString *)name {
    _dataModel = model;
    RCMessage *message = model.message;
    NSString *string = @"";
    if ([message.content isKindOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *notificationMessage = (RCInformationNotificationMessage *)message.content;
        string = notificationMessage.message;
        _contentLabel.attributedText = [ZZUtils setLineSpace:string space:5 fontSize:12 color:HEXCOLOR(0x7a7a7b)];
    }
    else if ([message.content isKindOfClass:[RCRecallNotificationMessage class]]) {
        if (message.messageDirection == MessageDirection_SEND) {
            string = @"你撤回了一条消息";
        } else {
            string = [NSString stringWithFormat:@"%@撤回了一条消息",name];
        }
        _contentLabel.attributedText = [ZZUtils setLineSpace:string space:5 fontSize:12 color:HEXCOLOR(0x7a7a7b)];
    }
    else if ([message.content isKindOfClass:[ZZChatReportModel class]]) {
        ZZChatReportModel *model = (ZZChatReportModel *)message.content;
        _contentLabel.attributedText = [ZZUtils setLineSpace:model.message space:5 fontSize:12 color:HEXCOLOR(0x7a7a7b)];
        NSRange range = [model.message rangeOfString:model.title];
        if (range.location != NSNotFound) {
            [_contentLabel addLinkToURL:[NSURL URLWithString:model.title] withRange:range];
        }
    }
    else if ([message.content isKindOfClass:[ZZChatSelectionModel class]]) {
        ZZChatSelectionModel *model = (ZZChatSelectionModel *)message.content;
        _contentLabel.attributedText = [ZZUtils setLineSpace:model.message space:5 fontSize:12 color:HEXCOLOR(0x7a7a7b)];
        NSRange range = [model.message rangeOfString:model.title];
        if (range.location != NSNotFound) {
            [_contentLabel addLinkToURL:[NSURL URLWithString:model.title] withRange:range];
        }
    }
    else if ([message.content isKindOfClass:[ZZChatCancelModel class]]) {
        ZZChatCancelModel *model = (ZZChatCancelModel *)message.content;
        _contentLabel.attributedText = [ZZUtils setLineSpace:model.message space:5 fontSize:12 color:HEXCOLOR(0x7a7a7b)];
        NSRange range = [model.message rangeOfString:model.title];
        if (range.location != NSNotFound) {
            [_contentLabel addLinkToURL:[NSURL URLWithString:model.title] withRange:range];
        }
    }
    else {
        string = @"无法识别的类型，请升级到最新版本";
        _contentLabel.attributedText = [ZZUtils setLineSpace:string space:5 fontSize:12 color:HEXCOLOR(0x7a7a7b)];
    }
    
    //是否显示时间
    CGFloat topOffset = 0;
    if (model.showTime) {
        _timeView.hidden = NO;
        _timeView.timeLabel.text = [[ZZDateHelper shareInstance] getMessageChatMessageTime:message.sentTime];
        topOffset = 45;
    } else {
        _timeView.hidden = YES;
        topOffset = 15;
    }
    
    CGFloat width = [ZZUtils widthForCellWithText:_contentLabel.text fontSize:12];
    
    if (width > SCREEN_WIDTH - 30 - 16) {
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(topOffset);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    else {
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(topOffset);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
    }
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([_dataModel.message.content isKindOfClass:[ZZChatReportModel class]]) {
        ZZChatReportModel *model = (ZZChatReportModel *)_dataModel.message.content;
        if ([label.text isEqualToString:[ZZChatUtil newThirdInfoString]]) {
            if (_touchThirdReport) {
                _touchThirdReport();
            }
        }
        else if ([label.text isEqualToString:@"已成功举报，若对方仍进行骚扰，可选择拉黑对方"]) {
            if (_touchAddBlack) {
                _touchAddBlack();
            }
        }
        else if ([model.title isEqualToString:@"去填写微信号"]) {
            // 去填写微信
            if (_touchGoAddWeiChat) {
                _touchGoAddWeiChat();
            }
        }
        else if ([label.text isEqualToString:@"点击查看Ta的微信号"]) {
            // 查看微信
            if (_touchGoCheckWeChat) {
                _touchGoCheckWeChat();
            }
        }
        else if ([label.text isEqualToString:@"消息未回复？试试查看Ta的微信号"]) {
            // 查看微信
            if (_touchGoCheckWeChat) {
                _touchGoCheckWeChat();
            }
        }
        else if ([model.extra isEqualToString:@"packet"]) {
            if (_touchSendPacket) {
                _touchSendPacket();
            }
        }
        else {
            if (_touchReport) {
                _touchReport();
            }
        }
    }
    else if ([_dataModel.message.content isKindOfClass:[ZZChatCancelModel class]]) {
        ZZChatCancelModel *model = (ZZChatCancelModel *)_dataModel.message.content;
        if ([model.title isEqualToString:@"查看"]) {
            if (_touchGoCheckIncome) {
                _touchGoCheckIncome();
            }
        }
    }
    else if ([_dataModel.message.content isKindOfClass:[ZZChatSelectionModel class]]) {
        ZZChatSelectionModel *model = (ZZChatSelectionModel *)_dataModel.message.content;
        switch (model.type) {
            case 1: {
                if (_touchChatServer) {
                    _touchChatServer();
                }
                break;
            }
            default:
                break;
        }
    }
}

@end
