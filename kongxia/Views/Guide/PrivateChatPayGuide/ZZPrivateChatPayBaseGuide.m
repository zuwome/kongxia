//
//  ZZPrivateChatPayBaseGuide.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPrivateChatPayBaseGuide.h"
@interface ZZPrivateChatPayBaseGuide()

/**
 关闭
 */
@property (strong, nonatomic) UIButton *closeButton;
//提示框
@property (strong, nonatomic) UIView *alertView;
//知道了
@property (strong, nonatomic) UIButton *knowButton;
/**
 图片
 */
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *titleLab;

@end

@implementation ZZPrivateChatPayBaseGuide

+ (void)showSendPrivChatMessageWhenFirstInto {
   NSString *firstInto =  [ZZUserHelper firstSendPrivChatMessage];
    if (!firstInto) {
        [[[ZZPrivateChatPayBaseGuide alloc ]init] showSendPrivChatMessageWhenFirstInto];
        [ZZUserHelper setFirstSendPrivChatMessage];
    }
}
- (void)showSendPrivChatMessageWhenFirstInto {
    
    [self setUI];
}

- (void)setUI {
    
    [self addSubview:self.alertView];
    [self.alertView addSubview:self.closeButton];
    [self addSubview:self.imageView];
    [self.alertView addSubview:self.knowButton];
    [self.alertView addSubview:self.titleLab];
    [self showView:nil];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setUpTheConstraints];
}


- (void)closeBUttonClick {
    [self dissMiss];
}
- (void)setUpTheConstraints {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.alertView.mas_top);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(44, 44)));
        make.right.offset(0);
        make.top.offset(0);
    }];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(32.5);
        make.right.offset(-32.5);
        make.centerY.equalTo(self);
        make.height.equalTo(self.alertView.mas_width).multipliedBy(224.0f/310.0f);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.offset(25);
        make.right.offset(-25);
        make.bottom.lessThanOrEqualTo(self.knowButton.mas_top).with.offset(-22.5);
    }];
    [self.knowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.alertView.mas_bottom).with.offset(-19);
        make.width.equalTo(@(AdaptedWidth(150)));
        make.height.equalTo(@44);
        make.centerX.equalTo(self);
        
    }];
}
-(UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"TA设置了私信消息收费，每发送一条消息消耗2么币";
        _titleLab.textColor = RGBCOLOR(0, 0, 0 );
        _titleLab.numberOfLines = 0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_titleLab.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:12];//行距的大小
        paragraphStyle.alignment =  NSTextAlignmentCenter;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _titleLab.text.length)];
        _titleLab.attributedText = attributedString;
        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    return _titleLab;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"picPayChatPop"];
    }
    return _imageView ;
}
- (UIButton *)knowButton {
    if (!_knowButton) {
        _knowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knowButton setBackgroundColor:RGBCOLOR(244, 203, 7)];
        [_knowButton setTitle:@"知道了" forState:UIControlStateNormal];
        [_knowButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _knowButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _knowButton.layer.cornerRadius = 25;
        _knowButton.clipsToBounds = YES;
        [_knowButton addTarget:self action:@selector(closeBUttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knowButton;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc]init];
        _alertView.layer.cornerRadius = 6;
        _alertView.clipsToBounds = YES;
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"icClose_privChat"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeBUttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
    
}

@end
