//
//  ZZRentPageBottomView.m
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentPageBottomView.h"

@interface ZZRentPageBottomView ()

@property (nonatomic, strong) UIButton *packetBtn;

@end

@implementation ZZRentPageBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor =RGBCOLOR(245, 245, 245);
//        self.clipsToBounds = YES;
        self.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowOpacity = 0.9;
        self.layer.shadowRadius = 1;
        
        _chatBtn = [[UIButton alloc] init];
        _chatBtn.backgroundColor = [UIColor whiteColor];
        [_chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chatBtn];
        
        [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom).offset(isIPhoneX ? (-34) : 0);
            make.width.mas_equalTo(@75);
        }];
        
        UIImageView *chatImgView = [[UIImageView alloc] init];
        chatImgView.contentMode = UIViewContentModeCenter;
        chatImgView.image = [UIImage imageNamed:@"icon_rent_chat"];
        chatImgView.userInteractionEnabled = NO;
        [_chatBtn addSubview:chatImgView];
        
        [chatImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_chatBtn.mas_centerX);
            make.top.mas_equalTo(_chatBtn.mas_top).offset(6.5);
            make.size.mas_equalTo(CGSizeMake(26, 26));
        }];
        
        UILabel *chatTitleLabel = [[UILabel alloc] init];
        chatTitleLabel.textAlignment = NSTextAlignmentCenter;
        chatTitleLabel.textColor = HEXCOLOR(0x3F3A3A);
        chatTitleLabel.font = [UIFont systemFontOfSize:12];
        chatTitleLabel.text = @"私信";
        chatTitleLabel.userInteractionEnabled = NO;
        [_chatBtn addSubview:chatTitleLabel];
        
        [chatTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_chatBtn.mas_centerX);
            make.top.mas_equalTo(chatImgView.mas_bottom);
            make.bottom.mas_equalTo(_chatBtn.mas_bottom);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom).offset(isIPhoneX ? (-34) : 0);
            make.right.mas_equalTo(_chatBtn.mas_right);
            make.width.mas_equalTo(@1);
        }];
        
        self.packetBtn.hidden = NO;
        CGFloat offset = 0;
        if ([ZZUserHelper shareInstance].configModel) {
            if ([ZZUserHelper shareInstance].configModel.hide_link_mic) {
            } else {
                offset = 75;
                self.videoBtn.hidden = NO;
            }
        }
        
        UIView *rentBgView = [UIView new];
        rentBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:rentBgView];
        [rentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_packetBtn.mas_right);
            make.right.mas_equalTo(self.mas_right);
            make.centerY.mas_equalTo(_chatBtn.mas_centerY);
            make.bottom.equalTo(@(isIPhoneX ? (-34) : 0));
        }];
    
        _rentBtn = [[UIButton alloc] init];
        [_rentBtn setTitle:@"马上约TA" forState:UIControlStateNormal];
        [_rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _rentBtn.backgroundColor = kYellowColor;
        _rentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rentBtn addTarget:self action:@selector(rentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rentBtn];
        
        if (offset == 0) {
            _rentBtn.layer.cornerRadius = 4;
            [_rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_packetBtn.mas_right).offset(15);
                make.right.mas_equalTo(self.mas_right).offset(-15);
                make.centerY.mas_equalTo(_chatBtn.mas_centerY);
                make.height.mas_equalTo(@38);
            }];
        } else {
            [_rentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_packetBtn.mas_right).offset(offset);
                make.top.right.mas_equalTo(self);
                make.bottom.mas_equalTo(isIPhoneX ? (-34) : 0);
            }];
        }
        
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = kLineViewColor;
        [self addSubview:topLineView];
        
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(@0.5);
        }];
        
        self.chooseBtn.hidden = YES;
    }
    
    return self;
}

- (void)setFromLiveStream:(BOOL)fromLiveStream {
    _fromLiveStream = fromLiveStream;
    if (fromLiveStream) {
        self.chooseBtn.hidden = NO;
    }
    else {
        self.chooseBtn.hidden = YES;
    }
}

