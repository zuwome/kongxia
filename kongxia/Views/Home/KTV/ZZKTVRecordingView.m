//
//  ZZKTVRecordingView.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/10.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVRecordingView.h"

#import <FLAnimatedImage.h>
#import <FLAnimatedImageView.h>

#import "ZZACRRecognitionHelper.h"
#import "ZZKTVConfig.h"
#import "AudioManager.h"
#import "ACRCloudRecognition.h"
#import "ACRCloudConfig.h"

@interface ZZKTVRecordingView () <AudioManagerDelegate>

@property (nonatomic, strong) ZZKTVModel *taskModel;

@property (nonatomic, assign) NSInteger selectedSongIndex;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *lyricsLabel;

@property (nonatomic, strong) UIView *progressView;

@property (nonatomic, strong) UIView *progressLine;

@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, strong) UIImageView *recordingImageView;

@property (nonatomic, strong) UILabel *recordingTitleLabel;

@property (nonatomic, strong) FLAnimatedImageView *recordingIconImageView;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UILabel *supportLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) ZZACRRecognitionHelper *helper;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ZZKTVRecordingView

- (instancetype)initWithTaskModel:(ZZKTVModel *)model selectedSong:(NSInteger)index {
    self = [super init];
    if (self) {
        _taskModel = model;
        _selectedSongIndex = index;
        [self layout];
        [self configureData];
    }
    return self;
}

- (void)configureData {
    _lyricsLabel.text = _taskModel.song_list[_selectedSongIndex].content;
}

- (void)hide {
    [self removeFromSuperview];
}


#pragma mark - public Method
- (void)didRecognizedSuccess:(BOOL)isSuccess filePath:(NSString *)filePath duration:(NSTimeInterval)duration {
    if (!isSuccess) {
        _statusLabel.hidden = NO;
        _progressView.hidden = YES;
        
        _recordingImageView.hidden = YES;
        _actionBtn.hidden = NO;
    }
    else {
        _statusLabel.hidden = YES;
        _progressView.hidden = NO;
        _recordingImageView.hidden = NO;
        _actionBtn.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(view:recogniteComplete:fileDuration:)]) {
            [self.delegate view:self recogniteComplete:filePath fileDuration:duration];
        }
    }
}


#pragma mark - response method
- (void)cancelAction {
    [[AudioManager audioManager] stopRecording];
    [AudioManager audioManager].delegate = self;
    [self hide];
}

- (void)singingAction {
    if ([AudioManager audioManager].recordState != RecordStateRecording) {
        [self resetRecordingProgress];
        [[AudioManager audioManager] startRecording];
        [AudioManager audioManager].delegate = self;
        
        _statusLabel.hidden = YES;
        _progressView.hidden = NO;
        
        _recordingImageView.hidden = NO;
        _actionBtn.hidden = YES;
    }
    else {
        [[AudioManager audioManager] stopRecording];
        
        _recordingImageView.hidden = YES;
        _actionBtn.hidden = NO;
    }
}


#pragma mark - AudioManagerDelegateDelegate
- (void)audioManager:(AudioManager *)manager recordSuccess:(NSString *)filePath duration:(NSTimeInterval)audioDurantion {
    WeakSelf
    if (!_helper) {
        _helper = [[ZZACRRecognitionHelper alloc] init];
    }
    [ZZHUD showProgress:-1 status:@"正在识别"];
    [_helper recogniteSong:_taskModel.song_list[_selectedSongIndex].name
                  filePath:filePath
           completeHandler:^(BOOL isRecognited) {
        [ZZHUD dismiss];
        [weakSelf didRecognizedSuccess:isRecognited filePath:filePath duration:audioDurantion];
    }];
}

- (void)audioManager:(AudioManager *)manager recordingDuration:(NSTimeInterval)duration soundPower:(NSDictionary *)powerInfo {
    NSLog(@"duration is %f", duration);
    [self showRecordingProgress:duration];
}


#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [self addSubview:self.lyricsLabel];
    [self addSubview:self.progressView];
    [self.progressView addSubview:self.progressLine];
    [self addSubview:self.recordingImageView];
    [self addSubview:self.actionBtn];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.supportLabel];
    [self addSubview:self.statusLabel];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_lyricsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(SCALE_SET(212.0));
        make.left.equalTo(self).offset(51.0);
        make.right.equalTo(self).offset(-51.0);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_lyricsLabel.mas_bottom).offset(SCALE_SET(82));
        make.left.equalTo(self).offset(67.0);
        make.right.equalTo(self).offset(-67.0);
        make.height.equalTo(@4.0);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_lyricsLabel.mas_bottom).offset(SCALE_SET(68));
        make.left.equalTo(self).offset(68.0);
        make.right.equalTo(self).offset(-67.0);
    }];
    
    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_progressView.mas_bottom).offset(SCALE_SET(30.0));
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [_recordingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_progressView.mas_bottom).offset(SCALE_SET(30.0));
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_actionBtn.mas_bottom).offset(SCALE_SET(22.0));
        make.size.mas_equalTo(CGSizeMake(100, 25.0));
    }];
    
    [_supportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-20.0);
        make.left.equalTo(self).offset(51.0);
        make.right.equalTo(self).offset(-51.0);
    }];
    
}

