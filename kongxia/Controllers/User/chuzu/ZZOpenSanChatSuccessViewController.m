//
//  ZZOpenSanChatSuccessViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOpenSanChatSuccessViewController.h"
#import "ZZOpenSanChatGuideView.h"
#import "ZZSelfIntroduceVC.h"
#import "ZZUserEditViewController.h"
@interface ZZOpenSanChatSuccessViewController ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) ZZOpenSanChatGuideView *guideView;
@property (nonatomic,strong) UIButton *jumpButton;
@property (nonatomic,strong) UIButton *netButton;

@end

@implementation ZZOpenSanChatSuccessViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setUpUI];
}

/**
 设置UI
 */
- (void)setUpUI {
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.guideView];
    [self.view addSubview:self.jumpButton];
    [self.view addSubview:self.netButton];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
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
    
    [self setUpTheConstraints];
}
/**
 设置约束
 */
- (void)setUpTheConstraints {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.right.offset(-17);
        make.height.equalTo(self.guideView.mas_width).multipliedBy(339/320.0f);
        make.top.equalTo(@(AdaptedHeight(189)));
    }];
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.equalTo(@(-SafeAreaBottomHeight));
        make.height.equalTo(@50);
        make.right.equalTo(self.netButton.mas_left);
    }];
    
    [self.netButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.equalTo(@(-SafeAreaBottomHeight));
        make.height.equalTo(@50);
        make.width.equalTo(self.jumpButton.mas_width);
    }];
    
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"bgOpenSuccess"];
        _bgImageView.alpha = 0.87;
    }
    return _bgImageView;
}
- (ZZOpenSanChatGuideView *)guideView {
    if (!_guideView) {
        _guideView = [[ZZOpenSanChatGuideView alloc]initWithFrame:CGRectZero];
    }
    return _guideView;
}
- (UIButton *)jumpButton {
    if (!_jumpButton) {
        _jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_jumpButton setTitleColor:RGBCOLOR(100, 100, 100) forState:UIControlStateNormal];
        _jumpButton.titleLabel.font = CustomFont(15);
        [_jumpButton addTarget:self action:@selector(jumpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_jumpButton setBackgroundColor:RGBCOLOR(255, 244, 227)];

    }
    return _jumpButton;
}
- (void)jumpButtonClick:(UIButton *)sender {
     NSLog(@"PY_跳过");
    [self goToPerfectInformation:ShowHUDType_OpenRentSuccess];

}
- (UIButton *)netButton {
    if (!_netButton) {
        _netButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _netButton.layer.shadowColor = RGBCOLOR(175, 157, 125).CGColor;
        _netButton.layer.shadowOffset = CGSizeMake(0, -1);
        _netButton.layer.shadowOpacity = 1;
        _netButton.layer.shadowRadius = 2;
        [_netButton setTitle:@"立即开通" forState:UIControlStateNormal];
        [_netButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        _netButton.titleLabel.font = CustomFont(15);
        [_netButton setBackgroundColor:RGBCOLOR(244, 89, 21)];
        [_netButton addTarget:self action:@selector(netButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _netButton;
}
- (void)netButtonClick:(UIButton *)sender {
     NSLog(@"PY_立即开通");
    ZZSelfIntroduceVC *introduceVC = [ZZSelfIntroduceVC new];
    introduceVC.isUploadAfterCompleted = YES;
    introduceVC.isFastChat = YES;
    introduceVC.showType = ShowHUDType_OpenSanChat;
    ZZUser *user = [ZZUserHelper shareInstance].loginer;
    if (user.base_video.status == 0) {
        introduceVC.reviewStatus = ZZVideoReviewStatusNoRecord;
        [self.navigationController pushViewController:introduceVC animated:YES];
    } else if (user.base_video.status == 1) {
        [self goToPerfectInformation:ShowHUDType_OpenSanChat];
    } else if (user.base_video.status == 2) {
        introduceVC.reviewStatus = ZZVideoReviewStatusFail;
        introduceVC.loginer = user;
        [self.navigationController pushViewController:introduceVC animated:YES];
    }
}


/**
 完善资料
 */
- (void)goToPerfectInformation:(ShowHUDType)type{
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    controller.gotoRootCtl = YES;
    controller.showType = type;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)leftBtnNavigationClick {
    [ZZHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
