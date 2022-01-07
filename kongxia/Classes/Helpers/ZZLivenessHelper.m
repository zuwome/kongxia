//
//  ZZLivenessHelper.m
//  kongxia
//
//  Created by qiming xiao on 2020/10/22.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZLivenessHelper.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <math.h>
#import <MGFaceIDLiveDetect/MGFaceIDLiveDetect.h>

#import "ImageUtils.h"
#import "LivingConfigModel.h"

#import "ZZSignUpS3ViewController.h"
#import "ZZRealNameListViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZUserChuzuViewController.h"
#import "ZZChangePhoneViewController.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZRegisterRentViewController.h"
#import "ZZUploader.h"

#define api_key @"xM1rXDO5zZin3fKzUXwoa7jwU7L_uWt4"//@"xM1rXDO5zZin3fKzUXwoa7jwU7L_uWt4"
#define api_secret @"PhfW8ihbFdluMBUSYpoFzht8VU_3EfQd"//@"PhfW8ihbFdluMBUSYpoFzht8VU_3EfQd"

@interface ZZLivenessHelper()

@property (nonatomic, weak) UIViewController *controller;

@end

@implementation ZZLivenessHelper

- (instancetype)initWithType:(NavigationType)type inController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        _type = type;
        _controller = controller;
    }
    return self;
}

- (void)start {
    WeakSelf
    [self canCompareFace:^(BOOL canCompare) {
        if (canCompare) {
            [weakSelf fetchBizToken];
        }
    }];
}

- (void)getImageData:(NSData *)imageData checkOK:(BOOL)check {
    if (check && imageData) {
        if (_type == NavigationTypeUserCenter) {
            [ZZHUD showWithStatus:@"保存重新识别的数据"];
        }
        else if(_type == NavigationTypeTiXian) {
            [ZZHUD showWithStatus:@"账户安全检测中"];
        }
        else {
            [ZZHUD showWithStatus:@"正在保存数据"];
        }
        
        [ZZUploader putData:imageData next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (resp) {
                NSString *bestUrl = resp[@"key"];
                [self checkPhotoIsHackBestUrl:bestUrl envData:nil delta:nil];
            }
            else {
                [ZZHUD showErrorWithStatus:@"保存失败，请重新刷脸"];
            }
        }];
    }
    else {
        NSString *errorMsg = nil;
        if (!check) {
            errorMsg = @"检测超时，重试一次";
        }
        else if (!imageData) {
            errorMsg = @"获取图片失败，重试一次";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测失败" message:errorMsg delegate:_controller cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (BOOL)isMeetNavigationType {
    return _type == NavigationTypeChat || _type == NavigationTypeOrder || _type == NavigationTypeApplyTalent || _type == NavigationTypeWeChat || _type == NavigationTypeRealName || _type == NavigationTypeRealNameIndentify || _type == NavigationTypeCashWithdrawal || _type == NavigationTypeSnatchOrder || _type == NavigationTypeSelfIntroduce || _type == NavigationTypeOpenFastChat || _type == NSNotFound;
}

- (void)checkIsTheOwner:(NSString *)url {
    NSMutableDictionary *param = [@{@"image_env":url} mutableCopy];
    if (_type == NavigationTypeChangePhone) {
        [param setObject:@(1) forKey:@"type"];
    }
    else if (_type == NavigationTypeAccountCancel) {
        [param setObject:@(2) forKey:@"type"];
    }
    else if (_type == NavigationTypeRestartPhone) {
        [param setObject:@(3) forKey:@"type"];
    }
    else if (_type == NavigationTypeTiXian) {
        [param setObject:@(4) forKey:@"type"];
    }
    else if (_type == NavigationTypeDevicesLoginFirst) {
        [param setObject:@(5) forKey:@"type"];
    }
    
    [ZZRequest method:@"POST" path:@"/api/user/compare_face" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        if (error) {
            if (_type == NavigationTypeDevicesLoginFirst) {
                [self.controller.navigationController popViewControllerAnimated:YES];
                if (_newDeviceLoginBlock) {
                    _newDeviceLoginBlock(NO, url, error.message ?: @"人脸对比失败哦");
                }
            }
            else if (_type == NavigationTypeTiXian) {
                [_controller.navigationController popViewControllerAnimated:YES];
                if (_withdrawCompleBlock) {
                    _withdrawCompleBlock(url, 1);
                }
            }
            else {
                [ZZHUD showErrorWithStatus:error.message];
            }
        }
        else {
            if (_type == NavigationTypeAccountCancel) {
                [_controller.navigationController popViewControllerAnimated:YES];
                if (_checkSuccess) {
                    _checkSuccess();
                }
            }
            else if (_type ==NavigationTypeRestartPhone) {
                
                [_controller.navigationController popViewControllerAnimated:YES];
                if (_checkSuccess) {
                    _checkSuccess();
                }
            }
            else if (_type == NavigationTypeTiXian) {
                [_controller.navigationController popViewControllerAnimated:YES];
                if (_withdrawCompleBlock) {
                    _withdrawCompleBlock(url, 2);
                }
            }
            else if (_type == NavigationTypeDevicesLoginFirst) {
                [_controller.navigationController popViewControllerAnimated:YES];
                if (_newDeviceLoginBlock) {
                    _newDeviceLoginBlock(YES, url, @"成功");
                }
            }
            else {
                ZZChangePhoneViewController *controller = [[ZZChangePhoneViewController alloc] init];
                controller.user = _user;
                controller.updateBlock = ^{
                    if (_checkSuccess) {
                        _checkSuccess();
                    }
                };
                [self pushAction:controller];
            }
        }
    }];
}

