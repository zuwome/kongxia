//
//  ZZTaksDetailsViewModel.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaksDetailsViewModel.h"
#import <CoreLocation/CoreLocation.h>
#import "ZZTaskModel.h"
#import "ZZTaskLikeModel.h"
#import "ZZTaskSignuperModel.h"
#import "ZZTasksServer.h"

#import "ZZTaskUserInfoCell.h"
#import "ZZTaskInfoCell.h"
#import "ZZTaskPhotosCell.h"
#import "ZZTaskActionsCell.h"
#import "ZZTaskLiskesCell.h"
#import "ZZSignuperCell.h"
#import "ZZEmptySignuperTableViewCell.h"
#import "ZZSignupFooterView.h"
#import "ZXPopupMenu.h"

#import "ZZSignupHeaderView.h"

@interface ZZTaksDetailsViewModel () <UITableViewDataSource, UITableViewDelegate, ZZTaskActionsCellDelegate, ZZTaskPhotosCellDelegate, ZZTaskUserInfoCellDelegate, ZZTaskInfoCellDelegate, ZZTaskLiskesCellDelegate, ZZSignuperCellDelegate, ZXPopupMenuDelegate>

@property (nonatomic, strong) NSIndexPath *taskIndexPath;

@property (nonatomic, copy) NSArray<TaskSection *> *itemsArray;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ZZTaksDetailsViewModel

- (instancetype)initWithTaskModel:(ZZTaskModel *)task tableView:(UITableView *)tableView indexPath:(NSIndexPath *)taskIndexPath taskType:(TaskType)taskType {
    self = [super init];
    if (self) {
        _currentListType = ListNone;
        _task = task;
        _tableView = tableView;
        _taskIndexPath = taskIndexPath;
        _taskType = taskType;
        [self configureTableView];
        [self fetchTaskDetails:NO];
        [self createCells];
    }
    return self;
}

- (instancetype)initWithTaskID:(NSString *)taskID tableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        _task = [[ZZTaskModel alloc] init];
        _task.task = [[ZZTask alloc] init];
        _task.task._id = taskID;
        _tableView = tableView;
        [self configureTableView];
        [self fetchTaskDetails:NO];
        [self createCells];
    }
    return self;
}

- (void)dealloc {
    [self clearPicked];
}

#pragma mark - public Method
- (void)clearPicked {
    _task.task.pickSignupersArr = nil;
}

- (void)completeSelect {
    [self checkIFCanSelect];
}

/*
 *  每次进入详情页的时候要去判断是否需要弹出提示
 */
- (void)showAlertView {
    if (![_task.task isNewTask]) {
        return;
    }
    
    // 当通告不在进行中的时候 不显示
    if (!(_task.task.taskStatus == TaskOngoing || _task.task.taskStatus == TaskClose)) {
        [self clearLocalTaskInfos];
        return;
    }
    
    // 没有人报名不显示
    if (_task.task.count == 0) {
        [self clearLocalTaskInfos];
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *myTasksInfo = [[userDefault objectForKey:@"myTasksInfo"] mutableCopy];
    
    // 如果全局关闭了 也不显示
    if ([myTasksInfo[@"shouldShowAlert"] isEqualToString:@"1"]) {
        [self clearLocalTaskInfos];
        return;
    }
    
    // 所有点进详情的都要保存一下,因为每个都要判断,然后还要删掉防止过大
    NSMutableArray<NSDictionary *> *infosArray = [myTasksInfo[@"infos"] mutableCopy];
    __block BOOL shouldShow = YES;
    [infosArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([info[@"taskID"] isEqualToString:_task.task._id]) {
            *stop = YES;
            shouldShow = NO;
        }
    }];
    
    if (!shouldShow) {
        [self clearLocalTaskInfos];
        return;
    }
    
    if (!infosArray) {
        infosArray = @[].mutableCopy;
    }
    
    // 将数据保存起来
    if (!isNullString(_task.task._id)) {
        NSMutableDictionary *infos = @{}.mutableCopy;
        infos[@"taskID"] = _task.task._id;
        if (!isNullString(_task.task.dated_at)) {
            infos[@"taskDate"] = _task.task.dated_at;
        }
        [infosArray addObject:infos.copy];
    }
    
    if (!myTasksInfo) {
        myTasksInfo = @{}.mutableCopy;
    }
    
    myTasksInfo[@"infos"] = infosArray.copy;
    
    [ZZUserDefaultsHelper setObject:myTasksInfo.copy forDestKey:@"myTasksInfo"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认选择" message:@"报名人数不限，您最多可从中选择5名达人同时进行邀约，勾选意向达人后，支付邀约金后即可开始邀约" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"不再提示" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        myTasksInfo[@"shouldShowAlert"] = @"1";
        myTasksInfo[@"infos"] = nil;
        [ZZUserDefaultsHelper setObject:myTasksInfo.copy forDestKey:@"myTasksInfo"];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:nil];
    [alert addAction:continueAction];
    [alert addAction:cancelAction];
    [[UIViewController currentDisplayViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)didPickUser:(ZZUser *)user {
    if ([_task.task didUserPicked:user.uid]) {
        return;
    }
    
    __block ZZTaskSignuperModel *signuper = nil;
    [_task.task.signupers enumerateObjectsUsingBlock:^(ZZTaskSignuperModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.user.uuid isEqualToString:user.uid]) {
            signuper = obj;
            *stop = YES;
        }
    }];
    
    if (!signuper) {
        return;
    }
    
    [self pickUser:signuper];
}

