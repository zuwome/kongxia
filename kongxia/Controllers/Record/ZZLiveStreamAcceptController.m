//
//  ZZLiveStreamAcceptController.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/6.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZLiveStreamAcceptController.h"
#import "ZZliveStreamHeadView.h"
#import "ZZLiveStreamVideoAlert.h"
#import "ZZLiveStreamHelper.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZChatManagerNetwork.h"

#import "ZZRecordBtnView.h"
#import "ZZRecordChooseView.h"
#import "WZBCountdownLabel.h"
#import "ZZCenterButton.h"
#import "ZZRecordTopicTitleView.h"
#import "ZZRecordTopicView.h"
#import "ZZRecordProgressView.h"
#import "ZZRecordBottomView.h"
#import "ZZRecordQuestionGuideView.h"
#import "PhotoAlbumViewController.h"
#import "ZZSelectPhotoManager.h"

#import "ZZFileHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZZLiveStreamConnectTopView.h"
#import "ZZLocalPushManager.h"
#import "ZZYLabel.h"
#import "ZZVideoMessage.h"
#import "ZZChatBaseModel.h"
#import "WBReachabilityManager.h"
#import "ZZCallIphoneVideoManager.h"

@interface ZZLiveStreamAcceptController () <GPUImageVideoCameraDelegate,ZZRecordBtnViewDelegate,ZZRecordChooseDelegate,ZZRecordProgressViewDelegate, WBSelectPhotoManagerObserver>
{
    GPUImageUIElement   *uiElementInput;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) ZZliveStreamHeadView *headView;
@property (nonatomic, strong) UIView *bottomBtnView;
@property (nonatomic, strong) UIButton *refuseBtn;
@property (nonatomic, strong) UIButton *acceptBtn;

@property (nonatomic, strong) ZZLiveStreamVideoAlert *cancelAlert;
@property (nonatomic, strong) ZZLiveStreamConnectTopView *topView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat yScale;

@property (nonatomic, assign) BOOL isAccept;    //点击过一次接通

@property (nonatomic, strong) ZZRecordBtnView *recordView;
@property (nonatomic, strong) ZZRecordChooseView *chooseView;
@property (nonatomic, strong) UIImageView *dynamicImgView;
@property (nonatomic, strong) ZZRecordQuestionGuideView *questionGuideView;

@property (nonatomic, strong) NSMutableArray *labelArray;//话题array

@property (nonatomic, strong) GPUImageStillCamera *videoCamera;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageView *previewView;
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) NSURL *exportURL;

@property (nonatomic, assign) BOOL haveLoadConfigView;
@property (nonatomic, assign) BOOL initSdkFailure;
@property (nonatomic, assign) BOOL haveLoadBeauty;//加载了美颜

@property (nonatomic, strong) GPUImageAlphaBlendFilter *blendFilter;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, assign) NSInteger currentQuestionIndex;
@property (nonatomic, assign) BOOL canChangeQuestion;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, assign) BOOL isFirstQuestion;
@property (nonatomic, assign) CGFloat timeScale;
@property (nonatomic, assign) NSInteger lastImgIndex;

@end

@implementation ZZLiveStreamAcceptController

- (void)viewWillAppear:(BOOL)animated {//将要出现
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    [self closeRightHandGestures];
    
}

- (void)viewDidAppear:(BOOL)animated { //出现之后
    [super viewDidAppear:animated];
    [self closeRightHandGestures];
    
    [self.view bringSubviewToFront:self.chooseView];
    [[ZZCallIphoneVideoManager shared] beginRing];

}

- (void)viewWillDisappear:(BOOL)animated { //将要消失
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self openRightHandGestures];
}

- (void)viewDidDisappear:(BOOL)animated {  //消失之后
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self openRightHandGestures];
}

