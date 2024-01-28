 //
//  ZZRecordViewController.m
//  zuwome
//
//  Created by angBiu on 2016/12/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRecordViewController.h"

#import "ZZRecordBtnView.h"
#import "ZZRecordChooseView.h"
#import "WZBCountdownLabel.h"
#import "ZZCenterButton.h"
#import "ZZRecordTopicTitleView.h"
#import "ZZRecordProgressView.h"
#import "ZZRecordBottomView.h"
#import "ZZRecordQuestionGuideView.h"
#import "PhotoAlbumViewController.h"
#import "ZZSelectPhotoManager.h"
#import "ZZLiveStreamHelper.h"

#import "ZZFileHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"

@interface ZZRecordViewController () <GPUImageVideoCameraDelegate,ZZRecordBtnViewDelegate,ZZRecordChooseDelegate,ZZRecordProgressViewDelegate, WBSelectPhotoManagerObserver,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    GPUImageUIElement   *uiElementInput;
}

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) ZZCenterButton *rightBtn;
@property (nonatomic, strong) UIImageView *albumsGuide;//相册指引动画imageView
@property (nonatomic, strong) ZZCenterButton *delayBtn;//延时btn
@property (nonatomic, strong) UILabel *delayLabel;
@property (nonatomic, strong) ZZRecordBtnView *recordView;
@property (nonatomic, strong) ZZRecordChooseView *chooseView;

@property (nonatomic, strong) ZZRecordTopicTitleView *topicTitleView;

@property (nonatomic, strong) ZZRecordProgressView *progressView;
@property (nonatomic, strong) UIImageView *dynamicImgView;
@property (nonatomic, strong) ZZRecordBottomView *bottomView;
@property (nonatomic, strong) ZZRecordQuestionGuideView *questionGuideView;

@property (nonatomic, strong) NSMutableArray *labelArray;//话题array

@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) NSURL *exportURL;

@property (nonatomic, assign) BOOL haveLoadConfigView;
@property (nonatomic, assign) BOOL initSdkFailure;
@property (nonatomic, assign) BOOL isCounting;//正在倒计时

@property (nonatomic, strong) NSMutableArray *videoUrlArray;
@property (nonatomic, assign) BOOL animating;//延时提示动画
@property (nonatomic, assign) BOOL shouldFinishVideo;//自动录制到了最大限制时间
@property (nonatomic, strong) NSDictionary *topicDict;
@property (nonatomic, strong) NSArray *questionArray;
@property (nonatomic, strong) NSArray *questionImgArray;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, assign) NSInteger currentQuestionIndex;
@property (nonatomic, assign) BOOL canChangeQuestion;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, assign) BOOL isFirstQuestion;
@property (nonatomic, assign) CGFloat timeScale;
@property (nonatomic, assign) NSInteger lastImgIndex;
@property (nonatomic, assign) BOOL isCompleted;//是否录制达到最小时间

@property (nonatomic, strong) UILabel *isMinpromptLab;//最小录制时间提示

#pragma mark 视频相关属性
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;

@property (nonatomic, strong) GPUImageView *previewView;

@property (nonatomic, strong) GPUImageFilter *blendFilter;

@property (assign, nonatomic) CGFloat startTime;

@property (assign, nonatomic) CGFloat endTime;

@property (strong, nonatomic) PLShortVideoTranscoder *shortVideoTranscoder;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UILabel *progressLabel;

@end

@implementation ZZRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_haveLoadConfigView && !_initSdkFailure) {
        if (!self.isHidePhoto) {
            // 创建相册第一次指引动画
            [self showAnimation];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isIntroduceVideo) {
        // 是录制达人视频，统一由后台控制是否能选取相册
        self.isHidePhoto = [ZZUserHelper shareInstance].configModel.hide_base_sk_album;
    }
    else if(_type == RecordTypeSK) {
        // 其他普通录制，也统一由后台控制是否能选取相册
        self.isHidePhoto = [ZZUserHelper shareInstance].configModel.hide_sk_album;
    }
    else {
        self.isHidePhoto = [ZZUserHelper shareInstance].configModel.hide_mmd_album;;
    }

    [GetSelectPhotoManager() addObserver:self];
    [self createViews];
}