#pragma mark - private method
- (void)postNotification:(ZZTaskModel *)task action:(TaskAction)action {
    NSMutableDictionary *userInfo = @{
                               @"task": task,
                               @"from": @"taskDetails",
                               @"action": @(action),
                               @"currentListType": @(_currentListType),
                               }.mutableCopy;
    if (_taskIndexPath) {
        userInfo[@"indexPath"] = _taskIndexPath;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_TaskStatusDidChanged object:nil userInfo:userInfo];
}

/**
 订单操作
 */
- (void)taskStatusDidChangedWithAction:(TaskAction)action {
    if (action == taskActionLike) {
        // 点赞
        _task.task.selected_count = 1;
        _task.task.like += 1;
        
        ZZTaskLikeModel *likeModel = [[ZZTaskLikeModel alloc] init];
        likeModel.like_user = UserHelper.loginer;
        
        NSMutableArray *likeUsersArray = _task.task.likedUsers.mutableCopy;
        if (!likeUsersArray) {
            likeUsersArray = [[NSMutableArray alloc] init];
        }
        [likeUsersArray insertObject:likeModel atIndex:0];
        _task.task.likedUsers = likeUsersArray.copy;
        
        [self createCells];
        
        [self postNotification:_task action:action];
    }
    else if (action == taskActionSignUp) {
        // 报名
        _task.task.push_count = 1;
        _task.task.count += 1;
        [_tableView reloadData];
        [self postNotification:_task action:action];
    }
    else if (action == taskActionCancel) {
        // 取消订单
        _task.task.order_end = 0;
        _task.task.status = 2;
        if ([_task.task isNewTask]) {
            _task.task.pickSignupersArr = nil;
        }
        [_tableView reloadData];
        [self postNotification:_task action:action];
        if (self.delegate && [self.delegate respondsToSelector:@selector(taskStatusDidChanged:)]) {
            [self.delegate taskStatusDidChanged:self];
        }
    }
    else if (action == taskActionPick) {
        // 选人
        [self postNotification:_task action:action];
    }
    else if (action == taskActionClose) {
        // 关闭订单
        _task.task.order_end = 1;
        _task.task.status = 0;
        [_tableView reloadData];
        [self postNotification:_task action:action];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(taskStatusDidChanged:)]) {
            [self.delegate taskStatusDidChanged:self];
        }
    }
    else if (action == taskActionTonggaoPay) {
        _task.task.order_end = 1;
        _task.task.status = 3;
        [_tableView reloadData];
        [self postNotification:_task action:action];
        
    }
}

/*
 清楚已经过期了的保存在本地的通告信息
 */
- (void)clearLocalTaskInfos {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *myTasksInfo = [[userDefault objectForKey:@"myTasksInfo"] mutableCopy];
        
        NSArray <NSDictionary *> *infosArray = myTasksInfo[@"infos"];
        
        NSMutableArray<NSDictionary *> *arr = @[].mutableCopy;
        [infosArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *date = info[@"taskDate"];
            if (![[ZZDateHelper shareInstance] taskDatePassToday:date]) {
                [arr addObject:info];
            }
        }];
        
        myTasksInfo[@"infos"] = arr.copy;
        
        [ZZUserDefaultsHelper setObject:myTasksInfo.copy forDestKey:@"myTasksInfo"];
    });
}

