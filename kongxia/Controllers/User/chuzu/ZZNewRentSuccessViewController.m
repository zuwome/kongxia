//
//  ZZNewRentSuccessViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewRentSuccessViewController.h"
#import "ZZRentSuccessShadowView.h"
#import "ZZOpenSanChatSuccessViewController.h"
#import "ZZOpenNotificationGuide.h"
#import "ZZUserEditViewController.h"
#define BackWhenRentSuccesKey @"BackWhenRentSuccesKey" //当出租成功的返回
#define NextWhenOpenRobTask @"NextWhenOpenRobTask" //当开启抢任务模式
#import "ZZRentSuccessModel.h"
@interface ZZNewRentSuccessViewController ()
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel  *titleDetailsLab;
@property (nonatomic,strong) ZZRentSuccessShadowView *showBgView;
@end

@implementation ZZNewRentSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ZZRentSuccessModel getRentSuccessCallBack:^(ZZRentSuccessModel *rentSuccessModel) {
        [self updateUIWithModel:rentSuccessModel];
    }];
    [self setUI];
    [self setUpTheConstraints];
}
- (void)updateUIWithModel:(ZZRentSuccessModel *)rentSuccessModel {
    self.titleDetailsLab.text = rentSuccessModel.title;
    self.showBgView.morePromptLab.text = rentSuccessModel.desc;
    self.showBgView.instructionsLab.text = rentSuccessModel.detail;
    [UILabel changeLineSpaceForLabel:self.showBgView.instructionsLab WithSpace:5];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
/**
 设置UI
 */
- (void)setUI {
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.showBgView];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.titleDetailsLab];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
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

}
/**
 设置约束
 */
- (void)setUpTheConstraints {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(AdaptedHeight(NAVIGATIONBAR_HEIGHT));
        make.height.mas_equalTo(@36);
    }];
    [self.titleDetailsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.titleLab.mas_bottom).offset(18);
    }];
    
    [self.showBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(-49);
        make.top.equalTo(self.titleDetailsLab.mas_bottom).offset(28);
    }];

    UILabel *robTaskLab = [[UILabel alloc]init];
    [self.showBgView addSubview:robTaskLab];
    
    

}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"申请成功";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = ADaptedFontBoldSize(28);
        _titleLab.textColor = RGBCOLOR(255, 255, 255);
    }
    return _titleLab;
}
- (ZZRentSuccessShadowView *)showBgView {
    if (!_showBgView) {
        _showBgView = [[ZZRentSuccessShadowView alloc]initWithFrame:CGRectZero];
        WS(weakSelf);
        _showBgView.sureCallBlock = ^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf nextClick];
        };
    }
    return _showBgView;
}


/**
 下一步
 */
- (void)nextClick {
    NSString *fist =  [ZZUserDefaultsHelper objectForDestKey:NextWhenOpenRobTask];
    if (!fist) {
        if (([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone)&&_showBgView.openSwitch.on) {
    [ZZOpenNotificationGuide openNotificationWhenOpenRentSuccess:self heightProportion:0.45 showMessageTitle:@"获得首页推荐机会\n及时处理邀约信息，轻松获得收益" showImageName:@"bgNoticePopup_rent" showTitleColor:RGBCOLOR(63, 58, 58)];
            [ZZUserDefaultsHelper setObject:NextWhenOpenRobTask forDestKey:NextWhenOpenRobTask];
            return;
        }
    }
    WS(weakSelf);
    ZZUser *model = [[ZZUser alloc] init];

    [model updateWithParam:@{@"push_config":@{@"pd_push":@(_showBgView.openSwitch.on)}} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
           weakSelf.showBgView.openSwitch.on =! _showBgView.openSwitch.on;
        } else {
            ZZUser *user   = [[ZZUser alloc] initWithDictionary:data error:nil];
            weakSelf.showBgView.openSwitch.on = user.push_config.pd_push;
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            if ([ZZUserHelper shareInstance].configModel.can_skip_qchat) {
                [weakSelf jumpClick:ShowHUDType_OpenRentSuccess];
            } else {
                [weakSelf jumpOpenSanChatSuccess];
            }
        }
    }];
}
- (void)jumpClick:(ShowHUDType)type { //跳过
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    controller.gotoRootCtl = YES;
    controller.showType = type;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)jumpOpenSanChatSuccess {
    ZZOpenSanChatSuccessViewController *newOpen = [[ZZOpenSanChatSuccessViewController alloc]init];
    [self.navigationController pushViewController:newOpen animated:YES];
}
- (UILabel *)titleDetailsLab {
    if (!_titleDetailsLab) {
        _titleDetailsLab = [[UILabel alloc]init];
        _titleDetailsLab.textColor = RGBCOLOR(255, 255, 255);
        _titleDetailsLab.textAlignment = NSTextAlignmentCenter;
        _titleDetailsLab.numberOfLines = 0;
        _titleDetailsLab.font = ADaptedFontBoldSize(16);
        _titleDetailsLab.text = @"您已申请成功！与其等待邀约，不如主动抢邀约";
    }
    return _titleDetailsLab;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"newOpenRentSuccess"];
        _bgImageView.alpha = 0.87;
    }
    return _bgImageView;
}


/**
 开启强任务模式
 */
- (void)openTask {

}

- (void)leftBtnNavigationClick {
    [ZZHUD dismiss];
    NSString *first = [ZZUserDefaultsHelper objectForDestKey:BackWhenRentSuccesKey];
    if (!first) {
        if (([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone)) {
             [ZZOpenNotificationGuide openNotificationWhenOpenRentSuccess:self heightProportion:0.45 showMessageTitle:@"获得首页推荐机会\n及时处理邀约信息，轻松获得收益" showImageName:@"bgNoticePopup_rent" showTitleColor:RGBCOLOR(63, 58, 58)];
            [ZZUserDefaultsHelper setObject:BackWhenRentSuccesKey forDestKey:BackWhenRentSuccesKey];
            
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
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