- (void)dealloc {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    [self.shortVideoTranscoder cancelTranscoding];
    self.shortVideoTranscoder = nil;
    
    [self releaseObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)releaseObject {
    [ZZLiveStreamHelper sharedInstance].isBusy = NO;
    [WZBCountdownLabel remove];
    _videoCamera.audioEncodingTarget = nil;
    [_videoCamera removeTarget:_blendFilter];
    [_blendFilter removeTarget:_movieWriter];
    [_blendFilter removeTarget:_previewView];
    _videoCamera = nil;
    [_movieWriter finishRecording];
    _movieWriter = nil;

    _previewView = nil;
    _blendFilter = nil;
}

- (void)createViews {

    [self setupDynamicImage];
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.delayBtn];
    [self.view addSubview:self.recordView];
    [self.view addSubview:self.isMinpromptLab];
    self.bottomView.hidden = NO;
    self.bottomView.isHidePhoto = self.isHidePhoto;
    self.recordView.minDuring = 1;
    self.chooseView.hidden = NO;
    
    if (_type == RecordTypeSK) {
        self.progressView.minDuration = 6;
        if (_groupModel) {
            if (_is_base_sk) {
                [self.view addSubview:self.topicTitleView];
                self.topicTitleView.selectedModel = _groupModel;
                self.topicTitleView.isIntroduceVideo = self.isIntroduceVideo;
            }
        }
        else {
            if (![[ZZUserHelper shareInstance].lastSKTopicVersion isEqualToString:[ZZUserHelper shareInstance].configModel.group_version]) {
            }
        }
    }
    else {
        self.progressView.minDuration = 6;
    }
    
    if (self.isIntroduceVideo) {
        // 达人视频 最少8秒
        self.progressView.minDuration = 6;
        self.topicTitleView.isIntroduceVideo = YES;
    }
    [self createPhotoAnimationUI];
    
    // 展示视频拼接的动画
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    // 展示视频拼接的进度
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 200, 45)];
    self.progressLabel.center = CGPointMake(self.activityIndicatorView.center.x, self.activityIndicatorView.center.y + 30);
    self.progressLabel.textAlignment =  NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)createPhotoAnimationUI {
    self.albumsGuide = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rectangle25"]];
    self.albumsGuide.alpha = 0;
    [self.view addSubview:self.albumsGuide];
    [_albumsGuide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(135.0, 48));
        make.centerX.equalTo(self.bottomView.selectPhotoBtn).offset(-6);
        make.bottom.equalTo(self.bottomView.selectPhotoBtn.mas_top).offset(-6);
    }];
    UILabel *title = [UILabel new];
    title.text = @"可以上传相册视频啦";
    title.textColor = kBlackColor;
    title.font = [UIFont systemFontOfSize:13];
    title.textAlignment = NSTextAlignmentCenter;
    [self.albumsGuide addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@(-5));
    }];
}

- (void)showAnimation {
    //达人视频  这个也要有
    if (self.isIntroduceVideo) {
        NSString *isDaRen = [[NSUserDefaults standardUserDefaults] objectForKey:@"isDaRenAlbumsGuide"];
        if (isNullString(isDaRen)) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isDaRenAlbumsGuide"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            WEAK_SELF();
            [UIView animateWithDuration:0.8 animations:^{
                weakSelf.albumsGuide.mj_y = SCREEN_HEIGHT - 123 - (isIPhoneX ? 34 : 0);
                weakSelf.albumsGuide.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [weakSelf shakeAnimation];
                [NSObject asyncWaitingWithTime:3.0f completeBlock:^{
                    [weakSelf.albumsGuide removeFromSuperview];
                }];
            }];
        }
            return;
    }
    
    NSString *isShow = [[NSUserDefaults standardUserDefaults] objectForKey:@"albumsGuide"];
    if (isNullString(isShow)) {

        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"albumsGuide"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        WEAK_SELF();
        [UIView animateWithDuration:0.8 animations:^{
            weakSelf.albumsGuide.mj_y = SCREEN_HEIGHT - 123 - (isIPhoneX ? 34 : 0);
            weakSelf.albumsGuide.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [weakSelf shakeAnimation];
            [NSObject asyncWaitingWithTime:3.0f completeBlock:^{
                [weakSelf.albumsGuide removeFromSuperview];
            }];
        }];
    }
}

- (void)shakeAnimation {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    moveAnimation.duration = 0.8f;
    moveAnimation.fromValue = [NSNumber numberWithFloat:-5];
    moveAnimation.toValue = [NSNumber numberWithFloat:5];
    moveAnimation.repeatCount = HUGE_VALF;
    moveAnimation.autoreverses = YES;
    [self.albumsGuide.layer addAnimation:moveAnimation forKey:nil];
}

//重置moviewrite
- (void)resetMovieWrite {
    [_blendFilter removeTarget:_movieWriter];
    _movieWriter = nil;
    [_blendFilter addTarget:self.movieWriter];
}

//动态图片问题
- (void)setupDynamicImage {
    
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetiFrame1280x720 cameraPosition:AVCaptureDevicePositionFront];
    _videoCamera.frameRate = 30;
     _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
     _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
     _videoCamera.horizontallyMirrorRearFacingCamera = NO;
     //该句可防止允许声音通过的情况下，避免录制第一帧黑屏闪屏(====)
     [_videoCamera addAudioInputsAndOutputs];
    
    _blendFilter = [[GPUImageFilter alloc] init];
    _previewView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    _previewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    self.view = _previewView;
    
    [_videoCamera addTarget:_blendFilter];
    [_blendFilter addTarget:_previewView];
    [_videoCamera startCameraCapture];
}

