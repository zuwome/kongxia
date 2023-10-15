//
//  ZZPlayerViewController.m
//  zuwome
//
//  Created by angBiu on 2016/12/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZPlayerViewController.h"
#import "ZZTopicDetailViewController.h"
#import "ZZContributionViewController.h"
#import "ZZRentViewController.h"
#import "ZZReportViewController.h"
#import "ZZChatViewController.h"
#import "ZZMemedaAnswerDetailViewController.h"
#import "ZZRecordViewController.h"
#import "ZZChangePhoneViewController.h"

#import "ZZPlayerCell.h"
#import "ZZVideoAlertView.h"
#import "ZZPacketAlertView.h"
#import "ZZPlayerGuideView.h"

#import "ZZVideoUploadStatusView.h"
#import "ZZCheckWXView.h"

#import "ZZAFNHelper.h"
#import "VideoPlayer.h"
#import "ZZMMDTipModel.h"
#import "ZZDateHelper.h"
#import "ZZPlayerHelper.h"
#import "ZZPlayerViewController+ZZUIColletionView.h"
#import "ZZPlayerViewController+ZZProxys.h"


@interface ZZPlayerViewController () <JPVideoPlayerDelegate,TTTAttributedLabelDelegate>

@property (nonatomic, strong) ZZVideoAlertView *alertView;
@property (nonatomic, strong) ZZPlayerGuideView *guideView;
@property (nonatomic, assign) BOOL isHideViews;//隐藏顶部和底部

@property (nonatomic, assign) BOOL haveAddShareView;//是否已添加了分享view
@property (nonatomic, assign) BOOL isViewPush;//是否要显示导航栏
@property (nonatomic, assign) BOOL keyboardDidShow;//键盘出现
@property (nonatomic, assign) BOOL commentIng;//正在评论
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, strong) ZZCheckWXView *wxCopyView;
@property (nonatomic, assign) BOOL isChangeCommit;//是否改变过底部的颜色
@property (nonatomic, assign) BOOL isBan;

@end

