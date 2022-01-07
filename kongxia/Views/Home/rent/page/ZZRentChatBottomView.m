//
//  ZZRentChatBottomView.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/15.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRentChatBottomView.h"

@implementation ZZRentChatBottomView

- (instancetype)init {
    if (self = [super init]) {
        CGFloat scale = 157.0f / 375.0f;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoBtn setTitle:@"1V1视频咨询" forState:(UIControlStateNormal)];
        [_videoBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _videoBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        //    videoBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        [_videoBtn setBackgroundImage:[UIImage imageNamed:@"icVideoChat"] forState:UIControlStateNormal];
        [_videoBtn addTarget:self action:@selector(videoConnectClick) forControlEvents:UIControlEventTouchUpInside];
        _videoBtn.layer.masksToBounds = YES;
        _videoBtn.layer.cornerRadius = 4.0f;
        [_videoBtn setImage:[UIImage imageNamed:@"icProfileShipin"] forState:UIControlStateNormal];
        _videoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        
        _fastChatRentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fastChatRentBtn setTitle:@"私信" forState:(UIControlStateNormal)];
        [_fastChatRentBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _fastChatRentBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        //    self.fastChatRentBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        [_fastChatRentBtn setBackgroundImage:[UIImage imageNamed:@"icRent"] forState:UIControlStateNormal];
        [_fastChatRentBtn addTarget:self action:@selector(rentClick) forControlEvents:UIControlEventTouchUpInside];
        _fastChatRentBtn.layer.masksToBounds = YES;
        _fastChatRentBtn.layer.cornerRadius = 4.0f;
        [_fastChatRentBtn setImage:[UIImage imageNamed:@"san_chat_Priv_Info"] forState:UIControlStateNormal];
        _fastChatRentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = kLineViewColor;
        
        UIView *lineView2 = [UIView new];
        lineView2.backgroundColor = kLineViewColor;
        
        [self addSubview:lineView];
        [self addSubview:lineView2];
        [self addSubview:_videoBtn];
        [self addSubview:_fastChatRentBtn];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.width.equalTo(@1);
            make.leading.equalTo(@(SCREEN_WIDTH * scale));
            make.bottom.equalTo(@(-SafeAreaBottomHeight));
        }];
        
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(@0);
            make.height.equalTo(@1);
        }];
        
        [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lineView.mas_trailing).offset(12);
            make.top.equalTo(@8);
            make.bottom.equalTo(@(-SafeAreaBottomHeight - 8));
            make.trailing.equalTo(@(-12));
        }];
        
        [_fastChatRentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@12);
            make.top.equalTo(@8);
            make.bottom.equalTo(@(-SafeAreaBottomHeight - 8));
            make.width.equalTo(@(SCREEN_WIDTH * scale - 24));
        }];
        
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.equalTo(@0);
//            make.bottom.mas_equalTo(-SafeAreaBottomHeight);
//            make.height.equalTo(@55);
//        }];
    }
    return self;
}

- (void)videoConnectClick {
    !self.videoConnect ? : self.videoConnect();
}

- (void)rentClick {
    !self.rentNow ? : self.rentNow();
}

@end
