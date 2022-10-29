//
//  ZZPlayerViewController+ZZProxys.m
//  zuwome
//
//  Created by 潘杨 on 2018/2/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//用于获取服务器数据接口的
#import "ZZPlayerViewController+ZZUIColletionView.h"

#import "ZZPlayerViewController+ZZProxys.h"
#import "ZZPlayerCell.h"
#import "ZZAFNHelper.h"
#import "ZZMMDTipModel.h"
#import "ZZWXViewController.h"
#import "ZZWeiChatEvaluationModel.h"
#import "ZZWeiChatEvaluationManager.h"

@implementation ZZPlayerViewController (ZZProxys)
- (void)loadBalance
{
    [[ZZUserHelper shareInstance].loginer getBalance:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [self playWithPlayerCell:self.playingCell];
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            //更新余额
            ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
            loginer.balance = data[@"balance"];
            [[ZZUserHelper shareInstance] saveLoginer:loginer postNotif:NO];
            
            [self createAlertView];
        }
    }];
}

- (void)mmdUnlikeMethod
{
    ZZFindVideoModel *findModel = self.findModel;
    ZZUserVideoListModel *videoModel = self.userVideo;
    ZZMMDModel *model = self.currentMMDModel;
    [ZZMemedaModel unzanMemeda:self.currentMMDModel next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            findModel.like_status = NO;
            videoModel.like_status = NO;
            self.mmdDetailModel.like_status = NO;
            if (model == self.currentMMDModel) {
                self.navigationView.animateLikeStatus = NO;
                [self.navigationView setMMDData:model];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_MMD_Zan_Status object:findModel == nil ? videoModel : findModel];
        }
    }];
}

#pragma mark - 分享事件

- (void)setShareInfomation
{
    if (self.currentSkModel) {
        self.shareView.shareUrl = [NSString stringWithFormat:@"%@/sk/%@/page", kBase_URL, self.currentSkModel.id];
        if (isNullString(self.currentSkModel.content)) {
            self.shareView.shareTitle = [NSString stringWithFormat:@"瞬间"];
        } else {
            self.shareView.shareTitle = [NSString stringWithFormat:@"瞬间｜%@",self.currentSkModel.content];
        }
        self.shareView.shareContent = [NSString stringWithFormat:@"%@在【空虾】发布了新的瞬间", self.currentSkModel.user.nickname];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:self.currentSkModel.video.cover_url];
        self.shareView.shareImg = image;
        self.shareView.uid = self.currentSkModel.user.uid;
        self.shareView.userImgUrl = self.currentSkModel.video.cover_url;
        if ([self.currentSkModel.user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            self.shareView.itemCount = 4;
        } else {
            self.shareView.itemCount = 5;
        }
        self.shareView.skId = self.currentSkModel.id;
        
    } else {
        self.shareView.shareUrl = [NSString stringWithFormat:@"/%@mmd/%@/page", kBase_URL, self.currentMMDModel.mid];
        self.shareView.shareTitle = [NSString stringWithFormat:@"么么答｜%@",self.currentMMDModel.content];
        self.shareView.shareContent = [NSString stringWithFormat:@"%@在「空虾」用视频回答了这个问题，快去看看", self.currentMMDModel.to.nickname];
        self.shareView.uid = self.currentMMDModel.to.uid;
        ZZMMDAnswersModel *answerModel = self.currentMMDModel.answers[0];
        self.shareView.userImgUrl = answerModel.video.cover_url;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:answerModel.video.cover_url];
        self.shareView.shareImg = image;
        if ([self.currentMMDModel.to.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            self.shareView.itemCount = 4;
        } else {
            self.shareView.itemCount = 5;
        }
        self.shareView.mid = self.currentMMDModel.mid;
    }
}

- (void)getWXNumber:(NSString *)channel
{
    NSDictionary *aDict;
    if ([ZZUserHelper shareInstance].charge_id) {
        aDict = @{@"charge_id":[ZZUserHelper shareInstance].charge_id,
                  @"channel":channel};
    }
    WEAK_SELF();
    ZZUser *user = self.rentUser;
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/wechat",user.uid] params:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
         [ZZHUD showTaskInfoWithStatus:@"复制成功，前往微信添加"];
            NSString *wxNumber = [data objectForKey:@"wechat_no"];
            if (user.wechat) {
                user.wechat.no = wxNumber;
            } else {
                ZZWechat *wechat = [[ZZWechat alloc] init];
                wechat.no = wxNumber;
                user.wechat = wechat;
            }
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = user.wechat.no;
            user.can_see_wechat_no = YES;
            self.rentUser = user;
            [weakSelf showWXNumber];
        }
    }];
}

