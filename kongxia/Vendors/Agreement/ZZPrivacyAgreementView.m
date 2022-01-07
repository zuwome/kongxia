//
//  ZZPrivacyAgreementView.m
//  zuwome
//
//  Created by YuTianLong on 2017/9/27.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZPrivacyAgreementView.h"

@interface ZZPrivacyAgreementView () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ZZPrivacyAgreementView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZPrivacyAgreementView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZPrivacyAgreementView);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

commonInitImplementationSafe(ZZPrivacyAgreementView) {

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 10.0f;
    backgroundView.layer.borderWidth = 1.0f;
    backgroundView.layer.borderColor = RGBCOLOR(227, 227, 227).CGColor;
    
    NSString *htmlString = [NSString stringWithFormat:@"http://static.zuwome.com/privacy.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlString]];
    
    // 隐私协议 H5
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = NO;
    webView.opaque = NO;
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    webView.userInteractionEnabled = YES;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    [webView loadRequest:request];
    self.webView = webView;

    UIView *separator = [UIView new];
    separator.backgroundColor = RGBCOLOR(227, 227, 227);
    
    UIView *line = [UIView new];
    line.backgroundColor = RGBCOLOR(227, 227, 227);
    
    UIButton *unAgreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unAgreeButton setTitle:@"不同意" forState:UIControlStateNormal];
    [unAgreeButton setTitleColor:RGBCOLOR(33, 158, 252) forState:UIControlStateNormal];
    unAgreeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [unAgreeButton addTarget:self action:@selector(unAgreeCLick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    [agreeButton setTitleColor:RGBCOLOR(251, 41, 50) forState:UIControlStateNormal];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [agreeButton addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [backgroundView addSubview:self.webView];
    [backgroundView addSubview:separator];
    [backgroundView addSubview:line];
    [backgroundView addSubview:unAgreeButton];
    [backgroundView addSubview:agreeButton];
    [self addSubview:backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@35);
        make.trailing.equalTo(@(-35));
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@(300 * self.height / 500.0f));
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@5);
        make.trailing.equalTo(@(-5));
        make.bottom.equalTo(separator.mas_top);
    }];
    
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(unAgreeButton.mas_top);
        make.height.equalTo(@1);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.bottom.equalTo(@0);
        make.width.equalTo(@1);
        make.height.equalTo(@45);
    }];
    
    [unAgreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(@0);
        make.height.equalTo(@45);
        make.trailing.equalTo(backgroundView.mas_centerX).offset(-1);
    }];
    
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(@0);
        make.height.equalTo(unAgreeButton.mas_height);
        make.leading.equalTo(backgroundView.mas_centerX).offset(1);
    }];
}

#pragma mark - Private methods

- (void)show:(BOOL)animated {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.alpha = 0.5;
    [window addSubview:self];
    animated ?
    [self shakeToShow:self] :
    nil;
}

- (void)dismiss {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.alpha = 1;
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self layoutSubviews];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)shakeToShow:(UIView *)aView{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (IBAction)unAgreeCLick:(id)sender {
    BLOCK_SAFE_CALLS(self.agreeBlock, NO);
}

- (IBAction)agreeClick:(id)sender {
    BLOCK_SAFE_CALLS(self.agreeBlock, YES);
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

@end
