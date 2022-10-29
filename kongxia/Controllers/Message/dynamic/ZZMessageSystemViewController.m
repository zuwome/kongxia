//
//  ZZMessageSystemViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageSystemViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZWXViewController.h"
#import "ZZRegisterRentViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSettingPrivacyViewController.h"
#import "ZZTaskDetailViewController.h"
#import "ZZSkillOptionViewController.h"

#import "ZZMessageSystemTextCell.h"
#import "ZZMessageSystemDetailCell.h"
#import "ZZMessageSystemImageCell.h"
#import "ZZMessageSystemErrorPhotoCell.h"
#import "ZZMessageSystemVideoCell.h"
#import "ZZSelfIntroduceVC.h"
#import "ZZVideoUploadStatusView.h"
#import "ZZFastChatSettingVC.h"
#import "ZZSystemMessageModel.h"
#import "ZZSendVideoManager.h"
#import "ZZServiceChargeVC.h"
#import "ZZPlayerViewController.h"
#import "ZZMessageSystemHideVideoCell.h"
#import "ZZHelpCenterVC.h"//帮助中心
#import "ZZMeBiViewController.h"
#import "ZZNotNetEmptyView.h" //没网络的占位图
#import "ZZAlertNotNetEmptyView.h" // 已经加载过数据下拉加载的时候显示的
#import "HttpDNS.h"//用于网络监测的
#import "ZZMyIntegralViewController.h"
#import "ZZIDPhotoManagerViewController.h"
#import "ZZTasks.h"
@interface ZZMessageSystemViewController () <UITableViewDataSource,UITableViewDelegate, WBSendVideoManagerObserver>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger lastCount;
@property (nonatomic, assign) BOOL isUploading;
@property (nonatomic, strong) ZZVideoUploadStatusView *model;
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;
@end

@implementation ZZMessageSystemViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"系统消息";
    self.view.backgroundColor = kBGColor;
    [GetSendVideoManager() addObserver:self];
    [self createViews];
    [self loadData];
}

- (void)createViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    [_tableView registerClass:[ZZMessageSystemTextCell class] forCellReuseIdentifier:@"textcell"];
    [_tableView registerClass:[ZZMessageSystemDetailCell class] forCellReuseIdentifier:@"contentcell"];
    [_tableView registerClass:[ZZMessageSystemImageCell class] forCellReuseIdentifier:@"imagecell"];
    [_tableView registerClass:[ZZMessageSystemErrorPhotoCell class] forCellReuseIdentifier:@"errorphotocell"];
    [_tableView registerClass:[ZZMessageSystemHideVideoCell class] forCellReuseIdentifier:@"ZZMessageSystemHideVideoCellID"];
    
    [_tableView registerClass:[ZZMessageSystemVideoCell class] forCellReuseIdentifier:@"videocell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.estimatedRowHeight = 40.0;
    [self.view addSubview:_tableView];
    _emptyView =    [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:_tableView.frame viewController:self];
    //    当网络从没网状态到有网状态判断如果当前请求数据为空  就重新请求
    WS(weakSelf);
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    };
}

#pragma mark - Data
- (void)loadData {
    if ([[ZZUserHelper shareInstance].unreadModel.system_msg integerValue]>=0) {
        [ZZUserHelper shareInstance].unreadModel.system_msg = @0;
        [ZZUserHelper shareInstance].updateMessageList = YES;
    }
    __weak typeof(self)weakSelf = self;
    [self pullRequest:nil];
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        ZZSystemMessageModel *model = [weakSelf.dataArray lastObject];
        [weakSelf pullRequest:model.sort_value];
    }];
}