#pragma mark - loaddata

- (void)loadMoreData
{
    switch (self.playType) {
        case PlayTypeFindHot:
        case PlayTypeTopicHot:
        {
            ZZFindVideoModel *model = [self.videoArray lastObject];
            [self pullRequest:nil soor_value1:model.sort_value1 sort_value2:model.sort_value2 current_type:nil];
        }
            break;
        case PlayTypeFindNew:
        case PlayTypeTopicNew:
        {
            ZZFindVideoModel *model = [self.videoArray lastObject];
            [self pullRequest:model.sort_value soor_value1:nil sort_value2:nil current_type:nil];
        }
            break;
        case PlayTypeRecommend:
        {
            ZZFindVideoModel *model = [self.videoArray lastObject];
            [self pullRequest:model.sort_value soor_value1:nil sort_value2:nil current_type:model.current_type];
        }
            break;
        case PlayTypeUserVideo:
        {
            ZZUserVideoListModel *model = [self.videoArray lastObject];
            [self pullRequest:model.sort_value soor_value1:nil sort_value2:nil current_type:nil];
        }
            break;
        default:
            break;
    }
}

- (void)pullRequest:(NSString *)sort_value soor_value1:(NSString *)sort_value1 sort_value2:(NSString *)sort_value2 current_type:(NSString *)current_type
{
    NSMutableDictionary *aDict = [@{} mutableCopy];
    BOOL loadMore = NO;
    switch (self.playType) {
        case PlayTypeFindHot:
        case PlayTypeTopicHot:
        {
            [aDict setObject:@"hot" forKey:@"type"];
        }
            break;
        case PlayTypeFindNew:
        case PlayTypeTopicNew:
        {
            [aDict setObject:@"latest" forKey:@"type"];
        }
            break;
        case PlayTypeRecommend:
        {
            if (self.location) {
                [aDict setObject:[NSNumber numberWithFloat:self.location.coordinate.latitude] forKey:@"lat"];
                [aDict setObject:[NSNumber numberWithFloat:self.location.coordinate.longitude] forKey:@"lng"];
            }
            if (sort_value) {
                if (!isNullString(current_type)) {
                    [aDict setObject:current_type forKey:@"current_type"];
                }
            }
        }
            break;
        default:
            break;
    }
    if (sort_value) {
        [aDict setObject:sort_value forKey:@"sort_value"];
        loadMore = YES;
    }
    if (sort_value1 && sort_value2) {
        [aDict setObject:sort_value1 forKey:@"sort_value1"];
        [aDict setObject:sort_value2 forKey:@"sort_value2"];
        loadMore = YES;
    }
    self.isLoadingData = YES;
    switch (self.playType) {
        case PlayTypeRecommend:
        {
            [ZZFindVideoModel getRecommendVideList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                [self dealData:data error:error loadMore:loadMore];
            }];
        }
            break;
        case PlayTypeFindHot:
        case PlayTypeFindNew:
        {
            if (!isNullString(self.groupId)) {
                [aDict setObject:self.groupId forKey:@"groupId"];
            }
            [ZZFindVideoModel getFindVideoList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                [self dealData:data error:error loadMore:loadMore];
            }];
        }
            break;
        case PlayTypeTopicNew:
        case PlayTypeTopicHot:
        {
            [ZZFindVideoModel getTopicVideoList:aDict groupId:self.groupId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                [self dealData:data error:error loadMore:loadMore];
            }];
        }
            break;
        case PlayTypeUserVideo:
        {
            [ZZUserVideoListModel getUserPageVideoList:aDict uid:self.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                [self dealData:data error:error loadMore:loadMore];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)dealData:(id)data error:(ZZError *)error loadMore:(BOOL)loadMore
{
    self.stillPlayWhenFooterStatusChange = YES;
    self.isLoadingData = NO;
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else {
        NSMutableArray *array;
        if (self.playType == PlayTypeUserVideo) {
            array = [ZZUserVideoListModel arrayOfModelsFromDictionaries:data error:nil];
        }
        else {
            array = [ZZFindVideoModel arrayOfModelsFromDictionaries:data error:nil];
        }
        if (array.count == 0) {
            self.noMoreData = YES;
        }
        if (!loadMore) {
            [self.videoArray removeAllObjects];
        }
        if (self.playType != PlayTypeUserVideo) {
            for (ZZFindVideoModel *model in array) {
                if (!model.group.groupId) {
                    [self.videoArray addObject:model];
                }
            }
        } else {
            [self.videoArray addObjectsFromArray:array];
        }
        
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadData];
            [NSObject asyncWaitingWithTime:0.001 completeBlock:^{
                [self handleScrollStop];
            }];
        }];
    }
}