#pragma mark - GPUImageVideoCameraDelegate
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice] orientation];
    switch (iDeviceOrientation) {
        case UIDeviceOrientationPortrait: {
            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_0;
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_270;
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_90;
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown: {
            [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_180;
            break;
        }
        default:
            break;
    }
}

#pragma mark - ZZRecordBtnViewDelegate
- (void)recordViewBeginDelayReocrd {
    self.delayBtn.hidden = YES;
    WeakSelf;
    if (self.recordView.haveStartRecord) {
        [self.recordView finishRecord:YES];
    }
    else {
        _isCounting = YES;
        self.bottomView.userInteractionEnabled = NO;
        [WZBCountdownLabel playWithNumber:5 endTitle:@"GO" success:^(WZBCountdownLabel *label) {
            weakSelf.bottomView.userInteractionEnabled = YES;
            weakSelf.isCounting = NO;
            [weakSelf.recordView beginRecord];
            //            [weakSelf.recordView showInfoText:@"点击屏幕结束录制"];
        }];
    }
}

- (void)recordViewStatrRecord {
    if (!self.isCompleted) {
        self.isMinpromptLab.hidden = NO;
    }
    if (_type == RecordTypeSK) {
        [MobClick event:Event_click_record_record_sk];
    } else {
        [MobClick event:Event_click_record_record_memeda];
    }
    [self startRecord];
    [self disenableBtn];
}

- (void)recordViewTooShort {
    self.recordView.userInteractionEnabled = NO;
    WeakSelf;
    [weakSelf enableBtn];
    self.progressView.currentDuration = 0;
    NSURL *url = _movieURL;
    [self.movieWriter finishRecordingWithCompletionHandler:^{
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        [weakSelf resetMovieWrite];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.recordView.userInteractionEnabled = YES;
        });
    }];
}

- (void)recordViewEndRecord {
    self.view.userInteractionEnabled = NO;
    WeakSelf;
    [self.movieWriter finishRecordingWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.videoUrlArray insertObject:_movieURL atIndex:0];
            weakSelf.bottomView.videoCount = weakSelf.videoUrlArray.count;
            [weakSelf enableBtn];
            weakSelf.view.userInteractionEnabled = YES;
            [weakSelf resetMovieWrite];
            weakSelf.progressView.lastSumDuration = weakSelf.progressView.lastSumDuration + weakSelf.recordView.count/100.0 - 0.1;
            if (weakSelf.shouldFinishVideo) {
                [self doneBtnClick];
            }
        });
    }];
}

- (void)recordViewProgressing {
    if (self.bottomView.deleteSelected) {
        self.bottomView.deleteSelected = NO;
    }
    [self.progressView isHiddenProgress:NO];
    self.progressView.currentDuration = self.recordView.count / 100.0;
}

- (void)enableBtn {
    _leftBtn.hidden = NO;
    _delayBtn.hidden = NO;
    [self.bottomView showAllViews];
}

- (void)disenableBtn {
    _leftBtn.hidden = YES;
    _delayBtn.hidden = YES;
    [self.bottomView hideAllViews];
}

- (void)addWatermarkToVideo {
    /*****************    裁剪视频头0.1秒 解决第一帧偶现黑屏问题    ************************/
    // 创建可变的音视频组合
    AVMutableComposition *comosition = [AVMutableComposition composition];
    //分离视频的音轨和视频轨
    AVMutableCompositionTrack *videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    for (NSInteger i=0; i<_videoUrlArray.count; i++) {
        AVURLAsset *videoAsset = [[AVURLAsset alloc]initWithURL:_videoUrlArray[i] options:nil];
        
        CMTime duration = videoAsset.duration;
        //要截取的时间
        CMTime clipTime = CMTimeMakeWithSeconds(0.1, duration.timescale);
        //截取后的视频时长
        CMTime clipDurationTime = CMTimeSubtract(duration, clipTime);
        //截取后的视频时间范围
        CMTimeRange videoTimeRange = CMTimeRangeMake(clipTime, clipDurationTime);
        //视频采集通道
        AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        //把采集的轨道数据加入到视频轨道之中
        [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
        
        //音频采集通道
        AVAssetTrack *audioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio]firstObject];
        //把采集的轨道数据加入到音频轨道之中
        [audioTrack insertTimeRange:videoTimeRange ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    }
    
 
    // export
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:[comosition copy] presetName:AVAssetExportPresetHighestQuality];
    //    exportSession.videoComposition = videoComposition;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = self.exportURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    WeakSelf;
    __weak AVAssetExportSession *weakExportSession = exportSession;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.view.userInteractionEnabled = YES;
        });
        
        
        weakSelf.shouldFinishVideo = NO;
        NSLog(@"PY_视频录制完毕存储 %ld",weakExportSession.status );
        if (weakExportSession.status == AVAssetExportSessionStatusCompleted) {
            [ZZHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf gotoEditView];
            });
        }
        else if (weakExportSession.status == AVAssetExportSessionStatusExporting){
            [ZZHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf gotoEditView];
            });
        }
        else {
            [ZZHUD showErrorWithStatus:@"视频处理失败"];
            [[NSFileManager defaultManager] removeItemAtURL:weakSelf.exportURL error:nil];
        }
        [weakSelf resetMovieWrite];
    }];
}

