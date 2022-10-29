//
//  ZZSignUpS3ViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSignUpS3ViewController.h"
#import "ZZUploader.h"
#import "PECropViewController.h"

#import "ZZSignRecommendViewController.h"
#import "ZZPayHelper.h"
#import "WBKeyChain.h"

#import "OpenInstallSDK.h"

@interface ZZSignUpS3ViewController ()<PECropViewControllerDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UITextField *_nameField;
    IBOutlet UIButton *_boyButton;
    IBOutlet UIButton *_girlButton;
    UIImage *_avatarImage;
    ZZUserHelper *_userHelper;
    UIButton *_leftReturnBtn;
    UILabel *_subTitleLabel;
    __weak IBOutlet UIButton *loginButton;
}

@property (strong, nonatomic) IBOutlet UIButton *avatarButton;
@property (copy, nonatomic) NSString *gender_auto;//1男 2女  3性别无法判别时

@property (nonatomic, copy) NSDictionary *inviteInfo;
@end

@implementation ZZSignUpS3ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    [ZZHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = kBGColor;
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.numberOfLines = 2;
    _subTitleLabel.text = @"为确保资料真实，保障您的人身及账户资金安全，提交资料后需要您进行人脸识别，请确保是您本人操作";
    _subTitleLabel.hidden = YES;
    _subTitleLabel.font = [UIFont systemFontOfSize:12];
    _subTitleLabel.textColor = UIColor.grayColor;
    [self.view addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(18);
        make.right.equalTo(self.view).offset(-18);
        make.top.equalTo(loginButton.mas_bottom).offset(10);
    }];
    
    
    if (!_user) {
        _user = [[ZZUser alloc] init];
    }
    _user.gender = _user.gender;
    if (_user.gender == 1) {
        _boyButton.selected = YES;
    }
    else if (_user.gender == 2) {
        _girlButton.selected = YES;
    }
    _userHelper = [ZZUserHelper shareInstance];
    _nameField.text = _user.nickname;
    _avatarButton.layer.cornerRadius = 45;
    _avatarButton.clipsToBounds = YES;
    _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;

    [self createNavigationLeftButton];
    [self fetchInviteCode];

}

- (void)fetchInviteCode {
    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData * _Nullable appData) {
        NSString *getData;
        if (appData.data) {
            // 如果有中文，转换一下方便展示
            getData = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:appData.data options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            _inviteInfo = appData.data;
        }
    }];
}


- (void)fetchGenderAuto {
    if (_faces.count > 0) {
        WEAK_SELF();
        [ZZHUD showWithStatus:@"检测性别"];
        [_user getGenderAutoWithParam:@{@"image_best" : _faces[0]} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [ZZHUD dismiss];
            _gender_auto = [NSString stringWithFormat:@"%d", [data[@"gender_auto"] intValue]];
            
            if ([_gender_auto intValue] == 1) {
                [weakSelf tapBoy:_boyButton];
            }
            else if ([_gender_auto intValue] == 2) {
                [weakSelf tapBoy:_girlButton];
            }
        }];
    }
}

- (void)createNavigationLeftButton {
    _leftReturnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    _leftReturnBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    _leftReturnBtn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftReturnBtn];
    [_leftReturnBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_leftReturnBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [_leftReturnBtn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems =@[leftItem];
    
}

- (void)navigationLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)done:(UIButton *)sender {
    WeakSelf
    [self.view endEditing:YES];
    [MobClick event:Event_click_infomation_complete];
    NSString *nickname = [_nameField.text trimmedString];
    if (_avatarImage == NULL) {
        [ZZHUD showErrorWithStatus:@"头像不能为空"];
        return;
    }

    NSString *str = [ZZUtils deleteEmptyStrWithString:nickname];
    if (isNullString(str)) {
        [ZZHUD showErrorWithStatus:@"用户名不能全空格"];
        return;
    }
    
    if (nickname.length == 0 || [ZZUtils lenghtWithString:nickname] > 15) {
        [ZZHUD showErrorWithStatus:@"用户名不能超过7个汉字或15个字母"];
        return;
    }
    
    if (!_user.gender) {
        [ZZHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    
    [ZZUserHelper checkTextWithText:nickname type:2 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
           [ZZHUD showErrorWithStatus:error.message];
        } else {
            if (_user.gender == 1) {
                [weakSelf checkSuccessWithName:nickname faces:nil];
            }
            else {
                [weakSelf livenessCheckWithName:nickname];
            }
        }
    }];
}

