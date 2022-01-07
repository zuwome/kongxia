//
//  ZZChatLocationCell.m
//  zuwome
//
//  Created by angBiu on 2016/11/16.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatLocationCell.h"

@implementation ZZChatLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _imgView = [[ZZCustomChatImage alloc] init];
        [self.bgView addSubview:_imgView];
        
        CGFloat height = [ZZUtils heightForCellWithText:@"哈哈哈哈" fontSize:13 labelWidth:SCREEN_WIDTH];
    
        UIView *blackBgView = [[UIView alloc] init];
       
        blackBgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        [_imgView addSubview:blackBgView];
        [blackBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_imgView);
            make.height.mas_equalTo(height+8);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationClick)];
        [self.bgView addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
    [super setData:model];
    RCMessage *message = model.message;
    RCLocationMessage *locationMessage = (RCLocationMessage *)model.message.content;
    _imgView.image = locationMessage.thumbnailImage;

    //容云提供的方案
    CGFloat imageWidth = SCREEN_WIDTH/2.0f;
    CGFloat imageHeight = imageWidth * locationMessage.thumbnailImage.size.height/locationMessage.thumbnailImage.size.width;
    

    
    self.localLabel.text = locationMessage.locationName;
    NSString *extra =  [ZZUtils dictionaryWithJsonString:locationMessage.extra][@"payChat"];
    if ([locationMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
        if (message.messageDirection == MessageDirection_SEND) {
            self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"icon_chat_bubble_right_prv_chat"]];
            [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImgView).offset(14);
                make.right.equalTo(self.bubbleImgView).offset(-3);
                make.top.equalTo(self.bubbleImgView).offset(9.5);
                make.bottom.equalTo(self.bubbleImgView).offset(-2.3);
                make.width.mas_equalTo(imageWidth);
            }];
           [_imgView  drawInboundsRight:CGRectMake(0, 0, imageWidth, imageHeight+5)];


        }else{
            [_imgView  drawInboundsleft:CGRectMake(0, 0, imageWidth, imageHeight+5)];
            self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"icon_chat_bubble_left_prv_chat"]];
            if ([locationMessage.extra isEqualToString:@"PrivateChatPay_expire"]) {
                self.bubbleImgView.alpha = 0.5;
            }
            [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImgView).offset(3);
                make.right.equalTo(self.bubbleImgView).offset(-14);
                make.top.equalTo(self.bubbleImgView).offset(9);
                make.bottom.equalTo(self.bubbleImgView).offset(-2.2);
                make.width.mas_equalTo(imageWidth);
            }];
        }
        [self.bgView bringSubviewToFront:self.bubbleImgView];
        [self.bgView bringSubviewToFront:self.localLabel];
    
 
        
    }else{
        [self.bgView bringSubviewToFront:self.imgView];
        [self.bgView bringSubviewToFront:self.localLabel];
        if (message.messageDirection == MessageDirection_SEND) {
            [_imgView  drawInboundsRight:CGRectMake(0, 0, imageWidth, imageHeight+5)];
        }else{
            [_imgView  drawInboundsleft:CGRectMake(0, 0, imageWidth, imageHeight+5)];
        }
        [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleImgView).offset(0);
            make.right.equalTo(self.bubbleImgView).offset(0);
            make.top.equalTo(self.bubbleImgView).offset(0);
            make.bottom.equalTo(self.bubbleImgView).offset(0);
            make.width.mas_equalTo(imageWidth);
        }];
    }

    

}

#pragma mark - 

- (void)locationClick
{
    [[self nextResponder] routerEventWithName:ZZRouterEventTapLocation
                                     userInfo:@{@"data":self.dataModel} Cell:self];
}

#pragma mark -

- (UILabel *)localLabel
{
    if (!_localLabel) {
        _localLabel = [[UILabel alloc] init];
        _localLabel.textAlignment = NSTextAlignmentCenter;
        _localLabel.textColor = [UIColor whiteColor];
        _localLabel.font = [UIFont systemFontOfSize:13];
        [self.bgView addSubview:_localLabel];
        
        [_localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_left).offset(10);
            make.right.mas_equalTo(_imgView.mas_right).offset(-10);
            make.bottom.mas_equalTo(_imgView.mas_bottom).offset(-4);
        }];
    }
    
    return _localLabel;
}

@end