@implementation ZZPlayerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    _isViewPush = NO;
    if (_currentMMDModel || _currentSkModel || _chatBaseModel) {
        [self playVideoWithPlayerCell:self.playingCell];
    }
    _viewDidAppear = YES;
    [self addNotification];
    if (self.isShowTextField) {
        [self.commentView.textField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    if (_popNotHide && !_isViewPush) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [self pausePlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (!_isBeDeleted) {
        [ZZHUD dismiss];
    }
    _viewDidAppear = NO;
    [self stopPlay];
    [self removeNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.isBaseVideo) {
        self.view.backgroundColor = HEXCOLOR(0x010101);
    }
    _viewDidAppear = YES;
    _location = [ZZUserHelper shareInstance].location;
    [self createViews];
    if (_canLoadMore) {
        [self managerFirstGuide];
    }
    if (_skId) {
        //瞬间视屏
        [self getSKDetail];
    }
    if(_mid){
        //么么哒视屏
        [self getMMDDetail:NO];
    }
    if (_chatBaseModel) {
        [self configChatVideo];
    }
    
    self.isShowWXCopyView = NO;//当前是否已经显示查看视频了
}

- (void)configChatVideo {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ZZPlayerCell *cell = (ZZPlayerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell setCommentArray:nil contributions:nil noMoreData:YES];
    if (self.viewDidAppear) {
        [self managerPlayStatusWithPlayerCell:cell];
    }

}

//下载完成
- (void)finishedDownload {
    NSInteger status = [JPVideoPlayerPlayVideoTool sharedTool].currentPlayVideoItem.player.status;
    NSInteger  status2 = 2;
    if (IOS10) {
        status2 =  [JPVideoPlayerPlayVideoTool sharedTool].currentPlayVideoItem.player.timeControlStatus;
    }
    NSLog(@"PY_当前收到下载完毕的通知开始播放呢 %ld %ld",(long)status,(long)status2);
    WS(weakSelf);
    if (status !=1||status2 <2) {
        NSLog(@"PY_当前收到下载完毕的通知开始播放呢 一秒以后%ld %ld",(long)status,(long)status2);
        [weakSelf beginPlayerCell:weakSelf.playingCell];
    }
}

- (void)createViews {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.navigationView];
//    [self.view addSubview:self.contentView];//去掉上面的评论
    [self.view addSubview:self.commentView];
    
    if (_dataIndexPath.row != 0) {
        _scrollCannotPlay = YES;
        [self.collectionView scrollToItemAtIndexPath:_dataIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

- (void)addNotification {
    ///下载完成判断是不是播放界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedDownload) name:@"www.jpvideplayer.download.finished.notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVideo:) name:kMsg_UploadUpdateVideo object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMsg_UploadUpdateVideo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"www.jpvideplayer.download.finished.notification" object:nil];
}

//手势引导
- (void)managerFirstGuide {
    if (![ZZKeyValueStore getValueWithKey:@"havePlayerDownUpGuide"]) {
        [self.view addSubview:self.guideView];
        [ZZKeyValueStore saveValue:@"havePlayerDownUpGuide" key:@"havePlayerDownUpGuide"];
    }
}

- (void)managerViewcontrollers {
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[ZZMemedaAnswerDetailViewController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
    
    [self showAnswerSuccessAlertView];
}

- (void)showAnswerSuccessAlertView {
    __weak typeof(self)weakSelf = self;
    ZZPacketAlertView *packerAlertView = [[ZZPacketAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds withController:weakSelf];
    packerAlertView.shareUrl = [NSString stringWithFormat:@"/%@mmd/%@/page", kBase_URL, _currentMMDModel.mid];
    packerAlertView.shareTitle = [NSString stringWithFormat:@"么么答｜%@",_currentMMDModel.content];
    packerAlertView.shareContent = [NSString stringWithFormat:@"%@在「空虾」用视频回答了这个问题，快去看看", _currentMMDModel.to.nickname];
    packerAlertView.shareImg = nil;
    packerAlertView.uid = _currentMMDModel.to.uid;
    packerAlertView.mid = _currentMMDModel.mid;
    if (_currentMMDModel.answers.count) {
        ZZMMDAnswersModel *answerModel = _currentMMDModel.answers[0];
        packerAlertView.userImgUrl = answerModel.video.cover_url;
    }
    
    [packerAlertView.headImgView setUser:_currentMMDModel.from width:64 vWidth:12];
    packerAlertView.nameLabel.text = [NSString stringWithFormat:@"%@打赏了",_currentMMDModel.from.nickname];
    packerAlertView.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_currentMMDModel.total_price];
    packerAlertView.packetPriceLabel.text = [NSString stringWithFormat:@"%.2f",_currentMMDModel.total_price-_currentMMDModel.yj_price];
    packerAlertView.servicePriceLabel.text = [NSString stringWithFormat:@"%.2f",_currentMMDModel.yj_price];
    [self.view addSubview:packerAlertView];
    
    packerAlertView.touchCancel = ^{
        [weakSelf playVideoWithPlayerCell:weakSelf.playingCell];
    };
}

//评论
- (void)commentWithContent:(NSString *)content replyId:(NSString *)replyId {
    if (![self canDoThings]) {
        return;
    }
    if (isNullString(content)) {
        return;
    }
    _commentIng = YES;
    ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
    NSMutableDictionary *aDict = [@{@"content":content} mutableCopy];
    if (replyId) {
        [aDict setObject:replyId forKey:@"reply_which_reply"];
    }
    self.commentView.sendBtn.userInteractionEnabled = NO;
    self.commentView.textField.text = nil;
    if (_currentSkModel) {
        [ZZSKModel commentMememdaParam:aDict skId:_skId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            self.commentView.sendBtn.userInteractionEnabled = YES;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [self commentSuccess:data];
                _currentSkModel.reply_count++;
            }
            _commentIng = NO;
        }];
    } else {
        [model commentMememdaParam:aDict mid:_mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            self.commentView.sendBtn.userInteractionEnabled = YES;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [self commentSuccess:data];
                _currentMMDModel.reply_count++;
            }
            _commentIng = NO;
        }];
    }
}

- (void)commentSuccess:(id)data {
    [self.view endEditing:YES];
    [ZZHUD showSuccessWithStatus:@"评论成功"];
    self.commentView.replyId = nil;
    self.commentView.commentNameString = nil;
    ZZCommentModel *model = [[ZZCommentModel alloc] init];
    ZZReplyModel *replyModel = [[ZZReplyModel alloc] initWithDictionary:data error:nil];
    model.reply = replyModel;
    model.sort_value = nil;
    NSMutableDictionary *aDict = [self getCurrentDictionary];
    NSMutableArray *commentArray = [aDict objectForKey:DictComments];
    [commentArray insertObject:model atIndex:0];
    [self setCellData:self.playingCell dict:aDict];
}

- (void)setCellData:(ZZPlayerCell *)cell dict:(NSMutableDictionary *)dict
{
    NSMutableArray *comments = [dict objectForKey:DictComments];
    NSMutableArray *contributions = [dict objectForKey:DictContributions];
    BOOL noMoreData = [[dict objectForKey:DictNomoredata] boolValue];
    [cell setCommentArray:comments contributions:contributions noMoreData:noMoreData];
}
#pragma mark - ViewAnimation

- (void)viewOffset:(CGFloat )cellY isLongVideo:(BOOL)isLongVideo
{
    [self.view endEditing:YES];
    

    if (!_keyboardDidShow && self.playingCell.tableView.contentSize.height != SCREEN_HEIGHT) {
        //长视频判断滑动的偏移
        if (cellY>0) {
                CGFloat scale = 1;
                if (cellY<85) {
                    scale = cellY/85.0;
                }
                [self.commentView normalWhiteStatus:scale];
                scale = 1;
                if (cellY<64) {
                    scale = cellY/64.0;
                }
                [self.navigationView setViewAlphaScale:scale];
            
        } else {
                [self.commentView normalClearStatus];
                [self.navigationView setViewAlphaScale:0];
        }
    }
}


#pragma mark - 首次进入播放的时候话题的处理

/**
 如果是全屏的长视频不处理,如果是短的视屏
 */
- (void)dealWithContentViewWhenFirstIntoPlayer:(BOOL)isShow {
    [self hideContentView:isShow];
}

- (void)hideContentView:(BOOL)hide
{
    if (!hide) {
        [self.commentView normalWhiteStatus:1];
    }else{
        [self.commentView normalClearStatus];
    }
}

- (void)doubleClickTableView
{
    //如果是查看达人，则没有双击点赞
    if (self.isBaseVideo) {
        return;
    }
    [MobClick event:Event_click_player_doubleclick];
    if (![self canDoThings]) {
        return;
    }
    if (_canLoadMore) {
        if (_playType == PlayTypeUserVideo) {
            if (!_userVideo.like_status) {
                if (_userVideo.sk.id) {
                    [self skLikeMethod];
                } else {
                    [self mmdLikeMethod];
                }
            }
        } else {
            if (!_findModel.like_status) {
                if (_findModel.sk.id) {
                    [self skLikeMethod];
                } else {
                    [self mmdLikeMethod];
                }
            }
        }
    } else if (_skDetailModel && !_skDetailModel.like_status) {
        [self skLikeMethod];
    } else if (_mmdDetailModel && !_mmdDetailModel.like_status) {
        [self mmdLikeMethod];
    }
}

- (void)oneClickTableView
{
    if ([self.commentView.textField isFirstResponder]) {
        [self.view endEditing:YES];
        return;
    }
    if (![self canDoThings]) {
        return;
    }
    if (_isScrolling) {
        return;
    }
    if (_isHideViews) {
        [self showViews];
    } else {
        [self hideViews];
    }
}

- (void)showViews
{
//     CGFloat bottomHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [UIView animateWithDuration:0.3 animations:^{
//        self.contentView.top = SCREEN_HEIGHT - bottomHeight;

        self.commentView.top = SCREEN_HEIGHT - 55 - SafeAreaBottomHeight;
        self.navigationView.top = 0;
    } completion:^(BOOL finished) {
        _isHideViews = NO;
        self.navigationView.clipsToBounds = NO;
    }];
}

