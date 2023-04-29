//
//  ZZLivenessCheckViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/8/29.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZLivenessCheckViewController.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>
#import "VideoCaptureDevice.h"
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

#define scaleValue 0.7

#define ScreenRect [UIScreen mainScreen].bounds
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ZZLivenessCheckViewController () <UIAlertViewDelegate,CaptureDataOutputProtocol, CAAnimationDelegate>

@property (nonatomic, assign) LivenessCheckType checkType;

@property (nonatomic, strong) UIImageView *displayImageView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) LivenessCircleView *circleView;

@property (nonatomic, strong) UIButton *returnBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *warningTitleLabel;

@property (nonatomic, strong) UILabel *warningSubTitleLabel;

@property (nonatomic, strong) UIButton *proceeActionBtn;

@property (nonatomic, strong) VideoCaptureDevice *captureDevice;

@property (nonatomic, assign) CGRect detectRect;

@property (nonatomic, assign) CGRect circleRect;

@property (nonatomic, assign) CGRect previewRect;

@property (nonatomic, assign) BOOL didStartDetect;

@property (nonatomic, assign) BOOL hasFinished;

@property (nonatomic, strong) NSArray * livenessArray;

@property (nonatomic, assign) BOOL order;

@property (nonatomic, assign) NSInteger numberOfLiveness;

@property (nonatomic, assign) CGFloat value;

@property (nonatomic, copy) NSArray<FLAnimatedImageView *> *iconsArray;

@end

@implementation ZZLivenessCheckViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _checkType = LivenessTypeCommon;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _didStartDetect = NO;
    _value = 0.0;
    [self faceSDKManagerDefault];
    [self layout];
    [self createCircle];
    [self addNotifications];
    [self createCaptreDevice];
    [self defaultConfig];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    _hasFinished = NO;
    _captureDevice.runningStatus = YES;
    [_captureDevice startSession];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IDLFaceLivenessManager sharedInstance] startInitial];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hasFinished = YES;
    _captureDevice.runningStatus = NO;
}

#pragma mark - private method
- (void)defaultConfig {
    NSString *title = @"";
    if (_type == NavigationTypeAccountCancel) {
        title = @"为保证您的账户资金安全，在为您注销账号,之前需要进行一次脸部安全识别，请确保为该账户拥有者本人操作";
    }
    else if (_type == NavigationTypeChangePhone) {
        title = @"为保障您的账户资金安全，在为您更换绑定手机,之前需要进行一次脸部安全识别，请确保为该账户拥有者本人操作";
    }
    else if (_type ==NavigationTypeRestartPhone) {
        title = @"为保证您的账户资金安全，在为您启用账号之前需要进行一次脸部安全识别，请确保为该账户拥有者本人操作";
    }
    else if (_type ==NavigationTypeTiXian) {
        title = [NSString stringWithFormat: @"为保障您的账户资金安全，在为您提现,之前需要进行一次脸部安全识别，证明为%@本人操作 ",[ZZUserHelper shareInstance].loginer.realname.name];
    }
    else if (_type == NavigationTypeDevicesLoginFirst) {
        title = [NSString stringWithFormat: @"您的账户在新的设备登录，为了保障您的,账户安全，需要您进行一次面部安全识别，证明是您本人操作"];
    }
    else if (_type == NavigationTypeChangePwd) {
        title = [NSString stringWithFormat: @"您正在重置密码，为了保障您的账户资金安全，将进行真人验证，请确保是您本人操作"];
    }
    else if (_type == NavigationTypeUserLogin) {
        title = [NSString stringWithFormat: @"为了确保资料真实, 保障您的人身及后续账户资金安全, 将进行真人验证, 请确保是您本人操作"];
    }
    
    //富文本属性
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    //基本属性设置
    //字体颜色
    textDict[NSForegroundColorAttributeName] = RGBCOLOR(244, 203, 7);
    //字号大小
    textDict[NSFontAttributeName] = ADaptedFontSCBoldSize(15);
    
    //段落样式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paraStyle.lineSpacing = 8.0;

    //使用
    //文本段落样式
    textDict[NSParagraphStyleAttributeName] = paraStyle;
    
    _warningTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:textDict];
    _warningTitleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)reset {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[IDLFaceLivenessManager sharedInstance] reset];
        
        _value = 0;
        
        // 我实在不知道怎么清除CGContextRef
        [_circleView removeFromSuperview];
        _circleView = nil;
        
        [self.view addSubview:self.circleView];
        _circleView.frame = CGRectMake(self.circleRect.origin.x - SCALE_SET(26), self.circleRect.origin.y - SCALE_SET(26), SCALE_SET(319), SCALE_SET(319));
        [self createCircle];
        
        // icon 复位
        [_iconsArray enumerateObjectsUsingBlock:^(FLAnimatedImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                imageView.center = CGPointMake(_circleView.center.x, _circleView.top);
            }
            else {
                imageView.hidden = YES;
                imageView.center = CGPointMake(_circleView.center.x, _circleView.bottom);
            }
            imageView.bounds = CGRectMake(0.0, 0.0, 60.0, 60.0);
            [self.view bringSubviewToFront:imageView];
        }];
        
        [[IDLFaceLivenessManager sharedInstance] startInitial];
        [self faceSDKManagerDefault];
        [self startLivenessCheck];
    });
}