- (void)pickUser:(ZZTaskSignuperModel *)signuper {
    if (_task.task.taskStatus == TaskExpired) {
        [ZZHUD showTaskInfoWithStatus:@"该邀约已过期,租金已退回,无法在选人哦"];
    }
    else if (_task.task.taskStatus == TaskCancel) {
        [ZZHUD showTaskInfoWithStatus:@"该邀约已被取消,租金已退回,无法在选人哦"];
    }
    else if (_task.task.taskStatus == TaskFinish) {
        [ZZHUD showTaskInfoWithStatus:@"该邀约已结束"];
    }
    else if (_task.task.taskStatus == TaskOngoing || _task.task.taskStatus == TaskClose) {
        if ([_task.task isNewTask]) {
            // 多选
            
            if (_task.task.taskStatus != TaskOngoing && _task.task.taskStatus != TaskClose) {
                // 结束了 不能在选人
                [ZZHUD showErrorWithStatus:@"该通告邀约已经结束，无法再继续选人哦"];
                return;
            }
            
            //            if ([_task.task isPassLimitedTime]) {
            //                // 超过30分钟了不能在选人
            //                [ZZHUD showErrorWithStatus:@"该通告邀约时间已过，无法再继续选人哦"];
            //                return;
            //            }
            
            NSMutableArray<ZZTaskSignuperModel *> *signupers = _task.task.pickSignupersArr.mutableCopy;
            if (!signupers) {
                signupers = [NSMutableArray arrayWithCapacity:5];
            }
            
            if ([signupers containsObject:signuper]) {
                [signupers removeObject:signuper];
            }
            else {
                //                if (signupers.count == 5) {
                //                    // 最多选择5个人
                //                    [ZZHUD showErrorWithStatus:@"最多选择5个人"];
                //                }
                //                else {
                [signupers addObject:signuper];
                //                }
            }
            _task.task.pickSignupersArr = signupers.copy;
            [_tableView reloadData];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelUserDidPicked:)]) {
                [self.delegate viewModelUserDidPicked:self];
            }
        }
        else {
            [ZZInfoToastView showWithType:ToastTaskConfirmChoose keyStr:signuper.user.nickname action:^(NSInteger actionIndex, ToastType type) {
                if (actionIndex == 1) {
                    [self pick:signuper];
                }
                else {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:)]) {
                        [self.delegate viewModel:self chatWith:signuper.user];
                    }
                }
            }];
        }
    }
}

#pragma mark - ZXPopupMenuDelegate
- (void)zxPopupMenuDidSelectedAtIndex:(NSInteger)index zxPopupMenu:(ZXPopupMenu *)zxPopupMenu{
    switch (index) {
        case 0:{
            
            NSString *message = nil;
            NSString *title = nil;
            if ([_task.task isNewTask]) {
                ToastType type = ToastTonggaoCancelStyle1;
                BOOL isPassLimitedTime = [_task.task isPassLimitedTime];
                if (isPassLimitedTime && _task.task.count == 0) {
                    type = ToastTonggaoCancelStyle2;
                }
                else {
                    type = ToastTonggaoCancelStyle1;
                }
                
                [ZZInfoToastView showWithType:type action:^(NSInteger actionIndex, ToastType type) {
                    if (actionIndex == 1) {
                        [self newCancelTask];
                    }
                }];
            }
            else {
                title = @"确认取消吗?";
                message = @"取消后，该邀约将自动结束，不可报名，不可选人";
                
                [UIAlertController presentAlertControllerWithTitle:title message:message doneTitle:@"结束" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                    if (!isCancelled) {
                        if ([_task.task isNewTask]) {
                            [self newCancelTask];
                        }
                        else {
                            [self cancelTask];
                        }
                    }
                }];
            }
            
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - ZZTaskUserInfoCellDelegate
- (void)cell:(ZZTaskUserInfoCell *)cell showMoreAction:(TaskUserInfoItem *)item {
//    if (item.task.task.isMine) {
        // 取消任务
        if (item.task.task.taskStatus == TaskOngoing || item.task.task.taskStatus == TaskClose) {
            NSArray *titleArray = @[@"取消发布"];
            [ZXPopupMenu showRelyOnView:cell.moreBtn titles:titleArray icons:nil menuWidth:135 otherSettings:^(ZXPopupMenu *popupMenu) {
                popupMenu.delegate = self;
            }];
        }
//    }
//    else {
//        // 举报
//        if (item.task.task.taskStatus == TaskOngoing) {
//
//        }
//    }
}

- (void)cell:(ZZTaskUserInfoCell *)cell showUserInfoWith:(TaskUserInfoItem *)item {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showUserInfoWith:isPick:)]) {
        [self.delegate viewModel:self showUserInfoWith:item.task.from isPick:NO];
    }
}

