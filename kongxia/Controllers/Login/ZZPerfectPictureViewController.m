//
//  ZZPerfectPictureViewController.m
//  zuwome
//
//  Created by YuTianLong on 2017/10/16.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZPerfectPictureViewController.h"
#import "ZZUploader.h"

#import "ZZChatViewController.h"
#import "ZZRentChooseSkillViewController.h"
#import "ZZUserChuzuViewController.h"
#import "ZZWXViewController.h"
#import "ZZRealNameListViewController.h"
#import "ZZSelfIntroduceVC.h"
#import "ZZRentalAgreementVC.h"
#import "ZZFastChatSettingVC.h"
#import "PECropViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZRegisterRentViewController.h"

@interface ZZPerfectPictureViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,PECropViewControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *headButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIImage *avatarImage;

@end

@implementation ZZPerfectPictureViewController

- (instancetype)initWithTitle:(NSString *)title successMessage:(NSString *)successMessage {
    self = [super init];
    if (self) {
        _mainTitle = title;
        _successMessage = successMessage;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.faces) {
        self.faces = [ZZUserHelper shareInstance].loginer.faces;
        self.user = [ZZUserHelper shareInstance].loginer;
        self.type = NavigationTypeApplyTalent;
        self.isShowTopUploadStatus = YES;
    }
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter & Setter

- (UIButton *)headButton {
    if (!_headButton) {
        // loginAvatar
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headButton setTitle:@"上传真实头像" forState:UIControlStateNormal];
        [_headButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    
        [_headButton setImage:[UIImage imageNamed:@"loginAvatar"] forState:UIControlStateNormal];

        _headButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headButton addTarget:self action:@selector(uploadPictureClick) forControlEvents:UIControlEventTouchUpInside];
        _headButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _headButton.layer.masksToBounds = YES;
        _headButton.layer.cornerRadius = 45.0f;
    }
    return _headButton;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _doneButton.backgroundColor = RGBCOLOR(240, 194, 12);
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doneButton addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _doneButton;
}

#pragma mark - Private methdso

- (void)setupUI {
    
    self.navigationItem.title = [self.mainTitle isEmptyOrWhitespace] ? @"完善资料" : self.mainTitle;
    
    [self.view addSubview:self.headButton];
    [self.view addSubview:self.doneButton];
    
    [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.centerX.equalTo(self.view);
        make.height.width.equalTo(@90);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headButton.mas_bottom).offset(50);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@50);
    }];
}

// 上传头像
- (IBAction)uploadPictureClick {
    [MobClick event:Event_click_infomation_uploadhead];
    [self.view endEditing:YES];
    [UIActionSheet showInView:self.view
                    withTitle:@"上传真实头像"
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"拍照",@"从手机相册选择"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                         if (buttonIndex ==0) {
                             UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                             [imgPicker setAllowsEditing:YES];
                             imgPicker.delegate = self;
                             [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                             imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
                             [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
                             
                         }
                         if (buttonIndex ==1) {
                             [self gotoAlbum];
                         }
                     }];

}

// 完成
- (IBAction)doneClick:(id)sender {
     if (!_avatarImage) {
        [ZZHUD showErrorWithStatus:@"头像不能为空"];
        return;
    }
    
    [self checkHeadImage];
}

- (void)photoFailAction:(ZZPhoto *)photo {
    WEAK_SELF();
    [ZZInfoToastView showWithType:ToastRealAvatarFailInPerfect action:^(NSInteger actionIndex, ToastType type) {
        if (actionIndex == -1) {
            [ZZHUD dismiss];
        }
        else if (actionIndex == 1) {
            [ZZHUD dismiss];
            [weakSelf continueSaveUserInfo:YES];
        }
        else {
            [ZZHUD dismiss];
        }
    }];
}


// 继续保存用户信息x
- (void)continueSaveUserInfo:(BOOL)shouldCheckFaceManually {
    // 如果达人视频上传成功的话，则保存的时候需要将 sk Id 上传

    NSMutableDictionary *userInfoMutableDic = [_user toDictionary].mutableCopy;
    NSMutableDictionary *userMDic = [[NSMutableDictionary alloc] init];
    userMDic[@"uid"] = _user.uid;
    userMDic[@"photos"] = userInfoMutableDic[@"photos"];
    userMDic[@"photos_origin"] = userInfoMutableDic[@"photos_origin"];
    userMDic[@"avatar"] = userInfoMutableDic[@"avatar"];
    // 假如是在审核中的话，就要把它删除掉 不要再穿了，不要后台会把旧头像清除掉
    if ([userMDic[@"avatar_manual_status"] intValue] != 1) {
        // 是否需要人工审核
        if (shouldCheckFaceManually) {
            userMDic[@"avatar_manual_status"] = @1;
        }
    }

    [_user updateUserFacesAndManualStatus:userMDic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            if ([_successMessage isEmptyOrWhitespace]) {
                [ZZHUD showWithStatus:@"更新成功"];
            }
            else {
                if (_type == NavigationTypeSignUpForTask) {
                    [ZZHUD showWithStatus:@"我们将在1个工作日内审核"];
                }
                else {
                    [ZZHUD showWithStatus:_successMessage];
                }
            }

            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            _user = loginedUser;
            // 判断跳转...
            [self pushAdjustNavigation];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedAvatar object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
        }
    }];
}