- (void)hideViews
{
    self.navigationView.clipsToBounds = YES;
//    CGFloat bottomHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [UIView animateWithDuration:0.3 animations:^{
//        self.contentView.top = SCREEN_HEIGHT -bottomHeight;

        self.commentView.top = SCREEN_HEIGHT  -SafeAreaBottomHeight- 55 ;
        self.navigationView.top = -self.navigationView.height;
    } completion:^(BOOL finished) {
        _isHideViews = YES;
    }];
}

#pragma mark - notification

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!self.commentView.textField.isFirstResponder) {
        return;
    }
    self.keyboardDidShow = YES;
    self.collectionView.scrollEnabled = NO;
    [self.commentView keyboardShowStatus];
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSUInteger during = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    [UIView animateWithDuration:during animations:^{
        self.commentView.top = SCREEN_HEIGHT - rect.size.height - self.commentView.height;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.keyboardDidShow) {
        return;
    }
    NSUInteger during = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    [UIView animateWithDuration:during animations:^{
        self.commentView.top = SCREEN_HEIGHT - self.commentView.height;
    } completion:^(BOOL finished) {
        self.keyboardDidShow = NO;
        self.collectionView.scrollEnabled = YES;
        if (self.playingCell.tableView.contentOffset.y>0) {
            [self.commentView normalWhiteStatus:1];
            [self hideContentView:YES];
        } else if(self.playingCell.isLongVideo){
            [self.commentView normalClearStatus];
            [self hideContentView:NO];
        }else {
            [self.commentView normalWhiteStatus:1];
            [self hideContentView:YES];
        }
    }];
}

- (void)updateVideo:(NSNotification *)notification
{
    NSString *mid = [notification.userInfo objectForKey:@"mid"];
    if ([_mid isEqualToString:mid]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_VideoDataShouldUpdate object:nil];
        [self getMMDDetail:YES];
    }
}



- (void)resetData
{
    _offset = 0;
    self.playingCell.process = 0;
    [self.navigationView setViewAlphaScale:0];
//    [self.commentView normalClearStatus];

    self.commentView.commentNameString = nil;
    self.commentView.replyId = nil;
    self.commentView.textField.text = nil;
}

-(void)handleQuickScroll
{
    if (!self.playingCell || !_canLoadMore) return;
    NSArray *visiableCells = [self.collectionView visibleCells];
    
    if (visiableCells.count) {
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (ZZPlayerCell *cell in visiableCells) {
            [indexPaths addObject:cell.indexPath];
        }
        BOOL isPlayingCellVisiable = YES;
        //判断可视区域中的cell 是不是包含当前播放的 ,不包含就让它  重新播放
        if (![indexPaths containsObject:self.playingCell.indexPath]) {
            isPlayingCellVisiable = NO;
        }
        if (!isPlayingCellVisiable || ![self.playingCell.indexPath isEqual:self.currentVideoPath]) {
            if (!_stillPlayWhenFooterStatusChange) {
               //sdk内部已经做过停止了
            } else {
                //上拉加载更多
                _stillPlayWhenFooterStatusChange = NO;
            }
        }
    }
}

- (void)playVideoWithPlayerCell:(ZZPlayerCell *)cell
{
    WEAK_SELF();
    NSArray *visiableCells = [self.collectionView visibleCells];
    if (visiableCells.count) {
        ZZPlayerCell *cell = visiableCells[0];
        WEAK_OBJECT(cell, weakCell);
        weakSelf.playingCell = weakCell;
        
        weakSelf.currentVideoPath = weakCell.indexPath;
        [weakSelf managerData];
        weakCell.imgView.jp_videoPlayerDelegate = weakSelf;
        [self dealWithContentViewWhenFirstIntoPlayer:weakSelf.playingCell.isLongVideo];
        BOOL isPlayer = [self whenWatchDaRenVideoBacKIsFillScreen:weakCell];

        if (self.isBaseVideo&&!isPlayer) {
            weakCell.tableView.backgroundColor = HEXCOLOR(0x010101);
            weakCell.imgView.backgroundColor = HEXCOLOR(0x010101);
            [weakCell.imgView jp_playVideoWithURL:[weakSelf getUrlWithString:weakCell.playerUrlStr] options:JPVideoPlayerContinueInBackground | JPVideoPlayerLayerVideoGravityResizeAspect | JPVideoPlayerShowActivityIndicatorView progress:nil completed:^(NSString * _Nullable fullVideoCachePath, NSError * _Nullable error, JPVideoPlayerCacheType cacheType, NSURL * _Nullable videoURL) {
                if (error == nil) {
                    
                }
            }];
        }else{
            [weakCell.imgView jp_playVideoWithURL:[weakSelf getUrlWithString:weakCell.playerUrlStr] options:JPVideoPlayerContinueInBackground | JPVideoPlayerLayerVideoGravityResizeAspect | JPVideoPlayerShowActivityIndicatorView progress:nil completed:^(NSString * _Nullable fullVideoCachePath, NSError * _Nullable error, JPVideoPlayerCacheType cacheType, NSURL * _Nullable videoURL) {
                if (error == nil) {
                }
            }];
        }

        [weakCell.imgView bringSubviewToFront:weakCell.playerTopicView];
        [weakSelf setInfomation];
        [weakSelf calculateReadCount];
    }
}


/**
 当前为达人视频的话,如果达人视频的宽高比大于1.5就高度适配
 不是的话就自适应

 @param cell 当前播放的cell
 @return yes 拉伸  NO自适应
 */
- (BOOL)whenWatchDaRenVideoBacKIsFillScreen:(ZZPlayerCell *)cell {
    return cell.isDarenVideo;
}