- (void)cell:(ZZTaskUserInfoCell *)cell cancelAction:(TaskUserInfoItem *)item {
    NSString *message = nil;
    NSString *title = nil;
    if ([_task.task isNewTask]) {
        ToastType type = ToastTonggaoCancelStyle1;
        BOOL isPassLimitedTime = [_task.task isPassLimitedTime];
        if (isPassLimitedTime && _task.task.count == 0) {
            type = ToastTonggaoCancelStyle2;
        }
        else {
            type = ToastTonggaoCancelStyle1;
        }
        
        [ZZInfoToastView showWithType:type action:^(NSInteger actionIndex, ToastType type) {
            if (actionIndex == 1) {
                [self newCancelTask];
            }
        }];
    }
    else {
        title = @"确认取消吗?";
        message = @"取消后，该邀约将自动结束，不可报名，不可选人";
        
        [UIAlertController presentAlertControllerWithTitle:title message:message doneTitle:@"结束" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                if ([_task.task isNewTask]) {
                    [self newCancelTask];
                }
                else {
                    [self cancelTask];
                }
            }
        }];
    }
}

#pragma mark - ZZTaskInfoCell
/**
 显示地图
 */
- (void)cell:(ZZTaskInfoCell *)cell showLocations:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showLocations:)]) {
        [self.delegate viewModel:self showLocations:task];
    }
}

/**
 显示价格详情
 */
- (void)cell:(ZZTaskInfoCell *)cell showPriceDetails:(ZZTaskModel *)task {
//    if (task.task.isMine) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showPriceDetails:)]) {
            [self.delegate viewModel:self showPriceDetails:task];
        }
//    }
}

#pragma mark - ZZTaskPhotosCellDelegate
- (void)cell:(ZZTaskPhotosCell *)cell showPhotoWith:(ZZTaskModel *)task currentImgStr:(NSString *)currentImgStr {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showPhotoWith:currentImgStr:)]) {
        [self.delegate viewModel:self showPhotoWith:task currentImgStr:currentImgStr];
    }
}

#pragma mark - ZZTaskLiskesCellDelegate
/**
 个人详情
 */
- (void)cell:(ZZTaskLiskesCell *)cell showLikedUserInfoWith:(ZZUser *)user {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showUserInfoWith:isPick:)]) {
        [self.delegate viewModel:self showUserInfoWith:user isPick:NO];
    }
}

/**
 显示更多点赞
 */
- (void)cell:(ZZTaskLiskesCell *)cell showMoreUsers:(TaskLikesItem *)item {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showMoreLikedUsers:)]) {
        [self.delegate viewModel:self showMoreLikedUsers:item.task];
    }
}

#pragma mark - ZZTaskActionsCellDelegate
/*
 点赞
 */
- (void)cell:(ZZTaskActionsCell *)cell likeActionWithItem:(TaskActionsItem *)item {
    if (item.task.task.selected_count == 1) {
        [ZZHUD showTaskInfoWithStatus:@"您已经点赞过了"];
    }
    else {
        if (item.task.task.taskStatus == TaskOngoing) {
            [self like:item.task];
        }
    }
}

/*
 聊天
 */
- (void)cell:(ZZTaskActionsCell *)cell chatWithItem:(TaskActionsItem *)item {
    if (item.task.task.isMine) {
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:)]) {
            [self.delegate viewModel:self chatWith:item.task.from];
        }
    }
}

/*
 报名
 */
- (void)cell:(ZZTaskActionsCell *)cell signUpActionWith:(TaskActionsItem *)item {
//    if (item.task.task.isMine) {
        // 只有订单还在进行中,才能点击结束订单
        if (item.task.task.taskStatus == TaskOngoing) {
            [UIAlertController presentAlertControllerWithTitle:@"确认结束报名吗？" message:@"结束后，您只能从已报名用户中选择达人进行本次邀约" doneTitle:@"结束" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) {
                    [self closeTask:item.task];
                }
            }];
        }