- (void)showRecordingProgress:(NSTimeInterval)time {
    _progressLine.hidden = NO;
    
    CGFloat totalWidth = SCREEN_WIDTH - 67 * 2;
    CGFloat currentWidth = (time / 20) * totalWidth;
    _progressLine.frame = CGRectMake(totalWidth * 0.5 - currentWidth * 0.5,
                                     0.0,
                                     currentWidth,
                                     4);
}

- (void)resetRecordingProgress {
    _progressLine.frame = CGRectZero;
}


#pragma mark - getters and setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.9;
    }
    return _bgView;
}

- (UILabel *)lyricsLabel {
    if (!_lyricsLabel) {
        _lyricsLabel = [[UILabel alloc] init];
        _lyricsLabel.font = ADaptedFontSCBoldSize(17);
        _lyricsLabel.textColor = kGoldenRod;
        _lyricsLabel.numberOfLines = 0;
        _lyricsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lyricsLabel;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = UIColor.whiteColor;
        _progressView.layer.cornerRadius = 2.0;
    }
    return _progressView;
}

- (UIView *)progressLine {
    if (!_progressLine) {
        _progressLine = [[UIView alloc] init];
        _progressLine.backgroundColor = RGBCOLOR(247, 200, 23);
        _progressLine.layer.cornerRadius = 2.0;
        _progressLine.hidden = YES;
    }
    return _progressLine;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] init];
        [_actionBtn addTarget:self action:@selector(singingAction) forControlEvents:UIControlEventTouchUpInside];
        _actionBtn.backgroundColor = UIColor.randomColor;
        _actionBtn.layer.cornerRadius = 50.0;
        _actionBtn.hidden = YES;
        _actionBtn.normalImage = [UIImage imageNamed:@"icChongchang"];
    }
    return _actionBtn;
}

- (UIImageView *)recordingImageView {
    if (!_recordingImageView) {
        _recordingImageView = [[UIImageView alloc] init];
        _recordingImageView.image = [UIImage imageNamed:@"ktv_playing_bg"];
        _recordingImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singingAction)];
        [_recordingImageView addGestureRecognizer:tap];
        
        _recordingTitleLabel = [[UILabel alloc] init];
        _recordingTitleLabel.text = @"停止";
        _recordingTitleLabel.font = ADaptedFontMediumSize(14.0);
        _recordingTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _recordingTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_recordingImageView addSubview:_recordingTitleLabel];
        
        _recordingIconImageView = [[FLAnimatedImageView alloc] init];
        NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:@"KTV_PlayAudio" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
        _recordingIconImageView.animatedImage = image;
        [_recordingImageView addSubview:_recordingIconImageView];
        
        [_recordingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_recordingImageView);
            make.bottom.equalTo(_recordingImageView).offset(-16);
        }];
        
        [_recordingIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_recordingImageView);
            make.bottom.equalTo(_recordingTitleLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    return _recordingImageView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.normalImage = [UIImage imageNamed:@"icFanhui"];
        _cancelBtn.normalTitle = @"取消";
        _cancelBtn.normalTitleColor = RGBACOLOR(255, 255, 255, 0.8);
        _cancelBtn.titleLabel.font = ADaptedFontMediumSize(14.0);
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setImagePosition:LXMImagePositionLeft spacing:11];
    }
    return _cancelBtn;
}

- (UILabel *)supportLabel {
    if (!_supportLabel) {
        _supportLabel = [[UILabel alloc] init];
        _supportLabel.text = @"哼唱识别技术由“ACRCloud”提供";
        _supportLabel.font = ADaptedFontMediumSize(14.0);
        _supportLabel.textColor = RGBACOLOR(255, 255, 255, 0.8);
        _supportLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _supportLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"没有发挥好，再试一次";
        _statusLabel.font = ADaptedFontSCBoldSize(19.0);
        _statusLabel.textColor = RGBACOLOR(255, 255, 255, 1);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.hidden = YES;
    }
    return _statusLabel;
}

@end
