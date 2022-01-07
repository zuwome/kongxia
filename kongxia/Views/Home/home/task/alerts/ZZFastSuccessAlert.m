//
//  ZZFastSuccessAlert.m
//  zuwome
//
//  Created by YuTianLong on 2018/1/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZFastSuccessAlert.h"

@interface ZZFastSuccessAlert ()

//@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, strong) UIImageView *centerImgView;
//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *contentLabel;
//@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, copy) void(^actionBlock)(void);

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) ZZFastToastView *toastView;

@end

@implementation ZZFastSuccessAlert

+ (instancetype)showWithType:(FastSuccessToastType)type action:(void (^)(void))action {
    ZZFastSuccessAlert *alertView = [[ZZFastSuccessAlert alloc] init];
    alertView.toastType = type;
    
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    [alertView show];
    return alertView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.5;
        _toastView.alpha = 1.0;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0;
        _toastView.alpha = 0;
    } completion:^(BOOL finished) {
        _actionBlock = nil;
        [_bgView removeFromSuperview];
        [_toastView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)closeAction {
    if (_actionBlock) {
        _actionBlock();
    }
    [self hide];
}

- (void)action {
    if (_actionBlock) {
        _actionBlock();
    }
    [self hide];
}

#pragma mark - UI
- (void)layoutUI {
    [self addSubview:self.bgView];
    [self addSubview:self.toastView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@286.5);
        make.height.equalTo(@371.0);
    }];
}

#pragma mark - Setter&Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.0;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
//        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (ZZFastToastView *)toastView {
    if (!_toastView) {
        _toastView = [[ZZFastToastView alloc] init];
        _toastView.alpha = 0.0;
        
        [_toastView.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [_toastView.actionButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toastView;
}

- (void)setToastType:(FastSuccessToastType)toastType {
    _toastType = toastType;
    [_toastView configToastInfoWithType:_toastType];
}

@end

@interface ZZFastToastView ()

@end

@implementation ZZFastToastView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configToastInfoWithType:(FastSuccessToastType)type {
    if (type == ToastSuccess) {
        _titleLabel.text =  @"您已成功开通闪聊功能\n我们希望你";
        
        NSString *string = @"* 遵守社交礼仪\n* 打开系统推送或经常在线，不要错过任何1V1视频呦";
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range1 = [string rangeOfString:@"* 打"];
        NSRange range2 = [string rangeOfString:@"* 遵"];
        [hintString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(244, 203, 7) range:NSMakeRange(range1.location, 1)];
        [hintString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(244, 203, 7) range:NSMakeRange(range2.location, 1)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [hintString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        
        self.subTitleLabel.attributedText = hintString;
    }
    else if (type == ToastReviewing) {
        _titleLabel.text =  @"视频咨询功能开通成功";
        _subTitleLabel.text = @"视频咨询广场推荐的都是有真实头像的优质达人，您的头像正在人工审核中，请您等待审核结果";
    }
}

#pragma mark - UI
- (void)layout {
    self.image = [UIImage imageNamed:@"bcTcSpzxktWtx"];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentScrollView];
    
    [self addSubview:self.actionButton];
    [self addSubview:self.closeButton];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self).offset(-15.0);
        make.top.equalTo(self).offset(156.0);
    }];
    
    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(0.0);
        make.width.equalTo(@213.0);
        make.height.equalTo(@78.0);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(22.0, 22.0));
    }];
    
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(33.0);
        make.right.equalTo(self).offset(-33.0);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10.0);
        make.bottom.equalTo(_actionButton.mas_top).offset(-19.0);
    }];
    
    UIView *contentView = [UIView new];
    [_contentScrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentScrollView);
        make.width.equalTo(_contentScrollView);
    }];
    
    [contentView addSubview:self.subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];

}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint pointTemp = [self convertPoint:point toView:_closeButton];
    if ([_closeButton pointInside:pointTemp withEvent:event]) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark - Setter&Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:17.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.backgroundColor = UIColor.clearColor;
        _contentScrollView.showsVerticalScrollIndicator = NO;
    }
    return _contentScrollView;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = UIColor.whiteColor;
        _subTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"icGbSpzxtc"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        [_actionButton setImage:[UIImage imageNamed:@"icZdlTc"] forState:UIControlStateNormal];
    }
    return _actionButton;
}

@end