//    }
//    else {
//        if (item.task.task.push_count == 1) {
//            [ZZHUD showTaskInfoWithStatus:@"您已经报名了"];
//        }
//        else {
//            // 您未上传本人正脸五官清晰照，暂不可报名
//            if (![UserHelper.loginer didHaveRealAvatar] && !([UserHelper.loginer isAvatarManualReviewing] && [UserHelper.loginer didHaveOldAvatar])) {
//                [UIAlertController presentAlertControllerWithTitle:@"您未上传本人正脸五官清晰照，暂不可报名"
//                                                           message:nil
//                                                         doneTitle:@"去上传"
//                                                       cancelTitle:@"取消"
//                                                     completeBlock:^(BOOL isCancelled) {
//                                                         if (!isCancelled) {
//                                                             if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showUploadFaceVC:)]) {
//                                                                 [self.delegate viewModel:self showUploadFaceVC:item.task];
//                                                             }
//                                                         }
//                                                     }];
//                return;
//            }
//
//            [ZZInfoToastView showWithType:ToastTaskConfirmSignUp action:^(NSInteger actionIndex, ToastType type) {
//                if (actionIndex == 1) {
//                    [self signUpForTask:item.task];
//                }
//            }];
//
//        }
//    }
}

#pragma mark - ZZSignuperCellDelegate
/**
 聊天
 */
- (void)cell:(ZZSignuperCell *)cell goChat:(ZZUser *)user {
    [self fetchSayHiStatusUser:user handler:^(id data) {
        if ([[data objectForKey:@"say_hi_status"] integerValue] == 0) {
            if (loginedUser.avatar_manual_status == 1) {
                if (![loginedUser didHaveOldAvatar]) {
                    [UIAlertController showOkAlertIn:[UIViewController currentDisplayViewController]
                                               title:@"提示"
                                             message:@"打招呼需要上传本人五官正脸清晰照，您的头像还在审核中，暂不可打招呼"
                                        confirmTitle:@"知道了"
                                      confirmHandler:nil];
                }
                else {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:)]) {
                        [self.delegate viewModel:self chatWith:user];
                    }
                }
            }
        }
        else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:)]) {
                [self.delegate viewModel:self chatWith:user];
            }
        }
    }];
}

/**
 选人
 */
- (void)cell:(ZZSignuperCell *)cell pickUser:(TaskSignuperItem *)item {
    [self pickUser:item.signUper];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _itemsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemsArray[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskItem *item = _itemsArray[indexPath.section].items[indexPath.row];
    switch (item.type) {
        case taskUserInfo: {
            ZZTaskUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskUserInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.item = item;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case taskInfo: {
            ZZTaskInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.item = item;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case taskPhotos: {
            ZZTaskPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskPhotosCell cellIdentifier] forIndexPath:indexPath];
            cell.item = item;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
            break;
        }
        case taskActions: {
            ZZTaskActionsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskActionsCell cellIdentifier] forIndexPath:indexPath];
            cell.item = item;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case taskLikes: {
            ZZTaskLiskesCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskLiskesCell cellIdentifier] forIndexPath:indexPath];
            cell.item = item;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
            break;
        }
        case taskSignUper: {
            TaskSignuperItem *signuperItem = (TaskSignuperItem *)item;
            ZZSignuperCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZSignuperCell cellIdentifier] forIndexPath:indexPath];
            cell.item = signuperItem;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell didPicked:NO];
            
            if (_task.task.taskStatus == TaskOngoing || _task.task.taskStatus == TaskClose) {
                [cell didPicked:[_task.task.pickSignupersArr containsObject:signuperItem.signUper]];
            }
            else {
                if (_task.task.selected_users.count > 0) {
                    [cell didPicked:[_task.task.selected_users containsObject:signuperItem.signUper.user.uuid]];
                }
                
                if (_task.task.pickSignupersArr.count > 0) {
                    [cell didPicked:[_task.task.pickSignupersArr containsObject:signuperItem.signUper]];
                }
            }
            
            return cell;
            break;
        }
        case taskEmpty: {
            ZZEmptySignuperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZEmptySignuperTableViewCell cellIdentifier] forIndexPath:indexPath];
            TaskEmptyItem *emptyItem = (TaskEmptyItem *)item;
            cell.item = emptyItem;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        default: {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskItem *item = _itemsArray[indexPath.section].items[indexPath.row];
    return item.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    TaskSection *taskSection = _itemsArray[section];
    if (taskSection.type == taskSignUper) {
        return 44;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TaskSection *taskSection = _itemsArray[section];
    if (taskSection.type == taskSignUper) {
        
        ZZSignupHeaderView *view = [[ZZSignupHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 44)];
        view.titleLabel.text = taskSection.sectionTitle;
        return view;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.1)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskItem *item = _itemsArray[indexPath.section].items[indexPath.row];
    if (item.type == taskSignUper) {
        TaskSignuperItem *signupItem = (TaskSignuperItem *)item;
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showUserInfoWith:isPick:)]) {
            [self.delegate viewModel:self showUserInfoWith:signupItem.signUper.user isPick:YES];
        }
    }
}

