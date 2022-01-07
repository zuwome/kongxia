//
//  ZZChatOrderInfoCell.m
//  zuwome
//
//  Created by angBiu on 2016/11/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatOrderInfoCell.h"

#import "ZZChatOrderInfoModel.h"
#import "ZZChatOrderNotifyModel.h"
#import "ZZDateHelper.h"

@interface ZZChatOrderInfoCell ()

@property (nonatomic, strong) ZZChatBaseModel *dataModel;

@end

@implementation ZZChatOrderInfoCell

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
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kYellowColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(8);
            make.top.mas_equalTo(_bgView.mas_top).offset(10);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(_bgView.mas_right).offset(-8);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-10);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderClick)];
        [_bgView addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
    _dataModel = model;
    RCMessage *message = model.message;
    if ([model.message.content isKindOfClass:[ZZChatOrderInfoModel class]]) {
        ZZChatOrderInfoModel *infoModel = (ZZChatOrderInfoModel *)message.content;
        _titleLabel.text = infoModel.title;
        _contentLabel.text = infoModel.content;
    } else {
        ZZChatOrderNotifyModel *notifyModel = (ZZChatOrderNotifyModel *)message.content;
        _titleLabel.text = notifyModel.title;
        NSRange range = [notifyModel.message rangeOfString:notifyModel.content];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:notifyModel.message];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        _contentLabel.attributedText = attributedString;
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
    
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(topOffset);
    }];
}

#pragma mark -

- (void)orderClick
{
    [[self nextResponder] routerEventWithName:ZZRouterEventTapOrderInfo
                                     userInfo:@{@"data":_dataModel} Cell:self];
}

@end