- (void)openRightHandGestures {
    [self releaseObject];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)closeRightHandGestures {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

    if (self.isValidation) {
        WEAK_SELF();
        [ZZHUD show];
        self.view.userInteractionEnabled = NO;
        [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/room/%@/status", [ZZLiveStreamHelper sharedInstance].room_id] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [ZZHUD dismiss];
            if (data) {
                NSNumber *string = [data objectForKey:@"status"];
                if ([string intValue] == 0) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.view.userInteractionEnabled = NO;
                        weakSelf.statusLabel.text = @"对方已取消视频";
                        [NSObject asyncWaitingWithTime:2.0f completeBlock:^{
                            [ZZHUD dismiss];
                            [ZZLiveStreamHelper sharedInstance].isBusy = NO;
                            [weakSelf remove];
                        }];
                    });
                } else {
                    weakSelf.view.userInteractionEnabled = YES;
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupUI {
    
    self.view.backgroundColor = HEXACOLOR(0x000000, 0.9);
    
    self.isAccept = NO;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCancelMessage:) name:kMsg_CancelConnect object:nil];
    [self setupDynamicImage];
    
//    [self.view addSubview:self.progressView];
//    [self.view addSubview:self.leftBtn];
//    [self.view addSubview:self.rightBtn];
//    [self.view addSubview:self.delayBtn];
    [self.view addSubview:self.recordView];
//    self.bottomView.hidden = NO;
//    self.bottomView.isHidePhoto = YES;
//    self.recordView.minDuring = 1;
    self.chooseView.hidden = NO;
    
    self.bgView.hidden = NO;
    self.refuseBtn.hidden = NO;
    self.acceptBtn.hidden = NO;
    
    // 如果对方已经取消了，（为了防止一直处于后台，被调起，又被取消的时候当前页面还没有初始化注册通知，无法返回问题，则记录在本地缓存一个标志判断）
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kMsg_CancelConnect]) {
        WEAK_SELF();
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = NO;
            weakSelf.statusLabel.text = @"对方已取消视频";
            [NSObject asyncWaitingWithTime:2.0f completeBlock:^{
                [ZZLiveStreamHelper sharedInstance].isBusy = NO;
                [weakSelf remove];
            }];
        });
    }
}

- (void)setUser:(ZZUser *)user
{
    _user = user;
//    [self.headView.headImgView sd_setImageWithURL:[NSURL URLWithString:_user.avatar]];
//    //    _nameLabel.text = user.nickname;
//    NSString *string = [NSString stringWithFormat:@"%@申请与您视频聊天", user.nickname];
//    NSRange range = [string rangeOfString:user.nickname];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(244, 203, 7) range:range];
//    _nameLabel.attributedText = attributedString;
}

- (void)remove
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_cancelAlert removeFromSuperview];
//        [self.view removeFromSuperview];
        [ZZLiveStreamHelper sharedInstance].isBusy = NO;
        [self releaseObject];
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

// 接通方法
- (void)acceptBtnClick
{
    if (!GetReachabilityManager().isReachable) {
        [ZZHUD showErrorWithStatus:@"网络异常，请检查"];
        return;
    }

    [MobClick event:Event_click_Other_Video_Through];
    if (self.isAccept) {
        return;
    }
    if (_touchAccept) {
        
        // 点击接通视频，需要告诉对方可以开始连接房间
        [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/user/notify", [ZZLiveStreamHelper sharedInstance].room_id] params:@{@"type" : Through_Type} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [ZZLiveStreamHelper sharedInstance].isBusy = YES;
        }];

        self.isAccept = YES;
        self.acceptBtn.enabled = NO;
        self.refuseBtn.enabled = NO;
        
        [ZZLiveStreamHelper sharedInstance].user = _user;
        _touchAccept();
    }
}

- (void)refuseBtnClick
{
    if (!GetReachabilityManager().isReachable) {
        [ZZHUD showErrorWithStatus:@"网络异常，请检查"];
        return;
    }
    [MobClick event:Event_click_Other_Video_Refused];
    [self.view addSubview:self.cancelAlert];
}

// 拒接方法
- (void)sendRefuseMessage
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/room/%@/user/notify", [ZZLiveStreamHelper sharedInstance].room_id] params:@{@"type" : Refuse_Type} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [ZZLiveStreamHelper sharedInstance].isBusy = NO;
    }];
}