- (void)pullRequest:(NSString *)sort_value {
    NSDictionary *aDict = nil;
    if (sort_value) {
        aDict = @{@"sort_value":sort_value};
    }
    ZZSystemMessageModel *model = [[ZZSystemMessageModel alloc] init];
    WS(weakSelf);
    [model getSystemMessageList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            if (error.code ==1111) {
                if (weakSelf.dataArray.count<=0) {
                    weakSelf.emptyView.hidden = NO;
                }else{
                    weakSelf.emptyView.hidden = YES;
                    [weakSelf.alertEmptyView showView:weakSelf];
                }
            }else{
                [ZZHUD showErrorWithStatus:error.message];
            }
        } else {
            weakSelf.emptyView.hidden = YES;
            [weakSelf.tableView.mj_header endRefreshing];
            NSMutableArray *array = [ZZSystemMessageModel arrayOfModelsFromDictionaries:data error:nil];
            if (sort_value) {
                [weakSelf.dataArray addObjectsFromArray:array];
            } else {
                weakSelf.dataArray = array;
            }
            [weakSelf.tableView reloadData];
            if (!sort_value) {
                if (weakSelf.dataArray.count) {
                    NSUInteger rowCount = weakSelf.dataArray.count;
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:0];
                    [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

                }
            } else {
                if (array.count) {
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:weakSelf.dataArray.count - weakSelf.lastCount inSection:0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    });
                }
            }
            weakSelf.lastCount = weakSelf.dataArray.count;
        }
     
    }];
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZSystemMessageModel *model = _dataArray[_dataArray.count - 1 - indexPath.row];
    
    if (
        [model.message.type isEqualToString:@"base_video"]
        || [model.message.type isEqualToString:@"rent_expired"]
        || [model.message.type isEqualToString:@"qchat_unpass"]
        || [model.message.type isEqualToString:@"video_hot"]
        || [model.message.type isEqualToString:@"withdraw_fail"]
        || [model.message.type isEqualToString:@"score_expired"]
        || [model.message.type isEqualToString:@"score_expired_soon"]
        || [model.message.type isEqualToString:@"id_photo_unpass"]
        || [model.message.type isEqualToString:@"upload_id_photo"]
        || [model.message.type isEqualToString:@"to_order"]
        || [model.message.type isEqualToString:@"see_user_guide"]
        || [model.message.type isEqualToString:@"rent_success"]
        || [model.message.type isEqualToString:@"apply_rent"]   // 申请达人
        || [model.message.type isEqualToString:@"re_upload"]    // 重新上传
        || [model.message.type isEqualToString:@"fill_info"]    // 去完善资料
        || [model.message.type isEqualToString:@"upload_photo"] // 去上传
        || [model.message.type isEqualToString:@"to_show"]      // 去上架
        || [model.message.type isEqualToString:@"to_wechatseen_48"] // 用户查看后48小时双方无操作，则提示24小时内内确认  达人
        || [model.message.type isEqualToString:@"from_wechatseen_48"] // 用户查看后48小时双方无操作，则提示24小时内内确认  用户
        || [model.message.type isEqualToString:@"to_ok_wechatseen_24"] // 达人确认添加后24小时，提示用户24小时内确认用户
        || [model.message.type isEqualToString:@"to_wechatseen_report"] // 达人被举报通知达人
        || [model.message.type isEqualToString:@"to_wechatseen_report_ok"] // 达人被举报成功通知达人
        || [model.message.type isEqualToString:@"pd_before_30minute"] // 邀约时间开始时间前30分钟
        || [model.message.type isEqualToString:@"pdg_before30_minute"] // 活动自动过期
        || [model.message.type isEqualToString:@"pdg_start"] // 活动生成邀约
        || [model.message.type isEqualToString:@"pd_four_refund"] // 无人报名自动结束
        || [model.message.type isEqualToString:@"skill_nopass_photo_msg"] // 技能不合格通知类型
        || [model.message.type isEqualToString:@"skill_photo_msg"] //  技能系统消息
        || [model.message.type isEqualToString:@"skill_nopass_content_msg"] //  技能文字不合格通知类型
        
        ) {
        //  qchat_unpass达人视频审核不成功      withdraw_fail  提现失败 score_expired 积分过期 id_photo_unpass: 证件照上传失败
        ZZMessageSystemVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videocell"];
        [cell setData:model];
        return cell;
    }

    if ([model.message.type isEqualToString:@"video_hide"]
        || [model.message.type isEqualToString:@"qchat_pass"]
        || [model.message.type isEqualToString:@"mcoin_recharge_cancel"]
        || [model.message.type isEqualToString:@"to_wechatseen_bad_comment"] // 达人微信差评通知达人
        || [model.message.type isEqualToString:@"from_wechatseen_report_ok"] // 用户查看微信举报成功用户
        || [model.message.type isEqualToString:@"pd_give"] // 发单赠送100么币
        || [model.message.type isEqualToString:@"order_xdf"] // 下单费
        || [model.message.type isEqualToString:@"bio_msg"] // 自我介绍
        || [model.message.type isEqualToString:@"nickname_msg"] // 昵称消息
        ) {//设置为全站隐藏 //充值引导 //闪聊通过
        ZZMessageSystemHideVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZMessageSystemHideVideoCellID"];
        [cell setData:model];
        return cell;
    }
    if ([model.message.type isEqualToString:@"withdraw_success"]) {
        //提现成功
        ZZMessageSystemTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textcell"];
        [cell setData:model];
        return cell;
    }
   
    switch (model.message.media_type) {
        case 1: {
            ZZMessageSystemTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textcell"];
            [cell setData:model];
            return cell;
            break;
        }
        case 2: {
            ZZMessageSystemDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentcell"];
            [cell setData:model];
            cell.touchLinkUrl = ^{
                [self touchLinkUrl:indexPath];
            };
            return cell;
            break;
        }
        case 4: {
            ZZMessageSystemErrorPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"errorphotocell"];
            [cell setData:model];
            return cell;
            break;
        }
        default: {
            // 1.人工审核头像通过通知
            ZZMessageSystemImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imagecell"];
            [cell setData:model];
            return cell;
            break;
        }
    }
}

