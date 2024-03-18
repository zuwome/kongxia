//
//  LoginHelper.m
//  Exercise    
//
//  Created by qiming on 2020/10/13.
//

#import "LoginHelper.h"
#import <ATAuthSDK/ATAuthSDK.h>
#import "ZZPasswordSetViewController.h"
#import "ZZSignUpS1ViewController.h"
#import "ZZActivityUrlNetManager.h"
#import <MGFaceIDLiveDetect/MGFaceIDLiveDetect.h>
#import "ZZLoginViewController.h"

@interface LoginHelper()

@property(nonatomic, strong)UIViewController *controller;

@property(nonatomic, assign)BOOL isPushed;

@end

@implementation LoginHelper

+ (void)setAliAuthenSDK {
    NSString *version = [[TXCommonHandler sharedInstance] getVersion];
     [[TXCommonHandler sharedInstance] setAuthSDKInfo:AliAuthKey complete:nil];
}

+ (instancetype)sharedInstance {
    static LoginHelper *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[LoginHelper alloc] init];
    });
    return shareInstance;
}

+ (void)showLoginViewIn:(UIViewController *)controller {
    [[LoginHelper sharedInstance] showLoginViewIn:controller];
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)isAlreadyDisPlayed {
    UIViewController *controller = [UIViewController currentDisplayViewController];
    NSString *cname = NSStringFromClass([controller class]);
    if ([cname isEqualToString:@"TXSSOLoginViewController"] || [controller isKindOfClass:[ZZLoginViewController class]]) {
        return YES;
    }
    return NO;
}

- (void)showLoginViewIn:(UIViewController *)controller {
    if ([self isAlreadyDisPlayed]) {
        return;
    }
    
    WeakSelf
    [ZZHUD show];
    [self didSupportQuickLoginWithHandler:^(BOOL canQuickLogin) {
        if (canQuickLogin) {
            [weakSelf showAliAuthController:controller];
        }
        else {
            [ZZHUD dismiss];
            [self showLoginViewIn:controller isFromAuth:NO];
        }
    }];
}

- (void)didSupportQuickLoginWithHandler:(void(^)(BOOL canQuickLogin))handler {
    [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
        BOOL isCanUseVerify = [PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
        
        if (isCanUseVerify) {
            [[TXCommonHandler sharedInstance] accelerateVerifyWithTimeout:3.0
                                        complete:^(NSDictionary * _Nonnull resultDic) {
                if (handler) {
                    handler(isCanUseVerify);
                }
            }];
        }
        else {
            if (handler) {
                handler(isCanUseVerify);
            }
        }
    }];
}

- (TXCustomModel *)buildFullScreenPortraitModelWithButton1Title:(NSString *)button1Title
                                                        target1:(id)target1
                                                      selector1:(SEL)selector1
                                                     controller:(UIViewController *)controller {
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.navColor = kGoldenRod;
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : [UIColor blackColor],
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    model.navBackImage = [UIImage imageNamed:@"x"];
    model.logoImage = [UIImage imageNamed:@"icKongxia_HighR"];
    model.changeBtnIsHidden = YES;
    model.alertBarIsHidden = YES;

    model.privacyOne = @[@"《空虾用户协议》", H5Url.userProtocol];
    model.privacyTwo = @[@"《空虾隐私权政策》", H5Url.privacyProtocol];
    model.privacyOperatorPreText = @"《";
    model.privacyOperatorSufText = @"》";
    model.privacyColors = @[UIColor.blackColor, HEXCOLOR(0xF4cb07)];
    model.checkBoxIsHidden = YES;
    
    model.privacyNavColor = kGoldenRod;
    model.privacyNavBackImage = [UIImage imageNamed:@"x"];
    
    model.loginBtnHeight = 54;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"本机号码一键登录" attributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
        NSForegroundColorAttributeName: RGBCOLOR(51, 51, 51),
      }];
    model.loginBtnText =str;
    model.loginBtnBgImgs = @[[UIImage imageNamed:@"icRent"], [UIImage imageNamed:@"icon_chat_status_ban"], [UIImage imageNamed:@"icRent"]];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:button1Title forState:UIControlStateNormal];
    [button1 setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
    // 绑定数据源
    objc_setAssociatedObject(button1, @"controller", controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:button1];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + 20,
                                   CGRectGetWidth(loginFrame),
                                   30);
    };
    return model;
}

