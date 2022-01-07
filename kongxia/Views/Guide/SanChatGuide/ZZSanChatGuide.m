//
//  ZZSanChatGuide.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/24.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSanChatGuide.h"
@interface ZZSanChatGuide()
//提示框
@property (strong, nonatomic) UIView *alertView;
//x 按钮  关闭
@property (strong, nonatomic) UIButton *closeButton;
//欢迎的提示语
@property (strong, nonatomic) UILabel *welcomeLab;

/**
 1v1提示
 */
@property (strong, nonatomic) UILabel *oneToOneLab;

/**
 1V1 子标题
 */
@property (strong, nonatomic) UILabel *oneToOneSubLab;

/**
 底部的按钮
 */
@property (strong, nonatomic) UIButton *boomButton;

/**
 背景颜色
 */
@property (strong, nonatomic) UIImageView *welcomeImageView;

@end
@implementation ZZSanChatGuide

- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.70];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.welcomeImageView];
        [self.alertView addSubview:self.oneToOneSubLab];
        [self.alertView addSubview:self.oneToOneLab];
        [self.alertView addSubview:self.boomButton];

        [self.alertView addSubview:self.welcomeLab];
        [self.alertView addSubview:self.closeButton];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:tap1];

    }
    return self;
}
+ (void)ShowSanChatGuide {
    [[[ZZSanChatGuide alloc]init] show];
}

- (void)show {

    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
    } completion:nil];
}
- (void)layoutSubviews {
    [self setUpTheConstraints];
}
/**
 消失
 */
- (void)dissMiss {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - 懒加载

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc]init];
        _alertView.center = self.center;
        _alertView.bounds = CGRectMake(0, 0, SCREEN_WIDTH*0.845, SCREEN_WIDTH*0.78);
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.clipsToBounds = YES;
        _alertView.layer.cornerRadius = 4;
    }
    return _alertView;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"rectangle99"] forState:UIControlStateNormal];
        
    }
    return _closeButton;
}

- (UILabel *)welcomeLab {
    if (!_welcomeLab) {
        _welcomeLab = [[UILabel alloc]init];
        _welcomeLab.textAlignment = NSTextAlignmentCenter;
        NSString *text = @"欢迎来到「闪聊」";
        _welcomeLab.textColor = kBlackColor;
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = [text rangeOfString:@"欢迎来到"];
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        if (fontFirst != nil) {
            [attrString addAttribute:NSFontAttributeName
                               value:fontFirst
                               range:NSMakeRange(0,range.location)];
            UIFont *secondFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
            
            [attrString addAttribute:NSFontAttributeName
                               value:secondFont
                               range:NSMakeRange(range.location, text.length - range.location)];
            
            [_welcomeLab setAttributedText:attrString];
        }
       
    }
    return _welcomeLab;
}
- (UILabel *)oneToOneLab {
    if (!_oneToOneLab) {
        _oneToOneLab = [[UILabel alloc]init];
        _oneToOneLab.text = @"1V1视频互动";
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        if (fontFirst !=nil) {
            _oneToOneLab.font = fontFirst;
        }
        else{
            _oneToOneLab.font = [UIFont systemFontOfSize:15];
        }

        _oneToOneLab.textColor = kBlackColor;
        _oneToOneLab.textAlignment = NSTextAlignmentCenter;
    }
    return _oneToOneLab;
}

- (UILabel *)oneToOneSubLab {
    if (!_oneToOneSubLab) {
        _oneToOneSubLab = [[UILabel alloc]init];
        _oneToOneSubLab.text = @"线上分享你的才艺";
        _oneToOneSubLab.textColor = kBlackColor;
        _oneToOneSubLab.textAlignment = NSTextAlignmentCenter;
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        if (fontFirst !=nil) {
            _oneToOneSubLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        }
        else{
            _oneToOneSubLab.font = [UIFont systemFontOfSize:15];
        }

    }
    return _oneToOneSubLab;
}


- (UIButton *)boomButton {
    if (!_boomButton) {
        _boomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_boomButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [_boomButton setTitle:@"发现身边多才多艺的TA" forState:UIControlStateNormal];
        _boomButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_boomButton setBackgroundColor:RGBCOLOR(244,203,7)];
        [_boomButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        if (fontFirst !=nil) {
         _boomButton.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        }
        else{
             _boomButton.titleLabel.font = [UIFont systemFontOfSize:15];
        }
    }
    return _boomButton;
}

- (UIImageView *)welcomeImageView {
    if (!_welcomeImageView) {
        _welcomeImageView = [[UIImageView alloc]init];
        _welcomeImageView.image = [UIImage imageNamed:@"SanChat"];
    }
    return _welcomeImageView;
}


/**
 设置约束
 */
- (void)setUpTheConstraints {

    [self.welcomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.alertView.mas_centerY).multipliedBy(0.289);
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.left.offset(10);
        make.height.mas_equalTo(24);
        make.right.offset(-5);
    }];
    [self.welcomeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.height.mas_equalTo(self.alertView.mas_height).multipliedBy(0.465);
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
    }];
    [self.oneToOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.alertView.mas_centerY).multipliedBy(1.17);
        make.left.offset(5);
        make.right.offset(-5);
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.height.mas_equalTo(AdaptedWidth(21));

    }];
    [self.oneToOneSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.centerY.mas_equalTo(self.alertView.mas_centerY).multipliedBy(1.39);

    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(AdaptedWidth(44), AdaptedWidth(44)));
    }];
    
    [self.boomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AdaptedWidth(49));
        make.left.right.bottom.offset(0);
    }];
    
  
}

#pragma mark - 点击消失

- (void)click {
    [self dissMiss];
}

@end
