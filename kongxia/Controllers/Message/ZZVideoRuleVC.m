//
//  ZZVideoRuleVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/10/19.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZVideoRuleVC.h"

@interface ZZVideoRuleVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableData *mutableData;
@property (nonatomic, strong) UIImage *image;

@end

@implementation ZZVideoRuleVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"1v1视频规则";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
}

#pragma mark - Private methods

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];

    [ZZHUD show];
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"]; //设置请求方式
    [request setTimeoutInterval:60];//设置超时时间
    
    self.mutableData = [[NSMutableData alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:self];//发送一个异步请求
}

- (void)showImageView {
    
    // 比例
    CGFloat scale = self.image.size.width / self.image.size.height;
    // 适应屏幕高
    CGFloat height = self.scrollView.width / scale;

    self.scrollView.contentSize = CGSizeMake(0, height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    imageView.image = self.image;

    [self.scrollView addSubview:imageView];
}

#pragma mark - NSURLConnection delegate

// 数据组
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.mutableData appendData:data];
}

// 加载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    UIImage *image = [UIImage imageWithData:self.mutableData];
    self.image = image;
    
    [ZZHUD dismiss];
    [self showImageView];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"请求网络失败:%@",error);
    [ZZHUD showErrorWithStatus:@"加载失败"];
}

@end