- (void)receiveCancelMessage:(NSNotification *)notification
{
    WEAK_SELF();
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    if ([uid isEqualToString:_user.uid]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = NO;
            [ZZLiveStreamHelper sharedInstance].isBusy = YES;
            [weakSelf showErrorInfo:@"对方已取消视频"];
        });
    }
}

- (void)showErrorInfo:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = error;
        if ([ZZLocalPushManager runningInBackground]) {
            [self remove];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self remove];
            });
        }
    });
}


#pragma mark -

- (void)timerEvent {
    _count++;
    // 600 = 60秒 = 1分钟 等待超时时间
    if (_count > 600) {
        _count = 600;
        if (_timeOut) {
            _timeOut();
        }
        [ZZLiveStreamHelper sharedInstance].isBusy = NO;
        [self remove];
    } else {
        self.headView.progress =  1 - _count/600.0;
    }
}

//重置moviewrite
- (void)resetMovieWrite
{
    [_blendFilter removeTarget:_movieWriter];
    _movieWriter = nil;
    [_blendFilter addTarget:self.movieWriter];
}
//动态图片问题
- (void)setupDynamicImage
{
    GPUImageFilter *filter = [[GPUImageFilter alloc] init];
    [self.videoCamera addTarget:filter];
    
    _blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    _blendFilter.mix = 1.0;
    
    _dynamicImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _dynamicImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view addSubview:_dynamicImgView];
    
    uiElementInput = [[GPUImageUIElement alloc] initWithView:view];
    
    [filter addTarget:_blendFilter];
    [uiElementInput addTarget:_blendFilter];
    
    [_blendFilter addTarget:_previewView];
    NSDate *startTime = [NSDate date];
    
    WeakSelf;
    __unsafe_unretained GPUImageUIElement *weakUIElementInput = uiElementInput;
    [filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
        @autoreleasepool {
            //这边用30帧来大概估算，可否考虑使用FPS来计算？（待优化）
            if (!weakSelf.timeScale) {
                NSInteger index = -[startTime timeIntervalSinceNow]*1000;
                weakSelf.timeScale = index / (1000/30.0);
                if (weakSelf.timeScale < 1) {
                    weakSelf.timeScale = 1;
                }
//                NSLog(@"11111");
            }
            if (!weakSelf.isFirstQuestion) {
                if (weakSelf.imgArray.count && weakSelf.currentCount < weakSelf.imgArray.count) {
                    NSInteger count = weakSelf.imgArray.count;
                    NSInteger index = MIN((weakSelf.currentCount % count)*weakSelf.timeScale, count - 1);
                    if (index - weakSelf.lastImgIndex > 3) {
                        index = weakSelf.lastImgIndex + 2;
                    }
                    index = MIN(index, count - 1);
                    UIImage *image = weakSelf.imgArray[index];
                    weakSelf.dynamicImgView.image = image;
                    weakSelf.currentCount++;
                    weakSelf.lastImgIndex = index;
                }
//                NSLog(@"22222");
            } else {
                weakSelf.dynamicImgView.image = nil;
                weakSelf.currentCount = 0;
                weakSelf.lastImgIndex = 0;
//                NSLog(@"33333");
            }
        }
        [weakUIElementInput update];
    }];
    
    [_blendFilter addTarget:self.movieWriter];
    [self.videoCamera startCameraCapture];
}

#pragma mark - GPUImageVideoCameraDelegate

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
//    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice] orientation];
//    BOOL mirrored = (self.videoCamera.cameraPosition == AVCaptureDevicePositionFront && self.videoCamera.horizontallyMirrorFrontFacingCamera) || (self.videoCamera.cameraPosition == AVCaptureDevicePositionBack && self.videoCamera.horizontallyMirrorRearFacingCamera);
//    
//    cv_rotate_type cvMobileRotate;
    switch (iDeviceOrientation) {
        case UIDeviceOrientationPortrait:
//            cvMobileRotate = CV_CLOCKWISE_ROTATE_90;
            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_0;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
//            cvMobileRotate = mirrored ? CV_CLOCKWISE_ROTATE_180 : CV_CLOCKWISE_ROTATE_0;
            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_270;
            break;
            
        case UIDeviceOrientationLandscapeRight:
//            cvMobileRotate = mirrored ? CV_CLOCKWISE_ROTATE_0 : CV_CLOCKWISE_ROTATE_180;
            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_90;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
//            cvMobileRotate = CV_CLOCKWISE_ROTATE_270;
            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_180;
            break;
            
        default:
//            cvMobileRotate = CV_CLOCKWISE_ROTATE_0;
            break;
    }

}