-(void)stopPlay
{
    if (!self.playingCell) {
        return;
    }
    [self.playingCell.imgView jp_stopPlay];
    self.playingCell = nil;
    self.currentVideoPath = nil;
}

- (void)pausePlay
{
    [JPVideoPlayerPlayVideoTool sharedTool].stopWhenAppDidEnterPlayGround = YES;
    [self.playingCell.imgView jp_pause];//暂停
}

- (void)playWithPlayerCell:(ZZPlayerCell *)cell
{
    [JPVideoPlayerPlayVideoTool sharedTool].stopWhenAppDidEnterPlayGround = NO;
    if ([JPVideoPlayerPlayVideoTool sharedTool].currentPlayVideoItem.currentPlayerLayer && !_isPushView) {
        [cell.imgView jp_resume];
    } else {
        _isPushView = NO;
        [self playVideoWithPlayerCell:cell];
    }
}



#pragma mark - UIButtonMethod

- (void)leftBtnClick
{
    [MobClick event:Event_click_player_cancel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zanBtnClick
{
    [MobClick event:Event_click_player_zan];
    if (![self canDoThings]) {
        return;
    }
    BOOL likeStatus = NO;
    if (_findModel || _userVideo) {
        if (_playType == PlayTypeUserVideo) {
            likeStatus = _userVideo.like_status;
        } else {
            likeStatus = _findModel.like_status;
        }
    } else if (_skDetailModel) {
        likeStatus = _skDetailModel.like_status;
    } else if (_mmdDetailModel) {
        likeStatus = _mmdDetailModel.like_status;
    }
    if (likeStatus) {
        if (_currentSkModel) {
            [self skUnlikeMethod];
        } else {
            [self mmdUnlikeMethod];
        }
    } else {
        if (_currentSkModel) {
            [self skLikeMethod];
        } else {
            [self mmdLikeMethod];
        }
    }
}

/**
 点击显示更多
 */
- (void)moreBtnClick
{
    [MobClick event:Event_click_player_more];
    if (![self canDoThings]) {
        return;
    }
    [self pausePlay];
    BOOL mySelf = NO;
    if (_currentSkModel) {
        if ([_currentSkModel.user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            mySelf = YES;
        }
    } else {
        if ([_currentMMDModel.to.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid] || [_currentMMDModel.from.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            mySelf = YES;
        }
    }
    self.shareView.showDelete = mySelf;
    [self setShareInfomation];
    if (!_haveAddShareView) {
        [self.view addSubview:self.shareView];
        _haveAddShareView = YES;
    } else {
        self.shareView.hidden = NO;
        [self.shareView show];
    }
}

- (void)packetBtnClick
{
    [MobClick event:Event_click_player_packet];
    if ([ZZUtils isConnecting]) {
        return;
    }
    if (![self canDoThings]) {
        return;
    }
    [self pausePlay];
    [ZZHUD showWithStatus:@"获取支付信息..."];
    [self loadBalance];
}

- (void)attentBtnClick
{
    NSIndexPath *indexPath = _currentVideoPath;
    [MobClick event:Event_click_player_attent];
    if (![self canDoThings]) {
        return;
    }
    ZZUser *user = nil;
    if (_currentSkModel) {
        user = _currentSkModel.user;
    } else {
        user = _currentMMDModel.to;
    }
    if (!user.follow_status) {
        [user followWithUid:user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"关注成功"];
                user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
                if (indexPath == _currentVideoPath) {
                    [self.navigationView viewAnimation];
                }
            }
        }];
    } else {
        [user unfollowWithUid:user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"已取消关注"];
                user.follow_status = [[data objectForKey:@"follow_status"] integerValue];
            }
        }];
    }
}

- (BOOL)canDoThings
{
    [self.view endEditing:YES];
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return NO;
    }
    if ([ZZUtils isBan]) {
        return NO;
    }
    if (_findModel || _skDetailModel || _mmdDetailModel || _userVideo) {
        return YES;
    }
    return NO;
}

#pragma mark - JPVideoPlayerDelegate

- (void)playingProgressDidChanged:(CGFloat)playingProgress
{
    self.playingCell.process = playingProgress;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    NSArray *keys = [components allKeys];
    if (keys.count) {
        NSInteger index = [keys[0] integerValue];
        if (_currentMMDModel) {
            if (_currentMMDModel.groups.count > index) {
                ZZMemedaTopicModel *topic = _currentMMDModel.groups[index];
                [self gotoTopicDetail:topic];
            }
        } else {
            if (_currentSkModel.groups.count > index) {
                ZZMemedaTopicModel *topic = _currentSkModel.groups[index];
                [self gotoTopicDetail:topic];
            }
        }
    }
}

