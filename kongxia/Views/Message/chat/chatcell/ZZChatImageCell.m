//
//  ZZChatImageCell.m
//  zuwome
//
//  Created by angBiu on 16/10/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatImageCell.h"


@interface ZZChatImageCell ()

@property (nonatomic, strong) UIActivityIndicatorView *uploadIndicatroView;
@property (nonatomic, strong) UILabel *processLabel;
@property (nonatomic, strong) UIView *blackCoverView;

@end

@implementation ZZChatImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.bgView addSubview:self.imgView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
        [self.bgView addGestureRecognizer:recognizer];
    }
    return self;
}
- (ZZCustomChatImage *)imgView {
    if (!_imgView) {
        _imgView = [[ZZCustomChatImage alloc] init];
    }
    return _imgView;
}

- (void)setData:(ZZChatBaseModel *)model {
    [super setData:model];
    if (model.message.messageDirection == MessageDirection_RECEIVE) {
        self.blackCoverView.hidden = YES;
        self.uploadIndicatroView.hidden = YES;
        self.processLabel.hidden = YES;
    }
    
    self.activityView.hidden = YES;
    RCMessage *Imagemessage = model.message;
    RCImageMessage *message = (RCImageMessage *)model.message.content;
    
    _imgView.image = message.thumbnailImage;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    //容云提供的方案
    CGFloat imageWidth = 120;
    CGFloat imageHeight = 120;
    if (message.thumbnailImage.size.width > 121 || message.thumbnailImage.size.height > 121) {
        imageWidth = message.thumbnailImage.size.width / 2.0f;
        imageHeight = message.thumbnailImage.size.height / 2.0f;
    }
    else {
        imageWidth = message.thumbnailImage.size.width;
        imageHeight = message.thumbnailImage.size.height;
    }
    
    NSString *extra = [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
    if ([message.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
        if (Imagemessage.messageDirection == MessageDirection_SEND) {
            [_imgView  drawInboundsRight:CGRectMake(0, 0, imageWidth, imageHeight+5)];
            self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"icon_chat_bubble_right_prv_chat"]];
            [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bubbleImgView).offset(14);
                make.right.equalTo(self.bubbleImgView).offset(-3);
                make.top.equalTo(self.bubbleImgView).offset(9.5);
                make.bottom.equalTo(self.bubbleImgView).offset(-2.3);
                make.width.mas_equalTo(imageWidth);
            }];

        }
        else {
            [_imgView drawInboundsleft:CGRectMake(0, 0, imageWidth, imageHeight+5)];

            self.bubbleImgView.image = [ZZChatBaseCell resizeWithImage:[UIImage imageNamed:@"icon_chat_bubble_left_prv_chat"]];
            if ([Imagemessage.extra isEqualToString:@"PrivateChatPay_expire"]) {
                self.bubbleImgView.alpha = 0.5;
            }
            else {
                self.bubbleImgView.alpha =1;
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

    }
    else {
        self.bubbleImgView.image = nil;
        [self.bgView bringSubviewToFront:self.imgView];
        
        if (Imagemessage.messageDirection == MessageDirection_SEND) {
            [_imgView  drawInboundsRight:CGRectMake(0, 0, imageWidth, imageHeight+5)];
        }
        else{
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

- (void)layoutSubviews {
}

#pragma mark - 

- (void)imageClick {
    [[self nextResponder] routerEventWithName:ZZRouterEventTapImage
                                     userInfo:@{@"data":self.dataModel,
                                                @"target":_imgView} Cell:self];
}

#pragma mark -
- (void)setProcess:(int)process {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (process < 100) {
            self.blackCoverView.hidden = NO;
            self.uploadIndicatroView.hidden = NO;
            [self.uploadIndicatroView startAnimating];
            self.processLabel.hidden = NO;
            self.processLabel.text = [NSString stringWithFormat:@"%d%%",process];
        }
        else {
            self.blackCoverView.hidden = YES;
            self.uploadIndicatroView.hidden = YES;
            [self.uploadIndicatroView stopAnimating];
            self.processLabel.hidden = YES;
            self.processLabel.text = @"";
        }
    });
}

- (UIView *)blackCoverView {
    if (!_blackCoverView) {
        _blackCoverView = [[UIView alloc] init];
        _blackCoverView.backgroundColor = kBlackTextColor;
        _blackCoverView.alpha = 0.7;
        
        [_imgView addSubview:_blackCoverView];
        [_blackCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_imgView);
        }];
        
        _uploadIndicatroView = [[UIActivityIndicatorView alloc] init];
        [_imgView addSubview:_uploadIndicatroView];
        
        [_uploadIndicatroView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_imgView.mas_centerX);
            make.bottom.mas_equalTo(_imgView.mas_centerY).offset(-2);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        _processLabel = [[UILabel alloc] init];
        _processLabel.textAlignment = NSTextAlignmentCenter;
        _processLabel.textColor = [UIColor whiteColor];
        _processLabel.font = [UIFont systemFontOfSize:13];
        [_imgView addSubview:_processLabel];
        
        [_processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_imgView.mas_centerX);
            make.top.mas_equalTo(_imgView.mas_centerY).offset(2);
        }];
    }
    return _blackCoverView;
}

@end
