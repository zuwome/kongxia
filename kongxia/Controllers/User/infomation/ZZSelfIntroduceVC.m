//
//  ZZSelfIntroduceVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/11/16.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZSelfIntroduceVC.h"
#import "ZZRecordViewController.h"
#import "ZZSendVideoManager.h"
#import "ZZPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZZChatVideoPlayerController.h"
#import "ZZFastChatSettingVC.h"
#import "PhotoAlbumViewController.h"
#import "ZZUserEditViewController.h"

#import "PLShortVideoKit/PLShortVideoKit.h"
@interface ZZSelfIntroduceVC () <WBSendVideoManagerObserver>

@property (strong, nonatomic) IBOutlet UIImageView *failImageView;  //失败图标
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;         //title
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;          //tip
@property (strong, nonatomic) IBOutlet UIButton *videoCoverButton;  //视频背景
@property (strong, nonatomic) IBOutlet UIImageView *videoCoverImage;//视频封面背景
@property (strong, nonatomic) IBOutlet UIButton *videoIconButton;   //拍摄button
@property (strong, nonatomic) IBOutlet UILabel *uploadTipLabel;     //上传文案label
@property (strong, nonatomic) IBOutlet UIButton *sampleVideoButton; //示例视频
@property (strong, nonatomic) IBOutlet UIButton *againShootButton;  //重新拍摄
@property (nonatomic, strong) NSURL *exportURL;

@property (strong, nonatomic) IBOutlet UIView *shadowView;//阴影层

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videoTopNSLayoutConstraint;

@property (assign, nonatomic) CGFloat startTime;

@property (assign, nonatomic) CGFloat endTime;

@property (strong, nonatomic) PLShortVideoTranscoder *shortVideoTranscoder;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UILabel *progressLabel;

@end

@implementation ZZSelfIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"达人视频";
    if (self.isShanzuAndFirst) {
        self.titleLabel.text = @"成为闪租达人前，你需要录制一段视频";
    }
    [GetSendVideoManager() addObserver:self];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)dealloc {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    [self.shortVideoTranscoder cancelTranscoding];
    self.shortVideoTranscoder = nil;
}

#pragma mark - Getter

- (void)setIsShowTopUploadStatus:(BOOL)isShowTopUploadStatus {
    _isShowTopUploadStatus = isShowTopUploadStatus;
}

#pragma mark - Private methods