- (void)touchLinkUrl:(NSIndexPath *)indexPath {
    ZZSystemMessageModel *model = _dataArray[_dataArray.count - 1 - indexPath.row];
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = model.message.link;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_dataArray.count != 0 || !_dataArray) {
        return 0.1;
    }
    else {
        return SCREEN_HEIGHT - 64 - 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_dataArray.count != 0 || !_dataArray) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
        headView.backgroundColor = kBGColor;
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.textColor = kBlackTextColor;
        infoLabel.font = [UIFont systemFontOfSize:17];
        infoLabel.text = @"暂无系统消息";
        [headView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(headView);
        }];
        return headView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZSystemMessageModel *model = _dataArray[_dataArray.count - 1 - indexPath.row];
    if (model.message.media_type == 4) {
        [MobClick event:Event_click_me_icon];
        ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
        controller.gotoUserPage = YES;
        controller.hidesBottomBarWhenPushed = YES;
        controller.editCallBack = ^{
            
        };
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if ([model.message.type isEqualToString:@"user_ban"]) {
        [self goToWebView:@"user_ban"];
    }
    if ([model.message.type isEqualToString:@"chatcharge"]) {
        [self goToFastChatView];
    }
    else if ([model.message.type isEqualToString:@"wechat_unpass"]) {
        [self goToWXView];
    }
    else if ([model.message.type isEqualToString:@"base_video"]) {
        [self goToSelfIntroView:@"base_video"];
    }
    else if ([model.message.type isEqualToString:@"rent_expired"]) {
        [self goToChargeView];
    }
    else if ([model.message.type isEqualToString:@"qchat_unpass"]) {
        [self goToSelfIntroView:@"qchat_unpass"];
    }
    else if ([model.message.type isEqualToString:@"withdraw_fail"]){
        [self goToHelpView];
    }
    else if ([model.message.type isEqualToString:@"score_expired"]||[model.message.type isEqualToString:@"score_expired_soon"]){
        [self goToMyScoreView];
    }
    else if ([model.message.type isEqualToString:@"video_hot"]) {
        NSLog(@"PY_热门推荐");
        [self goToVideoPlayerView:model];
    }
    else if ([model.message.type isEqualToString:@"video_hide"]) {
        NSLog(@"PY_全站隐藏");
    }
    else if ([model.message.type isEqualToString:@"mcoin_recharge_cancel"]) {
        NSLog(@"PY_充值指南");
        [self goToRechargeView:model];
    }
    else if ([model.message.type isEqualToString:@"id_photo_unpass"] || [model.message.type isEqualToString:@"upload_id_photo"]) {
        // 第一次、或者证件照审核失败
        NSLog(@"重新证件照");
        [self goToEditIdentifierPhotoView];
    }
    else if([model.message.type isEqualToString:@"to_order"] ||
            [model.message.type isEqualToString:@"rent_success"]) {
        NSLog(@"邀约流程");
        [self goToInviteView:model];
    }
    else if ([model.message.type isEqualToString:@"see_user_guide"]) {
        // 新手指南
        [self goToUserGuidView:model];
    }
    else if ([model.message.type isEqualToString:@"apply_rent"]) {
        // 申请达人(只有在人工审核的情况下才会发送该消息): 头像和副头像位置图片中有图片人工审核成功且没有申请达人、没有编辑出租信息的用户
        [self goToApplyStarView];
    }
    else if ([model.message.type isEqualToString:@"re_upload"]) {
        // 重新上传(只有在人工审核的情况下才会发送该消息):未出租_且审核后无任何可用的头像
        [self goToEditView];
    }
    else if ([model.message.type isEqualToString:@"fill_info"]) {
        // 去完善资料(只有在人工审核的情况下才会发送该消息):
        [self goToEditView];
    }
    else if ([model.message.type isEqualToString:@"upload_photo"]) {
        // 去上传(只有在人工审核的情况下才会发送该消息)
        [self goToEditView];
    }
    else if ([model.message.type isEqualToString:@"to_show"]) {
        // 去上架(只有在人工审核的情况下才会发送该消息): 出租状态在隐身中，头像提交人工审核的用户.
        [self goToPrivateSettingView];
    }
    else if ([model.message.type isEqualToString:@"to_wechatseen_48"]) {
        NSString *wxOrderID = model.message.params[@"id"];
        if (!isNullString(wxOrderID)) {
            ZZWXOrderDetailViewController *orderDetailsVC = [ZZWXOrderDetailViewController createWithOrderID:wxOrderID];
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }
    }
    else if ([model.message.type isEqualToString:@"from_wechatseen_48"]) {
        NSString *wxOrderID = model.message.params[@"id"];
        if (!isNullString(wxOrderID)) {
            ZZWXOrderDetailViewController *orderDetailsVC = [ZZWXOrderDetailViewController createWithOrderID:wxOrderID];
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }
    }
    else if ([model.message.type isEqualToString:@"to_ok_wechatseen_24"]) {
        NSString *wxOrderID = model.message.params[@"id"];
        if (!isNullString(wxOrderID)) {
            ZZWXOrderDetailViewController *orderDetailsVC = [ZZWXOrderDetailViewController createWithOrderID:wxOrderID];
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }
    }
    else if ([model.message.type isEqualToString:@"to_wechatseen_report"]) {
        NSString *wxOrderID = model.message.params[@"id"];
        if (!isNullString(wxOrderID)) {
            ZZWXOrderDetailViewController *orderDetailsVC = [ZZWXOrderDetailViewController createWithOrderID:wxOrderID];
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }
    }
    else if ([model.message.type isEqualToString:@"to_wechatseen_report_ok"]) {
        NSString *wxOrderID = model.message.params[@"id"];
        if (!isNullString(wxOrderID)) {
            ZZWXOrderDetailViewController *orderDetailsVC = [ZZWXOrderDetailViewController createWithOrderID:wxOrderID];
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }
    }
    else if ([model.message.type isEqualToString:@"pd_before_30minute"]) {
        // 邀约时间开始时间前30分钟
//        NSString *taskID = model.message.params[@"id"];
//        if (!isNullString(taskID)) {
//            ZZTaskDetailViewController *orderDetailsVC = [[ZZTaskDetailViewController alloc] initWithTaskID:taskID];
//            [self.navigationController pushViewController:orderDetailsVC animated:YES];
//        }
        ZZTasksViewController *tasksViewController = [[ZZTasksViewController alloc] initWithTaskType:TaskNormal];
        tasksViewController.onlyShowMyActivities = YES;
        [self.navigationController pushViewController:tasksViewController animated:YES];
    }
    else if ([model.message.type isEqualToString:@"pdg_before30_minute"]) {
        // 活动自动过期
        [self jumoToMyActivities];
    }
    else if ([model.message.type isEqualToString:@"pdg_start"]) {
        // 活动生成邀约
        [self jumoToMyActivities];
    }
    else if ([model.message.type isEqualToString:@"order_send_kfwx"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:model.message.link];
        [ZZHUD showTaskInfoWithStatus:@"复制成功，前往微信添加"];
    }
    else if ([model.message.type isEqualToString:@"pd_four_refund"]) {
        ZZTasksViewController *tasksViewController = [[ZZTasksViewController alloc] initWithTaskType:TaskNormal];
        tasksViewController.onlyShowMyActivities = YES;
        [self.navigationController pushViewController:tasksViewController animated:YES];
    }
    else if ([model.message.type isEqualToString:@"skill_nopass_photo_msg"]
             || [model.message.type isEqualToString:@"skill_photo_msg"]
             || [model.message.type isEqualToString:@"skill_nopass_content_msg"]) {
        // 关于技能的
        NSString *skillID = model.message.params[@"id"];
        if (!isNullString(skillID)) {
            ZZSkillOptionViewController *orderDetailsVC = [[ZZSkillOptionViewController alloc] initWithSkillID:skillID];
            orderDetailsVC.type = SkillOptionTypeEdit;
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
        }
    }
    
    if ([model.message.type isEqualToString:@"system"] && model.message.media_type == 3) {
        if (model.message.link) {
            ZZLinkWebViewController *webViewC = [[ZZLinkWebViewController alloc]init];
            webViewC.urlString = model.message.link;
            [self.navigationController pushViewController:webViewC animated:YES];
        }
    }
}

