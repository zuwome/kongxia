//
//  ZZChatVoiceCell.m
//  zuwome
//
//  Created by angBiu on 16/10/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatVoiceCell.h"

@implementation ZZChatVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _voiceImgView = [[UIImageView alloc] init];
        _voiceImgView.animationDuration = 0.8;
        [self.bgView addSubview:_voiceImgView];
        
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = [UIFont systemFontOfSize:15];
        _durationLabel.textColor = kBlackTextColor;
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_durationLabel];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceClick)];
        [self.bgView addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
    [super setData:model];
    RCMessage *message = model.message;
    RCVoiceMessage *voiceMessage = (RCVoiceMessage *)message.content;

    _durationLabel.text = [NSString stringWithFormat:@"%ld''",voiceMessage.duration];
    CGFloat width = [ZZUtils widthForCellWithText:@"10''" fontSize:15];
    NSString *extra =  [ZZUtils dictionaryWithJsonString:voiceMessage.extra][@"payChat"];
    if (message.messageDirection == MessageDirection_SEND) {
        if ([voiceMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
            self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"chat_bubble_right_prv_chat"]];
            width +=10;
        }
        [_voiceImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if ([voiceMessage.extra isEqualToString:@"PrivateChatPay"]) {
                make.centerY.mas_equalTo(self.bgView.mas_centerY).offset(2.5);
            }else{
                make.centerY.mas_equalTo(self.bgView.mas_centerY);
            }
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.right.mas_equalTo(self.bgView.mas_right).offset(-14);
        }];
        [_durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_voiceImgView.mas_left).offset(-5);
            make.centerY.mas_equalTo(_voiceImgView.mas_centerY);
            make.left.mas_equalTo(self.bgView.mas_left).offset(18);
            make.width.mas_equalTo(width+3);
        }];
        
        _voiceImgView.image = IMAGENAME(@"to_voice");
        UIImage *image1 = IMAGENAME(@"to_voice_1");
        UIImage *image2 = IMAGENAME(@"to_voice_2");
        UIImage *image3 = IMAGENAME(@"to_voice_3");
        _voiceImgView.animationImages = @[image1,image2,image3];
        
    } else {
       
        if ([voiceMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
            self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"chat_bubble_left_prv_chat"]];
            if ([message.extra isEqualToString:@"PrivateChatPay_expire"]) {
                self.bubbleImgView.alpha = 0.5;
            }
            width +=10;
        }
        [_voiceImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if ([voiceMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                make.centerY.mas_equalTo(self.bgView.mas_centerY).offset(2.5);
            }else{
                make.centerY.mas_equalTo(self.bgView.mas_centerY);
            }
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.mas_equalTo(self.bgView.mas_left).offset(14);
        }];
        [_durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_voiceImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(_voiceImgView.mas_centerY);
            make.right.mas_equalTo(self.bgView.mas_right).offset(-18);
            make.width.mas_equalTo(width+3);
        }];
        
        if (message.receivedStatus != ReceivedStatus_LISTENED) {
            self.unreadRedPointView.hidden = NO;
        } else {
            self.unreadRedPointView.hidden = YES;
        }
        
        _voiceImgView.image = IMAGENAME(@"from_voice");
        
        UIImage *image1 = IMAGENAME(@"from_voice_1");
        UIImage *image2 = IMAGENAME(@"from_voice_2");
        UIImage *image3 = IMAGENAME(@"from_voice_3");
        _voiceImgView.animationImages = @[image1,image2,image3];
    }
}

#pragma mark - UIButtonMethod

- (void)voiceClick
{
    [[self nextResponder] routerEventWithName:ZZRouterEventPlayVoice userInfo:@{@"target":_voiceImgView,
                                                                                @"unreadpoint":self.unreadRedPointView,
                                                                                @"data":self.dataModel} Cell:nil];
}

@end
