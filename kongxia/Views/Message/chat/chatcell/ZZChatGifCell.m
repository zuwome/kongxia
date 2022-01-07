//
//  ZZChatGifCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/4/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChatGifCell.h"
#import "ZZGifMessageModel.h"
#import <UIImage+GIF.h>
#import "JX_GCDTimerManager.h"
@implementation ZZChatGifCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.bgView addSubview:self.imgGifView];
    }
    return self;
}
- (UIImageView *)imgGifView {
    
    if (!_imgGifView) {
        _imgGifView = [[UIImageView alloc]init];
        _imgGifView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgGifView;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setImgChatModel:(ZZChatBaseModel *)imgChatModel {
    RCMessage *message = imgChatModel.message;
    ZZGifMessageModel *gifModel =(ZZGifMessageModel *)message.content;
    NSLog(@"PY_gif_ 赋值%ld %ld",message.messageId,gifModel.resultsType);
    [super setData:imgChatModel];

    if ([message.extra isEqualToString:@"PrivateChatPay_expire"]) {
        self.bubbleImgView.alpha = 0.5;
    }else{
        self.bubbleImgView.alpha =1;
    }
    NSString *extra =  [ZZUtils dictionaryWithJsonString:gifModel.extra][@"payChat"];
    if ([gifModel.extra containsString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
        if ([message.extra containsString:@"PrivateChatPay_expire"]&&message.messageDirection == MessageDirection_RECEIVE) {
            self.bubbleImgView.alpha = 0.5;
        }else if(message.messageDirection == MessageDirection_RECEIVE){
        self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"icon_chat_bubble_left_prv_chat"]];
        }else if (message.messageDirection == MessageDirection_SEND){
            self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"icon_chat_bubble_right_prv_chat"]];
        }
        [self.bgView bringSubviewToFront:self.bubbleImgView];
    }else{
       
        self.bubbleImgView.image = nil;
    }
    if (_imgChatModel !=imgChatModel ) {
        
        NSLog(@"PY_gif_ 结果%ld %ld",message.messageId,gifModel.resultsType);
        _imgChatModel = imgChatModel;
        self.bubbleImgView.alpha = 1;
        if ([gifModel.type isEqualToString:@"game"]) {
            NSString *localPath =[NSString stringWithFormat:@"%@%ld",gifModel.localPath,gifModel.resultsType];
            NSString *gifPath = [NSString stringWithFormat:@"%@",gifModel.localPath];
            if ([gifModel.localPath isEqualToString:@"emojiGifMora"]) {
                localPath = [NSString stringWithFormat:@"%@%ld",localPath,message.messageDirection];
                gifPath = [NSString stringWithFormat:@"%@Gif%ld",gifPath,message.messageDirection];
            }
            if (![message.extra containsString :@"Read" ]) {
                NSString *path = [[NSBundle mainBundle]pathForResource:gifPath ofType:@".gif"];
                NSData *data = [NSData dataWithContentsOfFile:path];
                self.imgGifView.image = [UIImage sd_animatedGIFWithData:data];
                WS(weakSelf);
                NSString *key = [NSString stringWithFormat:@"%ld_%@",message.messageId,message.targetId];
                [[JX_GCDTimerManager sharedInstance].currentGameGifDic setObject:localPath forKey:key];
                [[JX_GCDTimerManager sharedInstance] justOnceScheduledDispatchTimerWithName:key timeInterval:1.5 queue:nil action:^(NSString *timerName) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if ([[NSString stringWithFormat:@"%ld_%@",message.messageId,message.targetId] isEqualToString:timerName]) {
                        [strongSelf updateGifGame:imgChatModel identifier:timerName];
                    }
                }];
                }else{
                self.imgGifView.image = [UIImage imageNamed:localPath];
            }
        
        }else{
            [self.imgGifView sd_setImageWithURL:[NSURL URLWithString:gifModel.fileUrl]];
        }
        
        if (message.messageDirection == MessageDirection_SEND ) {
            [self.imgGifView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(-5);
                if ([gifModel.extra containsString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                     make.top.left.offset(15);
                     make.right.offset(-10);
                }else{
                    make.right.offset(-5);
                    make.top.left.offset(5);
                }
                make.width.mas_equalTo(gifModel.gifWidth/2.0f);
                make.height.mas_equalTo(gifModel.gifHeight/2.0f);
            }];
        }
        else{
            [self.imgGifView mas_updateConstraints:^(MASConstraintMaker *make) {
                if ([gifModel.extra containsString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                    make.bottom.offset(-10);
                    make.right.offset(-15);
                    make.top.left.offset(10);
                }else{
                    make.top.left.offset(5);
                    make.right.offset(-5);
                    make.bottom.offset(-5);
                }
                make.width.mas_equalTo(gifModel.gifWidth/2.0f);
                make.height.mas_equalTo(gifModel.gifHeight/2.0f);
            }];
        }
    }
}

/**
 定时器结束刷新最后的结果
 */
- (void)updateGifGame:(ZZChatBaseModel *)updateModel identifier:(NSString *)identifier{
    dispatch_async(dispatch_get_main_queue(), ^{
        RCMessage *message = updateModel.message;
        NSString *localPath = [[JX_GCDTimerManager sharedInstance].currentGameGifDic objectForKey:identifier];
        [[RCIMClient sharedRCIMClient] setMessageExtra:message.messageId value:[NSString stringWithFormat:@"%@%@",message.extra,@"Read"]];
        [[JX_GCDTimerManager sharedInstance].currentGameGifDic removeObjectForKey:identifier];
        message.extra = [NSString stringWithFormat:@"%@%@",message.extra,@"Read"];
        NSLog(@"PY_gif 最后%ld %@ ",message.messageId,localPath);

        self.imgGifView.image = [UIImage imageNamed:localPath];
    });
}
- (void)setData:(ZZChatBaseModel *)model
{
    self.imgChatModel = model;
}
@end