#pragma mark - ZZRecordBtnViewDelegate

#pragma mark - ZZRecordChooseDelegate

- (void)chooseView:(id)chooseView isViewUp:(BOOL)isViewUp
{
    if (!isViewUp) {
        [self showViews];
    }
}

#pragma mark - ZZRecordProgressViewDelegate

- (void)progressView:(ZZRecordProgressView *)progressView videoDurationLongEnough:(BOOL)enough
{
}

- (void)videoReachMaxDuration
{
}

#pragma mark - private

- (void)hideViews
{
    [self updateUIHidden:YES];
}

- (void)showViews
{
    [self updateUIHidden:NO];
}

- (void)updateUIHidden:(BOOL)hidden {
    
    self.refuseBtn.hidden = hidden;
    self.acceptBtn.hidden = hidden;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self bottomItemsDown];
}

- (void)bottomItemsDown
{
    if (self.chooseView.isViewUp) {
        [self.chooseView viewDown];
    }

}

- (void)backConfigInfomation
{
    if (!_haveLoadConfigView) {
        return;
    }
    ZZRecordConfigModel *model = [[ZZRecordConfigModel alloc] init];
    [ZZUserHelper shareInstance].recordConfigModel = model;
}

#pragma mark - Lazyload

- (NSURL *)movieURL
{
    NSString *fileName = [[NSUUID UUID] UUIDString];
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
    NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld.mp4",fileName,timeInterval]];
    _movieURL = [NSURL fileURLWithPath:pathToMovie];
    return _movieURL;
}

- (NSURL *)exportURL
{
    if (!_exportURL) {
        NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
        NSString *pathToExport = [NSString stringWithFormat:@"%@/%ld.mp4",[ZZFileHelper createPathWithChildPath:video_savepath],timeInterval];
        _exportURL = [NSURL fileURLWithPath:pathToExport];
    }
    return _exportURL;
}

- (NSMutableArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}


- (GPUImageStillCamera *)videoCamera
{
    if (!_videoCamera) {
        if (ISiPhone4) {
            _videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetiFrame960x540 cameraPosition:AVCaptureDevicePositionFront];
        } else {
            _videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetiFrame1280x720 cameraPosition:AVCaptureDevicePositionFront];
        }
        _videoCamera.frameRate = 30;
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        _videoCamera.horizontallyMirrorRearFacingCamera = NO;
        //该句可防止允许声音通过的情况下，避免录制第一帧黑屏闪屏(====)
        [_videoCamera addAudioInputsAndOutputs];
        _videoCamera.delegate = self;
        
        [_videoCamera startCameraCapture];
        [self.previewView setHidden:NO];
    }
    
    return _videoCamera;
}

- (GPUImageView *)previewView
{
    if (!_previewView) {
        _previewView = [[GPUImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [self.view addSubview:_previewView];
    }
    
    return _previewView;
}

- (ZZLiveStreamConnectTopView *)topView
{
    if (!_topView) {
        _topView = [[ZZLiveStreamConnectTopView alloc] initWithFrame:CGRectMake(0, SafeAreaBottomHeight, SCREEN_WIDTH - 50, 10)];
    }
    return _topView;
}

- (GPUImageMovieWriter *)movieWriter
{
    if (!_movieWriter) {
        NSDictionary * videoSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
                                          AVVideoWidthKey : @(540),
                                          AVVideoHeightKey : @(960),
                                          AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill};
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.movieURL size:CGSizeMake(540.0, 960.0) fileType:AVFileTypeQuickTimeMovie outputSettings:videoSettings];
    }
    return _movieWriter;
}