- (void)clearTempVideo {
    self.bottomView.deleteSelected = NO;
    self.bottomView.doneSelected = NO;
    for (NSURL *url in _videoUrlArray) {
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    }
    [_videoUrlArray removeAllObjects];
    self.bottomView.videoCount = 0;
    [self.progressView removeAllVideo];
    [self.bottomView hideOperateView];
}

#pragma mark - ZZRecordChooseDelegate
- (void)chooseView:(id)chooseView isViewUp:(BOOL)isViewUp {
    if (!isViewUp) {
        [self showViews];
    }
}

#pragma mark - ZZRecordProgressViewDelegate
- (void)progressView:(ZZRecordProgressView *)progressView videoDurationLongEnough:(BOOL)enough {
    self.isMinpromptLab.hidden = YES;
    self.isCompleted = enough;
    self.bottomView.doneSelected = enough;
    self.bottomView.doneBtn.hidden = NO;
}

- (void)videoReachMaxDuration {
    _shouldFinishVideo = YES;
    [self.recordView finishRecord:NO];
}

#pragma mark - UIButtonMethod
- (void)leftBtnClick {
    if (self.videoUrlArray.count > 0) {
        [self showOkCancelAlert:@"提示" message:@"是否放弃当前录制" confirmTitle:@"确定" confirmHandler:^(UIAlertAction * _Nonnull action) {
            [self dismissView];
        } cancelTitle:@"取消" cancelHandler:nil];
    }
    else {
        [self dismissView];
    }
}

- (void)dismissView {
    [self clearTempVideo];
    if (_viewDismiss) {
        _viewDismiss();
    }
    [self.movieWriter finishRecording];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self releaseObject];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

- (void)rightBtnClick {
    [MobClick event:Event_click_record_changecamera];
    [self.videoCamera rotateCamera];
}

- (void)delayBtnClick {
    _delayLabel.hidden = NO;
    _delayLabel.transform = CGAffineTransformIdentity;
    if (self.delayBtn.selected) {
        self.delayBtn.selected = NO;
        self.recordView.isDelay = NO;
        self.delayLabel.text = @"延时：关";
    }
    else {
        self.delayBtn.selected = YES;
        self.recordView.isDelay = YES;
        self.delayLabel.text = @"延时：5S";
    }
    if (_animating) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(labelAnimation) object:nil];
    }
    _animating = YES;
    [self performSelector:@selector(labelAnimation) withObject:nil afterDelay:1];
}

- (void)labelAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.delayLabel.transform = CGAffineTransformMakeScale(0.3, 0.3);
    } completion:^(BOOL finished) {
        self.delayLabel.hidden = YES;
    }];
}

- (void)deleteBtnClick {
    if (self.bottomView.deleteSelected) {
        [self.progressView willRemoveLastVideo];
    }
    else {
        NSURL *url = [self.videoUrlArray lastObject];
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        [self.videoUrlArray removeObjectAtIndex:0];
        self.bottomView.videoCount = self.videoUrlArray.count;
        [self.progressView removeLastVideo];
        if (self.videoUrlArray.count == 0) {
            [self.bottomView hideOperateView];
            [self.bottomView showSelectPhotoView];
        }
    }
}

- (void)doneBtnClick {
    [MobClick event:Event_click_record_submit];
    if (self.recordView.haveStartRecord) {
        _shouldFinishVideo = YES;
        [self.recordView finishRecord:YES];
    }
    else {
        [ZZHUD showWithStatus:@"视频处理中..."];
        self.view.userInteractionEnabled = NO;
        __weak typeof(self)weakSelf = self;
        
        if (self.isIntroduceVideo) {
            if (!self.isCompleted) {
                [ZZHUD showErrorWithStatus:@"录制时间不能小于6秒"];
                self.view.userInteractionEnabled = YES;
                return;
            }
        }
        else {
            if (!self.isCompleted) {
                [ZZHUD showErrorWithStatus:@"录制时间不能小于6秒"];
                self.view.userInteractionEnabled = YES;
                return;
            }
        }
        
        [self.movieWriter finishRecordingWithCompletionHandler:^{
            weakSelf.videoCamera.audioEncodingTarget = nil;
            [weakSelf addWatermarkToVideo];
        }];
    }
}