// 满足条件，跳转到自定义的上传头像页
- (void)isMeetPushUploadHeadImage {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = YES;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = _type;
    [self pushAction:vc];
}

- (void)pushAction:(__kindof UIViewController *)vc {
    vc.hidesBottomBarWhenPushed = YES;
    NSMutableArray *vcs = _controller.navigationController.viewControllers.mutableCopy;
    if ([vcs.lastObject isKindOfClass:[self class]]) {
        [vcs removeLastObject];
    }
    [vcs addObject:vc];
    
    [_controller.navigationController setViewControllers:vcs.copy animated:YES];
}

- (void)gotoSkillTheme {
    ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self pushAction:controller];
}

- (void)shouldShowChooseSkillVC {
    if (_user.rent.topics.count == 3) {
        [self gotoSkillTheme];
    }
    else {
        [self chooseSkillVC];
    }
}

- (void)chooseSkillVC {
    ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self pushAction:controller];
}

- (void)gotoUpdatePhotoWithUrls:(NSMutableArray *)urls isPush:(BOOL)isPush {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ZZSignUpS3ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CompleteUserInfo"];
    vc.faces = urls;
    vc.code = _code;
    vc.countryCode = _countryCode;
    vc.user = _user;
    vc.isPush = isPush;
    if (_isUpdatePhone) {
        vc.isUpdatePhone = _isUpdatePhone;
    }
    else if (_isQuickLogin) {
        vc.quickLoginToken = _quickLoginToken;
        vc.isQuickLogin = _isQuickLogin;
    }
    vc.isSkipRecognition = NO;
    [self pushAction:vc];
}

- (void)canCompareFace:(void(^)(BOOL canCompare))completion {
    [MobClick event:Event_click_scan_starts];
    if (self.type == NavigationTypeUserLogin || self.type == NavigationTypeChangePwd) {
        if (completion) {
            completion(YES);
        }
        return;
    }
    
    [ZZHUD show];
    [ZZRequest method:@"GET" path:@"/api/user/can_compare_face" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZHUD dismiss];
        if (data) {
            completion(YES);
        }
        if (error) {
            completion(NO);
            [UIAlertController presentAlertControllerWithTitle:@"提示" message:error.message doneTitle:@"知道了" cancelTitle:nil showViewController:_controller completeBlock:^(BOOL isCancel) {
            }];
        }
    }];
}

- (void)checkPhotoIsHackBestUrl:(NSString *)bestUrl envData:(NSData *)envData delta:(NSString *)delta {
    NSDictionary *param = @{
        @"image_best":bestUrl
    };
    [self checkPhotoIsHackWithParam:param bestUrl:bestUrl];
}

- (void)checkPhotoIsHackWithParam:(NSDictionary *)param bestUrl:(NSString *)bestUrl {
    [ZZRequest method:@"POST" path:@"/photo/ishack" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD dismiss];
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测失败" message:@"系统错误,重试⼀次" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else {
            NSString *isHack = data[@"isHack"];
            if([isHack  isEqual: @"true"]){
                [ZZHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测失败" message:@"请重新刷脸" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
            else {
                if ([self isMeetNavigationType]) {
                    // 从这几个页面过来的，先更新faces到服务器，再跳到自定义页面
                    NSMutableArray *urls = [NSMutableArray array];
                    [urls addObject:bestUrl];
                    [self updateUserFaces:urls];
                    return ;
                }
                
                if (_type == NavigationTypeAccountCancel
                    || _type == NavigationTypeChangePhone
                    || _type ==NavigationTypeRestartPhone
                    || _type ==NavigationTypeDevicesLoginFirst) {
                    
                    [self checkIsTheOwner:bestUrl];
                    
                }
                else if (_type == NavigationTypeTiXian) {
                    [self checkIsTheOwner:bestUrl];
                }
                else if (_type == NavigationTypeChangePwd) {
                    if (self.checkSuccessBlock) {
                        self.checkSuccessBlock(bestUrl);
                    }
                }
                else {
                    NSMutableArray *urls = [NSMutableArray array];
                    [urls addObject:bestUrl];
                    if(_type == NavigationTypeUserLogin) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [ZZHUD dismiss];
                            if (self.checkSuccessBlock) {
                                self.checkSuccessBlock(urls.firstObject);
                            }
//                            [self gotoUpdatePhotoWithUrls:urls isPush:NO];
                        });
                    }
                    else {
                        [self updateUserFaces:urls];
                    }
                }
            }
        }
    }];
}