- (void)livenessCheckWithName:(NSString *)nickname {
    WeakSelf
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:NavigationTypeUserLogin inController:self];
    if (_fromSignUp) {
        if (!_isUpdatePhone) {
            helper.code = _code;
        }
    }
    else if (_isQuickLogin) {
        helper.quickLoginToken = _quickLoginToken;
        helper.isQuickLogin = _isQuickLogin;

    }
    else {
        helper.code = _code;
    }
    helper.user = _user;
    helper.isUpdatePhone = _isUpdatePhone;
    helper.countryCode = _countryCode;
    helper.checkSuccessBlock = ^(NSString * _Nonnull photo) {
        [weakSelf checkSuccessWithName:nickname faces:photo];
    };
    [helper start];
}

- (void)checkSuccessWithName:(NSString *)nickname faces:(NSString *)face {
    WEAK_SELF();
    _user.nickname = nickname;
    NSData *data = [ZZUtils userImageRepresentationDataWithImage:_avatarImage];
    [ZZHUD showWithStatus:@"正在保存图片"];
    _leftReturnBtn.userInteractionEnabled = NO;
    [ZZUploader putData:data next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (resp) {
            ZZPhoto *photo = [[ZZPhoto alloc] init];
            photo.url = resp[@"key"];
                // 跳过人脸识别，则直接注册
            if (!isNullString(face)) {
                weakSelf.user.faces = @[face];
            }
            weakSelf.user.photos = (NSMutableArray <ZZPhoto> *)@[photo];
                [weakSelf signUp:NO];
        }
        else {
            [ZZHUD showErrorWithStatus:@"照片保存失败"];
            _leftReturnBtn.userInteractionEnabled = YES;
        }
    }];
}

// 询问是否继续使用非真实头像
- (void)askingAlertView:(ZZPhoto *)photo {
    [ZZHUD dismiss];
    WEAK_SELF();
    [_avatarButton setImage:[ZZUtils coreBlurImage:_avatarImage withBlurNumber:30] forState:UIControlStateNormal];
    _leftReturnBtn.userInteractionEnabled = YES;
    [ZZInfoToastView showWithType:ToastRealAvatarNotMatch action:^(NSInteger actionIndex, ToastType type) {
        if (actionIndex == -1) {
            [ZZHUD dismiss];
        }
        else if (actionIndex == 1) {
            [ZZHUD dismiss];
            weakSelf.user.faces = _faces;
            weakSelf.user.photos = (NSMutableArray <ZZPhoto> *)@[photo];
            [weakSelf signUp:YES];
        }
        else {
            [ZZHUD showWithStatus:@"正在保存用户信息"];
            weakSelf.user.faces = _faces;
            weakSelf.user.photos = (NSMutableArray <ZZPhoto> *)@[photo];
            [weakSelf signUp:NO];
        }
    }];
}

