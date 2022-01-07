//
//  ZZSanChatMessageListGuide.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//
#import "ZZFastChatAgreementVC.h"

#import "ZZSanChatMessageListGuide.h"
@interface ZZSanChatMessageListGuide ()
@property (nonatomic,strong) UILabel *lable;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UIButton *sureOpenSanChat;
@property (nonatomic,strong) UINavigationController *nav;
@property (nonatomic,copy) dispatch_block_t closeClick;
@end

@implementation ZZSanChatMessageListGuide

+ (ZZSanChatMessageListGuide*)showOpenMessageListGuideCloseClick:(void(^)(void))closeClick nav:(UINavigationController *)nav {
    ZZSanChatMessageListGuide *openListGuide = [[ZZSanChatMessageListGuide alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    [openListGuide showOpenMessageListGuideCloseClick:^{
        if (closeClick) {
            closeClick();
        }
    } nav:nav];
    return openListGuide;
}
- (void)showOpenMessageListGuideCloseClick:(void(^)(void))closeClick nav:(UINavigationController *)nav {
    self.nav = nav;
    if (closeClick) {
       self.closeClick = closeClick;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sureOpenButtonClick)];
        [self addGestureRecognizer:tap1];
        [self addSubview:self.imageView];
        [self addSubview:self.closeButton];
        [self addSubview:self.lable];
        [self addSubview:self.sureOpenSanChat];
    }
    return self;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"icCloseKqslChatNotice"] forState:UIControlStateNormal];
    }
    return _closeButton;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"bgKaiqishanliaoChatNotice"];
    }
    return _imageView;
}

- (UILabel *)lable {
    if (!_lable) {
        _lable = [[UILabel alloc]init];
        _lable.text = @"开启视频咨询，线上互动也可获得收益";
        _lable.textColor = kBlackColor;
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.font = [UIFont systemFontOfSize:12];
    }
    return _lable;
}
- (UIButton *)sureOpenSanChat {
    if (!_sureOpenSanChat) {
        _sureOpenSanChat = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureOpenSanChat addTarget:self action:@selector(sureOpenButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureOpenSanChat setImage:[UIImage imageNamed:@"icKaiqiKqslChatNotice"] forState:UIControlStateNormal];
    }
    return _sureOpenSanChat;
}

- (void)sureOpenButtonClick {
    BOOL canProceed = [UserHelper canOpenQuickChatWithBlock:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        
    }];
    if (!canProceed) {
        return;
    }
    ZZFastChatAgreementVC *vc = [ZZFastChatAgreementVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.nav pushViewController:vc animated:YES];
}
- (void)closeButtonClick {
    if (self.closeClick) {
        self.closeClick();
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.closeButton.mas_right).with.offset(AdaptedWidth(31));
        make.centerY.equalTo(self.mas_centerY);
    make.right.greaterThanOrEqualTo(self.sureOpenSanChat.mas_left).with.offset(AdaptedWidth(-61));
    
    }];
    [self.sureOpenSanChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.offset(-15);
        make.width.equalTo(@63);
        }];
}
@end