- (ZZRecordChooseView *)chooseView
{
    WeakSelf;
    if (!_chooseView) {
        _chooseView = [[ZZRecordChooseView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 206+SafeAreaBottomHeight)];
        _chooseView.delegate = weakSelf;
//        [self.view addSubview:_chooseView];
        _chooseView.showRedPoint = ^{
//            weakSelf.bottomView.redPointView.hidden = NO;
        };
    }
    return _chooseView;
}


- (GPUImageRotationMode)trackRotation
{
    GPUImageRotationMode trackRotation = kGPUImageNoRotation;
    
    if ([self.videoCamera cameraPosition] == AVCaptureDevicePositionBack) {
        if (self.videoCamera.horizontallyMirrorRearFacingCamera) {
            switch(self.videoCamera.outputImageOrientation) {
                case UIInterfaceOrientationPortrait:trackRotation = kGPUImageRotateRightFlipVertical; break;
                case UIInterfaceOrientationPortraitUpsideDown:trackRotation = kGPUImageRotate180; break;
                case UIInterfaceOrientationLandscapeLeft:trackRotation = kGPUImageFlipHorizonal; break;
                case UIInterfaceOrientationLandscapeRight:trackRotation = kGPUImageFlipVertical; break;
                default:trackRotation = kGPUImageNoRotation;
            }
        } else {
            switch(self.videoCamera.outputImageOrientation) {
                case UIInterfaceOrientationPortrait:trackRotation = kGPUImageRotateRight; break;
                case UIInterfaceOrientationPortraitUpsideDown:trackRotation = kGPUImageRotateLeft; break;
                case UIInterfaceOrientationLandscapeLeft:trackRotation = kGPUImageRotate180; break;
                case UIInterfaceOrientationLandscapeRight:trackRotation = kGPUImageNoRotation; break;
                default:trackRotation = kGPUImageNoRotation;
            }
        }
    } else {
        if (self.videoCamera.horizontallyMirrorFrontFacingCamera) {
            switch(self.videoCamera.outputImageOrientation) {
                case UIInterfaceOrientationPortrait:trackRotation = kGPUImageRotateRightFlipVertical; break;
                case UIInterfaceOrientationPortraitUpsideDown:trackRotation = kGPUImageRotateRightFlipHorizontal; break;
                case UIInterfaceOrientationLandscapeLeft:trackRotation = kGPUImageFlipHorizonal; break;
                case UIInterfaceOrientationLandscapeRight:trackRotation = kGPUImageFlipVertical; break;
                default:trackRotation = kGPUImageNoRotation;
            }
        } else {
            switch(self.videoCamera.outputImageOrientation) {
                case UIInterfaceOrientationPortrait:trackRotation = kGPUImageRotateRight; break;
                case UIInterfaceOrientationPortraitUpsideDown:trackRotation = kGPUImageRotateLeft; break;
                case UIInterfaceOrientationLandscapeLeft:trackRotation = kGPUImageNoRotation; break;
                case UIInterfaceOrientationLandscapeRight:trackRotation = kGPUImageRotate180; break;
                default:trackRotation = kGPUImageNoRotation;
            }
        }
    }
    
    return trackRotation;
}

- (ZZRecordQuestionGuideView *)questionGuideView
{
    if (!_questionGuideView) {
        _questionGuideView = [[ZZRecordQuestionGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _questionGuideView;
}

- (void)releaseObject
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMsg_CancelConnect];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[ZZCallIphoneVideoManager shared] stopRing];
    [WZBCountdownLabel remove];
    _videoCamera = nil;
    _movieWriter = nil;
    _previewView = nil;
    _blendFilter = nil;
    
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_bgView];
        
        _scale = SCREEN_WIDTH/375.0;
        if (_scale > 1) {
            _scale = 1;
        }
        _yScale = SCREEN_HEIGHT/667.0;
        if (_yScale > 1) {
            _yScale = 1;
        }
        _bottomBtnView = [[UIView alloc] init];
        [_bgView addSubview:_bottomBtnView];
        
        [_bottomBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_bgView);
            //            make.top.mas_equalTo(_statusLabel.mas_bottom);
            make.height.mas_equalTo(230+SafeAreaBottomHeight);
        }];
        
        [_bgView addSubview:self.topView];
        self.topView.user = _user;
        CGFloat height = [_topView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
        _topView.height = height ;
        _topView.isConnectHeader = YES;
        _topView.accept = YES;

        self.headView.hidden = YES;
//        self.nameLabel.text = @"11111";
//        self.statusLabel.text = @"视频过程中 请确保本人正面出镜";
    }
    return _bgView;
}

