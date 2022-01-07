//
//  ZZIDPhotoPayCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatIDPhotoPayCell.h"
#import "ZZChatOrderNotifyModel.h"
#import "ZZDateHelper.h"
#import "ZZMessageChatWechatPayModel.h"

@interface ZZChatIDPhotoPayCell ()

@property (nonatomic, strong) ZZChatBaseModel *dataModel;

@property (nonatomic, strong) NSString *evaluationType;//微信号评价的类型

@end

@implementation ZZChatIDPhotoPayCell

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
        
        _titleCustomLabel = [[UILabel alloc] init];
        _titleCustomLabel.textColor = kYellowColor;
        _titleCustomLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_titleCustomLabel];
        
        [_titleCustomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(8);
            make.top.mas_equalTo(_bgView.mas_top).offset(10);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        [_bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleCustomLabel.mas_left);
            make.right.mas_equalTo(_bgView.mas_right).offset(-8);
            make.top.mas_equalTo(_titleCustomLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-10);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiChatPayClick)];
        [_bgView addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
    _dataModel = model;
    RCMessage *message = model.message;
    
    if ([model.message.content isKindOfClass:[ZZMessageChatWechatPayModel class]]) {
        ZZMessageChatWechatPayModel *infoModel = (ZZMessageChatWechatPayModel *)message.content;
        _evaluationType = [NSString stringWithFormat:@"%@",infoModel.pay_type];
        _titleCustomLabel.text = infoModel.title;
        
        if ([_evaluationType isEqualToString:@"2"]) {
            [ZZUser loadUser:self.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:nil];
                if (user.have_commented_wechat_no) {
                    _titleCustomLabel.text = @"已评价";
                }
            }];
            
        }
        _contentLabel.text = infoModel.content;
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

#pragma mark -  微信待评价

- (void)weiChatPayClick
{
    NSLog(@"PY_微信待评价点击事件");
    if ([_evaluationType isEqualToString:@"2"]) {
        [[self nextResponder] routerEventWithName:ZZWeiChatPayEventTapCall
                                         userInfo:@{@"data":_dataModel} Cell:self];
    }
}

@end
