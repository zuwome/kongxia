//
//  ZZProtocolViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/25.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZProtocolViewController.h"

#import "ZZViewHelper.h"

@interface ZZProtocolViewController ()

@end

@implementation ZZProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.isMianZe ? @"免责声明" : @"空虾用户协议";
    
    [self createViews];
}

- (void)navigationLeftBtnClick {
    [ZZHUD dismiss];
    if (self.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createViews
{
    UIView *webView = [ZZViewHelper createWebView];
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    NSString *urlString = H5Url.userProtocol;
    if (IOS8_OR_LATER) {
        [(WKWebView *)webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    } else {
        [(UIWebView *)webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
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
