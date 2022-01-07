//
//  ZZChatTextCell.m
//  zuwome
//
//  Created by angBiu on 16/10/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatTextCell.h"

@implementation ZZChatTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor  = kBlackColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [self.bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_top).offset(12);
            make.left.mas_equalTo(self.bgView.mas_left).offset(10);
            make.right.mas_equalTo(self.bgView.mas_right).offset(-10);
//            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-12);
        }];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
    [super setData:model];
    
    RCMessage *message = model.message;
    RCTextMessage *text = (RCTextMessage *)message.content;

    _titleLabel.text = text.content;
    
    CGFloat textWidth = [ZZUtils widthForCellWithText:text.content fontSize:15];
    CGFloat maxWidth = SCREEN_WIDTH - 180;
    CGFloat minWidth = 31;
    if (textWidth > maxWidth) {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(maxWidth);
        }];
    } else if ( textWidth<= minWidth) {

        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(minWidth);
        }];
    }
    else{
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textWidth);
        }];
    }
    NSString *extra =  [ZZUtils dictionaryWithJsonString:text.extra][@"payChat"];
    if (message.messageDirection == MessageDirection_SEND) {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            if ([text.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
                  make.left.mas_equalTo(self.bgView.mas_left).offset(30);
                  make.top.mas_equalTo(self.bgView.mas_top).offset(22);
                  make.right.mas_equalTo(self.bgView.mas_right).offset(-20);

                _titleLabel.textColor  = RGBCOLOR(243, 128, 0);
                self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"chat_bubble_right_prv_chat"]];
            }else{
                _titleLabel.textColor  = kBlackColor;
                make.top.mas_equalTo(self.bgView.mas_top).offset(12);
                make.left.mas_equalTo(self.bgView.mas_left).offset(20);
                make.right.mas_equalTo(self.bgView.mas_right).offset(-20);
            }

        }];
    } else {
        CGFloat topOffset = 0;
        //是否显示时间
        if (model.showTime) {
            topOffset = 45;
        } else {
            topOffset = 15;
        }
        _titleLabel.textColor  = kBlackColor;
        if ([text.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
            [self.otherHeadImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.top).offset(topOffset+7.5);
            }];
            self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"chat_bubble_left_prv_chat"]];
            if ([message.extra isEqualToString:@"PrivateChatPay_expire"]) {
                self.bubbleImgView.alpha = 0.5;
            }
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bgView.mas_left).offset(20);
                make.top.mas_equalTo(self.bgView.mas_top).offset(22);
                make.right.mas_equalTo(self.bgView.mas_right).offset(-30);
            }];
            
        }else{
            [self.otherHeadImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.top).offset(topOffset);
            }];
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bgView.mas_top).offset(12);
                make.left.mas_equalTo(self.bgView.mas_left).offset(30);
                make.right.mas_equalTo(self.bgView.mas_right).offset(-20);
            }];
        }
    }
       
}
@end
