//
//  ZZOpenSuccessVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/21.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZOpenSuccessVC.h"
#import "ZZLinkWebViewController.h"
#import "ZZUserEditViewController.h"

@interface ZZOpenSuccessVC ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZZOpenSuccessVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated //出现之后
{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } 
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

#pragma mark - Private methods

- (void)setupUI {
    
   
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgKaitong"]];
    [self.view addSubview:backgroundImageView];
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
    
    UIImageView *headBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invalidName"]];
    [self.view addSubview:headBackground];
    
    [headBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.leading.equalTo(@0);
        make.width.height.equalTo(@(SCREEN_WIDTH));
    }];
    
    CGFloat headHeight = SCREEN_WIDTH / 2.5;
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[ZZUserHelper shareInstance].loginer.avatar]];

    [headBackground addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headBackground.mas_centerX);
        make.centerY.equalTo(headBackground.mas_centerY);
        make.width.height.equalTo(@(headHeight));
    }];
    
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = headHeight / 2.0;
    
    self.titleLabel = [UILabel new];
    _titleLabel.text = @"恭喜您开通成功";
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:35];
    _titleLabel.textColor = RGBCOLOR(216, 170, 111);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (!isNullString(_titleString)) {
        _titleLabel.text = _titleString;
    }
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackground.mas_bottom).offset(5);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group11"]];
    [self.view addSubview:lineImageView];
    lineImageView.contentMode = UIViewContentModeScaleAspectFit;
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.leading.equalTo(@35);
        make.trailing.equalTo(@(-35));
        make.height.equalTo(@7);
    }];
    
    UIButton *daRenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [daRenButton setTitle:@"达人攻略 >>" forState:(UIControlStateNormal)];
    [daRenButton setTitleColor:RGBCOLOR(216, 170, 111) forState:UIControlStateNormal];
    daRenButton.backgroundColor = RGBCOLOR(247, 234, 192);
    [daRenButton addTarget:self action:@selector(gotoStrategyClick:) forControlEvents:UIControlEventTouchUpInside];
    daRenButton.layer.masksToBounds = YES;
    daRenButton.layer.cornerRadius = 4.0f;
    
    [self.view addSubview:daRenButton];
    [daRenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineImageView.mas_bottom).offset(8);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@270);
        make.height.equalTo(@50);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"ic_return"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ic_return"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    
    [button addTarget:self action:@selector(leftBtnNavigationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.offset(STATUSBAR_HEIGHT);
    }];
 
}
- (void)leftBtnNavigationClick {
    [ZZHUD dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)gotoStrategyClick:(UIButton *)sender {
    
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = H5Url.darenGuide;
    controller.hidesBottomBarWhenPushed = YES;
    controller.navigationItem.title = @"达人攻略";
    [self.navigationController pushViewController:controller animated:YES];
}


@end