#pragma mark - private
- (void)hideViews {
    [self.bottomView hideAllViews];
    self.recordView.hidden = YES;
}

- (void)showViews {
    [self.bottomView showAllViews];
    self.recordView.hidden = NO;
}

- (void)startRecord {
    self.movieWriter.encodingLiveVideo = YES;
    [_blendFilter addTarget:self.movieWriter];
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_0;
    [self.movieWriter startRecording];
    [self.recordView startTimer];
}

- (void)gotoEditView {
    ZZRecordEditViewController *controller = [[ZZRecordEditViewController alloc] init];
    controller.exportURL = self.exportURL;
    controller.type = _type;
    controller.model = _model;

    controller.selectedModel = self.topicTitleView.selectedModel;
    if (_type == RecordTypeSK) {
         controller.selectedModel = self.topicTitleView.selectedModel;
    }
    WS(weakSelf);
    controller.leftCallBack = ^{
        [[NSFileManager defaultManager] removeItemAtURL:weakSelf.exportURL error:nil];

    };

    controller.labelArray = self.labelArray;
    controller.is_base_sk = _is_base_sk;
    controller.isRecordVideo = YES;
    controller.pixelWidth = SCREEN_WIDTH;
    controller.pixelHeight = SCREEN_HEIGHT;
    controller.isIntroduceVideo = self.isIntroduceVideo;
    controller.isShowTopUploadStatus = self.isShowTopUploadStatus;
    controller.isUploadAfterCompleted = self.isUploadAfterCompleted;
    controller.isFastChat = self.isFastChat;
    
    [self.navigationController pushViewController:controller animated:YES];
    controller.callBack = ^{
        if (_callBack) {
            _callBack();
        }
        if (_viewDismiss) {
            _viewDismiss();
        }
        [self clearTempVideo];
        [self releaseObject];
    };
    controller.touchLeft = ^{
        [self clearTempVideo];
    };
}

- (void)showDynamicImage:(NSString *)topidId {
    _isFirstQuestion = YES;
    [self.imgArray removeAllObjects];
    _canChangeQuestion = NO;
    NSString *baseFile = [[ZZFileHelper createPathWithChildPath:question_savepath] stringByAppendingPathComponent:@"questions"];
    NSString *configFile = [baseFile stringByAppendingPathComponent:@"config.json"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:configFile isDirectory:NULL]) {
        NSData *data = [NSData dataWithContentsOfFile:configFile];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *aDict = [dict objectForKey:@"files"];
        if ([[aDict allKeys] containsObject:topidId]) {
            self.topicDict = [aDict objectForKey:topidId];
            NSDictionary *questionDict = [self.topicDict objectForKey:@"questions"];
            self.questionArray = [questionDict allKeys];
            _currentQuestionIndex = 0;
            _canChangeQuestion = YES;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self bottomItemsDown];
    if (_canChangeQuestion) {
        if (self.questionArray.count - 1 > _currentQuestionIndex) {
            _currentQuestionIndex++;
        } else {
            _currentQuestionIndex = 0;
        }
        [self.imgArray removeAllObjects];
        _canChangeQuestion = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _canChangeQuestion = YES;
        });
        if (_questionGuideView) {
            [_questionGuideView removeFromSuperview];
        }
    }
}

- (void)bottomItemsDown {
    if (self.chooseView.isViewUp) {
        [self.chooseView viewDown];
    }
}

- (void)backConfigInfomation {
    if (!_haveLoadConfigView) {
        return;
    }
    ZZRecordConfigModel *model = [[ZZRecordConfigModel alloc] init];
    [ZZUserHelper shareInstance].recordConfigModel = model;
}

#pragma mark - WBSelectPhotoManagerObserver
- (void)videoStarClip {
    self.view.userInteractionEnabled = NO;
}

- (void)videoClipCompleteWithUrl:(NSURL *)url pixelWidth:(NSString *)pixelWidth pixelHeight:(NSString *)pixelHeight {
    if (url != nil) {
        WEAK_SELF();
        
        [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
            weakSelf.view.userInteractionEnabled = YES;
            ZZRecordEditViewController *controller = [[ZZRecordEditViewController alloc] init];
            controller.exportURL = url;
            WS(weakSelf);
            controller.leftCallBack = ^{
                [[NSFileManager defaultManager] removeItemAtURL:weakSelf.exportURL error:nil];
            };
            controller.type = _type;
            controller.model = _model;
            controller.showType = self.showType;
            controller.selectedModel = self.topicTitleView.selectedModel;
            controller.labelArray = self.labelArray;
            controller.is_base_sk = _is_base_sk;
            controller.isRecordVideo = NO;
            controller.isIntroduceVideo = self.isIntroduceVideo;
            controller.pixelWidth = [pixelWidth integerValue];
            controller.pixelHeight = [pixelHeight integerValue];
            controller.isFastChat = self.isFastChat;
            
            [weakSelf.navigationController pushViewController:controller animated:YES];
            controller.callBack = ^{
                if (weakSelf.callBack) {
                    weakSelf.callBack();
                }
                if (weakSelf.viewDismiss) {
                    weakSelf.viewDismiss();
                }
                [weakSelf clearTempVideo];
                [weakSelf releaseObject];
            };
            controller.touchLeft = ^{
                [weakSelf clearTempVideo];
            };
        }];
    }
}

