//
//  ZZIDPhotoPreviewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZIDPhotoPreviewController.h"

@interface ZZIDPhotoPreviewController ()

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIImageView *idPhotoimageView;

@property (nonatomic, strong) UIButton *reportBtn;

@property (nonatomic, strong) UIButton *giftBtn;

@end

@implementation ZZIDPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layout];
    [self configData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0]];
    self.navigationController.navigationBar.tintColor = kBlackTextColor;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kYellowColor cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kYellowColor cornerRadius:0]];
    self.navigationController.navigationBar.tintColor = kYellowColor;
}

- (void)configData {
    NSString *utfString = [_idPhotoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_idPhotoimageView sd_setImageWithURL:[NSURL URLWithString:utfString] completed:nil];
}

/**
 *  私信聊天
 */
- (void)chatBtnClick {
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    if ([ZZUtils isBan]) {
        return;
    }
    
    // 判断当前操作是否需要做验证
    WeakSelf
    
    if ([[ZZUserHelper shareInstance].configModel.disable_module.no_have_face indexOfObject:@"chat"] != NSNotFound) {
        // 如果没有人脸
        if ([ZZUserHelper shareInstance].loginer.faces.count == 0) {
            [UIAlertController presentAlertControllerWithTitle:@"目前账户安全级别较低，将进行身份识别，否则不能聊天" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) { // 去验证人脸
                    [weakSelf gotoVerifyFace:NavigationTypeChat];
                }
            }];
            return;
        }
    }
    [MobClick event:Event_user_detail_chat];
    
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/say_hi_status",_user.uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            if ([[data objectForKey:@"say_hi_status"] integerValue] == 0) {
                if (loginedUser.avatar_manual_status == 1) {
                    if (![loginedUser didHaveOldAvatar]) {
                        [UIAlertView showWithTitle:@"提示"
                                           message:@"打招呼需要上传本人五官正脸清晰照，您的头像还在审核中，暂不可打招呼"
                                 cancelButtonTitle:@"知道了"
                                 otherButtonTitles:nil
                                          tapBlock:nil];
                    }
                    else {
                        [weakSelf gotoChatView];
                    }
                }
            }
            else {
                [weakSelf gotoChatView];
            }
        }
    }];
}


#pragma mark - response method
- (void)reportAction {
    [self reportIDPhoto];
}

- (void)sendGiftAction {
    [self chatBtnClick];
}


#pragma mark - Navigator
- (void)gotoChatView {
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    [ZZRCUserInfoHelper setUserInfo:_user];
    controller.user = _user;
    controller.nickName = _user.nickname;
    controller.uid = _user.uid;
    controller.portraitUrl = _user.avatar;
    controller.shouldShowGift = YES;
    controller.giftEntry = GiftEntryIDPhoto;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoVerifyFace:(NavigationType)type {   // 没有人脸，则验证人脸
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    helper.from = _user;
    [helper start];
}

#pragma mark - Request
- (void)reportIDPhoto {
    NSDictionary *param = @{
        @"to": _user.uid,
        @"img": _idPhotoURL,
    };
    [ZZRequest method:@"POST"
                 path:@"/api/reportIdPhoto"
               params:param
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD showSuccessWithStatus:@"举报成功！我们将尽快核实，谢谢您的反馈"];
    }];
}


#pragma mark - Layout
- (void)layout {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"picBgLiwu"];
    imageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.idPhotoimageView];
    [self.view addSubview:self.reportBtn];
    [self.view addSubview:imageView];
    [imageView addSubview:self.giftBtn];

    [_idPhotoimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
        make.size.mas_equalTo(CGSizeMake(SCALE_SET(305), SCALE_SET(405)));
    }];
    
    [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_idPhotoimageView).offset(10);
        make.top.equalTo(_idPhotoimageView.mas_bottom).offset(46.0);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_reportBtn.mas_right).offset(41);
        make.top.equalTo(_idPhotoimageView.mas_bottom).offset(41.0);
        make.size.mas_equalTo(CGSizeMake(209, 80));
    }];
    
    [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView).offset(10);
        make.top.equalTo(imageView).offset(5);
        make.size.mas_equalTo(CGSizeMake(189, 60));
    }];
    
    [self.view layoutIfNeeded];
    
    [_reportBtn setImagePosition:LXMImagePositionTop spacing:1];
    [_giftBtn setImagePosition:LXMImagePositionLeft spacing:10.0];

}

#pragma mark - getters and setters
- (UIImageView *)idPhotoimageView {
    if (!_idPhotoimageView) {
        _idPhotoimageView = [[UIImageView alloc] init];
        _idPhotoimageView.contentMode = UIViewContentModeScaleAspectFit;
        _idPhotoimageView.backgroundColor = UIColor.blackColor;
    }
    return _idPhotoimageView;
}

- (UIButton *)reportBtn {
    if (!_reportBtn) {
        _reportBtn = [[UIButton alloc] init];
        _reportBtn.normalImage = [UIImage imageNamed:@"icJubaoZjzh"];
        _reportBtn.normalTitle = @"举报";
        _reportBtn.normalTitleColor = RGBCOLOR(136, 136, 136);
        _reportBtn.titleLabel.font = ADaptedFontMediumSize(14);
        _reportBtn.layer.borderWidth = 1.5;
        _reportBtn.layer.borderColor = RGBCOLOR(136, 136, 136).CGColor;
        _reportBtn.layer.cornerRadius = 27.5;
        _reportBtn.imageView.size = CGSizeMake(26, 22);
        [_reportBtn addTarget:self
                       action:@selector(reportAction)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportBtn;
}

- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [[UIButton alloc] init];
        _giftBtn.normalTitle = @"送TA礼物";
        _giftBtn.titleLabel.font = ADaptedFontMediumSize(17);
        _giftBtn.normalImage = [UIImage imageNamed:@"icLiwuZjzh"];
        [_giftBtn addTarget:self
                     action:@selector(sendGiftAction)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftBtn;
}

@end