#pragma mark - Request
/*
 获取详情
 */
- (void)fetchTaskDetails:(BOOL)isUpdaing {
    [ZZHUD show];
    [ZZTasksServer fetchTaskDetailsWithParams:@{
                                                @"pid": _task.task._id,
                                                @"uid": UserHelper.loginer.uid,
                                                @"lat": @(UserHelper.location.coordinate.latitude),
                                                @"lng": @(UserHelper.location.coordinate.longitude),
                                                }
                                      handler:^(ZZError *error, id data) {
                                          [ZZHUD dismiss];
                                          if (!error && [data isKindOfClass:[NSDictionary class]]) {
                                              ZZTask *task = [[ZZTask alloc] initWithDictionary:data[@"pd"] error:nil];
                                              // 改造一下模型的样子,让他和外面基本一样
                                              _task = [[ZZTaskModel alloc] init];
                                              _task.task = task;
                                              _task.task.from.uid = _task.task.from.uuid;
                                              _task.task.from._id = _task.task.from.uuid;
                                              _task.from = task.from;
                                              // 点赞的人
                                              NSArray *likeUsers = data[@"like"];
                                              if ([likeUsers isKindOfClass: [NSArray class]]) {
                                                  if (likeUsers.count > 0) {
                                                      NSArray *likes = [ZZTaskLikeModel arrayOfModelsFromDictionaries:likeUsers error:nil].copy;
                                                      _task.task.likedUsers = likes;
                                                  }
                                              }
                                              
                                              // 所有报名的人
//                                              if (_task.task.isMine) {
                                                  NSArray *signuper = data[@"signup"];
                                                  if ([signuper isKindOfClass: [NSArray class]]) {
                                                      if (signuper.count > 0) {
                                                          NSError *error = nil;
                                                          NSArray *signupers = [ZZTaskSignuperModel arrayOfModelsFromDictionaries:signuper error:&error].copy;
                                                          _task.task.signupers = signupers;
                                                      }
                                                  }
//                                              }
                                              
                                              [self createCells];
                                              [self showAlertView];
//                                              NSString *title = @"发布详情";
//                                              if (_task.task.isMine) {
                                                  NSString *title = @"我的发布详情";
//                                              }
                                              
                                              if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:changeTitle:)]) {
                                                  [self.delegate viewModel:self changeTitle:title];
                                              }
                                              
                                              if (isUpdaing) {
                                                  
                                              }
                                          }
                                          else {
                                              [ZZHUD showErrorWithStatus:error.message];
                                          }
                                      }];
}

/*
 报名
 */
