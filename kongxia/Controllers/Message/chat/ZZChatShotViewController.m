//
//  ZZChatShotViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/6.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatShotViewController.h"
#import "ZZSightHelper.h"

@interface ZZChatShotViewController () <UIGestureRecognizerDelegate, ZZSightHelperDelegate>

@property (nonatomic, strong) ZZSightHelper *helper;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIView *shotView;

@property (nonatomic, strong) ZZChatShotCircleBgView *shotBgView;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *switchCameraBtn;

@property (nonatomic, strong) UIImageView *picturePreview;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) UIButton *goBackBtn;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

/**
*  预览图层
*/
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@end

@implementation ZZChatShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _action = ActionTakePicture;
    self.view.backgroundColor = UIColor.blackColor;
    [self initHelper];
    [self addNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotifications];
    [self releaseAvplayer];
    [_helper releaseCaptureSession];
}

#pragma mark - private method
- (void)initHelper {
    _helper = [[ZZSightHelper alloc] init];
    _helper.delegate = self;
    [_helper startCaptureWithCompleteBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createPreviewlayer];
            [self layout];
        });
    }];
}

- (void)reSetToTakeView {
    _picturePreview.hidden = YES;
    _goBackBtn.hidden = YES;
    _sendBtn.hidden = YES;
    
    _switchCameraBtn.hidden = NO;
    _tipsLabel.hidden = NO;
    _shotView.hidden = NO;
    _shotBgView.hidden = NO;
    _closeBtn.hidden = NO;
    
    _picturePreview.image = nil;
    
    _tipsLabel.text = @"轻触拍照 按住摄像";
}

- (void)showTookPicture:(UIImage *)image {
    _picturePreview.hidden = NO;
    _goBackBtn.hidden = NO;
    _sendBtn.hidden = NO;
    
    _switchCameraBtn.hidden = YES;
    _tipsLabel.hidden = YES;
    _shotView.hidden = YES;
    _shotBgView.hidden = YES;
    _closeBtn.hidden = YES;
    
    _picturePreview.image = image;
}

- (void)showFinshVideo {
    dispatch_async(dispatch_get_main_queue(), ^{
        _picturePreview.hidden = NO;
        _goBackBtn.hidden = NO;
        _sendBtn.hidden = NO;
        
        _switchCameraBtn.hidden = YES;
        _tipsLabel.hidden = YES;
        _shotView.hidden = YES;
        _shotBgView.hidden = YES;
        _closeBtn.hidden = YES;
    });
}

- (void)releaseAvplayer {
    [self.player pause];
    [_playerItem cancelPendingSeeks];
    [_playerItem.asset cancelLoading];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player = nil;
    self.playerItem = nil;
}

- (void)playVideo:(NSURL *)file {
    
    _playerItem = [AVPlayerItem playerItemWithURL:file];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_picturePreview.layer addSublayer:_playerLayer];
    
    self.player.automaticallyWaitsToMinimizeStalling = NO;
    [_player play];
    
    [self addPlayerNotifications];
}

#pragma mark - response method
- (void)swtichCamera {
    [_helper switchCamera];
}

- (void)close {
    [_helper stopCapture];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (_action == ActionTakePicture) {
        [_helper savePhotoTooAssetsLibrary];
        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didTakePicture:)]) {
            [self.delegate controller:self didTakePicture:_helper.tookImage];
        }
    }
    else {
        if (_helper.moviePath) {
            [_helper saveVideoToAssetsLibrary];
            if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didTakeVideo:thumbnail:)]) {
                [self.delegate controller:self didTakeVideo:[NSURL fileURLWithPath:_helper.moviePath] thumbnail:[ZZUtils getThumbImageWithVideoUrl:[NSURL fileURLWithPath:_helper.moviePath]]];
            }
        }
    }
}

- (void)back {
    if (_playerItem) {
        [self removePlayerNotifications];
    }
    
    [self releaseAvplayer];
    [self reSetToTakeView];
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer {
    WeakSelf
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [_helper takePictureWithCompleteHandler:^(UIImage *image) {
            if (image) {
                weakSelf.action = ActionTakePicture;
                [weakSelf showTookPicture:image];
            }
        }];
    }
}

- (void)longpress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.action = ActionTakeVideo;
        [self expandTheRecordBtn];
        [_helper startRecording];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self showFinshVideo];
        [self shrinkTheRecordBtn];
        [_helper stopRecording];
    }
}

#pragma mark - ZZSightHelperDelegate
- (void)helper:(ZZSightHelper *)helper finishRecording:(NSURL *)recordedFile {
//    if (recordedFile) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playVideo:recordedFile];
        });
//    }
}

- (void)helper:(ZZSightHelper *)helper recording:(CGFloat)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        _tipsLabel.text = [NSString stringWithFormat:@"%ld秒", (NSInteger)duration];
        _shotBgView.progress = ((CGFloat)duration / _helper.maximunDuration);
    });
}

#pragma mark - Notification Method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)addPlayerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterPlayGround)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        AVPlayerItemStatus status = playerItem.status;
        switch (status) {
            case AVPlayerItemStatusUnknown: {
                break;
            }
            case AVPlayerItemStatusReadyToPlay: {
                [self.player play];
                [self.player seekToTime:CMTimeMake(0, 1)];
                [self.player play];
                break;
            }
            case AVPlayerItemStatusFailed: {
                break;
            }
            default:
                break;
        }
    }
}