- (void)signUp:(BOOL)shouldManualReview {
    NSMutableDictionary *aDict = [[_user toDictionary] mutableCopy];
    if (isNullString(_code)) {
        [aDict setObject:@"" forKey:@"code"];
    }
    else {
        [aDict setObject:_code forKey:@"code"];
    }
    
    if (isNullString(_countryCode)) {
        [aDict setObject:@"" forKey:@"country_code"];
    }
    else {
        [aDict setObject:_countryCode forKey:@"country_code"];
    }
    
    // 是否需要人工审核头像
    if (shouldManualReview) {
        aDict[@"avatar_manual_status"] = @1;
    }
    
    // 如果没有自动检测性别，则这个参数传和选择的相反
    if (isNullString(_gender_auto)) {
        if (_user.gender == 1) {
            [aDict setObject:@"1" forKey:@"gender_auto"];
        }
        else {
            [aDict setObject:@"2" forKey:@"gender_auto"];
        }
    }
    else {
        [aDict setObject:_gender_auto forKey:@"gender_auto"];
    }
    
    if (_inviteInfo && !isNullString(_inviteInfo[@"code"]) && !isNullString(_inviteInfo[@"uid"])) {
        aDict[@"invite_code"] = _inviteInfo[@"code"];
        aDict[@"invite_uid"] = _inviteInfo[@"uid"];
    }
    
    NSString *uuid = [WBKeyChain keyChainLoadWithKey:DEVICE_ONLY_KEY];
    if (isNullString(uuid)) {
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    [WBKeyChain keyChainSave:uuid key:DEVICE_ONLY_KEY];
    if (uuid) {
        [aDict setObject:uuid forKey:@"uuid"];
    }
    [ZZHUD show];
    
    if (_isQuickLogin) {
        [self quickLogin:aDict shouldManualReview:shouldManualReview];
    }
    else {
        [self normalSignUp:aDict shouldManualReview:shouldManualReview];
    }
}

- (void)quickLogin:(NSMutableDictionary *)aDict shouldManualReview:(BOOL)shouldManualReview {
    aDict[@"AccessToken"] = _quickLoginToken;
    
    [ZZRequest method:@"POST" path:@"/user/registerByAliMobile" params:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZHUD dismiss];
            if (shouldManualReview) {
                [SVProgressHUD showInfoWithStatus:@"提交成功，我们将在1个工作日内审核"];
            }
            ZZUser *loginer = [ZZUser yy_modelWithJSON:data[@"user"]];
            [ZZUserHelper shareInstance].publicToken = data[@"access_token"];
         
            [ZZUserHelper shareInstance].oAuthToken = [ZZUserHelper shareInstance].publicToken;
            
            _userHelper.uploadToken = data[@"upload_token"];
            [_userHelper saveLoginer:loginer postNotif:YES];
            
            if ([ZZUserHelper shareInstance].location) {
                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
            }
            
            ZZSignRecommendViewController *controller = [[ZZSignRecommendViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
            // openInstall 统计注册的
            if (_inviteInfo && !isNullString(_inviteInfo[@"code"]) && !isNullString(_inviteInfo[@"uid"])) {
//#ifdef DEBUG
                [[OpenInstallSDK defaultManager] reportEffectPoint:@"register" effectValue:1];
//#else
//
//#endif
            }
            
        }
        _leftReturnBtn.userInteractionEnabled = YES;
    }];
}

- (void)normalSignUp:(NSMutableDictionary *)aDict shouldManualReview:(BOOL)shouldManualReview {
    [_user signUp:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZHUD dismiss];
            if (shouldManualReview) {
                [SVProgressHUD showInfoWithStatus:@"提交成功，我们将在1个工作日内审核"];
            }
            ZZUser *loginer = [ZZUser yy_modelWithJSON:data[@"user"]];
            [ZZUserHelper shareInstance].publicToken = data[@"access_token"];
            [ZZUserHelper shareInstance].oAuthToken = [ZZUserHelper shareInstance].publicToken;
            
            _userHelper.uploadToken = data[@"upload_token"];
            [_userHelper saveLoginer:loginer postNotif:YES];
            
            if ([ZZUserHelper shareInstance].location) {
                [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
            }
            
            ZZSignRecommendViewController *controller = [[ZZSignRecommendViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            
            // openInstall 统计注册的
            if (_inviteInfo && !isNullString(_inviteInfo[@"code"]) && !isNullString(_inviteInfo[@"uid"])) {
                [[OpenInstallSDK defaultManager] reportEffectPoint:@"register" effectValue:1];
            }
        }
        _leftReturnBtn.userInteractionEnabled = YES;
    }];
}