- (void)createCaptreDevice {
    _captureDevice = [[VideoCaptureDevice alloc] init];
    _captureDevice.delegate = self;
}

- (void)warningStatus:(LivenessWarningStatus)status warning:(NSString *)warning conditionMeet:(BOOL)meet {
    dispatch_async(dispatch_get_main_queue(), ^{
        _warningTitleLabel.text = warning;
    });
}

- (void)startLivenessCheck {
    _warningTitleLabel.text = @"光线充足时,正脸面对摄像头";
    _warningTitleLabel.font = ADaptedFontSCBoldSize(25);
    
    _warningSubTitleLabel.text = @"不是拍照，识别信息不会被别人看到";
    
    _proceeActionBtn.hidden = YES;
    _didStartDetect = YES;
    _hasFinished = NO;
    [self addCircledotLayer];
    
    NSString *gifName = nil;
    if (_checkType == LivenessTypeCommon) {
        gifName = @"LiveYaw";
    }
    else {
        gifName = @"LiveMouth";
    }
    
    FLAnimatedImageView *imageView = _iconsArray.firstObject;
    imageView.hidden = NO;
    NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:gifName withExtension:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
    imageView.animatedImage = image;
}

- (void)getDataCheckOK:(BOOL)check error:(BOOL)isError bestData:(NSData *)bestData envData:(NSData *)envData delta:(NSString *)delta {
    if (check && bestData) {
        if (_type == NavigationTypeUserCenter) {
            [ZZHUD showWithStatus:@"保存重新识别的数据"];
        }
        else if(_type == NavigationTypeTiXian) {
            [ZZHUD showWithStatus:@"账户安全检测中"];
        }
        else {
            [ZZHUD showWithStatus:@"正在保存数据"];
        }
        
        [ZZUploader putData:bestData next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (resp) {
                NSString *bestUrl = resp[@"key"];
                [self checkPhotoIsHackBestUrl:bestUrl envData:envData delta:delta];
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
        else if (!bestData) {
            errorMsg = @"获取图片失败，重试一次";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测失败" message:errorMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (BOOL)isMeetNavigationType {
    return _type == NavigationTypeChat || _type == NavigationTypeOrder || _type == NavigationTypeApplyTalent || _type == NavigationTypeWeChat || _type == NavigationTypeRealName || _type == NavigationTypeCashWithdrawal || _type == NavigationTypeSnatchOrder || _type == NavigationTypeSelfIntroduce || _type == NavigationTypeOpenFastChat || _type == NSNotFound;
}

#pragma mark - response method
- (void)goBack {
    _hasFinished = YES;
    self.captureDevice.runningStatus = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)proceed {
    [MobClick event:Event_click_scan_starts];
    if (self.type == NavigationTypeUserLogin || self.type == NavigationTypeChangePwd) {
        [self startLivenessCheck];
        return;
    }

    [ZZRequest method:@"GET" path:@"/api/user/can_compare_face" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            [self startLivenessCheck];
        }
        if (error) {
            [UIAlertController presentAlertControllerWithTitle:@"提示" message:error.message doneTitle:@"知道了" cancelTitle:nil showViewController:self completeBlock:^(BOOL isCancel) {
            }];
        }
    }];
}

#pragma mark - Animations
- (void)showAnimate {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat from = -0.25, to = 1;
        FLAnimatedImageView *imageView = _iconsArray.firstObject;
        CGPoint center = CGPointZero;
        
        if (_checkType != LivenessTypeRegist) {
            if (_value != 0.25) {
                from = -0.25;
                to = 0.25;
                _value = 0.25;
                center = CGPointMake(_circleView.center.x, _circleView.top);
            }
            else {
                from = 0.25;
                to = 1;
                imageView = _iconsArray[1];
                _value = 1;
                center = CGPointMake(_circleView.center.x, _circleView.bottom);
            }
        }
        else {
            _value = 1;
            center = CGPointMake(_circleView.center.x, _circleView.top);
        }
        
        CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"progress"];
        ani.duration = 0.5;
        ani.fromValue = @(from);
        ani.toValue = @(to);
        ani.removedOnCompletion = YES;
        ani.fillMode = kCAFillModeForwards;
        ani.delegate = self;

        [self.circleView.circleLayer addAnimation:ani forKey:@"progressAni"];

        imageView.width = 0.0;
        imageView.height = 0.0;
        imageView.center = center;
        imageView.image = [UIImage imageNamed:@"icShibieOk"];
        [UIView animateWithDuration:0.2 animations:^{
            imageView.bounds = CGRectMake(0.0, 0.0, 20.0, 20.0);
        }];
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.circleView.circleLayer.progress = _value;
    if (_checkType != LivenessTypeRegist && _value == 0.25) {
        FLAnimatedImageView *imageView = _iconsArray[1];
        imageView.hidden = NO;
        NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:@"LiveEye" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
        imageView.animatedImage = image;
    }
}

#pragma mark - LivenessCheck Methods
- (void)livenesswithList:(NSArray *)livenessArray order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness {
    _livenessArray = [NSArray arrayWithArray:livenessArray];
    _order = order;
    _numberOfLiveness = numberOfLiveness;
    [[IDLFaceLivenessManager sharedInstance] livenesswithList:livenessArray order:order numberOfLiveness:numberOfLiveness];
    [IDLFaceLivenessManager sharedInstance].enableSound = YES;
}

- (void)faceSDKManagerDefault {
    // 设置最小检测人脸阈值
    [[FaceSDKManager sharedInstance] setMinFaceSize:160]; //
    
    // 设置截取人脸图片大小
    [[FaceSDKManager sharedInstance] setCropFaceSizeWidth:400];
    
    // 设置人脸遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluThreshold:0.3]; //
    
    // 设置亮度阀值
    [[FaceSDKManager sharedInstance] setIllumThreshold:60]; //
    
    // 设置图像模糊阀值
    [[FaceSDKManager sharedInstance] setBlurThreshold:0.3]; //
    
    // 设置头部姿态角度
    [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:15 yaw:15 roll:15]; //
    
    // 设置是否进行人脸图片质量检测
    [[FaceSDKManager sharedInstance] setIsCheckQuality:YES]; //
    
    // 设置超时时间
    [[FaceSDKManager sharedInstance] setConditionTimeout:20];
    
    // 设置人脸检测精度阀值
    [[FaceSDKManager sharedInstance] setNotFaceThreshold:0.6];
    
    // 设置照片采集张数
    [[FaceSDKManager sharedInstance] setMaxCropImageNum:1];
    
    LivingConfigModel* model = [LivingConfigModel sharedInstance];
    if (_checkType == LivenessTypeRegist) {
        model.liveActionArray = @[@(FaceLivenessActionTypeLiveMouth)].mutableCopy;
        model.numOfLiveness = 1;
    }
    else {
//         model.liveActionArray = @[@(FaceLivenessActionTypeLiveEye), @(FaceLivenessActionTypeLivePitchDown)].mutableCopy;
        model.liveActionArray = @[@(FaceLivenessActionTypeLiveYaw), @(FaceLivenessActionTypeLiveMouth)].mutableCopy;
        model.numOfLiveness = 2;
    }
    [self livenesswithList:model.liveActionArray order:YES numberOfLiveness:model.numOfLiveness];
}

- (void)faceProcesss:(UIImage *)image {
    if (self.hasFinished || !self.didStartDetect) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[IDLFaceLivenessManager sharedInstance] livenessStratrgyWithImage:image previewRect:self.previewRect detectRect:self.detectRect completionHandler:^(NSDictionary *images, LivenessRemindCode remindCode) {
            NSData *bestData = nil;
            switch (remindCode) {
                case LivenessRemindCodeOK: {
                    weakSelf.didStartDetect = NO;
                    [weakSelf warningStatus:WarningCommonStatus warning:@"采集成功" conditionMeet:false];
                    if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
                        bestData = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf getDataCheckOK:YES error:NO bestData:bestData envData:nil delta:nil];
                    });
                    break;
                }
                case LivenessRemindCodePitchOutofDownRange: {
                    [weakSelf warningStatus:WarningPoseStatus warning:@"建议略微抬头" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodePitchOutofUpRange: {
                    [weakSelf warningStatus:WarningPoseStatus warning:@"建议略微低头" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeYawOutofLeftRange: {
                    [weakSelf warningStatus:WarningPoseStatus warning:@"建议略微向右转头" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeYawOutofRightRange: {
                    [weakSelf warningStatus:WarningPoseStatus warning:@"建议略微向左转头" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodePoorIllumination: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"光线再亮些" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeNoFaceDetected: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"把脸移入框内" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeImageBlured: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"请保持不动" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeOcclusionLeftEye: {
                    [weakSelf warningStatus:WarningocclusionStatus warning:@"左眼有遮挡" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeOcclusionRightEye: {
                    [weakSelf warningStatus:WarningocclusionStatus warning:@"右眼有遮挡" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeOcclusionNose: {
                    [weakSelf warningStatus:WarningocclusionStatus warning:@"鼻子有遮挡" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeOcclusionMouth: {
                    [weakSelf warningStatus:WarningocclusionStatus warning:@"嘴巴有遮挡" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeOcclusionLeftContour: {
                    [weakSelf warningStatus:WarningocclusionStatus warning:@"左脸颊有遮挡" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeOcclusionRightContour: {
                    [weakSelf warningStatus:WarningocclusionStatus warning:@"右脸颊有遮挡" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeOcclusionChinCoutour: {
                    [weakSelf warningStatus:WarningocclusionStatus warning:@"下颚有遮挡" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeTooClose: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"手机拿远一点" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeTooFar: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"手机拿近一点" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeBeyondPreviewFrame: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"把脸移入框内" conditionMeet:false];
                    break;
                }
                case LivenessRemindCodeLiveEye: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"请眨眨眼" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeLiveMouth: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"张张嘴" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeLiveYawRight: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"向右缓慢转头" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeLiveYawLeft: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"向左缓慢转头" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeLivePitchUp: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"缓慢抬头" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeLivePitchDown: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"缓慢低头" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeLiveYaw: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"请摇摇头" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeSingleLivenessFinished: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"非常好" conditionMeet:true];
                    [weakSelf showAnimate];
                    break;
                }
                case LivenessRemindCodeVerifyInitError: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"验证失败" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeVerifyDecryptError: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"验证失败" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeVerifyInfoFormatError: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"验证失败" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeVerifyExpired: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"验证失败" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeVerifyMissRequiredInfo: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"验证失败" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeVerifyInfoCheckError: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"验证失败" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeVerifyLocalFileError: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"验证失败" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeVerifyRemoteDataError: {
                    [weakSelf warningStatus:WarningCommonStatus warning:@"验证失败" conditionMeet:true];
                    break;
                }
                case LivenessRemindCodeTimeout: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.didStartDetect = NO;
                        [weakSelf warningStatus:WarningCommonStatus warning:@"超时了啦" conditionMeet:true];
                        [weakSelf getDataCheckOK:NO error:NO bestData:bestData envData:nil delta:nil];
                    });
                    break;
                }
                case LivenessRemindCodeConditionMeet: {
                    break;
                }
                default:
                    break;
            }
        }];
}

#pragma mark - Notification Method
- (void)addNotifications {
    // 监听重新返回APP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignAction) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onAppWillResignAction {
    _hasFinished = YES;
    [IDLFaceLivenessManager.sharedInstance reset];
}

- (void)onAppBecomeActive {
    _hasFinished = NO;
    [[IDLFaceLivenessManager sharedInstance] livenesswithList:_livenessArray order:_order numberOfLiveness:_numberOfLiveness];
}

#pragma mark - CaptureDataOutputProtocol
- (void)captureOutputSampleBuffer:(UIImage *)image {
    WeakSelf
    if (_hasFinished) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.displayImageView.image = image;
    });
    [self faceProcesss:image];
}

- (void)captureError {
    NSString *errorStr = @"出现未知错误，请检查相机设置";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        errorStr = @"相机权限受限,请在设置中启用";
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"知道啦");
        }];
        [alert addAction:action];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:true];
    }
    else{
        [self reset];
    }
}

#pragma mark - Navigator
- (void)pushAction:(__kindof UIViewController *)vc {
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    if ([vcs.lastObject isKindOfClass:[self class]]) {
        [vcs removeLastObject];
    }
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs.copy animated:YES];
}

- (void)gotoUpdatePhotoWithUrls:(NSMutableArray *)urls isPush:(BOOL)isPush {
    ZZSignUpS3ViewController *vc = [[ZZSignUpS3ViewController alloc] init];
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

// 满足条件，跳转到自定义的上传头像页
- (void)isMeetPushUploadHeadImage {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = YES;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = _type;
    [self pushAction:vc];
}

#pragma mark - Request
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
                            [self gotoUpdatePhotoWithUrls:urls isPush:NO];
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
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
            [ZZHUD dismiss];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                switch (_type) {
                    case NavigationTypeGotoCenter: {
                        ZZUserEditViewController *vc = [[ZZUserEditViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.gotoUserPage = YES;
                        vc.editCallBack = ^{
                            if (weakSelf.callBack) {
                                weakSelf.callBack();
                            }
                        };
                        [weakSelf pushAction:vc];
                        break;
                    }
                    case NavigationTypeRealname: {
                        ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
                        controller.user = _user;
                        [weakSelf pushAction:controller];
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
                                [weakSelf pushAction:controller];
//                                [weakSelf.navigationController pushViewController:controller animated:YES];
                            }];
                            [weakSelf.navigationController presentViewController:registerRent animated:YES completion:nil];
                        } else {
                            ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
                            controller.hidesBottomBarWhenPushed = YES;
                            [weakSelf pushAction:controller];
//                            [self.navigationController pushViewController:controller animated:YES];
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
                        [self isMeetPushUploadHeadImage];
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
                        [self isMeetPushUploadHeadImage];
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
                    default: {
                        [self.navigationController popViewControllerAnimated:YES];
                        break;
                    }
                }
            });
        }
    }];
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
        if (error) {
            if (_type == NavigationTypeDevicesLoginFirst) {
                [ZZHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
                if (_newDeviceLoginBlock) {
                    _newDeviceLoginBlock(NO, url, error.message ?: @"人脸对比失败哦");
                }
            }
            else if (_type == NavigationTypeTiXian) {
                [ZZHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
                if (_withdrawCompleBlock) {
                    _withdrawCompleBlock(url, 1);
                }
            }
            else {
                [ZZHUD showErrorWithStatus:error.message];
            }
        }
        else {
            [ZZHUD dismiss];
            if (_type == NavigationTypeAccountCancel) {
                [self.navigationController popViewControllerAnimated:YES];
                if (_checkSuccess) {
                    _checkSuccess();
                }
            }
            else if (_type ==NavigationTypeRestartPhone) {
                
                [self.navigationController popViewControllerAnimated:YES];
                if (_checkSuccess) {
                    _checkSuccess();
                }
            }
            else if (_type == NavigationTypeTiXian) {
                [self.navigationController popViewControllerAnimated:YES];
                if (_withdrawCompleBlock) {
                    _withdrawCompleBlock(url, 2);
                }
            }
            else if (_type == NavigationTypeDevicesLoginFirst) {
                [self.navigationController popViewControllerAnimated:YES];
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
//                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }];
}

#pragma mark - Layout
- (void)layout {
    [self.view addSubview:self.displayImageView];
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.circleView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.returnBtn];
    [self.view addSubview:self.proceeActionBtn];
    
    self.detectRect = CGRectMake(ScreenWidth * ( 1 - scaleValue) / 2.0,
                                 ScreenHeight * (1 - scaleValue) / 2.0 - 30.0,
                                 ScreenWidth * scaleValue,
                                 ScreenHeight * scaleValue);
    _displayImageView.frame = self.detectRect;
    
    _coverView.frame = self.view.bounds;
    
    self.circleRect = CGRectMake(SCREEN_WIDTH / 2 - SCALE_SET(265) / 2, self.view.center.y - 80 - SCALE_SET(265) / 2, SCALE_SET(265), SCALE_SET(265));
    
    self.previewRect = CGRectMake(self.circleRect.origin.x - self.circleRect.size.width * (1 / 0.7 - 1) / 2.0,
                                  self.circleRect.origin.y - self.circleRect.size.height * (1 / 0.7 - 1) / 2.0 - 60,
                                  self.circleRect.size.width / 0.7,
                                  self.circleRect.size.height / 0.7);
    
    _circleView.frame = CGRectMake(self.circleRect.origin.x - SCALE_SET(26), self.circleRect.origin.y - SCALE_SET(26), SCALE_SET(319), SCALE_SET(319));
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(isFullScreenDevice ? 50 : 33);
        make.centerX.equalTo(self.view);
    }];
    
    [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(isFullScreenDevice ? 50 : 33);
        make.left.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_proceeActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15.0);
        make.left.equalTo(self.view).offset(15.0);
        make.height.equalTo(@50.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-15);
        } else {
            make.bottom.equalTo(self.view).offset(-15);
        }
    }];
    
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < _livenessArray.count; i++) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        imageView.hidden = YES;
        if (i == 0) {
            imageView.center = CGPointMake(_circleView.center.x, _circleView.top);
        }
        else {
            imageView.center = CGPointMake(_circleView.center.x, _circleView.bottom);
        }
        
        imageView.bounds = CGRectMake(0.0, 0.0, 60.0, 60.0);
        [self.view addSubview:imageView];
        [arr addObject: imageView];
    }
    _iconsArray = arr.copy;
    
    [self.view addSubview:self.warningTitleLabel];
    [self.view addSubview:self.warningSubTitleLabel];
    
    [_warningTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37.0);
        make.right.equalTo(self.view).offset(-37.0);
        make.top.equalTo(self.view).offset(_circleRect.size.height + _circleRect.origin.y + 65);
    }];
    
    [_warningSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37.0);
        make.right.equalTo(self.view).offset(-37.0);
        make.top.equalTo(_warningTitleLabel.mas_bottom).offset(15.0);
    }];
    
    _circleView.layer.cornerRadius = _circleView.width / 2;
    _circleView.layer.borderWidth = 3;
    _circleView.layer.borderColor = UIColor.whiteColor.CGColor;
}