- (ZZliveStreamHeadView *)headView
{
    if (!_headView) {
        CGFloat offset = (SCREEN_HEIGHT/667.0)*104;
        CGFloat width = _scale*295;
        
        _headView = [[ZZliveStreamHeadView alloc] init];
        [_bgView addSubview:_headView];
        
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(offset);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(width, width));
        }];
    }
    return _headView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:24*_scale];
        [_bgView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_headView.mas_top).offset(-_yScale*20);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
        }];
    }
    return _nameLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:18];
        [_bgView addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_headView.mas_bottom).offset(_yScale*36);
            make.centerY.mas_equalTo(_bgView.mas_centerY);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
        }];
        
    }
    return _statusLabel;
}

- (UIButton *)refuseBtn {
    if (!_refuseBtn) {
        _refuseBtn = [[UIButton alloc] init];
        [_refuseBtn addTarget:self action:@selector(refuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtnView addSubview:_refuseBtn];
        
        [_refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_left).offset(SCREEN_WIDTH/4);
//            make.centerY.mas_equalTo(_bottomBtnView.mas_centerY);
            make.bottom.mas_equalTo(_bottomBtnView.mas_bottom).offset(-50-SafeAreaBottomHeight);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_livestream_refuse"];
        imgView.userInteractionEnabled = NO;
        [_refuseBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_refuseBtn);
            make.size.mas_equalTo(CGSizeMake(64*_scale, 64*_scale));
        }];
        
        ZZYLabel *label = [[ZZYLabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:17];
        label.text = @"拒接";
        label.userInteractionEnabled = NO;
        label.outlineColor = RGBCOLOR(173, 173, 177);
        label.outlineWidth = 1.0f;
        [_refuseBtn addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_refuseBtn.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(11);
            make.bottom.mas_equalTo(_refuseBtn.mas_bottom);
        }];
    }
    return _refuseBtn;
}

- (UIButton *)acceptBtn {
    if (!_acceptBtn) {
        _acceptBtn = [[UIButton alloc] init];
        [_acceptBtn addTarget:self action:@selector(acceptBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtnView addSubview:_acceptBtn];
        
        [_acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView.mas_right).offset(-SCREEN_WIDTH/4);
            make.bottom.mas_equalTo(_bottomBtnView.mas_bottom).offset(-50-SafeAreaBottomHeight);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_livestream_accept"];
        imgView.userInteractionEnabled = NO;
        [_acceptBtn addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_acceptBtn);
            make.size.mas_equalTo(CGSizeMake(64*_scale, 64*_scale));
        }];
        
        ZZYLabel *label = [[ZZYLabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:17];
        label.text = @"接通";
        label.userInteractionEnabled = NO;
        label.outlineColor = RGBCOLOR(173, 173, 177);
        label.outlineWidth = 1.0f;

        [_acceptBtn addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_acceptBtn.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(11);
            make.bottom.mas_equalTo(_acceptBtn.mas_bottom);
        }];
    }
    return _acceptBtn;
}

- (ZZLiveStreamVideoAlert *)cancelAlert
{
    WeakSelf;
    if (!_cancelAlert) {
        _cancelAlert = [[ZZLiveStreamVideoAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        if ([ZZLiveStreamHelper sharedInstance].by_mcoin) {//如果发单人使用的是么币，则弹窗么币
            _cancelAlert.type = 8;
        } else {//否则使用金钱弹窗
            _cancelAlert.type = 1;
        }
        _cancelAlert.touchRight = ^{
            [weakSelf remove];

            if (weakSelf.touchRefuse) {
                weakSelf.touchRefuse();
            }
            [weakSelf sendRefuseMessage];
        };
        _cancelAlert.touchLeft = ^{
            [weakSelf acceptBtnClick];
        };
    }
    return _cancelAlert;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
