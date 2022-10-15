//
//  ZZRecordEditViewController.m
//  zuwome
//
//  Created by angBiu on 2016/12/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRecordEditViewController.h"

#import "ZZRecordInputView.h"
#import "ZZRecordTopicTitleView.h"
#import "ZZRecordTopicView.h"
#import "ZZLiveStreamHelper.h"
#import "ZZMemedaModel.h"

#import "ZZUploader.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "ZZVideoUploadStatusView.h"
#import "ZZSendVideoManager.h"
#import "ZZLinkWebViewController.h"
#import "ZZRecordEditModel.h"
#import "ZZUtils.h"
#import "ZZRecordEditionLocationView.h"
#import "ZZSearchLocationController.h"
@interface ZZRecordEditViewController () <WBSendVideoManagerObserver>

@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) ZZRecordInputView *inputView;
@property (nonatomic, strong) NSString *upladVideoUrl;
@property (nonatomic, strong) ZZRecordTopicTitleView *topicTitleView;//话题

@property (nonatomic, strong) ZZRecordTopicView *topicView;

@property (nonatomic, strong) UIImageView *videoImageView;//显示第一帧的
@property (nonatomic, strong) UIImage *videoFirstImage;//第一帧
@property (nonatomic, strong) UIButton *recommendedButton;//上推荐
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *lineView;//横线
@property (nonatomic, strong) UIVisualEffectView *effectview;//毛玻璃
@property (nonatomic, strong) ZZRecordEditionLocationView *locationView;//地理位置定位
@property (nonatomic, strong) UIButton *leftBackCustomButton;

/**旧版本的录制达人视频要用到**/

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
/**旧版本的录制达人视频要用到**/
@end

@implementation ZZRecordEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ZZLiveStreamHelper sharedInstance].isBusy = YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [ZZLiveStreamHelper sharedInstance].isBusy = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSString *url = [self.exportURL absoluteString];
    _upladVideoUrl = [url stringByReplacingOccurrencesOfString:@"file:///private" withString:@""];
    // 如果是录制开通闪聊视频，则要在当前页 监听上传进度
    if (self.isFastChat) {
        [GetSendVideoManager() addObserver:self];
    }
    if (_is_base_sk) {
        //录制达人视频还是旧的
        [self setUpOldUI];
    }
    else{
        //录制时刻视屏和么么哒视频新改版
        [self setUpNewUI];
    }

}

/**
 返回按钮,将视频移除
 */
- (void)navigationLeftBtnCustomClick {
    if ([self.presentingViewController isKindOfClass:[ZZTabBarViewController class]]) {
        ZZTabBarViewController *tabbarVC = (ZZTabBarViewController *)self.presentingViewController;
        [tabbarVC resetMenuBtn];
    }
    
    if (self.leftCallBack) {
        self.leftCallBack();
    }

    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 设置UI 新版本的
 */
- (void)setUpNewUI {
    
    //背景图片
    UIImageView *image = [[UIImageView alloc]init];
    [self.view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.videoFirstImage = [ZZUtils getThumbImageWithVideoUrl:self.exportURL];
    image.image = self.videoFirstImage ;
    
    //毛玻璃
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_effectview];
    
    //导航

    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.center = CGPointMake(SCREEN_WIDTH / 2, 22);
    titleLabel.text = @"发布视频";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:titleLabel];
    _leftBackCustomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_leftBackCustomButton];
    [_leftBackCustomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
    }];
    
    [_leftBackCustomButton setImage:[UIImage imageNamed:@"icVideoFabuClose"] forState:UIControlStateNormal];
    [_leftBackCustomButton addTarget:self action:@selector(navigationLeftBtnCustomClick) forControlEvents:UIControlEventTouchUpInside];
    

    [self.view addSubview:self.videoImageView];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.inputView];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"icTip_video"];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_iconImageView];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.text = @"亲爱的用户，您上传的视频须遵守相关法律和社区规则，审核通过后才能生效展示";
    _subTitleLabel.textColor = [UIColor whiteColor];
    _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    _subTitleLabel.numberOfLines = 3;
    [self.view addSubview:_subTitleLabel];
    
    self.inputView.inputTV.text = [ZZUserHelper shareInstance].configModel.sk.content;
    [self.view addSubview:self.topicTitleView];
    if (_type == RecordTypeSK) {
        if (_selectedModel) {
            self.topicView.labelId = _selectedModel.groupId;
            self.topicTitleView.selectedModel = _selectedModel;
        }
    }
    else {
        ZZMMDModel *model = (ZZMMDModel* )_model;
        if (model.groups.count>0) {
            ZZMemedaTopicModel *topicModel = model.groups[0];
            self.topicTitleView.titleLabel.text = topicModel.content;
            self.topicTitleView.currentWidth = [ZZUtils widthForCellWithText:topicModel.content fontSize:13]+72;
            self.topicTitleView.isRecordTypeMemeda = YES;
        }
        else{
            self.topicTitleView.isRecordTypeMemeda = NO;
        }
    }

    [self.view addSubview:self.locationView];
    [self.view addSubview:self.recommendedButton];
    [self.view addSubview:self.publishBtn];

    [self setConstraints];
}