- (void)gotoSmsControllerAndShowNavBar:(UIButton *)sender {
    ZZLoginViewController *controller = [[ZZLoginViewController alloc] init];
    controller.isFromAliAuthen = YES;
    id data = objc_getAssociatedObject(sender, @"controller");
    if (data != NULL && [data isKindOfClass: [UIViewController class]]) {
        UIViewController *pController = (UIViewController *)data;
        if (pController.presentedViewController) {
            UINavigationController *nav = (UINavigationController *)pController.presentedViewController;
            
            if (@available(iOS 15.0, *)) {
                UINavigationBarAppearance *navigationBarAppearance = [UINavigationBarAppearance new];
                navigationBarAppearance.backgroundColor = kYellowColor;
                nav.navigationBar.scrollEdgeAppearance = navigationBarAppearance;
                nav.navigationBar.standardAppearance = navigationBarAppearance;
            }
            //找到授权页的导航控制器
            [nav pushViewController:controller animated:YES];
        }
    }
}

- (void)showAliAuthController:(UIViewController *)controller {
    __weak typeof(self) weakSelf = self;
    [[TXCommonHandler sharedInstance] accelerateVerifyWithTimeout:3.0
                                                         complete:^(NSDictionary * _Nonnull resultDic) {
        [ZZHUD dismiss];
        if ([PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]] == NO) {
            [self showLoginViewIn:controller isFromAuth:YES];
            return ;
        }
        
        TXCustomModel *model = [self buildFullScreenPortraitModelWithButton1Title:@"切换到其他方式" target1:self selector1:@selector(gotoSmsControllerAndShowNavBar:) controller:controller];
        
        [[TXCommonHandler sharedInstance]  getLoginTokenWithTimeout:3 controller:controller model:model complete:^(NSDictionary * _Nonnull resultDic) {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
                
            }
            else if ([PNSCodeSuccess isEqualToString:resultCode]) {
                [weakSelf loginWithToken:resultDic[@"token"] controller:controller];
            }
            else {
                [self showLoginViewIn:controller isFromAuth:YES];
            }
        }];
    }];
}

- (void)showLoginViewIn:(UIViewController *)controller isFromAuth:(BOOL)isFromAuth {
    [ZZHUD dismiss];
    if ([self isAlreadyDisPlayed]) {
        return;
    }
    
    ZZLoginViewController *loginController = [[ZZLoginViewController alloc] init];
    loginController.isFromAliAuthen = isFromAuth;
    
    ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:loginController];
    [controller presentViewController:navCtl animated:YES completion:nil];
}

