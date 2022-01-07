//
//  ZZUserEditVideoCell.m
//  zuwome
//
//  Created by angBiu on 2017/6/20.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserEditVideoCell.h"
#import "ZZSendVideoManager.h"
#import "ZZWaitingProgressView.h"
#import "GYHCircleProgressView.h"
#import "ZZVideoUploadStatusView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZZVideoUploadStatusView.h"

@interface ZZUserEditVideoCell () <WBSendVideoManagerObserver>

@property (nonatomic, strong) UIImageView *reviewFailedImageView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) ZZWaitingProgressView *cycleView;
@property (nonatomic, strong) GYHCircleProgressView *progressView;
@property (nonatomic, strong) UIButton *againUploadButton;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *height;

@property (nonatomic, strong) ZZVideoUploadStatusView *model;

@end

@implementation ZZUserEditVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icDarenshipinWo"];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-15);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBrownishGreyColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"达人视频";
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(15);
            make.centerY.mas_equalTo(_imgView.mas_centerY);
        }];
        
        self.reviewFailedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icReviewFailed"]];
        [self.contentView addSubview:self.reviewFailedImageView];
        [self.reviewFailedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(15);
            make.width.height.equalTo(@14);
        }];
        
        _tipsLabel = [UILabel new];
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        _tipsLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_tipsLabel];
        [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_titleLabel.mas_left);
            make.left.mas_equalTo(_reviewFailedImageView.mas_right).offset(3);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(15);
        }];
        
        _outerRingImageView = [[UIImageView alloc] init];
        _outerRingImageView.backgroundColor = [UIColor clearColor];
        _outerRingImageView.contentMode = UIViewContentModeScaleAspectFill;
        _outerRingImageView.layer.cornerRadius = 34;
        _outerRingImageView.clipsToBounds = YES;
        [self.contentView addSubview:_outerRingImageView];
        [_outerRingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-30);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(68, 68));
        }];
        
        self.headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icVedioAppend"]];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImageView.layer.cornerRadius = 28;
        self.headImageView.clipsToBounds = YES;
        [self.outerRingImageView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_outerRingImageView);
            make.centerY.equalTo(_outerRingImageView);
            make.width.height.equalTo(@56);
        }];

        self.cycleView = [[ZZWaitingProgressView alloc] init];
        _cycleView.animate = YES;
        _cycleView.isColor = YES;
        [self.outerRingImageView addSubview:self.cycleView];
        [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_outerRingImageView);
            make.centerY.equalTo(_outerRingImageView);
            make.width.height.equalTo(@70);
        }];
        
        _playImgView = [[UIImageView alloc] init];
        _playImgView.image = [UIImage imageNamed:@"icon_user_video_play"];
        [_outerRingImageView addSubview:_playImgView];
        [_playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_outerRingImageView);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        self.againUploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.againUploadButton.backgroundColor = [UIColor clearColor];
        [self.againUploadButton setBackgroundImage:[UIImage imageNamed:@"icon_group10"] forState:UIControlStateNormal];
        [self.againUploadButton addTarget:self action:@selector(againUploadClick:) forControlEvents:UIControlEventTouchUpInside];
        self.againUploadButton.hidden = YES;
        [self.contentView addSubview:self.againUploadButton];
        [self.againUploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_outerRingImageView);
            make.centerY.equalTo(_outerRingImageView);
            make.width.height.equalTo(@68);
        }];
        
        [GetSendVideoManager() addObserver:self];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_progressView && self.isAddProgress) {
        self.progressView = [[GYHCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
        self.progressView.hidden = YES;
        self.progressView.userInteractionEnabled = YES;
        self.progressView.progressStrokeWidth = 4.5f;
        self.progressView.progressColor = RGBCOLOR(246, 139, 61);
        [self.outerRingImageView addSubview:self.progressView];
        [self.contentView bringSubviewToFront:self.againUploadButton];
    }
}

- (void)setUser:(ZZUser *)user {
    _user = user;
//    if (user.base_sk.skId) {
//        _playImgView.hidden = NO;
//        [_rightImgView sd_setImageWithURL:[NSURL URLWithString:user.base_sk.video.cover_url]];
//        _rightImgView.backgroundColor = kGrayTextColor;
//    } else {
//        _playImgView.hidden = YES;
//        _rightImgView.image = [UIImage imageNamed:@"icon_user_video_add"];
//        _rightImgView.backgroundColor = [UIColor whiteColor];
//    }
    
    // 初始状态 UI
    if (user.base_video.sk.skId) {
        _playImgView.hidden = NO;
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.base_video.sk.video.cover_url] placeholderImage:nil options:SDWebImageRetryFailed];
        self.headImageView.backgroundColor = kGrayTextColor;
        self.outerRingImageView.hidden = NO;
        self.outerRingImageView.image = [UIImage imageNamed:@"icon_oval2"];
        self.cycleView.hidden = YES;
    }
    else {
        _playImgView.hidden = YES;
        _outerRingImageView.image = nil;
        self.cycleView.hidden = NO;
        self.headImageView.image = [UIImage imageNamed:@"icVedioAppend"];
        self.headImageView.hidden = NO;
    }
    if (user.base_video.status == 0 || user.base_video.status == 1) {
        _tipsLabel.text = @"个人主页的视频展示";
        _tipsLabel.textColor = kGrayTextColor;
        [self.tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
        }];
        [self.reviewFailedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
    else if (user.base_video.status == -1) {
        _tipsLabel.textColor = kUploadRedColor;
        _tipsLabel.text = @"待审核，审核通过后展示";
    }
    else {
        _tipsLabel.textColor = kUploadRedColor;
        _tipsLabel.text = @"审核失败，请重新上传";
    }
}

#pragma mark - WBSendVideoManagerObserver
- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model {
    _model = model;
    self.cycleView.hidden = YES;
    self.outerRingImageView.image = nil;
    self.againUploadButton.hidden = YES;
    self.headImageView.image = [ZZUtils getThumbImageWithVideoUrl:model.exportURL];
    self.progressView.hidden = NO;
    BLOCK_SAFE_CALLS(self.isUploadVideoBlock, YES);
}

// 视频发送进度
- (void)videoSendProgress:(NSString *)progress {
    self.progressView.progressValue = [progress floatValue];
}

// 视频发送完成
- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk {
    self.cycleView.hidden = YES;
    self.progressView.hidden = YES;
    self.againUploadButton.hidden = YES;
    self.outerRingImageView.image = [UIImage imageNamed:@"icon_oval2"];
    self.headImageView.hidden = NO;
    self.playImgView.hidden = NO;
    //等动画结束后 在算视频上传完
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BLOCK_SAFE_CALLS(self.isUploadVideoBlock, NO);
    });
}

// 视频发送失败
- (void)videoSendFailWithError:(NSDictionary *)error {
    self.cycleView.hidden = YES;
    self.progressView.hidden = YES;
    self.outerRingImageView.image = nil;
    self.playImgView.hidden = NO;
    self.againUploadButton.hidden = NO;
    //等动画结束后 在算视频上传完
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BLOCK_SAFE_CALLS(self.isUploadVideoBlock, NO);
    });
}

// 重新上上传
- (IBAction)againUploadClick:(id)sender {
    [GetSendVideoManager() asyncVideoStartSendingVideo:[ZZVideoUploadStatusView sharedInstance]];
    [_model showBeginStatusView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