- (void)setConstraints {
    
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset((NAVIGATIONBAR_HEIGHT));
        make.width.equalTo(@(AdaptedWidth(100)));
        make.height.equalTo(self.videoImageView.mas_width).multipliedBy(1.67);
    }];
    
   
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.videoImageView.mas_height);
        make.left.mas_equalTo(self.videoImageView.mas_right).with.offset(10);
        make.right.offset(-15);
        make.centerY.mas_equalTo(self.videoImageView.mas_centerY);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom).with.offset(12);
        make.left.offset(15);
        make.size.mas_equalTo(CGSizeMake(16, 14));
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_bottom).with.offset(12);
        make.left.equalTo(_iconImageView.mas_right).offset(6);
        make.right.offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(_subTitleLabel.mas_bottom).with.offset(15);
        make.height.equalTo(@1);
    }];
    
    [self.recommendedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.publishBtn.mas_top).offset(-16);
    }];
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-SafeAreaBottomHeight -25);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.equalTo(@49);
    }];
    if (self.topicTitleView.isRecordTypeMemeda==NO&&_type !=RecordTypeSK) {
        [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.lineView.mas_bottom).with.offset(12);
            make.width.equalTo(@(AdaptedWidth(103)));
        }];
        return;
    }
   
    [self.topicTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(12);
        make.width.equalTo(@(AdaptedWidth(205)));
    }];

   
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topicTitleView.mas_right).with.offset(15);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(12);
        make.width.equalTo(@(AdaptedWidth(103)));
    }];
}

#pragma mark - UIButtonMethod
- (void)publishBtnClick
{
  
    [MobClick event:Event_click_record_publish];
    ZZVideoUploadStatusView *uploadStatusView = [ZZVideoUploadStatusView sharedInstance];
    uploadStatusView.exportURL = self.exportURL;
    uploadStatusView.type = _type;
    uploadStatusView.mid = _model.mid;
    if (!self.topicTitleView.isNoTop) {
        uploadStatusView.labelId = self.topicTitleView.selectedModel.groupId;
    }

    uploadStatusView.content = self.inputView.inputTV.text;
    uploadStatusView.loc_name = self.locationView.loc_name;
    uploadStatusView.tagId = nil;
    uploadStatusView.expiredTime = _model.expired_at;
    uploadStatusView.is_base_sk = _is_base_sk;
    uploadStatusView.pixelWidth = self.pixelWidth;
    uploadStatusView.pixelHeight = self.pixelHeight;
    uploadStatusView.isRecordVideo = self.isRecordVideo;
    // 是否是录制达人视频(自我介绍)
    uploadStatusView.isIntroduceVideo = self.isIntroduceVideo;
    uploadStatusView.isShowTopUploadStatus = self.isShowTopUploadStatus;
    uploadStatusView.isUploadAfterCompleted = self.isUploadAfterCompleted;
    uploadStatusView.isFastChat = self.isFastChat;
    switch (_type) {
        case RecordTypeSK:
        {
            [MobClick event:Event_click_record_publish_sk];
        }
            break;
        case RecordTypeMemeda:
        {
            [MobClick event:Event_click_record_publish_memda];
        }
            break;
        case RecordTypeUpdateMemeda:
        {
            [MobClick event:Event_click_record_publish_memda];
        }
            break;
        default:
            break;
    }
    [self dismissView];
}