#pragma mark - Navigator
- (void)showPhotoAlbum {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES isFromChat:NO];
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按

    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频

    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.navigationController.navigationBar.translucent = NO;
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        [self selectVideo:asset];
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)selectVideo:(PHAsset *)asset {
    long long size = 0;
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    size = [[resource valueForKey:@"fileSize"] longLongValue];
   if ([asset movieURL] ==nil) {
       [ZZHUD showErrorWithStatus:@"该视频无法编辑"];
       return;
   }
   if ((size / 1024.0 / 1024.0) > 300 || asset.duration > 600) {
       [ZZHUD showErrorWithStatus:@"视频过长或体积过大"];
       return;
   }

   // 当前选择的直接转码再跳转
   [self movieTransCodeAction:asset];
}

- (void)movieTransCodeAction:(PHAsset *)asset {
    [self loadActivityIndicatorView];
    
    self.startTime = 0.f;
    self.endTime = asset.duration;
    CMTimeRange timeRange = CMTimeRangeFromTimeToTime(CMTimeMake(self.startTime, 1), CMTimeMake(self.endTime, 1));
    
    self.shortVideoTranscoder = [[PLShortVideoTranscoder alloc] initWithURL:[asset movieURL]];
    self.shortVideoTranscoder.outputFileType = PLSFileTypeMPEG4;
//        self.shortVideoTranscoder.outputFilePreset = self.transcoderPreset;
    self.shortVideoTranscoder.outputFilePreset = PLSFilePreset960x540;//都转成540P
    self.shortVideoTranscoder.timeRange = timeRange;
    
    WEAK_SELF();
    [self.shortVideoTranscoder setCompletionBlock:^(NSURL *url){
        NSLog(@"transCoding successd, url: %@", url);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeActivityIndicatorView];
            weakSelf.progressLabel.text = @"";

            __strong typeof(weakSelf)strongSelf = weakSelf;
            
            NSFileManager *manager = [NSFileManager defaultManager];
                NSError *error = nil;
                NSLog(@"PY_进入到这一步2");
                NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
                NSString *pathToExport = [NSString stringWithFormat:@"%@/%ld.mp4",[ZZFileHelper createPathWithChildPath:video_savepath],timeInterval];
                strongSelf.exportURL = [NSURL fileURLWithPath:pathToExport];

                if ([manager copyItemAtURL:url toURL:strongSelf.exportURL error:&error]) {
                    NSLog(@"PY_进入到这一步3");
                    
                    [manager removeItemAtURL:url error:nil];

                    ZZRecordEditViewController *controller = [[ZZRecordEditViewController alloc] init];
                    controller.exportURL = strongSelf.exportURL;
                    controller.type = strongSelf.type;
                    controller.isFastChat = strongSelf.isFastChat;
                    controller.leftCallBack = ^{
                        [[NSFileManager defaultManager] removeItemAtURL:strongSelf.exportURL error:nil];
                    };

                    controller.is_base_sk = strongSelf.is_base_sk;
                    controller.isRecordVideo = NO;
                    controller.pixelWidth = SCREEN_WIDTH;
                    controller.pixelHeight = SCREEN_HEIGHT;
                    controller.isIntroduceVideo = strongSelf.is_base_sk;
                    controller.showType = strongSelf.showType;
                    controller.isShowTopUploadStatus = strongSelf.isShowTopUploadStatus;
                    controller.isUploadAfterCompleted = strongSelf.isUploadAfterCompleted;
                    controller.isIntroduceVideo = strongSelf.isIntroduceVideo;
                    controller.selectAlbumsDirectly = YES;//直接选的相册
                    
                    if (_type == RecordTypeMemeda || _type == RecordTypeUpdateMemeda) {
                        controller.model = strongSelf.model;
                    }
                    
                    if ([weakSelf.presentingViewController isKindOfClass:[ZZNavigationController class]]) {
                        ZZNavigationController *parentVC = (ZZNavigationController*)weakSelf.presentingViewController;
                        [strongSelf dismissViewControllerAnimated:NO completion:^{
                            [parentVC pushViewController:controller animated:YES];
                        }];
                    }
                    else {
                        ZZTabBarViewController *tabs =(ZZTabBarViewController*)weakSelf.presentingViewController;
                        [strongSelf dismissViewControllerAnimated:NO completion:^{
                            ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:controller];
                            [tabs presentViewController:nav animated:YES completion:nil];
                        }];
                    }
                }
                else {
                    [weakSelf removeActivityIndicatorView];
                    [ZZHUD showErrorWithStatus:@"视频处理失败"];
                }
        });
    }];
    
    [self.shortVideoTranscoder setFailureBlock:^(NSError *error){
        NSLog(@"transCoding failed: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf removeActivityIndicatorView];
            weakSelf.progressLabel.text = @"";

            [ZZHUD showErrorWithStatus:@"转码失败"];
        });
    }];
    [self.shortVideoTranscoder setProcessingBlock:^(float progress){
        // 更新压缩进度的 UI
        NSLog(@"transCoding progress: %f", progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",[NSString stringWithFormat:@"转码进度%d%%", (int)(progress * 100)]);
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"转码进度%d%%", (int)(progress * 100)];
        });
    }];
    
    [self.shortVideoTranscoder startTranscoding];
}