- (void)createCircle {
    //最外层套一个大的圆角矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:_coverView.bounds cornerRadius:0];
    
    //中间添加一个圆形
    [bpath appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x, self.view.center.y - 80) radius:SCALE_SET(262) / 2 startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = RGBCOLOR(49, 48, 47).CGColor;
    shapeLayer.path = bpath.CGPath;
    [_coverView.layer addSublayer:shapeLayer];
}

- (void)addCircledotLayer {
    _circleView.layer.borderWidth = 0;
    _circleView.layer.borderColor = UIColor.clearColor.CGColor;
    
    UIBezierPath *roundpath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2.5,
                                                                                   2.5,
                                                                                   _circleView.width - 5,
                                                                                   _circleView.height - 5)
                                                         cornerRadius:(self.circleView.height / 2 - 5) - 5];//
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = UIColor.whiteColor.CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.lineWidth = 3;
    layer.lineDashPattern = @[@0.01, @((self.circleView.width - 5) * M_PI / 20)];
    layer.lineCap = kCALineCapRound;
    layer.path = roundpath.CGPath;
    layer.name = @"layer_dots";
    [_circleView.layer addSublayer:layer];
    
    self.circleView.circleLayer = [LivenessCircleLayer layer];
    self.circleView.circleLayer.frame = self.circleView.bounds;
    //像素大小比例
    self.circleView.circleLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.circleView.layer addSublayer:self.circleView.circleLayer];
}