- (void)dismissView {
    if ([self.presentingViewController isKindOfClass:[ZZTabBarViewController class]]) {
        ZZTabBarViewController *tabbarVC = (ZZTabBarViewController *)self.presentingViewController;
        [tabbarVC resetMenuBtn];
    }
    
    if (self.isIntroduceVideo) {//是录制达人视频
        [GetSendVideoManager() asyncVideoStartSendingVideo:[ZZVideoUploadStatusView sharedInstance]];
    }

    // 是录制闪聊视频，则在当前页 显示上传进度，不直接 dismiss
    if (self.isFastChat) {

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
        [[ZZVideoUploadStatusView sharedInstance] showBeginStatusView];
        return;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    if (self.selectAlbumsDirectly) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [[ZZVideoUploadStatusView sharedInstance] showBeginStatusView];
        if (_callBack) {
            _callBack();
        }
        return;
    }
   
    [self dismissViewControllerAnimated:YES completion:^{
        [[ZZVideoUploadStatusView sharedInstance] showBeginStatusView];
        if (_callBack) {
            _callBack();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - WBSendVideoManagerObserver
// 视频开始发送, 点小飞机以后
- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model {
    
    self.view.userInteractionEnabled = NO;
    [ZZHUD showProgress:0.0 status:@"正在上传..."];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

// 视频发送进度
- (void)videoSendProgress:(NSString *)progress {
    
    [ZZHUD showProgress:[progress floatValue] status:@"正在上传..."];
}

// 视频发送完成
- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk {
    
//    [ZZHUD showSuccessWithStatus:@"上传完成"];
    WEAK_SELF();
    [ZZHUD showWithStatus:@"更新信息"];
    ZZUser *user = [ZZUserHelper shareInstance].loginer;
    if (sk) {// 闪聊视频也要像达人视频一样拼接
        user.base_video.sk = sk;
        user.base_video.status = 1;
    }
    NSMutableDictionary *userDic = [[user toDictionary] mutableCopy];
    [userDic setObject:@(YES) forKey:@"bv_from_qchat"];
    [user updateWithParam:userDic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"更新成功"];
            NSError *err;
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
            [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    [GetSendVideoManager() asyncSendVideoWithVideoId:sk];
                }];
            }];
        }
    }];
}

// 视频发送失败
- (void)videoSendFailWithError:(NSDictionary *)error {
    [ZZHUD showErrorWithStatus:@"上传失败"];
    self.view.userInteractionEnabled = YES;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - Lazyload

- (void)setIsShowTopUploadStatus:(BOOL)isShowTopUploadStatus {
    _isShowTopUploadStatus = isShowTopUploadStatus;
}

- (UIButton *)publishBtn
{
    if (!_publishBtn) {
        if (_is_base_sk) {
            _publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, SCREEN_HEIGHT - 80 - SafeAreaBottomHeight, 60, 60)];
            [_publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [_publishBtn setImage:[UIImage imageNamed:@"icon_record_publish"] forState:UIControlStateNormal];
        }else{
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_publishBtn setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
        _publishBtn.backgroundColor = kYellowColor;
        _publishBtn.clipsToBounds = YES;
        _publishBtn.layer.cornerRadius = 3;
        }
        
    }
    return _publishBtn;
}

/**
 视频的第一帧图片
 */
- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc]init];
        _videoImageView.image = self.videoFirstImage ;
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.layer.cornerRadius = 4;
        _videoImageView.clipsToBounds = YES;
    }
    return _videoImageView;
}