- (void)getSKDetail
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (self.isBaseVideo) {
        [dic setObject:@(YES) forKey:@"is_base_video"];
    }
    
    [ZZSKModel getSKDetail:self.skId params:dic next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            self.isBeDeleted = YES;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ZZHUD dismiss];
            self.skDetailModel = [[ZZSKDetailModel alloc] initWithDictionary:data error:nil];
            BOOL shouldPaly = NO;
            if (!self.currentSkModel) {
                shouldPaly = YES;
            }
            [self managerData];
            [self setInfomation];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            ZZPlayerCell *cell = (ZZPlayerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.isBaseVideo = self.isBaseVideo;
            cell.skDataModel = self.currentSkModel;
            [self setCellData:cell dict:[self getCurrentDictionary]];
            if (shouldPaly) {
                if (self.viewDidAppear) {
                    [self managerPlayStatusWithPlayerCell:cell];
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self loadComment:indexPath];
//                [self loadContribution:indexPath];//获取打赏
            }
        }
    }];
}

- (void)getMMDDetail:(BOOL)isUpdate
{
    __block ZZPlayerCell *cell = nil;
    __block NSIndexPath *indexPath = nil;
    if (self.canLoadMore) {
        NSArray *visiableCells = [self.collectionView visibleCells];
        if (visiableCells.count>0) {
            cell = (ZZPlayerCell *)visiableCells[0];
            indexPath = cell.indexPath;
            self.currentVideoPath = indexPath;
        }
       
    }
    [ZZMemedaModel getMemedaDetaiWithMid:self.mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            self.isBeDeleted = YES;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ZZHUD dismiss];
            self.mmdDetailModel = [[ZZMemedaModel alloc] initWithDictionary:data error:nil];
            BOOL shouldPaly = NO;
            if (!self.currentMMDModel || isUpdate) {
                shouldPaly = YES;
            }
            if (self.canLoadMore) {
                if (indexPath == self.currentVideoPath) {
                    self.currentMMDModel = self.mmdDetailModel.mmd;
                    self.findModel.mmd = self.mmdDetailModel.mmd;
                    self.userVideo.mmd = self.mmdDetailModel.mmd;
                    [self setInfomation];
                    cell.mMDDataModel = self.currentMMDModel;
                    if (self.viewDidAppear) {
                        [self playVideoWithPlayerCell:cell];
                    }
                }
            } else {
                indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                cell = (ZZPlayerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                [self managerData];
                [self setInfomation];
                cell.mMDDataModel = self.currentMMDModel;
                [self setCellData:cell dict:[self getCurrentDictionary]];
            }
            if (self.fromAnswer && !isUpdate) {
                [self managerViewcontrollers];
            }
            
            if (shouldPaly) {
                if (self.viewDidAppear) {
                    [self managerPlayStatusWithPlayerCell:cell];
                }
                [self loadComment:indexPath];
//                [self loadContribution:indexPath];//获取打赏
            }
        }
    }];
}

- (void)configChatVideo {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ZZPlayerCell *cell = (ZZPlayerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self managerData];
    [self setInfomation];
    [cell setCommentArray:nil contributions:nil noMoreData:YES];
    if (self.viewDidAppear) {
        [self managerPlayStatusWithPlayerCell:cell];
    }
}

#pragma mark - 评论、贡献榜
//获取评论
- (void)loadComment:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self getCurrentDictionary];
    NSMutableArray *array = [dict objectForKey:DictComments];
    BOOL noMoreData = [[dict objectForKey:DictNomoredata] boolValue];
    if (array) {
        if (!noMoreData) {
            ZZCommentModel *lastModel = [array lastObject];
            [self pullWithSort_value:lastModel.sort_value indexPath:indexPath];
        }
    } else {
        [self pullWithSort_value:nil indexPath:indexPath];
    }
}