// 校验头像
- (void)checkHeadImage {
    WeakSelf
    NSData *data = [ZZUtils userImageRepresentationDataWithImage:_avatarImage];
    [ZZHUD showWithStatus:@"正在保存图片"];

    [ZZUploader putData:data next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (resp) {
            ZZPhoto *photo = [[ZZPhoto alloc] init];
            photo.url = resp[@"key"];

            [photo add:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                }
                else {
                    ZZPhoto *newPhoto = [[ZZPhoto alloc] initWithDictionary:data error:nil];
                    if (_user.photos.count == 0 || !_user.photos) {
                        _user.photos = @[newPhoto].mutableCopy;
                    }
                    else {
                        [_user.photos replaceObjectAtIndex:0 withObject:newPhoto];
                    }
                    [ZZHUD showWithStatus:@"正在检测头像"];
                    if (_user.gender == 1 && _type == NavigationTypeSignUpForTask) {
                        [weakSelf continueSaveUserInfo:YES];
                    }
                    else {
                        [_user checkPhotoIsSamePerson:newPhoto.url faces:_faces next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                            if (error) {
                                if (error.code == 1002) {
                                    [ZZHUD dismiss];
                                    [weakSelf photoFailAction:newPhoto];
                                }
                                else {
                                    [ZZHUD showErrorWithStatus:error.message];
                                    UIImage *loginAvatar = [UIImage imageNamed:@"loginAvatar.png"];
                                    [_headButton setTitle:@"上传真实头像" forState:UIControlStateNormal];
                                    [_headButton setImage:loginAvatar forState:UIControlStateNormal];
                                }
                            }
                            else {
                                NSString *isSame = data[@"isSame"];
                                if([isSame isEqual: @"false"]) {
                                    [ZZHUD dismiss];
                                    [weakSelf photoFailAction:newPhoto];
                                    
                                    if ([[data objectForKey:@"tipOpen"] boolValue]) {
                                        [UIAlertView showWithTitle:@"提示" message:data[@"tip"] cancelButtonTitle:nil otherButtonTitles:@[@"更换头像",@"识别本人"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                            if (buttonIndex == 0) {
                                                [self gotoAlbum];
                                            }
                                            if (buttonIndex == 1) {
                                                [self gotoLiveCheck];
                                            }
                                        }];
                                    }
                                }
                                else {
                                    if ([isSame isEqualToString:@"manual"]) {
                                        // 去人脸识别
                                        if ([[data objectForKey:@"tipOpen"] boolValue]) {
                                            [ZZHUD dismiss];
                                            [UIAlertView showWithTitle:@"提示" message:data[@"tip"] cancelButtonTitle:nil otherButtonTitles:@[@"识别"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                                [self gotoLiveCheck];
                                            }];
                                            return ;
                                        }
                                        else {
                                            [ZZHUD showWithStatus:@"匹配失败，已转为人工审核，正在保存..."];
                                        }
                                    }
                                    
                                    _user.faces = _faces;
                                    _user.avatar = resp[@"key"];
                                    [self updatePublicUserAvatar];
                                    [self pushAdjustNavigation];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedAvatar object:nil];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
                                }
                            }
                        }];
                    }
                }
            }];
        } else {
        }
    }];
}

//更新头像
- (void)updatePublicUserAvatar {
    WEAK_SELF();
    NSDictionary *param = @{@"avatar_url" : _user.avatar};
    [_user updateAvatar:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            
            [weakSelf updateWithData:data];
            // 判断跳转...
            [self pushAdjustNavigation];
        }
    }];
}

- (void)updateWithData:(id)data {
    ZZUser *user = [ZZUser yy_modelWithJSON:data];
    [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:YES];
    
    _user = [ZZUserHelper shareInstance].loginer;
}