- (UIButton *)recommendedButton {
    if (!_recommendedButton) {
        _recommendedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recommendedButton.frame = CGRectMake(0, 0, AdaptedWidth(130), 24);
        [_recommendedButton addTarget:self action:@selector(recommendedButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_recommendedButton setTitle:@"我要上推荐" forState:UIControlStateNormal];
        [_recommendedButton setImage:[UIImage imageNamed:@"icVideoEditTuijianMore"] forState:UIControlStateNormal];
       [ _recommendedButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_recommendedButton.imageView.size.width-3, 0, _recommendedButton.imageView.size.width+3)];
        [_recommendedButton setImageEdgeInsets:UIEdgeInsetsMake(0, _recommendedButton.titleLabel.bounds.size.width+3, 0, -_recommendedButton.titleLabel.bounds.size.width-3)];
        [_recommendedButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    }
    return _recommendedButton;
}

/**
 留言
 */
- (ZZRecordInputView *)inputView {
    if (!_inputView) {
        _inputView = [[ZZRecordInputView alloc] initWithFrame:CGRectZero];
        _inputView.hidden = self.isIntroduceVideo;
        _inputView.clipsToBounds = YES;
        _inputView.layer.cornerRadius = 3;
        _inputView.backgroundColor = [UIColor whiteColor];
    }
    return _inputView;
}

/**
 话题点击的view
 */
- (ZZRecordTopicTitleView *)topicTitleView
{
    WeakSelf;
    if (!_topicTitleView) {
        _topicTitleView = [[ZZRecordTopicTitleView alloc] initWithFrame:CGRectZero];
        _topicTitleView.clipsToBounds = YES;
        _topicTitleView.layer.cornerRadius = 3;
        _topicTitleView.isIntroduceVideo = self.isIntroduceVideo;
        if (_type == RecordTypeSK) {
            _topicTitleView.currentWidth = AdaptedWidth(205);
        }else{
            ZZMMDModel *model = (ZZMMDModel* )_model;
            if (model.groups.count>0) {
                ZZMemedaTopicModel *topicModel = model.groups[0];
                _topicTitleView.titleLabel.text = topicModel.content;
                 _topicTitleView.isRecordTypeMemeda = YES;
                _topicTitleView.currentWidth = AdaptedWidth(205);
            }
            _topicTitleView.currentWidth = 0;
        }
        _topicTitleView.tapSelf = ^{
            [weakSelf.topicView show];
            [weakSelf.navigationLeftBtn setHidden:YES];
            [ZZUserHelper shareInstance].lastSKTopicVersion = [ZZUserHelper shareInstance].lastSKTopicVersion;
        };
        
        _topicTitleView.delegateButtionCallback = ^{
            weakSelf.topicTitleView.titleLabel.text = @"# 添加话题 获得更多关注 #";
            weakSelf.topicTitleView.currentWidth = [ZZUtils widthForCellWithText:weakSelf.topicTitleView.titleLabel.text fontSize:13]+16+22+12;
            [weakSelf updateTopicTitleViewAndLocationViewUI];
        };
        
        if (_is_base_sk) {
            _topicTitleView.userInteractionEnabled = NO;
        }
    }
    return _topicTitleView;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(86, 86, 86);
    }
    return _lineView;
}
- (ZZRecordEditionLocationView *)locationView {
    if (!_locationView) {
        _locationView = [[ZZRecordEditionLocationView alloc]initWithFrame:CGRectZero];
        _locationView.currentWidth = AdaptedWidth(103);
        
        WS(weakSelf);
        
        _locationView.tapSelf = ^{
         [weakSelf jumpToLocationView];
        };
        
        _locationView.delegateButtionCallback = ^{
            weakSelf.locationView.titleLabel.text = @"你在哪里?";
            weakSelf.locationView.currentWidth = AdaptedWidth(103);
            [weakSelf updateTopicTitleViewAndLocationViewUI];
        };
    }
    return _locationView;
}
/**
 话题
 */
- (ZZRecordTopicView *)topicView
{
    WeakSelf;
    if (!_topicView) {
        _topicView = [[ZZRecordTopicView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_topicView];
        _topicView.selectedTopic = ^(ZZTopicGroupModel *model) {
            [weakSelf.navigationLeftBtn setHidden:NO];
            weakSelf.topicTitleView.currentWidth = [ZZUtils widthForCellWithText:model.content fontSize:13]+72;
            [weakSelf updateTopicTitleViewAndLocationViewUI];
            weakSelf.topicTitleView.selectedModel = model;
        };
        _topicView.closeClickCallBack = ^{
            [weakSelf.navigationLeftBtn setHidden:NO];
        };
    }
    return _topicView;
}

//TODO:更新话题和定位的UI
- (void)updateTopicTitleViewAndLocationViewUI {
    
    if (self.topicTitleView.isRecordTypeMemeda == NO && (_type != RecordTypeSK)) {
        //回答视频的么么哒,但是视屏没有话题
        [self.locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.width.equalTo(@(self.locationView.currentWidth));
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.equalTo(self.lineView.mas_bottom).with.offset(12);
        }];
        return;
    }
    
    if (self.topicTitleView.currentWidth+self.locationView.currentWidth>=SCREEN_WIDTH -45) {
        //说明一行显示不了了要换行显示了
        [self.topicTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.topicTitleView.currentWidth));
        }];
        [self.locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        make.top.equalTo(self.topicTitleView.mas_bottom).with.offset(12);
            make.width.equalTo(@(self.locationView.currentWidth));
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
        }];
    }else{
        //一行能显示完全
        [self.topicTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.topicTitleView.currentWidth));
        }];
        [self.locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.width.equalTo(@(self.locationView.currentWidth));
            make.left.mas_equalTo(self.topicTitleView.mas_right).with.offset(15);
            make.top.equalTo(self.lineView.mas_bottom).with.offset(12);
        }];
    }
}