- (void)pullWithSort_value:(NSString *)sort_value indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *param = nil;
    if (sort_value) {
        param = @{@"sort_value":sort_value};
    }
    if (self.skId) {
        [ZZSKModel getSKCommentList:param skId:self.skId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self requestCallBackSort_value:sort_value data:data error:error indexPath:indexPath];
        }];
    } else {
        [ZZMemedaModel getMemedaCommentList:param mid:self.mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [self requestCallBackSort_value:sort_value data:data error:error indexPath:indexPath];
        }];
    }
}

- (void)requestCallBackSort_value:(NSString *)sort_value data:(id)data error:(ZZError *)error indexPath:(NSIndexPath *)indexPath
{
    NSString *value = [self getCurrentCachekey];
    ZZPlayerCell *cell = (ZZPlayerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    UITableView *tableView = nil;
    if (cell) {
        tableView = cell.tableView;
    }
    [tableView.mj_footer endRefreshing];
    [tableView.mj_footer resetNoMoreData];
    NSMutableDictionary *dict = [self.cacheMessageDict objectForKey:value];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    NSMutableArray *comments = [dict objectForKey:DictComments];
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else if (data) {
        NSMutableArray *d = [ZZCommentModel arrayOfModelsFromDictionaries:data error:nil];
        BOOL noMoreData = NO;
        if (d.count == 0) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
            noMoreData = YES;
        }
        if (sort_value) {
            [comments addObjectsFromArray:d];
        } else {
            comments = d;
        }
        [dict setObject:comments forKey:DictComments];
        [dict setObject:[NSNumber numberWithBool:noMoreData] forKey:DictNomoredata];
        [self.cacheMessageDict setObject:dict forKey:value];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setCellData:cell dict:dict];
        });
    }
}

- (void)managerPlayStatusWithPlayerCell:(ZZPlayerCell *)finnalCell
{
    if (finnalCell == nil) {
        return;
    }
    switch ([[ZZAFNHelper shareInstance] reachabilityManager].networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:
        case AFNetworkReachabilityStatusUnknown:
        {
            [ZZHUD showErrorWithStatus:@"无法访问网络"];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            [self playWithPlayerCell:finnalCell];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            if (![ZZUserHelper shareInstance].allow3GPlay) {
                [UIAlertView showWithTitle:@"流量提示" message:@"正在使用移动网络，继续使用可能产生流量费用。" cancelButtonTitle:@"继续使用" otherButtonTitles:@[@"取消"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        [self playVideoWithPlayerCell:finnalCell];
                        [ZZUserHelper shareInstance].allow3GPlay = @"allow3GPlay";
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            } else {
                [self playWithPlayerCell:finnalCell];
            }
        }
            break;
        default:
            break;
    }
}
/*
//获取打赏
- (void)loadContribution:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self getCurrentDictionary];
    if (self.skId) {
        [ZZMMDTipModel getSKThreeTipsSkId:self.skId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                NSMutableArray *array = [ZZMMDTipsModel arrayOfModelsFromDictionaries:[data objectForKey:@"sk_tips"] error:nil];
                [dict setValue:[NSNumber numberWithBool:YES] forKey:DictHaveRequestContribution];
                if (array.count != 0) {
                    ZZPlayerCell *cell = (ZZPlayerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    [dict setValue:array forKey:DictContributions];
                    [self setCellData:cell dict:dict];
                }
            }
        }];
    } else {
        [ZZMMDTipModel getMMDThreeTipsMid:self.mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                NSMutableArray *array = [ZZMMDTipsModel arrayOfModelsFromDictionaries:[data objectForKey:@"mmd_tips"] error:nil];
                [dict setValue:[NSNumber numberWithBool:YES] forKey:DictHaveRequestContribution];
                if (array.count != 0) {
                    ZZPlayerCell *cell = (ZZPlayerCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    [dict setValue:array forKey:DictContributions];
                    [self setCellData:cell dict:dict];
                }
            }
        }];
    }
}*/
- (void)mmdLikeMethod
{
    ZZFindVideoModel *findModel = self.findModel;
    ZZUserVideoListModel *videoModel = self.userVideo;
    ZZMMDModel *model = self.currentMMDModel;
    [ZZMemedaModel zanMemeda:self.currentMMDModel next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            findModel.like_status = YES;
            videoModel.like_status = YES;
            self.mmdDetailModel.like_status = YES;
            if (model == self.currentMMDModel) {
                self.navigationView.animateLikeStatus = YES;
                [self.navigationView setMMDData:model];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_MMD_Zan_Status object:findModel == nil ? videoModel : findModel];
        }
    }];
}

