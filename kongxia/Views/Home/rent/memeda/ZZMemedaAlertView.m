//
//  ZZMemedaAlertView.m
//  zuwome
//
//  Created by angBiu on 16/8/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMemedaAlertView.h"

#import "ZZViewHelper.h"

@implementation ZZMemedaAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        UIButton *bgBtn = [[UIButton alloc] init];
        bgBtn.backgroundColor = kBlackTextColor;
        bgBtn.alpha = 0.5;
        [self addSubview:bgBtn];
        
        [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(25*scale);
            make.right.mas_equalTo(self.mas_right).offset(-25*scale);
            make.height.mas_equalTo(350);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIView *webView = [ZZViewHelper createWebView];
        webView.backgroundColor = kBGColor;
        [self addSubview:webView];
        
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(10);
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
            make.top.mas_equalTo(bgView.mas_top).offset(10);
            make.height.mas_equalTo(@280);
        }];
        
        NSString *htmlSring = H5Url.mmdDesc;
        [(WKWebView *)webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlSring]]];
        
        UIButton *sureBtn = [[UIButton alloc] init];
        sureBtn.backgroundColor = kYellowColor;
        [sureBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [sureBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        sureBtn.layer.cornerRadius = 3;
        [sureBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:sureBtn];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(webView.mas_bottom).offset(10);
            make.left.mas_equalTo(webView.mas_left);
            make.right.mas_equalTo(webView.mas_right);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-10);
        }];
    }
    
    return self;
}

- (void)btnClick
{
    self.hidden = YES;
}

@end