// 跳转前调整
- (void)pushAdjustNavigation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ZZHUD dismiss];
    });
    NSMutableArray<UIViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
    // 是否是从人脸识别页面跳过来的
    if (self.isFaceVC) {
        [vcs removeObject:self];
        [vcs removeLastObject];
    } else {
        [vcs removeObject:self];
    }
    ZZViewController *vc;
    if (_type == NavigationTypeChat) {
        vc = (ZZChatViewController *)[self createChatViewController];
    }
    else if (_type == NavigationTypeOrder) {
        vc = (ZZRentChooseSkillViewController *)[self createRentChooseSkillViewControlle];
    }
    else if (_type == NavigationTypeApplyTalent) {// 申请出租达人
        [self gotoUserChuzuVCIfNeededWithShowSkillTheme:YES];
        return ;
    }
    else if (_type == NavigationTypeWeChat) {
        vc = (ZZWXViewController *)[self createWXViewController];
    }
    else if (_type == NavigationTypeRealName) {
        vc = (ZZRealNameListViewController *)[self createRealNameListViewController];
    }
    else if (_type == NavigationTypeCashWithdrawal) {
        
    }
    else if (_type == NavigationTypeSnatchOrder) {    // 抢单
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
    }
    else if (_type == NavigationTypeSelfIntroduce) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublishedQuestion object:nil];
        vc = (ZZSelfIntroduceVC *)[self createSelfIntroduceVC];
    }
    else if (_type == NavigationTypeOpenFastChat) {
        [self openFastChatNextPage];
        return;
    }
    else if (_type == NavigationTypePublishTask) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else if (_type == NavigationTypeApplicantForTalent) {
        [self chooseSkillVC];
        return;
    }
    else if (_type == NavigationTypeSignUpForTask) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (vc != nil) {
        [vcs addObject:vc];
    }
    [self.navigationController setViewControllers:vcs animated:YES];
}

// 从申请出租达人过来，判断下一步操作
- (void)gotoUserChuzuVCIfNeededWithShowSkillTheme:(BOOL)showSkillTheme {
    WEAK_SELF();
    if ([ZZUserHelper shareInstance].configModel.open_rent_need_pay_module) {   // 有开启出租收费
        if (_user.gender_status == 2) {// 需要先去完善身份证信息
            [UIAlertController presentAlertControllerWithTitle:@"身份信息异常，请进行身份验证" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) {
                    [self showRealNameListController];
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
            return;
        }
        if (_user.rent_need_pay) { //此人出租需要付费
            if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstProtocol]) { // 需要先去同意协议
                [self showRentalAgreementController];
            }
            else {
                if (showSkillTheme) {
                   [weakSelf showSkillThemeManageViewController];
                }
                else {
                    [self createUserChuzuViewController];
                }
            }
        }
        else {   //不需要付费（字段的值会根据用户是否是男性，大陆，是否已付费，老用户等条件）
            if (showSkillTheme) {
               [self showSkillThemeManageViewController];
            }
            else {
                [self createUserChuzuViewController];
            }
        }
    } else {    // 没有开启出租收费功能
        // 服务端如果没有开关，则自己也需要本地判断是否需要验证
        if (_user.gender_status == 2) {// 本身性别有误，也需要验证身份证
            [UIAlertController presentAlertControllerWithTitle:@"身份信息异常，请进行身份验证" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) {
                    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.user = _user;
                    controller.isRentPerfectInfo = YES;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
            }];
        } else {// 否则才能直接去 出租页面
            if (showSkillTheme) {
                [self showSkillThemeManageViewController];
            }
            else {
                [self createUserChuzuViewController];
            }
        }
    }
}

- (void)chooseSkillVC {
    ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 申请开通闪聊验完头像，下一步
- (void)openFastChatNextPage {
    
    NSMutableArray<UIViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
    // 是否是从人脸识别页面跳过来的
    if (self.isFaceVC) {
        [vcs removeObject:self];
        [vcs removeLastObject];
    } else {
        [vcs removeObject:self];
    }
    
    WEAK_SELF();
    if (_user.base_video.status == 1) {
        //如果已经有达人视频，则直接申请成功
        NSMutableDictionary *userDic = [[_user toDictionary] mutableCopy];
        [userDic setObject:@(YES) forKey:@"bv_from_qchat"];
        [_user updateWithParam:userDic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                ZZUser *user = [ZZUser yy_modelWithJSON:data];
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                [weakSelf gotoFastChatSetting];
            }
        }];
    } else {
        //否则去录制达人视频
        ZZSelfIntroduceVC *vc = [ZZSelfIntroduceVC new];
        vc.isFastChat = YES;
        [vcs addObject:vc];
        [self.navigationController setViewControllers:vcs animated:YES];
    }
}