- (void)updateUserFaces:(NSMutableArray *)faces {
    WeakSelf
    [ZZRequest method:@"POST" path:@"/api/user2" params:@{@"faces":faces} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            if ([ZZUserHelper shareInstance].isMale) {
                [self continueSaveUserInfo:YES faces:faces];
            }
            else {
                ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:nil];
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                [ZZHUD dismiss];
                [weakSelf uploadFaceSuccessAction:faces];
            }
        }
    }];
}

// 继续保存用户信息x
- (void)continueSaveUserInfo:(BOOL)shouldCheckFaceManually faces:(NSMutableArray *)faces{
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
        [ZZHUD dismiss];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZUser loadUser:[ZZUserHelper shareInstance].loginerId param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error == NULL) {
                    ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:nil];
                    [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                }
                [self uploadFaceSuccessAction:faces];
            }];
        }
    }];
}

- (void)uploadFaceSuccessAction:(NSMutableArray *)faces {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (_type) {
            case NavigationTypeGotoCenter: {
                ZZUserEditViewController *vc = [[ZZUserEditViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.gotoUserPage = YES;
                vc.editCallBack = ^{
                    if (self.callBack) {
                        self.callBack();
                    }
                };
                [self pushAction:vc];
                break;
            }
            case NavigationTypeRealname: {
                ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                controller.user = _user;
                [self pushAction:controller];
                break;
            }
            case NavigationTypeRent: {
                //未出租状态前往申请达人，其余状态进入主题管理
                if (_user.rent.status == 0) {
                    ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
                    registerRent.type = RentTypeRegister;
                    [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
                        ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
                        controller.hidesBottomBarWhenPushed = YES;
                        [self pushAction:controller];
                    }];
                    [self.controller.navigationController presentViewController:registerRent animated:YES completion:nil];
                } else {
                    [self gotoSkillTheme];
                }
                break;
            }
            case NavigationTypeNoPhotos: {
                [self gotoUpdatePhotoWithUrls:faces isPush:YES];
                break;
            }
                //以下几种情况，跳到自定义传头像页面
            case NavigationTypeChat: {
                [self isMeetPushUploadHeadImage];
                 break;
            }
            case NavigationTypeOrder: {
                [self isMeetPushUploadHeadImage];
                break;
            }
            case NavigationTypeApplyTalent: {
                if ([[ZZUserHelper shareInstance] isMale]) {
                    [self shouldShowChooseSkillVC];
                }
                else {
                    [self isMeetPushUploadHeadImage];
                }
                
                break;
            }
            case NavigationTypeWeChat: {
                [self isMeetPushUploadHeadImage];
                break;
            }
            case NavigationTypeRealName: {
                [self isMeetPushUploadHeadImage];
                break;
            }
            case NavigationTypeCashWithdrawal: {
                if ([[ZZUserHelper shareInstance] isMale]) {
                    if (_checkSuccess) {
                        _checkSuccess();
                    }
                }
                else {
                    [self isMeetPushUploadHeadImage];
                }
                break;
            }
            case NavigationTypeSnatchOrder: {
                [self isMeetPushUploadHeadImage];
                break;
            }
            case NavigationTypeSelfIntroduce: {
                [self isMeetPushUploadHeadImage];
                break;
            }
            case NavigationTypeOpenFastChat: {
                [self isMeetPushUploadHeadImage];
                break;
            }
            case NavigationTypeSignUpForTask: {
//                [self isMeetPushUploadHeadImage];
                if (_checkSuccess) {
                    _checkSuccess();
                }
                break;
            }
            case NavigationTypeApplicantForTalent: {
                [self shouldShowChooseSkillVC];
                break;
            }
            case NavigationTypeRealNameIndentify: {
                if (_checkSuccess) {
                    _checkSuccess();
                }
                break;
            }
            case NavigationTypeRentInfoRealFace: {
                if (_checkSuccess) {
                    _checkSuccess();
                }
                break;
            }
            default: {
                [self.controller.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
    });
}

#pragma mark - Face++ params related
- (void)startDetectingWithBizToken:(NSString *)token {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MGFaceIDLiveDetectError* error;
    
        MGFaceIDLiveDetectManager* detectManager = [[MGFaceIDLiveDetectManager alloc] initMGFaceIDLiveDetectManagerWithBizToken:token language:MGFaceIDLiveDetectLanguageCh networkHost:@"https://api.megvii.com" extraData:nil error:&error];
        
        MGFaceIDLiveDetectCustomConfigItem *item = [[MGFaceIDLiveDetectCustomConfigItem alloc] init];
        item.livenessHomeBackgroundColor = UIColor.blackColor;
        [detectManager setMGFaceIDLiveDetectCustomUIConfig:item];
        
        if (error || !detectManager) {
            [ZZHUD showErrorWithStatus:error.errorMessageStr];
            return;
        }

        MGFaceIDLiveDetectCustomConfigItem* customConfigItem = [[MGFaceIDLiveDetectCustomConfigItem alloc] init];
        [detectManager setMGFaceIDLiveDetectCustomUIConfig:customConfigItem];
        [detectManager setMGFaceIDLiveDetectPhoneVertical:MGFaceIDLiveDetectPhoneVerticalFront];
        
        [detectManager startMGFaceIDLiveDetectWithCurrentController:_controller
                                                           callback:^(MGFaceIDLiveDetectError *error, NSData *deltaData, NSString *bizTokenStr, NSDictionary *extraOutDataDict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (deltaData != nil) {
                    [self verifiedWithBizToken:bizTokenStr verify:deltaData];
                }
            });
        }];
    });
}