- (void)setupUI {
    
    if (self.reviewStatus == ZZVideoReviewStatusNoRecord) {
        _shadowView.hidden = YES;
        [self noRecordUI];
    }
    else if (self.reviewStatus == ZZVideoReviewStatusSuccess) {
        if (SCREEN_HEIGHT > 568.0) {
            self.videoTopNSLayoutConstraint.constant = 70.0f;
        }
        _shadowView.hidden = NO;
        [self reviewSuccess];
    }
    else if (self.reviewStatus == ZZVideoReviewing){
        if (SCREEN_HEIGHT > 568.0) {
            self.videoTopNSLayoutConstraint.constant = 70.0f;
        }
        _shadowView.hidden = YES;
        [self reviewing];
    }
    else {
        if (SCREEN_HEIGHT > 568.0) {
            self.videoTopNSLayoutConstraint.constant = 70.0f;
        }
        _shadowView.hidden = NO;
        [self reviewFail];
    }
    
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    _shadowView.layer.shadowOffset = CGSizeMake(0, 2);//偏移距离
    _shadowView.layer.shadowOpacity = 0.4;//不透明度
    _shadowView.layer.shadowRadius = 2.0f;
    _shadowView.layer.cornerRadius = 10.0f;
    
    self.videoCoverImage.layer.masksToBounds = YES;
    self.videoCoverImage.layer.cornerRadius = 10.0f;
    
    self.againShootButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.againShootButton.layer.masksToBounds = YES;
    self.againShootButton.layer.cornerRadius = 16.0f;
    [self.againShootButton sizeToFit];
    
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

// 未录视频UI
- (void)noRecordUI {
    
    self.failImageView.hidden = YES;
    self.againShootButton.hidden = YES;
    self.titleLabel.text = @"上传一段视频展示自己";
    self.tipsLabel.text = @"内容优质的视频资料，可以提升您的魅力";
    self.videoCoverButton.hidden = NO;
}

// 审核成功UI
- (void)reviewSuccess {
    
    self.failImageView.hidden = YES;
    self.uploadTipLabel.hidden = YES;
    self.titleLabel.text = @"上传一段视频展示自己";
    self.tipsLabel.text = @"内容优质的视频资料，可以提升您的魅力";
    self.videoCoverButton.hidden = YES;
    [self.videoIconButton setBackgroundImage:[UIImage imageNamed:@"icVedioPlay"] forState:UIControlStateNormal];
    [self.videoCoverImage sd_setImageWithURL:[NSURL URLWithString:_loginer.base_video.sk.video.cover_url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.videoCoverButton.hidden = YES;
            self.videoCoverImage.hidden = NO;
            self.videoCoverImage.image = image;
            self.videoCoverImage.clipsToBounds = YES;
            self.videoCoverImage.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
}

// 审核失败UI
- (void)reviewFail {
    
    self.uploadTipLabel.hidden = YES;
    self.titleLabel.text = @"审核失败";
    self.titleLabel.textColor = [UIColor redColor];
    self.videoCoverButton.hidden = YES;
    
    NSString *failString = [NSString stringWithFormat:@"* %@", _loginer.base_video.status_text];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:failString];
    NSRange redRange = NSMakeRange(0, 1);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    self.tipsLabel.attributedText = string;
    
    [self.videoIconButton setBackgroundImage:[UIImage imageNamed:@"icVedioPlay2"] forState:UIControlStateNormal];
    
    [self.videoCoverImage sd_setImageWithURL:[NSURL URLWithString:_loginer.base_video.sk.video.cover_url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.videoCoverButton.hidden = YES;
            self.videoCoverImage.hidden = NO;
            self.videoCoverImage.image = image;
            self.videoCoverImage.clipsToBounds = YES;//存储图片中间部分，比例不表
            self.videoCoverImage.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
}

/**
 * 审核中
 */
- (void)reviewing {
    
    self.uploadTipLabel.hidden = YES;
    self.titleLabel.text = @"审核中";
    self.titleLabel.textColor = [UIColor redColor];
    self.videoCoverButton.hidden = YES;
    
    self.failImageView.hidden = YES;
    self.againShootButton.hidden = NO;
    self.videoCoverButton.hidden = NO;
    
    NSString *failString = @"待审核，审核通过后展示";//[NSString stringWithFormat:@"* %@", _loginer.base_video.status_text];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:failString];
    NSRange redRange = NSMakeRange(0, failString.length);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
    self.tipsLabel.attributedText = string;
    
    [self.videoIconButton setBackgroundImage:[UIImage imageNamed:@"icVedioPlay2"] forState:UIControlStateNormal];

    [self.videoCoverImage sd_setImageWithURL:[NSURL URLWithString:_loginer.base_video.sk.video.cover_url] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.videoCoverButton.hidden = YES;
            self.videoCoverImage.hidden = NO;
            self.videoCoverImage.image = image;
            self.videoCoverImage.clipsToBounds = YES;//存储图片中间部分，比例不表
            self.videoCoverImage.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
}

// 录制视频操作
- (IBAction)recordVideoClick:(UIButton *)sender {
    
    if (self.reviewStatus == ZZVideoReviewStatusNoRecord) {
        [self againShootButton:nil];
    }
    else if (self.reviewStatus == ZZVideoReviewStatusSuccess) {
        ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
        controller.fromLiveStream = YES;
        controller.skId = _loginer.base_video.sk.id;
        controller.hidesBottomBarWhenPushed = YES;
        controller.isBaseVideo = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else {
        ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
        controller.fromLiveStream = YES;
        controller.skId = _loginer.base_video.sk.id;
        controller.hidesBottomBarWhenPushed = YES;
        controller.isBaseVideo = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 查看示例视频
- (IBAction)sampleVideoClick:(UIButton *)sender {
    ZZChatVideoPlayerController *playerVC = [[ZZChatVideoPlayerController alloc] init];
    playerVC.entrance = EntranceOthers;
    playerVC.videoUrl = @"http://static.zuwome.com/drsl.mp4";
    [self presentViewController:playerVC animated:YES completion:nil];
}

- (void)selectFromTheAlbum {
    if (_reviewStatus == ZZVideoReviewStatusNoRecord) {
        [MobClick event:Event_click_Record_video];
    }
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES isFromChat:NO];
            imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
            imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按

            imagePickerVc.allowPickingVideo = YES;
            imagePickerVc.allowPickingImage = NO;
            imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频

            imagePickerVc.showSelectBtn = NO;
            imagePickerVc.allowCrop = NO;
            imagePickerVc.needCircleCrop = NO;

            [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
                [self selectVideo:asset];
            }];
            imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        }
    }];
}

- (void)selectVideo:(PHAsset *)asset {
    long long size = 0;
    if (IOS10) {
       PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
       size = [[resource valueForKey:@"fileSize"] longLongValue];
   } else {//ios 10 以下获取视频大小
       size = [NSData dataWithContentsOfURL:[asset movieURL]].length;
   }

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
    //    self.shortVideoTranscoder.outputFilePreset = self.transcoderPreset;
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
                    controller.type = RecordTypeSK;
                    
                    ZZTopicGroupModel *model = [[ZZTopicGroupModel alloc] init];
                    model.groupId = @"5a0d05e0e5be1849ea1da154";
                    model.content = @"我是达人";
                    controller.selectedModel = model;
                    
                    controller.isFastChat = strongSelf.isFastChat;
                    controller.leftCallBack = ^{
                        [[NSFileManager defaultManager] removeItemAtURL:strongSelf.exportURL error:nil];
                    };

                    controller.is_base_sk = YES;
                    controller.isRecordVideo = NO;
                    controller.pixelWidth = SCREEN_WIDTH;
                    controller.pixelHeight = SCREEN_HEIGHT;
                    controller.showType = strongSelf.showType;
                    controller.isShowTopUploadStatus = strongSelf.isShowTopUploadStatus;
                    controller.isUploadAfterCompleted = strongSelf.isUploadAfterCompleted;
                    controller.isIntroduceVideo = YES;
                    controller.selectAlbumsDirectly = YES;//直接选的相册
                    
                    if ([weakSelf.presentingViewController isKindOfClass:[ZZNavigationController class]]) {
                        ZZNavigationController *parentVC = (ZZNavigationController*)weakSelf.presentingViewController;
//
                        [strongSelf dismissViewControllerAnimated:NO completion:^{
                            [parentVC pushViewController:controller animated:YES];
                        }];
                    }
                    else {
                        ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:controller];
                        [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
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

- (void)recordVideo {
    if (_reviewStatus == ZZVideoReviewStatusNoRecord) {
        [MobClick event:Event_click_Record_video];
    }
    
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            ZZTopicGroupModel *model = [[ZZTopicGroupModel alloc] init];
            model.groupId = @"5a0d05e0e5be1849ea1da154";
            model.content = @"我是达人";
            ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
            controller.isHidePhoto = YES;
            controller.isIntroduceVideo = YES;
            controller.labelId = @"5a0d05e0e5be1849ea1da154";
            controller.groupModel = model;
            controller.is_base_sk = YES;
            controller.isShowTopUploadStatus = self.isShowTopUploadStatus;
            controller.isUploadAfterCompleted = self.isUploadAfterCompleted;
            controller.isFastChat = self.isFastChat;
            controller.showType = self.showType;
            ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
            [navCtl setNavigationBarHidden:YES animated:NO];
            [self presentViewController:navCtl animated:YES completion:nil];
            controller.viewDismiss = ^{
                NSLog(@"返回了。。。");
            };
        }
    }];
}
// 重新拍摄
- (IBAction)againShootButton:(UIButton *)sender {
    
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
        NSLog(@"从相册选择");
        [self selectFromTheAlbum];
    }];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"立即录制" style:UIAlertActionStyleDefault                                                             handler:^(UIAlertAction * action) {
        NSLog(@"立即录制");
        
        [self recordVideo];
    }];
    NSArray *array = @[cancelAction,fromPhotoAction,fromCameraAction];
    [UIAlertController presentActionControllerWithTitle:@"上传达人视频" actions:array];
 
}

#pragma mark - WBSendVideoManagerObserver

- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model {
    WEAK_SELF();
    
    if (self.isFastChat) {// 如果是闪聊视频发布成功
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray<ZZViewController *> *vcs = [weakSelf.navigationController.viewControllers mutableCopy];
        [vcs removeLastObject];
        [weakSelf.navigationController setViewControllers:vcs animated:NO];
    });
}

- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk {
    WEAK_SELF();
    if (self.isFastChat) {// 如果是闪聊视频发布成功
        if (self.showType ==ShowHUDType_OpenSanChat) {//从开通出租过来的
            dispatch_async(dispatch_get_main_queue(), ^{
                ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
                controller.gotoRootCtl = YES;
                controller.showType = ShowHUDType_OpenSanChat;
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_OpenFastChat object:nil];
            
            NSMutableArray<ZZViewController *> *vcs = [weakSelf.navigationController.viewControllers mutableCopy];
            [vcs removeObject:self];
            [vcs removeLastObject];
            
            ZZFastChatSettingVC *vc = [ZZFastChatSettingVC new];
            vc.isShow = YES;
            
            [vcs addObject:vc];
            [weakSelf.navigationController setViewControllers:vcs animated:NO];
        });
        return;
    }
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

@end
