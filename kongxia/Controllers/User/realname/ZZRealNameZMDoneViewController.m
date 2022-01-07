//
//  ZZRealNameZMDoneViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/20.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRealNameZMDoneViewController.h"

#import "ZZViewHelper.h"

@interface ZZRealNameZMDoneViewController ()

@end

@implementation ZZRealNameZMDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"芝麻信用";
    [self createViews];
}

- (void)createViews
{
    UIView *webView = [ZZViewHelper createWebView];
    webView.backgroundColor = kBGColor;
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    if (IOS8_OR_LATER) {
        [(WKWebView *)webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://xy.alipay.com/auth/whatszhima.htm?view=mobile&__md_hiddentoolbar=1"]]];
    } else {
        [(UIWebView *)webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://xy.alipay.com/auth/whatszhima.htm?view=mobile&__md_hiddentoolbar=1"]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