// 加载拼接视频的动画
- (void)loadActivityIndicatorView {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
    }
    
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView addSubview:self.progressLabel];
    [self.activityIndicatorView startAnimating];
}

// 移除拼接视频的动画
- (void)removeActivityIndicatorView {
    [self.progressLabel removeFromSuperview];
    [self.activityIndicatorView removeFromSuperview];
    [self.activityIndicatorView stopAnimating];
}


#pragma mark - Lazyload
- (NSURL *)movieURL {
    NSString *fileName = [[NSUUID UUID] UUIDString];
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
    NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld.mp4",fileName,timeInterval]];
    _movieURL = [NSURL fileURLWithPath:pathToMovie];
    return _movieURL;
}

- (NSURL *)exportURL {
    if (!_exportURL) {
        NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
        NSString *pathToExport = [NSString stringWithFormat:@"%@/%ld.mp4",[ZZFileHelper createPathWithChildPath:video_savepath],timeInterval];
        _exportURL = [NSURL fileURLWithPath:pathToExport];
    }
    return _exportURL;
}

- (NSMutableArray *)videoUrlArray {
    if (!_videoUrlArray) {
        _videoUrlArray = [NSMutableArray array];
    }
    return _videoUrlArray;
}

- (NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, isIPhoneX ? 44 : 20, 60, 44)];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *leftImgView = [[UIImageView alloc] init];
        leftImgView.image = [UIImage imageNamed:@"icon_record_cancel"];
        leftImgView.userInteractionEnabled = NO;
        [_leftBtn addSubview:leftImgView];
        
        [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_leftBtn.mas_left).offset(15);
            make.centerY.mas_equalTo(_leftBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    }
    return _leftBtn;
}

- (ZZCenterButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[ZZCenterButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, isIPhoneX ? 44 : 20, 60, 60)];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setImage:[UIImage imageNamed:@"icon_record_camera"] forState:UIControlStateNormal];
        [_rightBtn setTitle:@"翻转" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setTitle:@"翻转" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:kYellowColor forState:UIControlStateSelected];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        if (font) {
            _rightBtn.titleLabel.font = font;
        }else{
            _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        [_rightBtn layoutButtonWithImageAndTitleSpace:4];
    }
    return _rightBtn;
}

- (ZZCenterButton *)delayBtn {
    if (!_delayBtn) {
        _delayBtn = [[ZZCenterButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 125, isIPhoneX ? 44 : 20, 60, 60)];
        [_delayBtn addTarget:self action:@selector(delayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_delayBtn setImage:[UIImage imageNamed:@"icon_record_delay_n"] forState:UIControlStateNormal];
        [_delayBtn setImage:[UIImage imageNamed:@"icon_record_delay_p"] forState:UIControlStateSelected];
    
        [_delayBtn setTitle:@"延时" forState:UIControlStateNormal];
        [_delayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_delayBtn setTitle:@"延时" forState:UIControlStateSelected];
        [_delayBtn setTitleColor:kYellowColor forState:UIControlStateSelected];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        if (font) {
            _delayBtn.titleLabel.font = font;
        }else{
            _delayBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        [_delayBtn layoutButtonWithImageAndTitleSpace:4];
        
        _delayLabel = [[UILabel alloc] init];
        _delayLabel.textColor = [UIColor whiteColor];
        _delayLabel.font = [UIFont systemFontOfSize:28];
        _delayLabel.hidden = YES;
        [self.view addSubview:_delayLabel];
        
        [_delayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(self.view.mas_top).offset(70);
        }];
    }
    return _delayBtn;
}

- (ZZRecordBtnView *)recordView {
    if (!_recordView) {
        _recordView = [[ZZRecordBtnView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, SCREEN_HEIGHT - 120 - 20 - (isIPhoneX ? 34 : 0), 100, 120)];
        _recordView.delegate = self;
    }
    return _recordView;
}

- (GPUImageMovieWriter *)movieWriter {
    if (!_movieWriter) {
        NSDictionary * videoSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
                                          AVVideoWidthKey : @(540),
                                          AVVideoHeightKey : @(960),
                                          AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill};
        _movieWriter = [[GPUImageMovieWriter alloc]
                        initWithMovieURL:self.movieURL
                        size:CGSizeMake(540.0, 960.0)
                        fileType:AVFileTypeQuickTimeMovie
                        outputSettings:videoSettings];
    }
    return _movieWriter;
}

