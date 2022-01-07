//
//  ZZVideoMessageCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/8.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZVideoMessageCell.h"
#import "ZZVideoMessage.h"
@implementation ZZVideoMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [self.bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(12, 10, 12, 10));
        }];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
 
    RCMessage *message = model.message;
    
    ZZVideoMessage *text = (ZZVideoMessage *)message.content;
    
    if (message.messageDirection == MessageDirection_SEND ) {
        //超时
        if ([text.videoType isEqualToString:@"1"]) {
            message.messageDirection  = MessageDirection_RECEIVE;//左侧
            text.content = @"暂不方便接通你的视频咨询邀请";
            text.videoType = @"4";
            //取消
        }else if([text.videoType isEqualToString:@"2"])
         {
             //右侧
             text.content = @"暂不方便接通你的视频咨询邀请";
             text.videoType = @"4";
             message.messageDirection  = MessageDirection_RECEIVE;//左侧
//拒绝
         }else if([text.videoType isEqualToString:@"3"]) {
             //左侧
             message.messageDirection  = MessageDirection_RECEIVE;
             text.content = @"暂不方便接通你的视频咨询邀请";
             text.videoType = @"4";
         }
       
    }else{
        //挂断
        if([text.videoType isEqualToString:@"3"]) {
            //右侧
            message.messageDirection  = MessageDirection_RECEIVE;
            text.content = @"视频咨询邀请已拒绝";
            text.videoType = @"4";
        }else if([text.videoType isEqualToString:@"4"]){
            
        }
         else if ([text.videoType isEqualToString:@"1"]) {
             //超时右侧
             text.content = @"视频咨询邀请超时无应答已取消";
             message.messageDirection  = MessageDirection_RECEIVE;
             text.videoType = @"4";

         }
         else if ([text.videoType isEqualToString:@"2"]) {
             //取消 左侧
             text.content = @"视频咨询邀请超时无应答已取消";
             message.messageDirection  = MessageDirection_RECEIVE;
             text.videoType = @"4";
         }
        else{
              _titleLabel.text = text.content;
        }
    }
    
    [super setData:model];
    _titleLabel.text = text.content;
    
    CGFloat textWidth = [ZZUtils widthForCellWithText:_titleLabel.text fontSize:15];
    CGFloat maxWidth = SCREEN_WIDTH - 40 - 10 - 20 - 50;
    textWidth = MIN(textWidth, maxWidth);
    CGFloat textHeight = [ZZUtils heightForCellWithText:_titleLabel.text fontSize:15 labelWidth:textWidth];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(textWidth, textHeight));
        make.width.equalTo(@(textWidth));
    }];

    if (message.messageDirection == MessageDirection_SEND) {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_right).offset(-25);
            make.left.mas_equalTo(self.bgView.mas_left).offset(10);
        }];
    } else {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgView.mas_left).offset(25);
            make.right.mas_equalTo(self.bgView.mas_right).offset(-10);
        }];
    }
}
@end