- (void)setIsIntroduceVideo:(BOOL)isIntroduceVideo {
    _isIntroduceVideo = isIntroduceVideo;
    if (isIntroduceVideo) {//是达人录制视频
    }
}

- (void)jumpToLocationView {
    WS(weakSelf);
    
    ZZSearchLocationController *vc = [[ZZSearchLocationController alloc] init];
    vc.title = @"选择地点";
    vc.selectPoiDone = ^(ZZRentDropdownModel *model) {
        if (model.name) {
            weakSelf.locationView.titleLabelString = model.name;
            weakSelf.locationView.currentWidth = [ZZUtils widthForCellWithText:model.name fontSize:13]+32+40;
            [weakSelf updateTopicTitleViewAndLocationViewUI];
        }
    };
    vc.hidesBottomBarWhenPushed = YES;

    UIColor *navColor = kYellowColor;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:navColor cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:navColor cornerRadius:0]];
    [self.navigationController pushViewController:vc animated:YES];

}

/**
 上推荐跳转到H5
 */
- (void)recommendedButtonClick {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc]init];
    controller.urlString = H5Url.beingSelectedRecommendVideoGuide;
    controller.isHideBar = YES;
    controller.isHideNavigationBarWhenUp = YES;
    controller.isPush = YES;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 录制达人视屏

- (void)setUpOldUI {
    _playerItem = [AVPlayerItem playerItemWithURL:self.exportURL];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:playerLayer];
    if([[UIDevice currentDevice] systemVersion].intValue >= 10){
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    [self.view addSubview:self.deleteBtn];
    [self.view addSubview:self.downBtn];
    [self.view addSubview:self.publishBtn];

    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        AVPlayerItemStatus status = playerItem.status;
        switch (status) {
            case AVPlayerItemStatusUnknown:
            {
                
            }
                break;
                
            case AVPlayerItemStatusReadyToPlay:
            {
                [self.player play];
                [self.player seekToTime:CMTimeMake(0, 1)];
                [self.player play];
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                
            }
                break;
            default:
                break;
        }
    }
}
-(void)playbackFinished:(NSNotification *)notification
{
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

- (void)appDidEnterBackground
{
    [self.player pause];
}

- (void)appDidEnterPlayGround
{
    [self.player play];
}

- (void)downBtnClick
{
    [MobClick event:Event_click_record_down];
    if (IOS8_OR_LATER) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self.exportURL];
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                [self saveSuccess];
            } else {
                [ZZHUD showErrorWithStatus:@"保存失败"];
            }
        }];
    } else {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:self.exportURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:self.exportURL completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [ZZHUD showErrorWithStatus:@"保存失败"];
                    } else {
                        [self saveSuccess];
                    }
                });
            }];
        } else {
            [ZZHUD showErrorWithStatus:@"保存失败"];
        }
    }
}

- (void)saveSuccess
{
    if (![ZZUtils isAllowPhotoLibrary]) {
        return;
    }
    [ZZHUD showSuccessWithStatus:@"保存成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _downBtn.selected = YES;
        _downBtn.userInteractionEnabled = NO;
    });
}
- (void)deleteBtnClick
{
    [UIAlertView showWithTitle:nil message:@"是否放弃本段视频？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [MobClick event:Event_click_record_delete];
            if (_touchLeft) {
                _touchLeft();
            }
            [[NSFileManager defaultManager] removeItemAtURL:self.exportURL error:nil];
            if (self.navigationController.viewControllers.count == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

- (UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 20, 60, 44)];
        [_downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_downBtn setImage:[UIImage imageNamed:@"icon_record_edit_down"] forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@"icon_record_cache"] forState:UIControlStateSelected];
    }
    return _downBtn;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 80- SafeAreaBottomHeight, 60, 60)];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_record_delete"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (void)dealloc
{
    if (_is_base_sk) {
        if (!self.player) return;
        [self.player pause];
        [self.player cancelPendingPrerolls];
        self.player = nil;
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