- (void)gotoTopicDetail:(ZZMemedaTopicModel *)topic
{
    if (_fromLiveStream) {
        return;
    }
    ZZTopicGroupModel *group = [[ZZTopicGroupModel alloc] init];
    group.groupId = topic.topicID;
    group.content = topic.content;
    group.desc = topic.desc;
    ZZTopicDetailViewController *controller = [[ZZTopicDetailViewController alloc] init];
    controller.groupModel = group;
    controller.groupId = topic.topicID;
    _isViewPush = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Private

- (void)setFirstFindModel:(ZZFindVideoModel *)firstFindModel
{
    _findModel = firstFindModel;
    _currentSkModel = firstFindModel.sk;
    _currentMMDModel = firstFindModel.mmd;
    [self setInfomation];
    self.currentVideoPath = self.dataIndexPath;
    [self managerData];
    [self.collectionView reloadData];
    [self loadComment:_currentVideoPath];
   
//    [self loadContribution:_currentVideoPath];//获取打赏
}

- (void)setUserVideo:(ZZUserVideoListModel *)userVideo
{
    _userVideo = userVideo;
    _currentSkModel = userVideo.sk;
    _currentMMDModel = userVideo.mmd;
    [self setInfomation];
    self.currentVideoPath = self.dataIndexPath;
    [self managerData];
    [self.collectionView reloadData];
    [self loadComment:_currentVideoPath];
//    [self loadContribution:_currentVideoPath];//获取打赏
}

- (void)setFirstSkModel:(ZZSKModel *)firstSkModel
{
    _currentSkModel = firstSkModel;
    [self.collectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self loadComment:indexPath];
//    [self loadContribution:indexPath];//获取打赏
}

- (void)setFirstMMDModel:(ZZMMDModel *)firstMMDModel
{
    _currentMMDModel = firstMMDModel;
    [self.collectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self loadComment:indexPath];
//    [self loadContribution:indexPath];//获取打赏
}
//底部和顶部赋值
- (void)setInfomation
{
    if (_currentSkModel) {
        [self.navigationView setSKData:_currentSkModel];
//        self.contentView.skModel = _currentSkModel;
        self.playingCell.topicModel = _currentSkModel;
        [self.playingCell.tableView reloadData];

    } else {
        [self.navigationView setMMDData:_currentMMDModel];
//        self.contentView.mmdModel = _currentMMDModel;
        self.playingCell.topicModel = _currentMMDModel;
        [self.playingCell.tableView reloadData];
    }
    if (_canLoadMore) {
        if (_playType == PlayTypeUserVideo) {
            self.navigationView.like_status = _userVideo.like_status;
        } else {
            self.navigationView.like_status = _findModel.like_status;
        }
    } else if (_skDetailModel) {
        self.navigationView.like_status = _skDetailModel.like_status;
    } else {
        self.navigationView.like_status = _mmdDetailModel.like_status;
    }
//    CGFloat bottomHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    if (_isHideViews) {
//        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, bottomHeight);
//    } else {
//        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT - bottomHeight, SCREEN_WIDTH, bottomHeight);
//    }
}

- (void)managerData
{
    
    if (_canLoadMore) {
        if (self.currentVideoPath.row >= self.videoArray.count) {
            return;
        }
        if (_playType == PlayTypeUserVideo) {
            ZZUserVideoListModel *model = self.videoArray[self.currentVideoPath.row];
            _userVideo = model;
            _skId = model.sk.id;
            _mid = model.mmd.mid;
            _currentSkModel = model.sk;
            _currentMMDModel = model.mmd;
        }
        else {
            ZZFindVideoModel *model = self.videoArray[self.currentVideoPath.row];
            _findModel = model;
            _skId = model.sk.id;
            _mid = model.mmd.mid;
            _currentSkModel = _findModel.sk;
            _currentMMDModel = _findModel.mmd;
        }
    }
    NSMutableDictionary *aDict = [self getCurrentDictionary];
    BOOL haveValue = YES;
    if (!aDict) {
        haveValue = NO;
        aDict = [NSMutableDictionary dictionary];
    }
    NSMutableArray *contributions = [aDict objectForKey:DictContributions];
    if (_canLoadMore) {
        NSMutableArray *comments = [aDict objectForKey:DictComments];
        if (!haveValue) {
            comments = [NSMutableArray array];
            contributions = [NSMutableArray array];
        }
        if (_playType == PlayTypeUserVideo) {
            if (!haveValue) {
                if (_userVideo.sk.id) {
                    [contributions addObjectsFromArray:_userVideo.sk_tips];
                } else {
                    [contributions addObjectsFromArray:_userVideo.mmd_tips];
                }
            }
        } else {
            if (!haveValue) {
                if (_findModel.sk.id) {
                    [contributions addObjectsFromArray:_findModel.sk_tips];
                } else {
                    [contributions addObjectsFromArray:_findModel.mmd_tips];
                }
            }
        }
        [aDict setObject:comments forKey:DictComments];
        [aDict setObject:contributions forKey:DictContributions];
    } else {
        contributions = [NSMutableArray array];
        _currentSkModel = _skDetailModel.sk;
        _currentMMDModel = _mmdDetailModel.mmd;
        if (_skDetailModel.sk_tips.count) {
            [contributions addObjectsFromArray:_skDetailModel.sk_tips];
        }
        if (_mmdDetailModel.mmd_tips.count) {
            [contributions addObjectsFromArray:_mmdDetailModel.mmd_tips];
        }
        [aDict setObject:contributions forKey:DictContributions];
    }
    [self setCacheDictValue:aDict];
}



- (NSMutableDictionary *)getCurrentDictionary
{
    return [self.cacheMessageDict objectForKey:[self getCurrentCachekey]];
}

- (void)setCacheDictValue:(NSMutableDictionary *)aDict
{
    NSString *key = [self getCurrentCachekey];
    if (aDict && !isNullString(key)) {
        [self.cacheMessageDict setObject:aDict forKey:key];
    }
}

- (NSString *)getCurrentCachekey
{
    if (_skId) {
        return _skId;
    }
    else {
        return _mid;
    }
}

#pragma mark - 更多的事件(举报、删除)

- (void)reportMethod
{
    ZZReportViewController *controller = [[ZZReportViewController alloc] init];
    if (_currentSkModel) {
        controller.uid = _currentSkModel.user.uid;
        controller.skId = _currentSkModel.id;
    } else {
        controller.uid = _currentMMDModel.to.uid;
        controller.mid = _currentMMDModel.mid;
    }
    ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navCtl animated:YES completion:NULL];
}
/**
 删除视屏
 */
