//
//  ZZShowAgainSure.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZShowAgainSure.h"
@interface ZZShowAgainSure()
@property (nonatomic,copy) dispatch_block_t sureButtonCallBlack;
@property (nonatomic,copy) dispatch_block_t immediatelyButtonCallBlack;
@property (nonatomic,copy) dispatch_block_t cancelButtonCallBlack;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *lookImageView;//喜欢的❤️
@property (nonatomic, strong) UILabel *tiShiLab;
@property (nonatomic, strong) UILabel *tiShiDetailLab;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *immediatelyButton;

@end
@implementation ZZShowAgainSure
/**
 确认
 

 @param sureButtonCallBlack 确认的回调
  @param immediatelyButtonCallBlack 立刻联系的回调
 @param cancelButtonCallBlack 取消的回调
 */
+(void)showAgainSureAlertViewSureButton:(void(^)(void))sureButtonCallBlack immediatelyButton:(void(^)(void))immediatelyButtonCallBlack  cancelButton:(void(^)(void))cancelButtonCallBlack {

    
    [[[ZZShowAgainSure alloc]init] showAgainSureAlertViewSureButton:^{
        if (sureButtonCallBlack) {
            sureButtonCallBlack();
        }
    } immediatelyButton:^{
        if (immediatelyButtonCallBlack) {
            immediatelyButtonCallBlack();
        }
    } cancelButton:^{
        if (cancelButtonCallBlack) {
            cancelButtonCallBlack();
        }
    }];
    
    
    
}
- (void)showAgainSureAlertViewSureButton:(void(^)(void))sureButtonCallBlack immediatelyButton:(void(^)(void))immediatelyButtonCallBlack  cancelButton:(void(^)(void))cancelButtonCallBlack{
    
    if (sureButtonCallBlack) {
       self.sureButtonCallBlack = sureButtonCallBlack;
    }
    if (immediatelyButtonCallBlack) {
      self.immediatelyButtonCallBlack =  immediatelyButtonCallBlack;
    }
    if (cancelButtonCallBlack) {
        self.cancelButtonCallBlack = cancelButtonCallBlack;
    }
     [self setUpUI];
   
    [self showView:nil];
   
}
#pragma mark - 布局UI
- (void)setUpUI {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.lookImageView];
    [self.bgView addSubview:self.closeButton];
    [self.bgView addSubview:self.tiShiLab];
    [self.bgView addSubview:self.tiShiDetailLab];
    [self.bgView addSubview:self.sureButton];
    [self.bgView addSubview:self.immediatelyButton];
    [self setUpTheConstraints];
    
}
/**
 设置约束
 */
- (void)setUpTheConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
    make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.985);
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(285), AdaptedWidth(285)*0.824));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.offset(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.lookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(60), AdaptedWidth(60)));
        make.top.mas_equalTo(AdaptedHeight(22.5));
    }];

    [self.tiShiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
  make.centerY.mas_equalTo(self.bgView.mas_centerY).multipliedBy(0.91);
    }];
    [self.tiShiDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
    make.top.mas_equalTo(self.tiShiLab.mas_bottom).with.offset(AdaptedHeight(10));
    }];
   
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
       make.right.equalTo(self.immediatelyButton.mas_left).offset(-13);

        make.bottom.offset(-15);
        make.height.equalTo(@45);
    }];
    [self.immediatelyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.equalTo(self.sureButton.mas_height);
        make.width.equalTo(self.sureButton.mas_width);
        make.bottom.offset(-15);
    }];
    
}

#pragma mark -懒加载

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 4;
        
    }
    return _bgView;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"rectangle99"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickDissMiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:@"继续差评" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton setBackgroundColor:RGBCOLOR(216, 216, 216)];
        _sureButton.layer.cornerRadius = 4;
        _sureButton.clipsToBounds = YES;
           [_sureButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    }
    return _sureButton;
}

-(UIButton *)immediatelyButton{
    if (!_immediatelyButton) {
        _immediatelyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_immediatelyButton addTarget:self action:@selector(immediatelyButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_immediatelyButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_immediatelyButton setTitle:@"立刻沟通" forState:UIControlStateNormal];
        [_immediatelyButton setBackgroundColor:RGBCOLOR(244, 203, 7)];
        _immediatelyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _immediatelyButton.layer.cornerRadius = 4;
        _immediatelyButton.clipsToBounds = YES;
    }
    return _immediatelyButton;
}

- (UILabel *)tiShiLab {
    if (!_tiShiLab) {
        _tiShiLab = [[UILabel alloc]init];
        _tiShiLab.font = [UIFont systemFontOfSize:15];
        _tiShiLab.text = @"温馨提示";
        _tiShiLab.textColor = kBlackColor;
        _tiShiLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tiShiLab;
}
-(UILabel *)tiShiDetailLab {
    if (!_tiShiDetailLab) {
       _tiShiDetailLab = [[UILabel alloc]init];
        _tiShiDetailLab.font = [UIFont systemFontOfSize:15];
        _tiShiDetailLab.text = @"差评前，可以先和对方沟通一下";
        _tiShiDetailLab.textColor = kBlackColor;
        _tiShiDetailLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tiShiDetailLab;
}
- (UIImageView *)lookImageView {
    if (!_lookImageView) {
        _lookImageView = [UIImageView new];
        _lookImageView.image = [UIImage imageNamed:@"picTishiNegative"];
    }
    return _lookImageView;
}
#pragma mark - 点击事件
- (void)sureButtonClick {
    [self dissMiss];
    if (self.sureButtonCallBlack) {
        self.sureButtonCallBlack();
    }
}
- (void)immediatelyButtonClick {
    [self dissMiss];
    if (self.immediatelyButtonCallBlack) {
        self.immediatelyButtonCallBlack();
    }
}

- (void)clickDissMiss {
    [self dissMiss];
    if (self.cancelButtonCallBlack) {
           self.cancelButtonCallBlack();
    }
}
@end