- (void)loginWithToken:(NSString *)token controller:(UIViewController *)controller {
    if (isNullString(token)) {
        return;
    }
    
    WeakSelf
    [ZZHUD show];
    [ZZRequest method:@"POST" path:@"/user/aliGetMobile" params:@{@"AccessToken" : token} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error == NULL) {
            NSString *mobile = nil;
            BOOL hasRegister = [data[@"hasRegister"] boolValue];
            id getMobileResultDTO = data[@"GetMobileResultDTO"];
            if ([getMobileResultDTO isKindOfClass: [NSDictionary class]]) {
                NSDictionary *dto = (NSDictionary *)getMobileResultDTO;
                if (dto[@"Mobile"] != NULL) {
                    mobile = dto[@"Mobile"];
                }
            }
            if (hasRegister && mobile != NULL) {
                [weakSelf quickLoginWithToken:token controller:controller];
            }
            else {
                [ZZHUD dismiss];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
                    userHelper.uploadToken = ((NSDictionary *)data)[@"upload_token"];
                }
                [weakSelf qucikLoginSetPassword:token controller:controller];
            }
        }
        else {
//            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

- (void)quickLoginWithToken:(NSString *)token controller:(UIViewController *)controller {
    WeakSelf;
    [ZZRequest method:@"POST" path:@"/user/loginByAliMobile" params:@{@"AccessToken" : token} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        if (error != nil) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            BOOL accountCancel = [weakSelf isUserAccountCancel:data controller:controller block:^{
                [weakSelf loginEndByResData:data controller:controller];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [controller dismissViewControllerAnimated:YES completion:^{
                            if ([ZZUserHelper shareInstance].location) {
                                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                            }
                        }];
                    });
            }];
            if (!accountCancel) {
                [weakSelf loginEndByResData:data controller:controller];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [controller dismissViewControllerAnimated:YES completion:^{
                            if ([ZZUserHelper shareInstance].location) {
                                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
                            }
                        }];
                    });
            }
        }
    }];
}

- (void)qucikLoginSetPassword:(NSString *)token  controller:(UIViewController *)controller {
    ZZPasswordSetViewController *pcontroller = [[ZZPasswordSetViewController alloc] init];
    pcontroller.isQuickLogin = YES;
    pcontroller.quickLoginToken = token;
    pcontroller.isFromAliAuthen = YES;
    if (controller.presentedViewController) {
        //找到授权页的导航控制器
        [(UINavigationController *)controller.presentedViewController pushViewController:pcontroller animated:YES];
    }
}

- (BOOL)isUserAccountCancel:(id)data controller:(UIViewController *)controller block:(void (^)(void))block {
    ZZUser *loginer = [ZZUser yy_modelWithJSON:data[@"usaer"]];
    if (loginer.have_close_account) {
        ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
        userHelper.uploadToken = data[@"upload_token"];
        // 临时解决方案
        UIViewController *vc = [UIViewController currentDisplayViewController];
        [UIAlertController showOkCancelAlertIn:vc
                                         title:@"该帐号已被注销"
                                       message:@"是否重新启用该帐号"
                                  confirmTitle:@"确认启用"
                                confirmHandler:^(UIAlertAction * _Nonnull action) {
            [ZZUserHelper shareInstance].publicToken = data[@"access_token"];
            ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeRestartPhone inController:vc];
            helper.checkSuccess = ^{
                [ZZRequest method:@"POST" path:@"/api/user/account/recover" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    } else {
                        [ZZHUD showSuccessWithStatus:@"您的账号已被重新激活"];
                        block();
                    }
                }];
            };
            [helper start];
        } cancelTitle:@"取消" cancelHandler:nil];
        return YES;
    }
    return NO;
}

- (BOOL)loginEndByResData:(id)data controller:(UIViewController *)controller {
    ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
    userHelper.uploadToken = data[@"upload_token"];
    
    if (!data[@"access_token"]) {
        return NO;
    }
    ZZUser *loginer = [ZZUser yy_modelWithJSON:data[@"user"]];
    
    if (!loginer.phone) {
        ZZSignUpS1ViewController *s1 = [[ZZSignUpS1ViewController alloc] init];
        s1.user = loginer;
        s1.isUpdatePhone = YES;
        [controller.navigationController pushViewController:s1 animated:YES];
        userHelper.publicToken = data[@"access_token"];
        return YES;
    }
    if (data[@"access_token"]) {
        userHelper.oAuthToken = data[@"access_token"];
        [userHelper saveLoginer:loginer postNotif:YES];
        
        //登录成功开启内购漏单检测
        [ZZPayHelper startManager];
        [ZZActivityUrlNetManager requestHtmlActivityUrlDetailInfo];//h5活动页

        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserLogin object:self];
        return YES;
    } else {
        return NO;
    }
}

@end