- (void)deleteMethod
{
    NSIndexPath *indexPath = _currentVideoPath;
    if (_currentSkModel) {
        [ZZSKModel deleteSKWithSkId:_currentSkModel.id param:nil  next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [JPVideoPlayerPlayVideoTool sharedTool].stopWhenAppDidEnterPlayGround = NO;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
                [self playWithPlayerCell:self.playingCell];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_VideoDataShouldUpdate object:nil];
                [ZZHUD showSuccessWithStatus:@"瞬间已删除"];
                [ZZUserHelper shareInstance].upDateVideoList = YES;
                if (_canLoadMore&&indexPath.row!=0&&indexPath.section!=0&&indexPath !=nil) {
                    [self deleteObjectWithIndexPath:indexPath];
                } else {
                  
                    [self.navigationController popViewControllerAnimated:YES];
                }
                if (_deleteCallBack) {
                    _deleteCallBack();
                }
            }
        }];
    } else {
        if (_currentMMDModel.can_del) {
            [self showOkCancelAlert:@"删除该条么么答" 
                            message:@"删除么？"
                       confirmTitle:@"确认删除"
                     confirmHandler:^(UIAlertAction * _Nonnull action) {
                [self deleteRequest:indexPath];
            } cancelTitle:@"取消" cancelHandler:^(UIAlertAction * _Nonnull action) {
                [self playWithPlayerCell:self.playingCell];
            }];
        } else {
            if (_currentMMDModel.is_anonymous) {
                [self showOkAlert:@"提示" message:_currentMMDModel.del_msg confirmTitle:@"确定" confirmHandler:^(UIAlertAction * _Nonnull action) {
                    [self playWithPlayerCell:self.playingCell];
                }];
            } else {
                [self showOkCancelAlert:@"提示"
                                message:_currentMMDModel.del_msg
                           confirmTitle:@"联系对方"
                         confirmHandler:^(UIAlertAction * _Nonnull action) {
                    [self gotoChatView];
                } cancelTitle:@"取消" cancelHandler:^(UIAlertAction * _Nonnull action) {
                    [self playWithPlayerCell:self.playingCell];
                }];
            }
        }
    }
}

- (void)deleteRequest:(NSIndexPath *)indexPath
{
    [ZZMemedaModel deleteMemeda:_currentMMDModel.mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [JPVideoPlayerPlayVideoTool sharedTool].stopWhenAppDidEnterPlayGround = NO;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            [self playWithPlayerCell:self.playingCell];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_VideoDataShouldUpdate object:nil];
            [ZZHUD showSuccessWithStatus:@"么么答已删除"];
            if (_canLoadMore) {
                [self deleteObjectWithIndexPath:indexPath];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (_deleteCallBack) {
                _deleteCallBack();
            }
        }
    }];
}

- (void)deleteObjectWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"PY_崩溃");
    [self.videoArray removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    if (indexPath == _currentVideoPath) {
        [self stopPlay];
        [self handleScrollStop];
    }
}

#pragma mark - 重新录制视频

- (void)reRecordVideo {
    BOOL contain = NO;
    NSString *key = [NSString stringWithFormat:@"%@%@",[ZZStoreKey sharedInstance].uploadFailureVideo,[ZZUserHelper shareInstance].loginerId];
    NSArray *array = [ZZKeyValueStore getValueWithKey:key tableName:kTableName_VideoSave];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *aDict in array) {
        NSInteger type = [[aDict objectForKey:@"type"] integerValue];
        NSString *url = [aDict objectForKey:@"url"];
        NSString *mid = [aDict objectForKey:@"mid"];
        url = [NSString stringWithFormat:@"%@/%@",[ZZFileHelper createPathWithChildPath:video_savepath],url];
        if (type != 0)  {
            NSDate *expiredDate = [[ZZDateHelper shareInstance] getDateWithDateString:[aDict objectForKey:@"expiredTime"]];
            if ([[NSDate date] compare:expiredDate] == NSOrderedAscending) {
                if ([mid isEqualToString:_currentMMDModel.mid]) {
                    contain = YES;
                    [self pausePlay];
                    
                    [self showAlertActions:@"提示"
                                   message:@"您重新录制的视频上传失败了"
                                   actions:@[
                        [alertAction createWithTitle:@"重新上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            ZZVideoUploadStatusView *statusView = [ZZVideoUploadStatusView sharedInstance];
                            statusView.videoDict = aDict;
                            [statusView showBeginStatusView];
                            [self playWithPlayerCell:self.playingCell];
                        }],
                        
                        [alertAction createWithTitle:@"删除并重录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:url] error:nil];
                            [tempArray removeObject:aDict];
                            [ZZKeyValueStore saveValue:tempArray key:key tableName:kTableName_VideoSave];
                            [self gotoRecordView];
                            [self playWithPlayerCell:self.playingCell];
                        }],
                    ]];
                    break;
                }
            } else {
                [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:url] error:nil];
                [tempArray removeObject:aDict];
            }
        }
    }
    [ZZKeyValueStore saveValue:tempArray key:key tableName:kTableName_VideoSave];
    
    if (!contain) {
        [self gotoRecordView];
    }
}

#pragma mark - Navigation

- (void)gotoRecordView
{
    if (_fromLiveStream) {
        return;
    }
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            [self pushRecordView];
        }
    }];
}

- (void)pushRecordView
{
    ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
    controller.type = RecordTypeUpdateMemeda;
    controller.model = _currentMMDModel;
    ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navCtl animated:YES completion:nil];
}

- (void)gotoUserPage:(BOOL)isBottom
{
    [self.view endEditing:YES];
    if (isBottom) {
        [self gotoUserPageWithUid:_currentMMDModel.from.uid];
    } else if (_currentSkModel) {
        [self gotoUserPageWithUid:_currentSkModel.user.uid];
    } else {
        [self gotoUserPageWithUid:_currentMMDModel.to.uid];
    }
}

- (void)gotoUserPageWithUid:(NSString *)uid
{
    [self gotoUserPageToBuyWX:NO uid:uid];
}