- (void)setEntryTarget:(EntryTarget)entryTarget {
    _entryTarget = entryTarget;
    if (_entryTarget == TargetNormalTaskSignup) {
        _rentBtn.normalTitle = @"报名";
        [_rentBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _rentBtn.backgroundColor = kYellowColor;
    }
    else {
        _rentBtn.normalTitle = @"马上约TA";
    }
}

- (void)chatBtnClick {
    if (_touchChat) {
        _touchChat();
    }
}

- (void)askBtnClick {
    if (_touchAsk) {
        _touchAsk();
    }
}

- (void)rentBtnClick {
    if (_entryTarget == TargetNormalTaskSignup || _entryTarget == TargetActivitesRent) {
        if (_signup) {
            _signup();
        }
    }
    else {
        if (_touchRent) {
            _touchRent();
        }
    }
    
}

- (void)chooseBtnClick {
    if (_touchChoose) {
        _touchChoose();
    }
}

#pragma mark - lazyload

- (UIButton *)packetBtn
{
    if (!_packetBtn) {
        _packetBtn = [[UIButton alloc] init];
        _packetBtn.backgroundColor = [UIColor whiteColor];
        [_packetBtn addTarget:self action:@selector(askBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_packetBtn];
        
        [_packetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_chatBtn.mas_right);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom).offset(isIPhoneX ? (-34) : 0);
            make.width.mas_equalTo(@75);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"rent_gift"];
        imgView.userInteractionEnabled = NO;
        [_packetBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_packetBtn.mas_centerX);
            make.top.mas_equalTo(_packetBtn.mas_top).offset(6.5);
            make.size.mas_equalTo(CGSizeMake(26, 26));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x3F3A3A);
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"送礼物";
        label.userInteractionEnabled = NO;
        [_packetBtn addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_packetBtn.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom);
            make.bottom.mas_equalTo(_packetBtn.mas_bottom);
        }];
        
        // 动态隐藏发红包按钮
        _packetBtn.hidden = [ZZUserHelper shareInstance].configModel.hide_mmd_private_at_userdetail;
        _packetBtn.enabled = ![ZZUserHelper shareInstance].configModel.hide_mmd_private_at_userdetail;
        imgView.hidden = [ZZUserHelper shareInstance].configModel.hide_mmd_private_at_userdetail;
        label.hidden = [ZZUserHelper shareInstance].configModel.hide_mmd_private_at_userdetail;
        CGFloat widthPack = [ZZUserHelper shareInstance].configModel.hide_mmd_private_at_userdetail ? 0 : 75;
        [_packetBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(widthPack));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom).offset(isIPhoneX ? (-34) : 0);
            make.right.mas_equalTo(_packetBtn.mas_right);
            make.width.mas_equalTo(@1);
        }];
    }
    return _packetBtn;
}

- (UIButton *)videoBtn
{
    if (!_videoBtn) {
        _videoBtn = [[UIButton alloc] init];
        [_videoBtn addTarget:self action:@selector(chooseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _videoBtn.hidden = YES;
        [self addSubview:_videoBtn];
        
        [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_packetBtn.mas_right);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(@75);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_livestream_video"];
        imgView.userInteractionEnabled = NO;
        [_videoBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_videoBtn.mas_centerX);
            make.top.mas_equalTo(_videoBtn.mas_top).offset(6.5);
            make.size.mas_equalTo(CGSizeMake(27, 27));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x3F3A3A);
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"视频";
        label.userInteractionEnabled = NO;
        [_videoBtn addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_videoBtn.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom);
            make.bottom.mas_equalTo(_videoBtn.mas_bottom);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineViewColor;
        lineView.userInteractionEnabled = NO;
        [_videoBtn addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(_videoBtn);
            make.width.mas_equalTo(@1);
        }];
    }
    return _videoBtn;
}

- (UIButton *)chooseBtn
{
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc] init];
        [_chooseBtn setTitle:@"选TA" forState:UIControlStateNormal];
        [_chooseBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _chooseBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _chooseBtn.backgroundColor = kYellowColor;
        [_chooseBtn addTarget:self action:@selector(chooseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chooseBtn];
        
        [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return _chooseBtn;
}

@end
