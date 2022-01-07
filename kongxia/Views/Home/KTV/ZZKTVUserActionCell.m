//
//  ZZKTVUserActionCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVUserActionCell.h"

@interface ZZKTVUserActionCell ()

@property (nonatomic, strong) UIButton *chatBtn;

@property (nonatomic, strong) UIButton *sendGiftBtn;

@end

@implementation ZZKTVUserActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark - response method
- (void)sendGift {
    id model = nil;
    if (_receiverModel) {
        model = _receiverModel;
    }
    else if (_songModel) {
        model = _songModel;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:sendGift:)]) {
        [self.delegate cell:self sendGift:model];
    };
}

- (void)goChat {
    id model = nil;
    if (_receiverModel) {
        model = _receiverModel;
    }
    else if (_songModel) {
        model = _songModel;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:chat:)]) {
        [self.delegate cell:self chat:model];
    };
}

#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.chatBtn];
    [self.contentView addSubview:self.sendGiftBtn];
    
    [_sendGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(127, 34));
    }];
    
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(127, 34));
    }];
    
}


#pragma mark - getters and setters
- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [[UIButton alloc] init];
        _chatBtn.normalTitle = @"私信";
        _chatBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _chatBtn.titleLabel.font = ADaptedFontMediumSize(12);
        _chatBtn.normalImage = [UIImage imageNamed:@"icSixinChangpa"];
        _chatBtn.layer.cornerRadius = 16.0;
        _chatBtn.layer.borderWidth = 1.5;
        _chatBtn.layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
        [_chatBtn setImagePosition:LXMImagePositionLeft spacing:10.0];
        [_chatBtn addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}

- (UIButton *)sendGiftBtn {
    if (!_sendGiftBtn) {
        _sendGiftBtn = [[UIButton alloc] init];
        _sendGiftBtn.normalTitle = @"送TA礼物";
        _sendGiftBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _sendGiftBtn.titleLabel.font = ADaptedFontMediumSize(11);
        _sendGiftBtn.normalImage = [UIImage imageNamed:@"icLiwuChangpa"];
        _sendGiftBtn.layer.cornerRadius = 17.0;
        _sendGiftBtn.layer.borderWidth = 1.5;
        _sendGiftBtn.layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
        [_sendGiftBtn setImagePosition:LXMImagePositionLeft spacing:10.0];
        [_sendGiftBtn addTarget:self action:@selector(sendGift) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendGiftBtn;
}


@end