- (void)signUpForTask:(ZZTaskModel *)task {
    NSMutableDictionary *param = @{
                                   @"uid": UserHelper.loginer.uid,
                                   @"pid": task.task._id,
                                   }.mutableCopy;
    [ZZHUD show];
    [ZZTasksServer signupWithParams:param handler:^(ZZError *error, id data) {
        [ZZHUD dismiss];
        if (!error) {
            [ZZHUD showSuccessWithStatus:@"报名成功"];
            //            [self fetchTaskDetails:YES];
            [self taskStatusDidChangedWithAction:taskActionSignUp];
        }
        else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

/*
 点赞
 */
- (void)like:(ZZTaskModel *)task {
    NSMutableDictionary *param = @{
                                   @"uid": UserHelper.loginer.uid,
                                   @"pid": task.task._id,
                                   }.mutableCopy;
    [ZZHUD show];
    [ZZTasksServer likeWithParams:param handler:^(ZZError *error, id data) {
        [ZZHUD dismiss];
        if (!error) {
            [ZZHUD showSuccessWithStatus:@"点赞成功"];
            //            [self fetchTaskDetails:YES];
            [self taskStatusDidChangedWithAction:taskActionLike];
        }
        else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

/*
 选人
 */
- (void)pick:(ZZTaskSignuperModel *)signuper {
    NSMutableDictionary *param = @{
                                   @"from": UserHelper.loginer.uid,
                                   @"to": signuper.user.uuid,
                                   @"pid": _task.task._id,
                                   @"ptid":signuper._id,
                                   }.mutableCopy;
    [ZZHUD show];
    [ZZTasksServer pickWithParams:param handler:^(ZZError *error, id data) {
        [ZZHUD dismiss];
        if (!error) {
            [ZZHUD showSuccessWithStatus:@"选择成功"];
            //                         [self fetchTaskDetails:NO];
            [self taskStatusDidChangedWithAction:taskActionPick];
            
//            if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:picked:)]) {
//                [self.delegate viewModel:self picked:signuper.user];
//            }
        }
        else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

/**
 新版取消任务
 */
- (void)newCancelTask {
    [ZZHUD show];
    [ZZTasksServer newCancelWithTaskID:_task.task._id taskType:_taskType handler:^(ZZError *error, id data) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [_tableView reloadData];
            [ZZHUD showSuccessWithStatus:@"任务已取消"];
            [self taskStatusDidChangedWithAction:taskActionCancel];
        }
    }];
}

/**
 取消任务
 */
- (void)cancelTask {
    [ZZHUD show];
    [ZZTasksServer cancelWithTaskID:_task.task._id taskType:_taskType handler:^(ZZError *error, id data) {
        [ZZHUD dismiss];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [_tableView reloadData];
            [ZZHUD showSuccessWithStatus:@"任务已取消"];
            [self taskStatusDidChangedWithAction:taskActionCancel];
            
        }
    }];
}

/*
 结束报名
 */
- (void)closeTask:(ZZTaskModel *)task {
    [ZZHUD show];
    [ZZTasksServer closeWithParams:@{
                                     @"pid": task.task._id,
                                     @"uid": UserHelper.loginer.uid
                                     }
                           handler:^(ZZError *error, id data) {
                               [ZZHUD dismiss];
                               if (error) {
                                   [ZZHUD showErrorWithStatus:error.message];
                               }
                               else {
                                   [ZZHUD showSuccessWithStatus:@"任务已结束报名"];
                                   [self taskStatusDidChangedWithAction:taskActionClose];
                               }
                           }];
}

/**
 打招呼状态
 */
- (void)fetchSayHiStatusUser:(ZZUser *)user handler:(void(^)(id data))hander {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/say_hi_status",user.uuid] params:@{@"sayhi_type": @"3.7.0"} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            if (hander) {
                hander(data);
            }
        }
    }];
}

/*
 检查 选择的是否合法
 */
- (void)checkIFCanSelect {
    NSMutableArray *ids = @[].mutableCopy;
    NSMutableString *names = [NSMutableString new];
    [_task.task.pickSignupersArr enumerateObjectsUsingBlock:^(ZZTaskSignuperModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ids addObject:obj.user.uuid];
        [names appendString:obj.user.nickname];
        
        if (idx < _task.task.pickSignupersArr.count - 1) {
            [names appendString:@"、"];
        }
    }];
    
    NSDictionary *param = @{
                            @"unitPrice": _task.task.price,
                            @"pid": _task.task._id,
                            @"selectIds": ids.copy, 
                            };
    
    [ZZHUD show];
    [ZZTasksServer checkIfCanSelectAndPay:param handler:^(ZZError *error, id data) {
        [ZZHUD dismiss];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZInfoToastView showWithType:ToastPayTonggao keyStr:names action:^(NSInteger actionIndex, ToastType type) {
                if (actionIndex == 1) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewmodel:gotoPay:)]) {
                        [self.delegate viewmodel:self gotoPay:ids.copy];
                    }
                }
            }];
        }
    }];
}


#pragma mark - Layout
/*
 创建视图
 */
