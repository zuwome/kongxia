//
//  ZZChatVideoPlayerController.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatVideoPlayerController.h"

@interface ZZChatVideoPlayerController ()

@property (nonatomic, strong) UIView *processLineView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIImageView *picturePreview;

@property (nonatomic, strong) UIImageView *bgPreview;

@property (nonatomic, assign) BOOL isPaused;

@end

@implementation ZZChatVideoPlayerController

- (instancetype)init {
    self = [super init];
    if (self) {
        _entrance = EntranceChat;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotifications];
    [self releaseAvplayer];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isNullString(_videoUrl)) {
        [ZZHUD showErrorWithStatus:@"视频加载失败"];
        return;
    }
    [self playVideo:[NSURL URLWithString:_videoUrl]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - public Method
- (void)playVideo:(NSURL *)file {
    _playerItem = [AVPlayerItem playerItemWithURL:file];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_picturePreview.layer addSublayer:_playerLayer];
    self.player.automaticallyWaitsToMinimizeStalling = NO;
    [_player play];
    [self addNotifications];
    
    [ZZHUD show];
    
    __weak typeof(self) weakSelf = self;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        /// 更新播放进度
        //当前播放的时间
        NSTimeInterval current = CMTimeGetSeconds(time);
        //视频的总时间
        NSTimeInterval total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        
        CGFloat width = SCREEN_WIDTH * (current / total);
        if (isnan(width)) {
            width = 0;
        }
        if (width == 0) {
            weakSelf.processLineView.width = 0.1;
        }
        else {
            weakSelf.processLineView.width = width;
        }
    }];

}

#pragma mark - private method
- (void)releaseAvplayer {
    [self.player pause];
    [_playerItem cancelPendingSeeks];
    [_playerItem.asset cancelLoading];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player = nil;
}

#pragma mark - response method
- (void)close {
    if (_entrance == EntranceChat) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showAction {
    if (_playBtn.alpha == 0.0) {
        [UIView animateWithDuration:0.3 animations:^{
            _playBtn.alpha = 1.0;
            _bgPreview.alpha = 0.5;
            _backBtn.alpha = 1.0;
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            _playBtn.alpha = 0.0;
            _bgPreview.alpha = 0.0;
            _backBtn.alpha = 0.0;
        }];
    }
}

- (void)playAction {
    if (_isPaused) {
        [_player play];
    }
    else {
        [_player pause];
    }
    _isPaused = !_isPaused;
    _playBtn.selected = !_playBtn.selected;
}

#pragma mark - Notification Method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterPlayGround)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        AVPlayerItemStatus status = playerItem.status;
        switch (status) {
            case AVPlayerItemStatusUnknown: {
                break;
            }
            case AVPlayerItemStatusReadyToPlay: {
                [self.player play];
                _playBtn.selected = NO;
                break;
            }
            case AVPlayerItemStatusFailed: {
                break;
            }
            default:
                break;
        }
        [ZZHUD dismiss];
    }
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_playerItem removeObserver:self forKeyPath:@"status"];
}

- (void)playbackFinished:(NSNotification *)notification {
    if (_entrance == EntranceChat) {
        [self.player pause];
        [self.player seekToTime:CMTimeMake(0, 1)];
        _isPaused = !_isPaused;
        _playBtn.selected = YES;
        [self showAction];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)appDidEnterBackground {
    [self.player pause];
    _isPaused = !_isPaused;
}

- (void)appDidEnterPlayGround {
//    [self.player play];
}

#pragma mark - Layout
- (void)layout {
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.picturePreview];
    [self.view addSubview:self.processLineView];
    [self.view addSubview:self.bgPreview];
    [self.view addSubview:self.playBtn];
    [self.view addSubview:self.backBtn];
    
    [_picturePreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_bgPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(STATUSBAR_HEIGHT + 10);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(70, 44));
    }];
    
    _processLineView.frame = CGRectMake(0.0, SCREEN_HEIGHT - SafeAreaBottomHeight - 2, 0.0, 2);
}

#pragma mark - getters and setters
- (UIImageView *)picturePreview {
    if (!_picturePreview) {
        _picturePreview = [[UIImageView alloc] init];
        _picturePreview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAction)];
        [_picturePreview addGestureRecognizer:tap];
    }
    return _picturePreview;
}

- (UIImageView *)bgPreview {
    if (!_bgPreview) {
        _bgPreview = [[UIImageView alloc] init];
        _bgPreview.alpha = 0.0;
        _bgPreview.backgroundColor = UIColor.blackColor;
    }
    return _bgPreview;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        _playBtn.normalImage = [UIImage imageNamed:@"ic_zanting"];
        _playBtn.selectedImage = [UIImage imageNamed:@"icVedioPlay"];
        [_playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.alpha = 0.0;
        _playBtn.selected = YES;
    }
    return _playBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.normalImage = [UIImage imageNamed:@"icon_rent_left"];
        [_backBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.alpha = 0.0;
    }
    return _backBtn;
}

- (UIView *)processLineView {
    if (!_processLineView) {
        _processLineView = [[UIView alloc] init];
        _processLineView.backgroundColor = kYellowColor;
    }
    return _processLineView;
}

@end