- (ZZRecordChooseView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[ZZRecordChooseView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 206+SafeAreaBottomHeight)];
        _chooseView.delegate = self;
    }
    return _chooseView;
}

- (ZZRecordTopicTitleView *)topicTitleView {
    WeakSelf;
    if (!_topicTitleView) {
        _topicTitleView = [[ZZRecordTopicTitleView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150 )/2.0, STATUSBAR_HEIGHT + (isIPhoneX ? 3 : 0), AdaptedWidth(130), 37)];
        _topicTitleView.clipsToBounds = YES;
        _topicTitleView.layer.cornerRadius = 37/2.0f;
        _topicTitleView.tapSelf = ^{
            [weakSelf bottomItemsDown];
            [ZZUserHelper shareInstance].lastSKTopicVersion = [ZZUserHelper shareInstance].lastSKTopicVersion;
        };
        if (_is_base_sk) {
            _topicTitleView.userInteractionEnabled = NO;
        }
    }
    return _topicTitleView;
}

- (GPUImageRotationMode)trackRotation {
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
        }
        else {
            switch(self.videoCamera.outputImageOrientation) {
                case UIInterfaceOrientationPortrait:trackRotation = kGPUImageRotateRight; break;
                case UIInterfaceOrientationPortraitUpsideDown:trackRotation = kGPUImageRotateLeft; break;
                case UIInterfaceOrientationLandscapeLeft:trackRotation = kGPUImageRotate180; break;
                case UIInterfaceOrientationLandscapeRight:trackRotation = kGPUImageNoRotation; break;
                default:trackRotation = kGPUImageNoRotation;
            }
        }
    }
    else {
        if (self.videoCamera.horizontallyMirrorFrontFacingCamera) {
            switch(self.videoCamera.outputImageOrientation) {
                case UIInterfaceOrientationPortrait:trackRotation = kGPUImageRotateRightFlipVertical; break;
                case UIInterfaceOrientationPortraitUpsideDown:trackRotation = kGPUImageRotateRightFlipHorizontal; break;
                case UIInterfaceOrientationLandscapeLeft:trackRotation = kGPUImageFlipHorizonal; break;
                case UIInterfaceOrientationLandscapeRight:trackRotation = kGPUImageFlipVertical; break;
                default:trackRotation = kGPUImageNoRotation;
            }
        }
        else {
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

- (ZZRecordProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[ZZRecordProgressView alloc] initWithFrame:CGRectMake(0, isIPhoneX ? 36 : 0, SCREEN_WIDTH, 4)];
        _progressView.delegate = self;
        [_progressView isHiddenProgress:YES];

    }
    return _progressView;
}

// TODO:6秒提示
- (UILabel *)isMinpromptLab {
    if (!_isMinpromptLab) {
        _isMinpromptLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2-10, CGRectGetMaxY(self.progressView.frame), 20, 20)];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
        if (!font) {
            font = [UIFont systemFontOfSize:13];
        }
        _isMinpromptLab.hidden = YES;
        _isMinpromptLab.font = font;
        _isMinpromptLab.text = @"6s";
        _isMinpromptLab.textColor = [UIColor whiteColor];
        _isMinpromptLab.textAlignment = NSTextAlignmentCenter;
    }
    return _isMinpromptLab;
}

- (ZZRecordBottomView *)bottomView {
    WeakSelf;
    if (!_bottomView) {
        _bottomView = [[ZZRecordBottomView alloc] init];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 150-SafeAreaBottomHeight, SCREEN_WIDTH, 150+SafeAreaBottomHeight);
        _bottomView.isHidePhoto = _isHidePhoto;
        
        _bottomView.touchDelete = ^{
            [weakSelf deleteBtnClick];
        };
        
        _bottomView.touchDone = ^{
            [weakSelf doneBtnClick];
        };
        
        [_bottomView setSelectPhotoBlock:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showPhotoAlbum];
        }];
        [_bottomView hideOperateView];
        [self.view addSubview:_bottomView];
        [self.view bringSubviewToFront:_recordView];
    }
    return _bottomView;
}

- (ZZRecordQuestionGuideView *)questionGuideView {
    if (!_questionGuideView) {
        _questionGuideView = [[ZZRecordQuestionGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _questionGuideView;
}

- (void)setIsShowTopUploadStatus:(BOOL)isShowTopUploadStatus {
    _isShowTopUploadStatus = isShowTopUploadStatus;
}

@end