- (void)removePlayerNotifications {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)playbackFinished:(NSNotification *)notification {
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

- (void)appDidEnterBackground {
    if (_player) {
        [self.player pause];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)appDidEnterPlayGround {
    [self.player pause];
}

#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.picturePreview];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.shotBgView];
    [self.view addSubview:self.shotView];
    [self.view addSubview:self.switchCameraBtn];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.sendBtn];
    [self.view addSubview:self.goBackBtn];
    
    [_picturePreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_shotBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-48.5);
        }
        else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-48.5);
        }
        make.size.mas_equalTo(CGSizeMake(73, 73));
    }];
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.alpha = 0.47;
    [_shotBgView addSubview:whiteView];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_shotBgView);
    }];
    
    [_shotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_shotBgView);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_shotBgView);
        make.bottom.equalTo(_shotBgView.mas_top).offset(-30.0);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shotBgView);
        make.right.equalTo(_shotBgView.mas_left).offset(-45);
        make.size.mas_equalTo(CGSizeMake(50.0, 30.0));
    }];
    
    [_switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-30.0);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(30.0);
        }
        else {
            make.right.equalTo(self.view).offset(-30.0);
            make.top.equalTo(self.view).offset(30.0);
        }
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20.0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20.0);
        } else {
            make.right.bottom.equalTo(self.view).offset(-20.0);
        }
        make.size.mas_equalTo(CGSizeMake(57, 32));
    }];
    
    [_goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20.0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20.0);
        } else {
            make.bottom.equalTo(self.view).offset(-20.0);
        }
        make.size.mas_equalTo(CGSizeMake(57, 32));
    }];
}

- (void)createPreviewlayer {
    [self.view.layer addSublayer:self.previewLayer];
}

#pragma mark - Animations
- (void)expandTheRecordBtn {
    _shotBgView.layer.cornerRadius = 45.0;
    _shotView.layer.cornerRadius = 20.0;
    
    [_shotBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [_shotView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (void)shrinkTheRecordBtn {
    [_shotBgView clearLayer];
    
    _shotBgView.layer.cornerRadius = 73 * 0.5;
    _shotView.layer.cornerRadius = 28;
    
    [_shotBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(73, 73));
    }];
    
    [_shotView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
}

#pragma mark - getters and setters
- (UIImageView *)picturePreview {
    if (!_picturePreview) {
        _picturePreview = [[UIImageView alloc] init];
        _picturePreview.hidden = YES;
    }
    return _picturePreview;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"轻触拍照 按住摄像";
        _tipsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        _tipsLabel.textColor = UIColor.whiteColor;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UIView *)shotView {
    if (!_shotView) {
        _shotView = [[UIView alloc] init];
        _shotView.backgroundColor = UIColor.whiteColor;
        _shotView.layer.cornerRadius = 56 * 0.5;
        _shotView.userInteractionEnabled = NO;
    }
    return _shotView;
}

- (ZZChatShotCircleBgView *)shotBgView {
    if (!_shotBgView) {
        _shotBgView = [[ZZChatShotCircleBgView alloc] init];
        _shotBgView.backgroundColor = UIColor.clearColor;
        
        _shotBgView.layer.cornerRadius = 73 * 0.5;
        _shotBgView.userInteractionEnabled = YES;
        _shotBgView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_shotBgView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpress:)];
        [_shotBgView addGestureRecognizer:longpress];
    }
    return _shotBgView;
}

- (UIButton *)switchCameraBtn {
    if (!_switchCameraBtn) {
        _switchCameraBtn = [[UIButton alloc] init];
        _switchCameraBtn.normalImage = [UIImage imageNamed:@"icZhsxt"];
        [_switchCameraBtn addTarget:self action:@selector(swtichCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        _closeBtn.normalTitle = @"关闭";
        _closeBtn.normalTitleColor = UIColor.whiteColor;
        _closeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15.0];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
   
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        _sendBtn.normalTitle = @"发送";
        _sendBtn.normalTitleColor = RGBCOLOR(63, 58, 58);
        _sendBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        _sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15.0];
        [_sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.layer.cornerRadius = 5;
        _sendBtn.hidden = YES;
    }
    return _sendBtn;
}

- (UIButton *)goBackBtn {
    if (!_goBackBtn) {
        _goBackBtn = [[UIButton alloc] init];
        _goBackBtn.normalTitle = @"返回";
        _goBackBtn.normalTitleColor = UIColor.whiteColor;
        _goBackBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15.0];
        [_goBackBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _goBackBtn.hidden = YES;
    }
    return _goBackBtn;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer              = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.helper.captureSession];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame        = self.view.bounds;
    }
    return _previewLayer;
}

@end


#pragma mark - ZZChatShotCircleBgView

@interface ZZChatShotCircleBgView()

@property (nonatomic , strong)CAShapeLayer *progressLayer;

@end

@implementation ZZChatShotCircleBgView

- (void)drawRect:(CGRect)rect {
    
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat radius = (self.frame.size.width - 10) / 2 + 2;
    CGFloat start  = - M_PI_2; //设置起点
    CGFloat end    = - M_PI_2 + M_PI * 2 * self.progress;//设置终点
    
    //画一个圆，填充色透明，设置边框带颜色，就是一个圆环
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor; //填充颜色
    self.progressLayer.strokeColor = HEXCOLOR(0x65B962).CGColor;//[UIColor greenColor].CGColor; //path填充的颜色，即圆环的颜色
    self.progressLayer.lineCap = kCALineCapRound;//线边缘是圆形
    self.progressLayer.lineWidth = 5;
    
    //用贝塞尔曲线画圆
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    self.progressLayer.path = [bezierPath CGPath];
    [self.layer addSublayer:self.progressLayer];
}

- (void)clearLayer {
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
}

#pragma mark - getters and setters
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.progressLayer.opacity = 0;
    [self setNeedsDisplay];
}

@end