- (void)createCells {
    NSMutableArray<TaskSection *> *sectionsArray = @[].mutableCopy;
    
    NSMutableArray<TaskItem *> *itemsArray = @[].mutableCopy;
    
    // 用户信息
    TaskUserInfoItem *userInfoItem = [[TaskUserInfoItem alloc] initWithTaksModel:_task];
    [itemsArray addObject:userInfoItem];
    
    // 任务信息
    TaskInfoItem *taskInfoItem = [[TaskInfoItem alloc] initWithTaksModel:_task];
    [itemsArray addObject:taskInfoItem];
    
    // 图片
    if ([_task.task.imgs isKindOfClass: [NSArray class]] && _task.task.imgs.count > 0) {
        TaskPhotoItem *taskPhotoItem = [[TaskPhotoItem alloc] initWithTaksModel:_task];
        [itemsArray addObject:taskPhotoItem];
    }
    
    // 操作
    TaskActionsItem *actionItem = [[TaskActionsItem alloc] initWithTaksModel:_task];
    [itemsArray addObject:actionItem];
    
    // 点赞
    if (_task.task.likedUsers && _task.task.likedUsers.count > 0) {
        TaskLikesItem *likesItem = [[TaskLikesItem alloc] initWithTaksModel:_task];
        [itemsArray addObject:likesItem];
    }
    
    TaskSection *taskInfoSection = [[TaskSection alloc] initWithItems:itemsArray.copy];
    taskInfoSection.type = taskInfo;
    [sectionsArray addObject:taskInfoSection];
    
    // 报名人数
    NSMutableArray *signUpers = @[].mutableCopy;
    if (_task.task.signupers && _task.task.signupers.count > 0) {
        BOOL isNew = [_task.task isNewTask];
        [_task.task.signupers enumerateObjectsUsingBlock:^(ZZTaskSignuperModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TaskSignuperItem *signUperItem = [[TaskSignuperItem alloc] initWithSignUper:obj];
            signUperItem.isNewTask = isNew;
            [signUpers addObject:signUperItem];
        }];
        
        TaskSection *signUpersSection = [[TaskSection alloc] initWithItems:signUpers.copy];
        signUpersSection.sectionTitle = isNew ? @"最多可以选择5位达人进行本次邀约" : @"请选择1位报名用户进行本次邀约";
        signUpersSection.type = taskSignUper;
        [sectionsArray addObject:signUpersSection];
    }
    else {
        // 无人报名
        TaskEmptyItem *temptyItem = [[TaskEmptyItem alloc] init];
        temptyItem.title = @"暂时没有人报名呢";
        temptyItem.icon = @"picQuesheng";
        TaskSection *emptySignuperSection = [[TaskSection alloc] initWithItems:@[temptyItem]];
        emptySignuperSection.type = taskEmpty;
        [sectionsArray addObject:emptySignuperSection];
        
        
    }
    // 无人报名的话要嫁一个footer
    [self createTableViewFooterView:(_task.task.signupers && _task.task.signupers.count > 0) ? NO : YES];
    _itemsArray = sectionsArray.copy;
    [_tableView reloadData];
}

- (void)configureTableView {
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerClass:[ZZTaskUserInfoCell class]
       forCellReuseIdentifier:[ZZTaskUserInfoCell cellIdentifier]];
    
    [_tableView registerClass:[ZZTaskInfoCell class]
       forCellReuseIdentifier:[ZZTaskInfoCell cellIdentifier]];
    
    [_tableView registerClass:[ZZTaskPhotosCell class]
       forCellReuseIdentifier:[ZZTaskPhotosCell cellIdentifier]];
    
    [_tableView registerClass:[ZZTaskActionsCell class]
       forCellReuseIdentifier:[ZZTaskActionsCell cellIdentifier]];
    
    [_tableView registerClass:[ZZTaskLiskesCell class]
       forCellReuseIdentifier:[ZZTaskLiskesCell cellIdentifier]];
    
    [_tableView registerClass:[ZZSignuperCell class]
       forCellReuseIdentifier:[ZZSignuperCell cellIdentifier]];
    
    [_tableView registerClass:[ZZEmptySignuperTableViewCell class]
       forCellReuseIdentifier:[ZZEmptySignuperTableViewCell cellIdentifier]];
}

- (void)createTableViewFooterView:(BOOL)shouldShow {
    if (shouldShow) {
        ZZSignupFooterView *footerView = [[ZZSignupFooterView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 100)];
        _tableView.tableFooterView = footerView;
    }
    else {
        _tableView.tableFooterView = nil;
    }
}

@end

#pragma mark - TaskSection
@interface TaskSection ()

@end

@implementation TaskSection

- (instancetype)initWithItems:(NSArray<TaskItem *> *)items {
    self = [super init];
    if (self) {
        _items = items;
    }
    return self;
}

@end