#pragma mark - getters and setters
- (UIImageView *)displayImageView {
    if (!_displayImageView) {
        _displayImageView = [[UIImageView alloc] init];
        _displayImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _displayImageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = UIColor.clearColor;
    }
    return _coverView;
}

- (LivenessCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[LivenessCircleView alloc] init];
        _circleView.backgroundColor = UIColor.clearColor;
    }
    return _circleView;
}

- (UIButton *)returnBtn {
    if (!_returnBtn) {
        _returnBtn = [[UIButton alloc] init];
        _returnBtn.normalImage = [UIImage imageNamed:@"rectangle8961"];
        [_returnBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"人脸识别";
        _titleLabel.textColor = RGBCOLOR(244, 203, 7);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    }
    return _titleLabel;
}

- (UILabel *)warningTitleLabel {
    if (!_warningTitleLabel) {
        _warningTitleLabel = [[UILabel alloc] init];
        _warningTitleLabel.text = @"为了确保资料真实, 保障您的人身及后续账户资金安全, 将进行真人验证, 请确保是您本人操作";
        _warningTitleLabel.textColor = RGBCOLOR(244, 203, 7);
        _warningTitleLabel.textAlignment = NSTextAlignmentCenter;
        _warningTitleLabel.numberOfLines = 0;
        _warningTitleLabel.font = ADaptedFontSCBoldSize(15);
    }
    return _warningTitleLabel;
}

- (UILabel *)warningSubTitleLabel {
    if (!_warningSubTitleLabel) {
        _warningSubTitleLabel = [[UILabel alloc] init];
        _warningSubTitleLabel.text = @"不是拍照，识别信息不会被别人看到";
        _warningSubTitleLabel.textColor = RGBACOLOR(244, 203, 7, 0.8);
        _warningSubTitleLabel.textAlignment = NSTextAlignmentCenter;
        _warningSubTitleLabel.font = ADaptedFontMediumSize(15);
        
    }
    return _warningSubTitleLabel;
}

- (UIButton *)proceeActionBtn {
    if (!_proceeActionBtn) {
        _proceeActionBtn = [[UIButton alloc] init];
        _proceeActionBtn.backgroundColor = UIColor.redColor;
        _proceeActionBtn.normalTitle = @"开始识别";
        _proceeActionBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _proceeActionBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _proceeActionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19.0];
        [_proceeActionBtn addTarget:self action:@selector(proceed) forControlEvents:UIControlEventTouchUpInside];
        _proceeActionBtn.layer.cornerRadius = 26;
    }
    return _proceeActionBtn;
}

- (void)setHasFinished:(BOOL)hasFinished {
    _hasFinished = hasFinished;
    if (hasFinished) {
        [self.captureDevice stopSession];
        self.captureDevice.delegate = nil;
    }
}

- (void)setType:(NavigationType)type {
    _type = type;
    if (_type == NavigationTypeUserLogin) {
        _checkType = LivenessTypeRegist;
    }
    else {
        _checkType = LivenessTypeCommon;
    }
}

@end


#pragma mark - LivenessCircleView

@implementation LivenessCircleView

@end


#pragma mark - LivenessCircleLayer

@implementation LivenessCircleLayer

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat radius = self.bounds.size.width / 2;
    CGFloat lineWidth = 4;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius - lineWidth / 2 startAngle:(- 90 / 180.0 * M_PI) endAngle:M_PI * 2 * self.progress clockwise:YES];
    CGContextSetRGBStrokeColor(ctx, (244 / 255.0f), (203 / 255.0f), (7 / 255.0f), 1.0);//笔颜色
    
    CGContextSetLineWidth(ctx, 4);//线条宽度
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
}

- (instancetype)initWithLayer:(LivenessCircleLayer *)layer {
    if (self = [super initWithLayer:layer]) {
        self.progress = layer.progress;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

@end