- (void)isUpdateUserPhone
{
    NSMutableDictionary *param = [@{@"nickname":_user.nickname,
                                    @"avatar":_user.avatar,
                                    @"gender":[NSNumber numberWithInt:_user.gender],
                                    @"faces":_user.faces,
                                    @"phone":_user.phone,
                                    @"password":_user.password} mutableCopy];
    if (_countryCode) {
        [param setObject:_countryCode forKey:@"country_code"];
    }
    [_user updateWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            if ([ZZUserHelper shareInstance].publicToken) {
           

                [ZZUserHelper shareInstance].oAuthToken = [ZZUserHelper shareInstance].publicToken;
                [ZZUserHelper shareInstance].oAuthToken = [ZZUserHelper shareInstance].publicToken;
                [ZZUserHelper shareInstance].publicToken = nil;
            }
            if (_isPush) {
                [self updateWithData:data];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self updateWithData:data];
                }];
            }
        }
    }];
}

//更新头像
- (void)updatePublicUserAvatar
{
    NSDictionary *param = @{@"nickname":_user.nickname,
                            @"avatar":_user.avatar,
                            @"gender":[NSNumber numberWithInt:_user.gender],
                            @"faces":_user.faces};
    [_user updateWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            
            if ([ZZUserHelper shareInstance].publicToken) {
                [ZZUserHelper shareInstance].oAuthToken = [ZZUserHelper shareInstance].publicToken;
                [ZZUserHelper shareInstance].publicToken = nil;
            }
            if (_isPush) {
                [self updateWithData:data];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self updateWithData:data];
                }];
            }
        }
    }];
}

- (void)updateWithData:(id)data
{
    ZZUser *user = [ZZUser yy_modelWithJSON:data];
    [[ZZUserHelper shareInstance] saveLoginer:user postNotif:YES];
    if (!_isPush) {
     
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserLogin object:self];
    }
    
    if ([ZZUserHelper shareInstance].location) {
        [[ZZUserHelper shareInstance] updateUserLocationWithLocation:[ZZUserHelper shareInstance].location];
    }
}

- (IBAction)tapBoy:(UIButton *)sender {
    sender.selected = YES;
    _girlButton.selected = NO;
    _user.gender = 1;
    _subTitleLabel.hidden = YES;
}

- (IBAction)tapGirl:(UIButton *)sender {
    sender.selected = YES;
    _boyButton.selected = NO;
    _user.gender = 2;
    _subTitleLabel.hidden = NO;
}

- (IBAction)uploadAvatar:(UIButton *)sender {
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
                            WS(weakSelf);
                             imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
                                 IOS_11_NO_Show
                                 [[UIApplication sharedApplication] setStatusBarHidden:YES];
               
                                 [picker dismissViewControllerAnimated:YES completion:^{
                                     UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
                                     [weakSelf updateImg:image];
                                 }];
                             };
                             
                             imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
                                 [picker dismissViewControllerAnimated:YES completion:nil];
                             };
                             [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                             CGAffineTransform transform = CGAffineTransformIdentity;

                             imgPicker.cameraViewTransform = CGAffineTransformScale(transform, -1, 1);
                             imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
                             [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
                             
                         }
                         if (buttonIndex ==1) {
                          IOS_11_Show
                      
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
                         
                     }];
}


- (void)updateImg:(UIImage *)image {
    _avatarImage = image;
    [_avatarButton setImage:_avatarImage forState:UIControlStateNormal];
    [_avatarButton setTitle:@"" forState:UIControlStateNormal];
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
    [_avatarButton setImage:_avatarImage forState:UIControlStateNormal];
    [_avatarButton setTitle:@"" forState:UIControlStateNormal];
    IOS_11_NO_Show
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    IOS_11_NO_Show

    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)setUser:(ZZUser *)user {
    _user = user;
}

@end