#pragma mark - Navigator
- (void)goToWebView:(NSString *)type {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = [NSString stringWithFormat:@"%@/api/user/ban/page",kBase_URL];
    controller.hidesBottomBarWhenPushed = YES;
    controller.navigationItem.title = @"封禁申诉";
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  跳转到闪聊
 */
- (void)goToFastChatView {
    ZZFastChatSettingVC *vc = [ZZFastChatSettingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  跳转到微信界面
 */
- (void)goToWXView {
    ZZWXViewController *controller = [[ZZWXViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  跳转到系统重置？
 */
- (void)goToChargeView {
    ZZServiceChargeVC *vc = [ZZServiceChargeVC new];
    vc.isRenew = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  跳转到达人视频
 */
- (void)goToSelfIntroView:(NSString *)type {
    ZZUser *user = [ZZUserHelper shareInstance].loginer;
    ZZSelfIntroduceVC *vc = [[ZZSelfIntroduceVC alloc] init];
    vc.loginer = [ZZUserHelper shareInstance].loginer;
    
    if ([type isEqualToString:@"qchat_unpass"]) {
        vc.reviewStatus = ZZVideoReviewStatusFail;
        vc.isFastChat = YES;
    }
    else if ([type isEqualToString:@"base_video"]) {
        if (user.base_video.status == 1) {
            vc.reviewStatus = ZZVideoReviewStatusSuccess;
        }
        else {
            vc.reviewStatus = ZZVideoReviewStatusFail;
        }
        vc.isShowTopUploadStatus = YES;
        vc.isUploadAfterCompleted = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  跳转到帮助与反馈
 */
- (void)goToHelpView {
    ZZHelpCenterVC *controller = [[ZZHelpCenterVC alloc] init];
    controller.urlString = H5Url.helpAndFeedback;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  跳转到我的积分
 */
- (void)goToMyScoreView {
    ZZMyIntegralViewController *vc = [[ZZMyIntegralViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  跳转到视频播放
 */
- (void)goToVideoPlayerView:(ZZSystemMessageModel *)model {
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    if ([model.message.params[@"video_type"] isEqualToString:@"sk"]) {
        controller.skId = model.message.params[@"id"];
    }
    else if ([model.message.params[@"video_type"] isEqualToString:@"mmd" ]) {
        controller.mid = model.message.params[@"id"];
    }
    else {
        NSLog(@"PY_数据出错了");
        return;
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  跳转到充值页面
 */
- (void)goToRechargeView:(ZZSystemMessageModel *)model {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    
    if (isNullString(model.message.link)) {
        ZZMeBiViewController *MebiVC = [ZZMeBiViewController new];
        [self.navigationController pushViewController:MebiVC animated:YES];
        return;
    }
    controller.urlString = model.message.link;
    controller.title = @"么币充值服务";
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  跳转到证件照页面
 */
- (void)goToEditIdentifierPhotoView {
    ZZIDPhotoManagerViewController *viewController = [[ZZIDPhotoManagerViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 *  跳转到邀请页面
 */
- (void)goToInviteView:(ZZSystemMessageModel *)model {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = model.message.link;
    controller.isPush = YES;
    controller.isShowLeftButton = YES;
    controller.title = @"邀约流程";
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  跳转到新手指南
 */
- (void)goToUserGuidView:(ZZSystemMessageModel *)model {
    [ZZRequest method:@"POST" path:@"/api/mag_click/click" params:@{@"type":@"see_user_guide"} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        NSLog(@"success");
    }];
    NSLog(@"新手指南");
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = model.message.link;
    controller.isPush = YES;
    controller.isShowLeftButton = YES;
    controller.title = @"新手指南";
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  跳转到申请达人的页面
 */
- (void)goToApplyStarView {
    WeakSelf
    ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
    registerRent.type = RentTypeRegister;
    [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
        ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    [self.navigationController presentViewController:registerRent animated:YES completion:nil];
}

/**
 *  跳转到编辑个人资料页面
 */
- (void)goToEditView {
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    controller.gotoUserPage = YES;
    controller.hidesBottomBarWhenPushed = YES;
    controller.editCallBack = ^{
        
    };
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  跳转到个人隐私页面
 */
- (void)goToPrivateSettingView {
    ZZSettingPrivacyViewController *vc = [[ZZSettingPrivacyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.user = [ZZUserHelper shareInstance].loginer;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumoToMyActivities {
    ZZTasksViewController *tasksViewController = [[ZZTasksViewController alloc] initWithTaskType:TaskFree];
    tasksViewController.onlyShowMyActivities = YES;
    [self.navigationController pushViewController:tasksViewController animated:YES];
}

#pragma mark - WBSendVideoManagerObserver
- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model {
    _isUploading = YES;
    BLOCK_SAFE_CALLS(self.isUploadVideoBlock, YES);
    _model = model;
}

// 视频发送进度
- (void)videoSendProgress:(NSString *)progress {
    _isUploading = YES;
    BLOCK_SAFE_CALLS(self.isUploadVideoBlock, YES);
}

// 视频发送完成
- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isUploading = NO;
        BLOCK_SAFE_CALLS(self.isUploadVideoBlock, NO);
    });

    // 闪租页面的录制达人视频 需要直接更新到User-服务器
    if (_model.isUploadAfterCompleted) {
        ZZUser *user = [ZZUserHelper shareInstance].loginer;
        if (sk) {// 如果达人视频上传成功的话，则保存的时候需要将 sk 整个Model一起上传
            user.base_video.sk = sk;
            user.base_video.status = 1;
        }
        
        [ZZHUD showWithStatus:@"更新信息"];
        [user updateWithParam:[user toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"更新成功"];
                ZZUser *user = [ZZUser yy_modelWithJSON:data];
                [[ZZUserHelper shareInstance] saveLoginer:user postNotif:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
            }
        }];
    }
    _model = nil;
}

// 视频发送失败
- (void)videoSendFailWithError:(NSDictionary *)error {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isUploading = NO;
        BLOCK_SAFE_CALLS(self.isUploadVideoBlock, NO);
    });
}

#pragma mark - Setter&Getter
- (ZZAlertNotNetEmptyView *)alertEmptyView {
    if (!_alertEmptyView) {
        _alertEmptyView = [[ZZAlertNotNetEmptyView alloc]init];
        [_alertEmptyView alertShowViewController:self];
    }
    return _alertEmptyView;
}

@end