- (void)showRentalAgreementController {
    ZZRentalAgreementVC *vc = [ZZRentalAgreementVC new];
    [self pushController:vc];
}

- (void)showRealNameListController {
    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.user = _user;
    controller.isRentPerfectInfo = YES;
    [self pushController:controller];
}

- (void)gotoFastChatSetting {
    // 闪聊开通成功
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_OpenFastChat object:nil];
    ZZFastChatSettingVC *vc = [ZZFastChatSettingVC new];
    vc.isShow = YES;
    [self pushController:vc];
}


// 聊天页面
- (ZZChatViewController *)createChatViewController {
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    [ZZRCUserInfoHelper setUserInfo:_from];
    controller.user = _from;
    controller.nickName = _from.nickname;
    controller.uid = _from.uid;
    controller.portraitUrl = _from.avatar;
    controller.hidesBottomBarWhenPushed = YES;
    return controller;
}

// 选择技能页面
- (ZZRentChooseSkillViewController *)createRentChooseSkillViewControlle {
    ZZRentChooseSkillViewController *controller = [[ZZRentChooseSkillViewController alloc] init];
    controller.user = _from;
    controller.hidesBottomBarWhenPushed = YES;
    return controller;
}

- (void)showSkillThemeManageViewController {
    ZZViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
    [self pushController:controller];
}

- (void)createRentH5ViewController {
    WeakSelf
    ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
    registerRent.type = RentTypeRegister;
    [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
        ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf pushController:controller];
    }];
    [self.navigationController presentViewController:registerRent animated:YES completion:NULL];
}

// 申请达人(出租自己)页面
- (void)createUserChuzuViewController {
    [MobClick event:Event_click_me_rent];
    //未出租状态前往申请达人，其余状态进入主题管理
    ZZViewController *controller = nil;
    if (_user.rent.status == 0) {
        controller = [[ZZChooseSkillViewController alloc] init];
    } else {
        controller = [[ZZSkillThemeManageViewController alloc] init];
    }
    [self pushController:controller];
}

- (void)pushController:(ZZViewController *)controller {
    NSMutableArray<UIViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
    // 是否是从人脸识别页面跳过来的
    if (self.isFaceVC) {
        [vcs removeObject:self];
        [vcs removeLastObject];
    }
    else {
        [vcs removeObject:self];
    }
    
    controller.hidesBottomBarWhenPushed = YES;
    [vcs addObject:controller];
    [self.navigationController setViewControllers:vcs animated:YES];
}

// 我的微信号页面
- (ZZWXViewController *)createWXViewController {
    [MobClick event:Event_click_usercenter_wx];
    ZZWXViewController *controller = [[ZZWXViewController alloc] init];
    controller.user = _user;
    controller.hidesBottomBarWhenPushed = YES;
    return controller;
}

// 实名认证页面
- (ZZRealNameListViewController *)createRealNameListViewController {
    [MobClick event:Event_click_me_realname];
    ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.user = _user;
    return controller;
}

// 达人录制页面
- (ZZSelfIntroduceVC *)createSelfIntroduceVC {
    ZZSelfIntroduceVC *vc = [[ZZSelfIntroduceVC alloc] init];
    vc.loginer = _user;
    vc.reviewStatus = ZZVideoReviewStatusNoRecord;
    vc.isShowTopUploadStatus = self.isShowTopUploadStatus;
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}

- (void)gotoLiveCheck {
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [_headButton setImage:_avatarImage forState:UIControlStateNormal];

    [_headButton setTitle:@"" forState:UIControlStateNormal];
    IOS_11_NO_Show
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    IOS_11_NO_Show
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}

//相册
- (void)gotoAlbum
{
    WeakSelf;
    IOS_11_Show
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    //    [imgPicker setAllowsEditing:YES];
    [imgPicker setDelegate:self];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        IOS_11_NO_Show
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            //            [weakSelf uploadPhoto:image];
            [weakSelf edit:image];
            
        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        IOS_11_NO_Show
        
    };
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}
//编辑相册
-(void)edit:(UIImage *)originalImage{
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = originalImage;
    controller.keepingCropAspectRatio = YES;
    UIImage *image = originalImage;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    [controller resetCropRect];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    _avatarImage = croppedImage;
    [_headButton setImage:_avatarImage forState:UIControlStateNormal];
    
    [_headButton setTitle:@"" forState:UIControlStateNormal];}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