// 查看微信
- (void)gotoUserPageToBuyWX:(BOOL)wx uid:(NSString *)uid
{
    if (_fromLiveStream) {
        return;
    }
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = uid;
    controller.showWX = wx;
    _isViewPush = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoContributionView
{
    if (_fromLiveStream) {
        return;
    }
    [self.view endEditing:YES];
    ZZContributionViewController *controller = [[ZZContributionViewController alloc] init];
    if (_currentSkModel) {
        controller.skId = _currentSkModel.id;
    } else {
        controller.mid = _currentMMDModel.mid;
    }
    _isPushView = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoChatView
{
    if (_fromLiveStream) {
        return;
    }
    [JPVideoPlayerPlayVideoTool sharedTool].stopWhenAppDidEnterPlayGround = NO;
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    [ZZRCUserInfoHelper setUserInfo:_currentMMDModel.from];
    controller.user = _currentMMDModel.from;
    controller.nickName = _currentMMDModel.from.nickname;
    controller.uid = _currentMMDModel.from.uid;
    controller.portraitUrl = _currentMMDModel.from.avatar;
    _isViewPush = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)createAlertView
{
    WeakSelf;
    if (!_alertView) {
        _alertView = [[ZZVideoAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertView.fromLiveStream = _fromLiveStream;
        _alertView.ctl = weakSelf;
        _alertView.type = AlertPayTypeDashang;
        _alertView.moneyArray = @[@"2.2",@"3.6",@"5.2",@"6.6",@"8.8",@"9.9",@"12",@"15",@"18"];
        if ([ZZUserHelper shareInstance].configModel) {
            _alertView.inputTF.placeholder = [NSString stringWithFormat:@"%@~2000",[ZZUserHelper shareInstance].configModel.mmd.tip_min_price];
        } else {
            _alertView.inputTF.placeholder = @"2~2000";
        }
        if (_currentSkModel) {
            _alertView.user = _currentSkModel.user;
            _alertView.skId = _currentSkModel.id;
            _alertView.serviceScale = [ZZUserHelper shareInstance].configModel.yj.sk_tip;
        } else {
            _alertView.user = _currentMMDModel.to;
            _alertView.mid = _currentMMDModel.mid;
            _alertView.serviceScale = [ZZUserHelper shareInstance].configModel.yj.mmd_tip;
        }
        if ([ZZUserHelper shareInstance].lastPacketMoney) {
            _alertView.inputTF.text = [ZZUserHelper shareInstance].lastPacketMoney;
        }
        [_alertView calculatePrice];
        _alertView.payCallBack = ^{
//            [weakSelf loadContribution:weakSelf.currentVideoPath];//获取打赏
            [weakSelf playWithPlayerCell:weakSelf.playingCell];
        };
        _alertView.rechargeCallBack = ^{
            [ZZHUD showWithStatus:@"充值成功，余额更新中..."];
            [weakSelf loadBalance];
        };
        _alertView.touchCancel = ^{
    [weakSelf playWithPlayerCell:weakSelf.playingCell];        };
        [self.view addSubview:_alertView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertView.inputTF becomeFirstResponder];
        });
    } else {
        if (_currentSkModel) {
            _alertView.user = _currentSkModel.user;
            _alertView.skId = _currentSkModel.id;
        } else {
            _alertView.user = _currentMMDModel.to;
            _alertView.mid = _currentMMDModel.mid;
        }
        _alertView.hidden = NO;
        [_alertView showFirstResponder];
        [_alertView showInfoText];
    }
}

- (void)gotoChangePhoneView
{
    if (_fromLiveStream) {
        return;
    }
    ZZChangePhoneViewController *controller = [[ZZChangePhoneViewController alloc] init];
    controller.user = [ZZUserHelper shareInstance].loginer;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showWXNumber {
    
    WEAK_SELF();
    self.wxCopyView = [ZZCheckWXView new];
    self.wxCopyView.wxNumber = self.rentUser.wechat.no;
    [self.wxCopyView setCopyWXBlock:^{
        [weakSelf showOkCancelAlert:@"复制微信号" message:nil confirmTitle:@"复制" confirmHandler:^(UIAlertAction * _Nonnull action) {
            [MobClick event:Event_click_userpage_wx_copy];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = weakSelf.rentUser.wechat.no;
            [ZZHUD showSuccessWithStatus:@"已保存至粘贴板"];
        } cancelTitle:@"取消" cancelHandler:nil];
    }];
    [self.wxCopyView setDoneBlock:^{
        weakSelf.isShowWXCopyView = NO;
        [weakSelf.wxCopyView dismiss];
    }];
    
    [self.wxCopyView show:YES];
}

#pragma mark - Lazyload

- (ZZWXPayAlertView *)wxAlertView
{
    WeakSelf;
    if (!_wxAlertView) {
        _wxAlertView = [[ZZWXPayAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _wxAlertView.ctl = weakSelf;
        [self.view.window addSubview:_wxAlertView];
        _wxAlertView.touchChangePhone = ^{
            [weakSelf gotoChangePhoneView];
        };
        _wxAlertView.rechargeCallBack = ^{
            [ZZHUD showWithStatus:@"充值成功，余额更新中..."];
            // 更新余额
            [weakSelf showBuyWX];
        };
        _wxAlertView.paySuccess = ^(NSString *channel) {
            [weakSelf getWXNumber:channel];
        };
    }
    return _wxAlertView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[ZZCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        [_collectionView registerClass:[ZZPlayerCell class] forCellWithReuseIdentifier:playerCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = !self.isBaseVideo;
    }
    return _collectionView;
}

- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray arrayWithArray:self.dataArray];
    }
    return _videoArray;
}

- (ZZPlayerNavigationView *)navigationView
{
    WeakSelf;
    if (!_navigationView) {
        _navigationView = [[ZZPlayerNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _navigationView.isBaseVideo = self.isBaseVideo;
        _navigationView.touchLeft = ^{
            [weakSelf leftBtnClick];
        };
        _navigationView.touchMore = ^{
            [weakSelf moreBtnClick];
        };
        _navigationView.touchZan = ^{
            [weakSelf zanBtnClick];
        };
        _navigationView.touchAttent = ^{
            [weakSelf attentBtnClick];
        };
        _navigationView.touchHead = ^{
            if (weakSelf.canPop) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf gotoUserPage:NO];
            }
        };
        _navigationView.touchWX = ^(NSString *uid){
            //查看微信
            [MobClick event:Event_click_player_wx];
            if (weakSelf.isShowWXCopyView) {
                return ;
            }
            weakSelf.isShowWXCopyView = YES;
            if ([ZZUtils isUserLogin]) {
                
                [ZZHUD show];
                [weakSelf touchWXWithUid:uid];
            } else {
                weakSelf.isShowWXCopyView = NO;
            }
        };
        _navigationView.touchRecord = ^{
            [weakSelf reRecordVideo];
        };
    }
    return _navigationView;
}

- (ZZPlayerBottomCommentView *)commentView
{
    WeakSelf;
    if (!_commentView) {
        _commentView = [[ZZPlayerBottomCommentView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 55 - SafeAreaBottomHeight, SCREEN_WIDTH, 55+SafeAreaBottomHeight)];
        _commentView.hidden = self.isBaseVideo;
        _commentView.touchPacket = ^{
            [weakSelf packetBtnClick];
        };
        _commentView.sendComment = ^(NSString *comment, NSString *replyId){
            [weakSelf commentWithContent:comment replyId:replyId];
        };
    }
    return _commentView;
}

- (ZZRightShareView *)shareView
{
    WeakSelf;
    if (!_shareView) {
        
        ZZUser *user = nil;
        if (_findModel.sk.user) {
            user = _findModel.sk.user;
        }
        else if (_findModel.mmd.from) {
            user = _findModel.mmd.from;
        }
        BOOL isMine = [[ZZUserHelper shareInstance].loginer.uid isEqualToString:user.uid];
        _shareView = [[ZZRightShareView alloc] initWithFrame:[UIScreen mainScreen].bounds withController:weakSelf shouldShowNotIntersted: isMine ? NO : _isShowNotInterested blackList:isMine ? NO : _isShowBlackList isBanned:_isBan];
        _shareView.touchCancel = ^{
    [weakSelf playWithPlayerCell:weakSelf.playingCell];        };
        _shareView.touchDelete = ^{
    [weakSelf playWithPlayerCell:weakSelf.playingCell];
            
            [weakSelf showOkCancelAlert:nil
                            message:@"是否确定删除该视频"
                       confirmTitle:@"确定"
                     confirmHandler:^(UIAlertAction * _Nonnull action) {
                [weakSelf deleteMethod];
            } cancelTitle:@"取消" cancelHandler:nil];
        };
        _shareView.touchNotIntersted = ^{
            [ZZHUD showTaskInfoWithStatus:@"操作成功 ，将减少此类内容推荐"];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSMutableArray<NSString *> *muArray = [[userDefault objectForKey:@"UserVideoNotIntersted"] mutableCopy];
            if (!muArray) {
                muArray = @[].mutableCopy;
            }
            
            NSString *vid = nil;
            if (weakSelf.skDetailModel.sk.id && ![muArray containsObject:weakSelf.skDetailModel.sk.id]) {
                vid = weakSelf.skDetailModel.sk.id;
            }
            else if (weakSelf.mmdDetailModel.mmd.mid && ![muArray containsObject:weakSelf.mmdDetailModel.mmd.mid]) {
                vid = weakSelf.mmdDetailModel.mmd.mid;
            }
            
            if (![muArray containsObject:vid] && !isNullString(vid)) {
                [muArray addObject:vid];
            }
            
            [userDefault setObject:muArray.copy forKey:@"UserVideoNotIntersted"];
            [userDefault synchronize];
            
            if (weakSelf.notInterstedCallBack) {
                weakSelf.notInterstedCallBack();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        _shareView.touchBlackList = ^{
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            NSMutableArray<NSString *> *muArray = [[userDefault objectForKey:@"BannedVideoPeople"] mutableCopy];
            if (!muArray) {
                muArray = @[].mutableCopy;
            }
            
            NSString *uid = nil;
            if (weakSelf.skDetailModel.sk.user.uid && ![muArray containsObject:weakSelf.skDetailModel.sk.user.uid]) {
                uid = weakSelf.skDetailModel.sk.user.uid;
            }
            else if (weakSelf.mmdDetailModel.mmd.from.uid && ![muArray containsObject:weakSelf.mmdDetailModel.mmd.from.uid]) {
                uid = weakSelf.mmdDetailModel.mmd.from.uid;
            }
            
            if (!isNullString(uid)) {
                if ([muArray containsObject:uid]) {
                    if (weakSelf.isBan) {
                        [muArray removeObject:uid];
                    }
                }
                else {
                    [muArray addObject:uid];
                }
            }
            
            [userDefault setObject:muArray.copy forKey:@"BannedVideoPeople"];
            [userDefault synchronize];
            
            if (weakSelf.isBan) {
                [ZZUser removeBlackWithUid:uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    } else if (data) {
                        weakSelf.isBan = NO;
                        
                        
                    }
                }];
            }
            else {
                [ZZUser addBlackWithUid:uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    }
                    else if (data) {
                        weakSelf.isBan = YES;
                    }
                }];
            }
            
            if (weakSelf.vBannedCallBack) {
                weakSelf.vBannedCallBack(uid);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _shareView;
}
- (ZZPlayerGuideView *)guideView
{
    if (!_guideView) {
        _guideView = [[ZZPlayerGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _guideView;
}
- (NSMutableDictionary *)cacheMessageDict
{
    if (!_cacheMessageDict) {
        _cacheMessageDict = [NSMutableDictionary dictionary];
    }
    return _cacheMessageDict;
}
- (void)dealloc
{
    [self removeNotification];
    [self stopPlay];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[JPVideoPlayerCache sharedCache] clearDiskOnCompletion:^{
        NSLog(@"清除成功");
    }];
}

/**
 查询是否是黑名单
 */
- (void)getBanStatus {
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:self.uid success:^(int bizStatus) {
        if (bizStatus == 0) {
            _isBan = YES;
        } else {
            _isBan = NO;
        }
        NSLog(@"是否是黑名单%d",_isBan);
    } error:^(RCErrorCode status) {
        NSLog(@"查询失败");
    }];
}
@end
