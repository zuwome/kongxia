//
//  ZZChatVideoCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatVideoCell.h"

@interface ZZChatVideoCell ()

@property (nonatomic, strong) UIActivityIndicatorView *uploadIndicatroView;

@property (nonatomic, strong) UILabel *processLabel;

@property (nonatomic, strong) UIView *blackCoverView;

@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation ZZChatVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.bgView addSubview:self.imgView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
        [self.bgView addGestureRecognizer:recognizer];
        
        [self addSubview:self.playBtn];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imgView);
            make.size.mas_equalTo(CGSizeMake(35.0, 35.0));
        }];
    }
    return self;
}

- (void)layoutSubviews {
    
}

#pragma mark - response method
- (void)imageClick {
    [[self nextResponder] routerEventWithName:ZZRouterEventTapVideo
                                     userInfo:@{@"data":self.dataModel,
                                                @"target":_imgView} Cell:self];
}

- (void)playVideo {
    [[self nextResponder] routerEventWithName:ZZRouterEventTapVideo
                                        userInfo:@{@"data":self.dataModel,
                                                   @"target":_imgView} Cell:self];
}

#pragma mark - getters and setters
- (void)setData:(ZZChatBaseModel *)model {
    [super setData:model];
    
    self.activityView.hidden = YES;
    RCMessage *Imagemessage = model.message;
    RCImageMessage *message = (RCImageMessage *)model.message.content;
    
    _imgView.image = message.thumbnailImage;
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    //容云提供的方案
    CGFloat imageWidth = 100;
    CGFloat imageHeight = 180;
    NSString *extra =  [ZZUtils dictionaryWithJsonString:message.extra][@"payChat"];
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
            else{
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
        else {
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
    
    if (model.message.messageDirection == MessageDirection_RECEIVE) {
        self.blackCoverView.hidden = YES;
        self.uploadIndicatroView.hidden = YES;
        self.processLabel.hidden = YES;
    }
    
    [self bringSubviewToFront:_playBtn];
}

- (void)setProcess:(int)process {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (process < 100) {
            self.blackCoverView.hidden = NO;
            self.uploadIndicatroView.hidden = NO;
            [self.uploadIndicatroView startAnimating];
            self.processLabel.hidden = NO;
            self.processLabel.text = [NSString stringWithFormat:@"%d%%",process];
            _playBtn.hidden = YES;
        }
        else {
            self.blackCoverView.hidden = YES;
            self.uploadIndicatroView.hidden = YES;
            [self.uploadIndicatroView stopAnimating];
            self.processLabel.hidden = YES;
            _playBtn.hidden = NO;
        }
    });
}

- (ZZCustomChatImage *)imgView {
    if (!_imgView) {
        _imgView = [[ZZCustomChatImage alloc] init];
    }
    return _imgView;
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

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        _playBtn.normalImage = [UIImage imageNamed:@"icVedioPlay"];
        [_playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

@end