- (void)verifiedWithBizToken:(NSString *)bizTokenStr verify:(NSData *)megliveData {
    NSMutableDictionary *params = [self getVerifyWithBizParams:bizTokenStr];
    [ZZHUD show];
    [ZZRequest verifyWithParam:params verify:megliveData success:^(NSInteger statusCode, NSDictionary *responseObject) {
        [ZZHUD dismiss];
        if (statusCode == 200) {
            NSData *bestData;
            NSString *imageDataStr = responseObject[@"images"][@"image_best"];
            if (imageDataStr) {
                bestData = [[NSData alloc] initWithBase64EncodedString:imageDataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            }
            [self getImageData:bestData checkOK:YES];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [ZZHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)fetchBizToken {
    [ZZHUD show];
    UIImage *image = [UIImage imageNamed:@"icPic1Sltp"];
    [ZZRequest getBizToken:[self getBiztokenParams] userImage:image success:^(NSInteger statusCode, NSDictionary *responseObject) {
        [ZZHUD dismiss];
        if (statusCode == 200 && responseObject[@"biz_token"] != NULL) {
            [self startDetectingWithBizToken:responseObject[@"biz_token"]];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [ZZHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (NSMutableDictionary *)getVerifyWithBizParams:(NSString *)bizToken {
    return [@{
        @"sign" : [self getSignStr],
        @"sign_version" : [self getFaceIDSignVersionStr],
        @"biz_token" : bizToken,
    } mutableCopy];
}

- (NSDictionary *)getBiztokenParams {
//    @"liveness_type" : (_type == NavigationTypeRealName || _type == NavigationTypeRealNameIndentify) ? @"meglive" :  @"still",
    return @{
        @"sign" : [self getSignStr],
        @"sign_version" : [self getFaceIDSignVersionStr],
        @"comparison_type" : @"0" ,
        @"liveness_type" :  @"still",
        @"uuid" : @"11112222",
    };
}

- (NSString *)getSignStr {
    int valid_durtion = 10000;
    long int current_time = [[NSDate date] timeIntervalSince1970];
    long int expire_time = current_time + valid_durtion;
    long random = labs(arc4random() % 100000000000);
    NSString* str = [NSString stringWithFormat:@"a=%@&b=%ld&c=%ld&d=%ld", api_key, expire_time, current_time, random];
    NSData* sign_tmp = [self hmac_sha1:api_secret text:str];
    NSData* sign_raw_data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [[NSMutableData alloc] initWithData:sign_tmp];
    [data appendData:sign_raw_data];
    NSString* sign = [data base64EncodedStringWithOptions:0];
    return sign;
}

- (NSData *)hmac_sha1:(NSString *)key text:(NSString *)text{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return HMAC;
}

- (NSString *)getFaceIDSignVersionStr {
    return @"hmac_sha1";
}

@end
