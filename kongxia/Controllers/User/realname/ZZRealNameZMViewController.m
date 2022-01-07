//
//  ZZRealNameZMViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/7.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRealNameZMViewController.h"
#import "ZZRealNameInfoView.h"
#import "ZZRealNameZMBindViewController.h"

@interface ZZRealNameZMViewController ()

@end

@implementation ZZRealNameZMViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kYellowColor cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kYellowColor cornerRadius:0]];
    self.navigationController.navigationBar.tintColor = kYellowColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"芝麻信用";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createViews];
}

- (void)createViews
{
    ZZRealNameInfoView *infoView = [[ZZRealNameInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
    infoView.infoLabel.text = @"您的账户还未绑定芝麻信用";
    [self.view addSubview:infoView];
    
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.textColor = kGrayContentColor;
    firstLabel.font = [UIFont systemFontOfSize:14];
    firstLabel.text = @" 1.绑定芝麻信用即通过实名认证，一步到位";
    [self.view addSubview:firstLabel];
    
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_centerY);
    }];
    
    UIView *imgBgView = [[UIView alloc] init];
    [self.view addSubview:imgBgView];
    
    [imgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoView.mas_bottom);
        make.left.mas_equalTo(infoView.mas_left);
        make.right.mas_equalTo(infoView.mas_right);
        make.bottom.mas_equalTo(firstLabel.mas_top);
    }];
    
    CGFloat scale = SCREEN_HEIGHT/667.0;
    UIImageView *logoImgView = [[UIImageView alloc] init];
    logoImgView.image = [UIImage imageNamed:@"icon_zhima_logo"];
    logoImgView.contentMode = UIViewContentModeScaleToFill;
    [imgBgView addSubview:logoImgView];
    
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imgBgView.mas_centerX);
        make.centerY.mas_equalTo(imgBgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(73*scale, 119*scale));
    }];
    
    UILabel *secLabel = [[UILabel alloc] init];
    secLabel.textAlignment = NSTextAlignmentCenter;
    secLabel.textColor = kGrayContentColor;
    secLabel.font = [UIFont systemFontOfSize:14];
    secLabel.text = @"2.绑定芝麻信用后提现更方便，账户更安全";
    [self.view addSubview:secLabel];
    
    [secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(firstLabel.mas_bottom).offset(37*scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UILabel *thirdLabel = [[UILabel alloc] init];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.textColor = kGrayContentColor;
    thirdLabel.font = [UIFont systemFontOfSize:14];
    thirdLabel.text = @"3.可提高您的邀请成功率和信用度";
    [self.view addSubview:thirdLabel];
    
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secLabel.mas_bottom).offset(37*scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UIView *btnBgView = [[UIView alloc] init];
    [self.view addSubview:btnBgView];
    
    [btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thirdLabel.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    UIButton *binBtn = [[UIButton alloc] init];
    binBtn.backgroundColor = kYellowColor;
    [binBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
    [binBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    binBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [binBtn addTarget:self action:@selector(bindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:binBtn];
    
    [binBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnBgView.mas_centerY);
        make.left.mas_equalTo(btnBgView.mas_left).offset(15);
        make.right.mas_equalTo(btnBgView.mas_right).offset(-15);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - UIButtonMethod

- (void)bindBtnClick
{
    ZZRealNameZMBindViewController *controller = [[ZZRealNameZMBindViewController alloc] init];
    controller.user = _user;
    controller.successCallBack = ^{
        if (_successCallBack) {
            _successCallBack();
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
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