- (void)skUnlikeMethod
{
    ZZFindVideoModel *findModel = self.findModel;
    ZZUserVideoListModel *videoModel = self.userVideo;
    ZZSKModel *model = self.currentSkModel;
    [ZZSKModel unzanSkWithModel:self.currentSkModel next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            findModel.like_status = NO;
            videoModel.like_status = NO;
            self.skDetailModel.like_status = NO;
            if (model == self.currentSkModel) {
                self.navigationView.animateLikeStatus = NO;
                [self.navigationView setSKData:model];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SK_Zan_Status object:findModel == nil ? videoModel : findModel];
        }
    }];
}
#pragma mark - 点赞事件

- (void)skLikeMethod
{
    ZZFindVideoModel *findModel = self.findModel;
    ZZUserVideoListModel *videoModel = self.userVideo;
    ZZSKModel *model = self.currentSkModel;
    [ZZSKModel zanSkWithModel:model next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            findModel.like_status = YES;
            videoModel.like_status = YES;
            self.skDetailModel.like_status = YES;
            if (model == self.currentSkModel) {
                self.navigationView.animateLikeStatus = YES;
                [self.navigationView setSKData:model];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SK_Zan_Status object:findModel == nil ? videoModel : findModel];
        }
    }];
}

- (void)touchWXWithUid:(NSString *)uid {
    
    WeakSelf;

[ZZUser loadUser:uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
    if (error) {
        weakSelf.isShowWXCopyView = NO;
        [ZZHUD showErrorWithStatus:error.message];
    } else if (data) {
        [ZZHUD dismiss];
        
        ZZUser *user = [ZZUser yy_modelWithJSON:data];
        weakSelf.rentUser = user;
        //当前视频处于的用户
        if (user.can_see_wechat_no) {
            if ([[ZZUserHelper shareInstance].loginerId isEqualToString:user.uid]) {
                // 查看自己微信
                [weakSelf gotoWXView];
                weakSelf.isShowWXCopyView = NO;
            } else {
                // 查看微信窗口
                [weakSelf showWXNumber];
            }
        } else {
            // 购买微信串窗口
            [weakSelf buyWX];
            weakSelf.isShowWXCopyView = NO;
        }
    }
}];
}
// 购买微信查看
- (void)buyWX
{
    ZZUser *user = self.rentUser;
    if (user.can_see_wechat_no) {
        return;
    }
    if ([ZZUtils isConnecting]) {
        return;
    }
    [ZZHUD show];
    [self showBuyWX];
}

// 显示购买微信/更余额
- (void)showBuyWX {
    
    WEAK_SELF();
    [[ZZUserHelper shareInstance].loginer getBalance:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            //更新余额
            ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
            loginer.balance = data[@"balance"];
            [[ZZUserHelper shareInstance] saveLoginer:loginer postNotif:NO];
            
            ZZWeiChatEvaluationModel *model = [[ZZWeiChatEvaluationModel alloc]init];
            model.user = weakSelf.rentUser;
            model.type = PaymentTypeWX;
            model.mcoinForItem = [ZZUserHelper shareInstance].configModel.mcoin_for_id_photo;
            model.fromLiveStream = NO;

            WS(weakSelf);
            [[ZZPaymentManager shared] buyItemWithPayItem:model in:weakSelf buyComplete:^(BOOL isSuccess, NSString * _Nonnull payType) {

                if (isSuccess) {
                    [weakSelf getWXNumber:payType];
                }
            } rechargeComplete:^(BOOL isSuccess) {
                [ZZUser loadUser:weakSelf.rentUser.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    } else if (data) {
                        weakSelf.rentUser = [ZZUser yy_modelWithJSON:data];;
                    }
                }];
            }];
            

        }
    }];
}

- (void)gotoWXView
{
//    WEAK_SELF();
    ZZWXViewController *controller = [[ZZWXViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    controller.wxUpdate = ^{
        //        [weakSelf updateData];
    };
}
@end
