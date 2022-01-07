//
//  ZZTaksListViewModel.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaksListViewModel.h"
#import <CoreLocation/CoreLocation.h>
#import "ZZTaskModel.h"
#import "ZZTaskSignuperModel.h"
#import "ZZTaskUserInfoCell.h"
#import "ZZTaskInfoCell.h"
#import "ZZTaskPhotosCell.h"
#import "ZZTaskActionsCell.h"
#import "ZZTaskLiskesCell.h"
#import "ZZEmptySignuperTableViewCell.h"
#import "ZZActivityUserInfoCell.h"
#import "ZZTaskActivityInfoCell.h"
#import "ZZTaskActivityActionCell.h"
#import "ZXPopupMenu.h"
#import "ZZInfoToastView.h"
#import "ZZWeiChatEvaluationManager.h"
#import "ZZDateHelper.h"
#import "ZZTasksServer.h"

@interface ZZTaksListViewModel () <UITableViewDataSource, UITableViewDelegate, ZZTaskActionsCellDelegate, ZZTaskPhotosCellDelegate, ZZTaskUserInfoCellDelegate, ZZTaskInfoCellDelegate, ZZActivityUserInfoCellDelegate, ZZTaskActivityInfoCellDelegate, ZZTaskActivityActionCellDelegate, ZXPopupMenuDelegate, ZZWechatOrderSmallViewDelegate> {
    float willEndContentOffsetY;//滑动即将结束时偏移
    float endContentOffsetY;//滑动结束时偏移
}

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) NSArray<ZZTaskModel *> *tasksArray;

@property (nonatomic, strong) ZZTaskReponseModel *taskResponeModel;

@property (nonatomic, copy) NSArray<NSArray<TaskItem *> *> *itemsArray;

@property (nonatomic, strong) ZZTaskModel *temppedToCancelTask;

@property (nonatomic, strong) NSIndexPath *temppedToCancelTasksIndexPath;

@end

@implementation ZZTaksListViewModel

- (instancetype)initWithTableView:(UITableView *)tableView
                      currentType:(TaskListType)type
                         taskType:(TaskType)taskType {
    self = [super init];
    if (self) {
        _taskResponeModel = [[ZZTaskReponseModel alloc] init];
        _currentType = type;
        _tableView = tableView;
        _taskType = taskType;
        [self registerTableViewCell];
        [self createCells];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(taskStatusDidChanged:) name:kMsg_TaskStatusDidChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(publishedTask)
                                                     name:kMsg_PublishedTaskNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%p: %@ is dealloced",__func__, NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public Method

#pragma mark - private method
// 没有人脸，则验证人脸
- (void)gotoVerifyFace {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelGoVerify:)]) {
        [self.delegate viewModelGoVerify:self];
    }
}

- (void)showDetaislAction:(ZZTaskModel *)task indexPath:(NSIndexPath *)indexPath {
    if (task.task.isMine) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showDetailWith:indexPath:)]) {
            [self.delegate viewModel:self showDetailWith:task indexPath:indexPath];
        }
    }
}

- (void)chatAction:(ZZTaskModel *)taskModel {
        if (taskModel.from.open_charge) {
            if (_taskType == TaskFree) {
                [self fetchTaskFreeTaskStatue:taskModel completion:^(BOOL shouldShowActionView) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:shouldShowActionView:)]) {
                        [self.delegate viewModel:self chatWith:taskModel shouldShowActionView:shouldShowActionView];
                        [self checkWechatOrChatTaskID:taskModel.task._id taskAction:taskActionChat];
                    }
                }];
            }
            else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:shouldShowActionView:)]) {
                    [self.delegate viewModel:self chatWith:taskModel shouldShowActionView:NO];
                    [self checkWechatOrChatTaskID:taskModel.task._id taskAction:taskActionChat];
                }
            }
        }
        else {
            if ([UserHelper didHaveRealAvatar] || ([UserHelper didHaveOldAvatar] && [UserHelper.loginer isAvatarManualReviewing])) {
                [self fetchSayHiStatusTask:taskModel handler:^(id data) {
                    if ([[data objectForKey:@"say_hi_status"] integerValue] == 0) {
                        // say_hi_status == 0 是不可以打招呼
                        if (loginedUser.avatar_manual_status == 1) {
                            if (![loginedUser didHaveOldAvatar]) {
                                [UIAlertView showWithTitle:@"提示"
                                                   message:@"打招呼需要上传本人五官正脸清晰照，您的头像还在审核中，暂不可打招呼"
                                         cancelButtonTitle:@"知道了"
                                         otherButtonTitles:nil
                                                  tapBlock:nil];
                            }
                            else {
                                if (_taskType == TaskFree) {
                                    [self fetchTaskFreeTaskStatue:taskModel completion:^(BOOL shouldShowActionView) {
                                        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:shouldShowActionView:)]) {
                                            [self.delegate viewModel:self chatWith:taskModel shouldShowActionView:shouldShowActionView];
                                            [self checkWechatOrChatTaskID:taskModel.task._id taskAction:taskActionChat];
                                        }
                                    }];
                                }
                                else {
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:shouldShowActionView:)]) {
                                        [self.delegate viewModel:self chatWith:taskModel shouldShowActionView:NO];
                                        [self checkWechatOrChatTaskID:taskModel.task._id taskAction:taskActionChat];
                                    }
                                }
                            }
                        }
                        else {
                            [ZZHUD showErrorWithStatus:data[@"msg"]];
                        }
                    }
                    else {
                        if (_taskType == TaskFree) {
                            [self fetchTaskFreeTaskStatue:taskModel completion:^(BOOL shouldShowActionView) {
                                if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:shouldShowActionView:)]) {
                                    [self.delegate viewModel:self chatWith:taskModel shouldShowActionView:shouldShowActionView];
                                    [self checkWechatOrChatTaskID:taskModel.task._id taskAction:taskActionChat];
                                }
                            }];
                        }
                        else {
                            if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:shouldShowActionView:)]) {
                                [self.delegate viewModel:self chatWith:taskModel shouldShowActionView:NO];
                                [self checkWechatOrChatTaskID:taskModel.task._id taskAction:taskActionChat];
                            }
                        }
                    }
                }];
            }
            else {
                if ([UserHelper.loginer isAvatarManualReviewing]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"私信TA需要上传本人正脸五官清晰照您的头像正在人工审核中，请等待审核结果" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:doneAction];
                    
                    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                    if ([rootVC presentedViewController] != nil) {
                        rootVC = [UIAlertController findAppreciatedRootVC];
                    }
                    [rootVC presentViewController:alertController animated:YES completion:nil];
                }
                else {
                    [UIAlertController presentAlertControllerWithTitle:@"温馨提示"
                                                               message:@"您未上传本人正脸五官清晰照，暂不可私信TA"
                                                             doneTitle:@"去上传"
                                                           cancelTitle:@"取消"
                                                         completeBlock:^(BOOL isCancelled) {
                                                             if (!isCancelled) {
                                                                 if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showUploadFaceVC:)]) {
                                                                     [self.delegate viewModel:self showUploadFaceVC:taskModel];
                                                                 }
                                                             }
                                                         }];
                }
            }
        }
}

/**
 订单操作
 */
- (void)taskStatusDidChanged:(ZZTaskModel *)task atIndex:(NSIndexPath *)indexPath action:(TaskAction)action {
    if ((action == taskActionCancel || action == taskActionClose) && _currentType == ListAll) {
        // 只有在全部的列表中需要删除
        NSMutableArray *taskMut = _tasksArray.mutableCopy;
        NSMutableArray *itemMut = _itemsArray.mutableCopy;
        [taskMut removeObjectAtIndex: _temppedToCancelTasksIndexPath.section];
        [itemMut removeObjectAtIndex: _temppedToCancelTasksIndexPath.section];
        _tasksArray = taskMut.copy;
        _itemsArray = itemMut.copy;
        [_tableView reloadData];
        [self postNotification:task action:action indexPath:indexPath];
    }
    else {
        if (action == taskActionLike) {
            // 点赞
            ZZTaskModel *task = _itemsArray[indexPath.section][0].task;
            task.task.selected_count = 1;
            task.task.like += 1;
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            [self postNotification:task action:action indexPath:indexPath];
        }
        else if (action == taskActionSignUp) {
            // 报名
            ZZTaskModel *task = _itemsArray[indexPath.section][0].task;
            task.task.push_count = 1;
            task.task.count += 1;
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            [self postNotification:task action:action indexPath:indexPath];
        }
        else if (action == taskActionCancel) {
            ZZTaskModel *task = _itemsArray[indexPath.section][0].task;
            task.task.order_end = 0;
            task.task.status = 2;
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            [self postNotification:task action:action indexPath:indexPath];
        }
        else if (action == taskActionClose) {
            ZZTaskModel *task = _itemsArray[indexPath.section][0].task;
            task.task.order_end = 1;
            task.task.status = 0;
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            [self postNotification:task action:action indexPath:indexPath];
        }
    }
}

- (void)publishedTask {
    [_tableView.mj_header beginRefreshing];
}

/**
 *  发送通知
 */
- (void)postNotification:(ZZTaskModel *)task action:(TaskAction)action indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *userInfo = @{
                                      @"task": task,
                                      @"from": @"taskList",
                                      @"action": @(action),
                                      @"currentListType": @(_currentType),
                                      }.mutableCopy;
    userInfo[@"indexPath"] = indexPath;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_TaskStatusDidChanged
                                                        object:nil
                                                      userInfo:userInfo];
}

/**
 *  是不是可以操作
 *  必须登陆并且没有被封禁
 */
- (BOOL)actionCanProceed:(TaskAction)taskAction task:(ZZTaskModel *)task {
    // 未登录
    if (![ZZUserHelper shareInstance].isLogin) {
        UITabBarController *tabs = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navCtl = [tabs selectedViewController];
        NSLog(@"PY_登录界面%s",__func__);
        [[LoginHelper sharedInstance] showLoginViewIn:navCtl];
        return NO;
    }
    
    // 被封禁
    if ([ZZUtils isBan]) {
        [ZZHUD showErrorWithStatus:@"您已被封禁"];
        return NO;
    }
    
    return YES;
}

/**
 * 保存最新的一次刷新时间,用于显示有多少新的邀约
 */
- (void)saveRefreshTaskTime {
    if (_taskType != TaskFree) {
        NSString *latestTime = [ZZDateHelper getCurrentDate] ;
        [ZZUserDefaultsHelper setObject:latestTime forDestKey:@"TastLatestRead"];
    }
}

/**
 * 显示提示文案 目前只有普通的通告需要
 */
- (void)notifiToShowTips {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showAlertMessage:)]) {
        [self.delegate viewModel:self showAlertMessage:_taskResponeModel.tipText];
    }
}

#pragma mark - Notification Method
- (void)taskStatusDidChanged:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"%@",userInfo);
    if ([userInfo count] > 0) {
        
        if ([userInfo[@"from"] isEqualToString:@"taskList"] && ([userInfo[@"currentListType"] integerValue] == _currentType)) {
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            TaskAction action = (TaskAction)[userInfo[@"action"] integerValue];
            ZZTaskModel *changedTask = userInfo[@"task"];
            __block ZZTaskModel *selectedTask = nil;
            __block NSInteger index = -1;
            [_itemsArray enumerateObjectsUsingBlock:^(NSArray<TaskItem *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([changedTask.task._id isEqualToString:obj.firstObject.task.task._id]) {
                    *stop = YES;
                    selectedTask = obj.firstObject.task;
                    index = idx;
                }
            }];
            
            if (!selectedTask) {
                return ;
            }
            
            if ((action == taskActionCancel || action == taskActionClose || action == taskActionPick || action == taskActionTonggaoPay) && _currentType == ListAll) {
                // 只有在全部的列表中需要删除
                NSMutableArray *taskMut = _tasksArray.mutableCopy;
                NSMutableArray *itemMut = _itemsArray.mutableCopy;
                [taskMut removeObjectAtIndex: index];
                [itemMut removeObjectAtIndex: index];
                _tasksArray = taskMut.copy;
                _itemsArray = itemMut.copy;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }
            else {
                if (action == taskActionLike) {
                    // 点赞
                    selectedTask.task.selected_count = 1;
                    selectedTask.task.like += 1;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (index == -1) {
                            [_tableView reloadData];
                        }
                        else {
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    });
                }
                else if (action == taskActionSignUp) {
                    // 报名
                    selectedTask.task.push_count = 1;
                    selectedTask.task.count += 1;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (index == -1) {
                            [_tableView reloadData];
                        }
                        else {
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    });
                }
                else if (action == taskActionCancel) {
                    selectedTask.task.order_end = 0;
                    selectedTask.task.status = 2;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (index == -1) {
                            [_tableView reloadData];
                        }
                        else {
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    });
                }
                else if (action == taskActionClose) {
                    selectedTask.task.order_end = 1;
                    selectedTask.task.status = 0;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (index == -1) {
                            [_tableView reloadData];
                        }
                        else {
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    });
                }
                else if (action == taskActionPick) {
                    selectedTask.task.order_end = 1;
                    selectedTask.task.status = 3;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (index == -1) {
                            [_tableView reloadData];
                        }
                        else {
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    });
                }
                else if (action == taskActionTonggaoPay) {
                    selectedTask.task.order_end = 1;
                    selectedTask.task.status = 3;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (index == -1) {
                            [_tableView reloadData];
                        }
                        else {
                            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    });
                }
            }
        });
    }
}

#pragma mark - ZXPopupMenuDelegate
- (void)zxPopupMenuDidSelectedAtIndex:(NSInteger)index zxPopupMenu:(ZXPopupMenu *)zxPopupMenu {
    switch (index) {
        case 0:{
            if (_temppedToCancelTask.task.isMine) {
                // 取消发布
                if ([_temppedToCancelTask.task isNewTask]) {
                    ToastType type = ToastTonggaoCancelStyle1;
                    BOOL isPassLimitedTime = [_temppedToCancelTask.task isPassLimitedTime];
                    if (isPassLimitedTime && _temppedToCancelTask.task.count == 0) {
                        type = ToastTonggaoCancelStyle2;
                    }
                    else {
                        type = ToastTonggaoCancelStyle1;
                    }
                    
                    [ZZInfoToastView showWithType:type action:^(NSInteger actionIndex, ToastType type) {
                        if (actionIndex == 1) {
                            [self newCancelTask:_temppedToCancelTask indexPath:_temppedToCancelTasksIndexPath];
                        }
                    }];
                }
                else {
                    ToastType type = ToastTaskCancel;
                    if (_taskType == TaskFree) {
                        type = ToastTaskActivityCancel;
                    }
                    [ZZInfoToastView showWithType:type action:^(NSInteger actionIndex, ToastType type) {
                        if (actionIndex == 1) {
                            [self cancelTask:_temppedToCancelTask indexPath:_temppedToCancelTasksIndexPath];
                        }
                    }];
                }
            }
            else {
                // 举报
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showReportView:)]) {
                    [self.delegate viewModel:self showReportView:_temppedToCancelTask];
                }
                _temppedToCancelTask = nil;
                _temppedToCancelTasksIndexPath = nil;
            }
            break;
        }
        default:
            break;
    }
}

- (void)zxPopupMenuTouchOutside:(ZXPopupMenu *)zxPopupMenu {
    _temppedToCancelTask = nil;
    _temppedToCancelTasksIndexPath = nil;
}

#pragma mark - ZZTaskUserInfoCellDelegate
/**
 现实更多
 */
- (void)cell:(ZZTaskUserInfoCell *)cell showMoreAction:(TaskUserInfoItem *)item {
    if (![self actionCanProceed:taskActionNone task:_temppedToCancelTask]) {
        return;
    }
    if (item.task.task.isMine) {
        // 取消任务
        if (item.task.task.taskStatus == TaskOngoing || item.task.task.taskStatus == TaskClose) {
            NSArray *titleArray = @[@"取消发布"];
            [ZXPopupMenu showRelyOnView:cell.moreBtn titles:titleArray icons:nil menuWidth:135 otherSettings:^(ZXPopupMenu *popupMenu) {
                _temppedToCancelTask = item.task;
                _temppedToCancelTasksIndexPath = item.indexPath;
                popupMenu.delegate = self;
            }];
        }
    }
    else {
        // 举报
        if (item.task.task.taskStatus == TaskOngoing) {
            NSArray *titleArray = @[@"匿名举报"];
            [ZXPopupMenu showRelyOnView:cell.moreBtn titles:titleArray icons:nil menuWidth:135 otherSettings:^(ZXPopupMenu *popupMenu) {
                _temppedToCancelTask = item.task;
                _temppedToCancelTasksIndexPath = item.indexPath;
                popupMenu.delegate = self;
            }];
        }
    }
}

/**
 用户信息
 */
- (void)cell:(ZZTaskUserInfoCell *)cell showUserInfoWith:(TaskUserInfoItem *)item {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showUserInfoWith:)]) {
        [self.delegate viewModel:self showUserInfoWith:item.task];
    }
}

- (void)cell:(ZZTaskUserInfoCell *)cell cancelAction:(TaskUserInfoItem *)item {
    
    if (item.task.task.isMine) {
        
        _temppedToCancelTask = item.task;
        _temppedToCancelTasksIndexPath = item.indexPath;
        
        if ([_temppedToCancelTask.task isNewTask]) {
            ToastType type = ToastTonggaoCancelStyle1;
            BOOL isPassLimitedTime = [_temppedToCancelTask.task isPassLimitedTime];
            if (isPassLimitedTime && _temppedToCancelTask.task.count == 0) {
                type = ToastTonggaoCancelStyle2;
            }
            else {
                type = ToastTonggaoCancelStyle1;
            }
            
            [ZZInfoToastView showWithType:type action:^(NSInteger actionIndex, ToastType type) {
                if (actionIndex == 1) {
                    [self newCancelTask:_temppedToCancelTask indexPath:_temppedToCancelTasksIndexPath];
                }
            }];
        }
        else {
            ToastType type = ToastTaskCancel;
            if (_taskType == TaskFree) {
                type = ToastTaskActivityCancel;
            }
            
            [ZZInfoToastView showWithType:type action:^(NSInteger actionIndex, ToastType type) {
                if (actionIndex == 1) {
                    [self cancelTask:_temppedToCancelTask indexPath:_temppedToCancelTasksIndexPath];
                }
            }];
        }
    }
}

#pragma mark - ZZTaskInfoCell
/**
 显示位置
 */
- (void)cell:(ZZTaskInfoCell *)cell showLocations:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showLocations:)]) {
        [self.delegate viewModel:self showLocations:task];
    }
}

/**
 显示价格
 */
- (void)cell:(ZZTaskInfoCell *)cell showPriceDetails:(ZZTaskModel *)task {
    if (task.task.isMine) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showPriceDetails:)]) {
            [self.delegate viewModel:self showPriceDetails:task];
        }
    }
}

#pragma mark - ZZTaskPhotosCellDelegate
/**
 浏览图片
 */
- (void)cell:(ZZTaskPhotosCell *)cell showPhotoWith:(ZZTaskModel *)task currentImgStr:(NSString *)currentImgStr {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showPhotoWith:currentImgStr:)]) {
        [self.delegate viewModel:self showPhotoWith:task currentImgStr:currentImgStr];
    }
}

#pragma mark - ZZTaskActionsCellDelegate
/**
 点赞
 */
- (void)cell:(ZZTaskActionsCell *)cell likeActionWithItem:(TaskActionsItem *)item {
    if (![self actionCanProceed:taskActionLike task:item.task]) {
        return;
    }
    
    if (item.task.task.selected_count == 1) {
        [ZZHUD showTaskInfoWithStatus:@"您已经点赞过了"];
    }
    else {
        [self like:item.task indexPath:item.indexPath];
    }
}

/**
 聊天
 */
- (void)cell:(ZZTaskActionsCell *)cell chatWithItem:(TaskActionsItem *)item {
    if (![self actionCanProceed:taskActionChat task:item.task]) {
        return;
    }
    
    if (item.task.task.isMine) {
        [self showDetaislAction:item.task indexPath:item.indexPath];
    }
    else {
        [self chatAction:item.task];
    }
}

/**
 报名
 */
- (void)cell:(ZZTaskActionsCell *)cell signUpActionWith:(TaskActionsItem *)item {
    if (![self actionCanProceed:taskActionSignUp task:item.task]) {
        return;
    }
    
    if (item.task.task.isMine) {
        // 只有订单还在进行中,才能点击结束订单
        if (item.task.task.taskStatus == TaskOngoing) {
            NSString *errorMsg = nil;
            if (item.task.task.count != 0) {
                errorMsg = @"结束后，发布服务费不再退还，您只能从已报名用户中选择达人进行本次通告";
            }
            else {
                if ([item.task.task isPassLimitedTime]) {
                    errorMsg = @"您的发布已满30分钟，非常抱歉暂无达人报名您的通告，发布服务费将在通告过期后原路退还给您";
                }
                else {
                    errorMsg = @"您的发布未满30分钟，结束报名后达人将无法报名。发布服务费将不再退还";
                }
            }
            [UIAlertController presentAlertControllerWithTitle:@"确认结束报名吗？" message:errorMsg doneTitle:@"结束" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
                if (!isCancelled) {
                    [self closeTask:item.task indexPath:item.indexPath];
                }
            }];
        }
    }
    else {
        if (item.task.task.push_count == 1) {
            [ZZHUD showTaskInfoWithStatus:@"您已报名过，私信对方，获取更多机会"];
        }
        else {
            // 结束的单子就不需要下面操作了
            if (item.task.task.isTaskFinished) {
                [ZZHUD showTaskInfoWithStatus:@"通告已过期,发起私信就能收获Ta这个朋友"];
                return;
            }
            
            if (([UserHelper.loginer isAvatarManualReviewing] && ![UserHelper.loginer didHaveOldAvatar])) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您的头像正在人工审核中，暂不可报名" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                }];
                [alertController addAction:doneAction];

                UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                if ([rootVC presentedViewController] != nil) {
                    rootVC = [UIAlertController findAppreciatedRootVC];
                }
                [rootVC presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            // 头像可以报名逻辑: 有真实头像或者没有真实头像但是头像在人工审核中并且有旧的可用头像
            if (![UserHelper didHaveRealAvatar] && !([UserHelper isAvatarManualReviewing] && [UserHelper.loginer didHaveOldAvatar])) {
                [UIAlertController presentAlertControllerWithTitle:@"您未上传本人正脸五官清晰照，暂不可报名"
                                                           message:nil
                                                         doneTitle:@"去上传"
                                                       cancelTitle:@"取消"
                                                     completeBlock:^(BOOL isCancelled) {
                                                         if (!isCancelled) {
                                                             if (![UserHelper didHaveRealFace]) {
                                                                 [self gotoVerifyFace];
                                                                 return;
                                                             }
                                                             if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showUploadFaceVC:)]) {
                                                                 [self.delegate viewModel:self showUploadFaceVC:item.task];
                                                             }
                                                         }
                                                     }];
                return;
            }
            
            // 性别设置
            if ((item.task.task.gender != UserHelper.loginer.gender) && item.task.task.gender != 3) {
                [ZZHUD showErrorWithStatus:@"Ta设置了性别限制，同性无法报名哦"];
                return;
            }
            
            // 距离限制
            if ([item.task.task.address_city_name doubleValue] > _taskResponeModel.enterDisNum) {
                [ZZHUD showErrorWithStatus:@"距离过远,无法报名哦"];
                return;
            }
            
            // 报名
            [ZZInfoToastView showWithType:ToastTaskConfirmSignUp task:item.task.task action:^(NSInteger actionIndex, ToastType type) {
                if (actionIndex == 1) {
                    [self signUpForTask:item.task indexPath:item.indexPath];
                }
                else {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:chatWith:shouldShowActionView:)]) {
                        [self.delegate viewModel:self chatWith:item.task shouldShowActionView:NO];
                    }
                    
                }
            }];
        }
    }
}

#pragma mark - ZZActivityUserInfoCellDelegate
/**
 用户信息
 */
- (void)cell:(ZZActivityUserInfoCell *)cell activityShowUserInfoWith:(TaskActivityUserInfoItem *)item {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showUserInfoWith:)]) {
        [self.delegate viewModel:self showUserInfoWith:item.task];
    }
}

#pragma mark ZZTaskActivityInfoCellDelegate
/**
 地点
 */
- (void)cell:(ZZTaskActivityInfoCell *)cell activityShowLocations:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showLocations:)]) {
        [self.delegate viewModel:self showLocations:task];
    }
}

/**
 价格详情
 */
- (void)cell:(ZZTaskActivityInfoCell *)cell activityShowPriceDetails:(ZZTaskModel *)task {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:showPriceDetails:)]) {
        [self.delegate viewModel:self showPriceDetails:task];
    }
}

/**
 更多
 */
- (void)cell:(ZZTaskActivityInfoCell *)cell activityShowMoreAction:(TaskActivityInfoItem *)item {
    if (item.task.task.isMine) {
        if (item.task.task.taskStatus == TaskOngoing) {
            // 取消任务
            if (_taskType == TaskFree) {
                [ZZInfoToastView showWithType:ToastTaskActivityCancel action:^(NSInteger actionIndex, ToastType type) {
                    if (actionIndex == 1) {
                        [self cancelTask:item.task indexPath:item.indexPath];
                    }
                }];
            }
            else {
                NSArray *titleArray = @[@"取消发布"];
                [ZXPopupMenu showRelyOnView:cell.moreBtn titles:titleArray icons:nil menuWidth:135 otherSettings:^(ZXPopupMenu *popupMenu) {
                    _temppedToCancelTask = item.task;
                    _temppedToCancelTasksIndexPath = item.indexPath;
                    popupMenu.delegate = self;
                }];
            }
        }
    }
    else {
        // 举报
        if (item.task.task.taskStatus == TaskOngoing) {
            NSArray *titleArray = @[@"匿名举报"];
            [ZXPopupMenu showRelyOnView:cell.moreBtn titles:titleArray icons:nil menuWidth:135 otherSettings:^(ZXPopupMenu *popupMenu) {
                _temppedToCancelTask = item.task;
                _temppedToCancelTasksIndexPath = item.indexPath;
                popupMenu.delegate = self;
            }];
        }
    }
}

#pragma mark ZZTaskActivityActionCellDelegate
/**
 租他
 */
- (void)cell:(ZZTaskActivityActionCell *)cell rent:(TaskActivityActionsItem *)item {
    if (![self actionCanProceed:taskActionSignUp task:item.task]) {
        return;
    }
    
    if (![self actionCanProceed:taskActionRent task:_temppedToCancelTask]) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:rent:)]) {
        [self.delegate viewModel:self rent:item.task];
    }
}

/**
 聊天
 */
- (void)cell:(ZZTaskActivityActionCell *)cell chat:(TaskActivityActionsItem *)item {
    if (![self actionCanProceed:taskActionSignUp task:item.task]) {
        return;
    }
    
    [self chatAction:item.task];
}

/**
 查看微信
 */
- (void)cell:(ZZTaskActivityActionCell *)cell checkWechat:(TaskActivityActionsItem *)item {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModel:buyWechat:)]) {
        [self.delegate viewModel:self buyWechat:item.task];
    }
    
    if (_taskType == TaskFree) {
        [self checkWechatOrChatTaskID:item.task.task._id taskAction:taskActionCheckWechat];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _itemsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _itemsArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskItem *item = _itemsArray[indexPath.section][indexPath.row];
    
    switch (item.type) {
        case taskUserInfo: {
            ZZTaskUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskUserInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.item = (TaskUserInfoItem *)item;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case taskActivityUserInfo: {
            ZZActivityUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZActivityUserInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.item = (TaskActivityUserInfoItem *)item;
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
        case taskActivityInfo: {
            ZZTaskActivityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskActivityInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.item = (TaskActivityInfoItem *)item;
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
        case taskActivityAction: {
            ZZTaskActivityActionCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskActivityActionCell cellIdentifier] forIndexPath:indexPath];
            cell.item = (TaskActivityActionsItem *)item;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case taskLikes: {
            ZZTaskLiskesCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskLiskesCell cellIdentifier] forIndexPath:indexPath];
            cell.item = item;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case taskEmpty: {
            ZZEmptySignuperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZEmptySignuperTableViewCell cellIdentifier] forIndexPath:indexPath];
            TaskEmptyItem *emptyItem = (TaskEmptyItem *)item;
            cell.item = emptyItem;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_taskType == TaskFree) {
        // 活动没有详情页面
        return;
    }
    TaskItem *item = _itemsArray[indexPath.section][indexPath.row];
    switch (item.type) {
        case taskUserInfo: {
            [self showDetaislAction:item.task indexPath:item.indexPath];
            break;
        }
        case taskInfo: {
            [self showDetaislAction:item.task indexPath:item.indexPath];
            break;
        }
        case taskPhotos: {
            [self showDetaislAction:item.task indexPath:item.indexPath];
            break;
        }
        default: {
            
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.01)];
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 10.0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskItem *item = _itemsArray[indexPath.section][indexPath.row];
    return item.cellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    willEndContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    endContentOffsetY = scrollView.contentOffset.y;
    
    if (endContentOffsetY < willEndContentOffsetY) {
        // 从下往上移动
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublishBtnShowNotification object:nil userInfo:@{@"shouldShow": @(YES)}];
    }
    else if (endContentOffsetY > willEndContentOffsetY) {
        // 从上往下移动
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublishBtnShowNotification object:nil userInfo:@{@"shouldShow": @(NO)}];
    }
}

#pragma mark - Request
- (void)refreshing {
    if (_currentType == ListAll) {
        // 再刷新全部列表的时候要去获取一下未读的消息
        [self fetchAllTasks:0 typeStatus:0];
    }
    else {
        [self fetchMyTasksList:nil];
    }
}

- (void)fetchAllTasks:(NSInteger)pageIndex typeStatus:(NSInteger)typeStatus {
    if (pageIndex == 0) {
        if (_taskType != TaskFree) {
            [self fetchUnreadTasks];
        }
        
    }
    [self fetchAllTaskList:pageIndex typeStatus:typeStatus];
}

/**
 获取全部列表
 */
- (void)fetchAllTaskList:(NSInteger)pageIndex typeStatus:(NSInteger)typeStatus {
    if (isNullString(UserHelper.loginer.uid)) {
        return;
    }
    NSDictionary *param = @{
                            @"lat"        : @(UserHelper.location.coordinate.latitude),
                            @"lng"        : @(UserHelper.location.coordinate.longitude),
                            @"genderNum"  : @(UserHelper.loginer.gender),
                            @"uid"        : UserHelper.loginer.uid,
                            @"pageIndex"  : @(pageIndex),
                            @"typeStatus" : @(typeStatus),
                            };
    [ZZHUD show];
    [ZZTasksServer fetchTasksListWithParams:param taskType:_taskType handler:^(ZZError *error, id data) {
        [ZZHUD dismiss];
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        
        if (!error) {
            ZZTaskReponseModel *taskResponeModel = [[ZZTaskReponseModel alloc] initWithDictionary:data error:nil];
            
            // 要去过滤列表
            [taskResponeModel filterCanDisplayTask];
            
            if (pageIndex == 0) {
                // 下拉刷新
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    [self fetchAllTasks:_taskResponeModel.pageIndex + 2
                             typeStatus:_taskResponeModel.typeStatus];
                }];
                
                _taskResponeModel = taskResponeModel;
                
                // 保存最新的一次刷新时间,用于显示有多少新的邀约
                [self saveRefreshTaskTime];
                
                // 显示提示文案
                [self notifiToShowTips];
            }
            else {
                // 上拉加载更多
                [_taskResponeModel addMoreTasks:taskResponeModel];
            }
            [self createCells];
        }
        else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

/**
 获取我的列表
 */
- (void)fetchMyTasksList:(NSString *)time {
    NSMutableDictionary *param = @{
                                   @"uid": UserHelper.loginer.uid,
                                   }.mutableCopy;

    if (!isNullString(time)) {
        param[@"lastTime"] = time;
    }
    
    [ZZHUD show];
    [ZZTasksServer fetchMyTasksListWithParams:param.copy taskType:_taskType handler:^(ZZError *error, id data) {
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
        
        if ([_tableView.mj_footer isRefreshing]) {
            [_tableView.mj_footer endRefreshing];
        }
        [ZZHUD dismiss];
        if (!error) {
            NSMutableArray<ZZTask *> *array = [ZZTask arrayOfModelsFromDictionaries:data error:nil];
            if (!time) {
                // 下拉刷新
                _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    ZZTaskModel *lastTask = _taskResponeModel.tasksArray.lastObject;
                    [self fetchMyTasksList:lastTask.task.created_at];
                }];
                [_taskResponeModel configureMyTaskModels:array];
            }
            else {
                // 上拉加载更多
                [_taskResponeModel addMoreMyTasks:array];
            }
            [self createCells];
            
        }
        else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

/**
 报名
 */
- (void)signUpForTask:(ZZTaskModel *)taskModel indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *param = @{
                                   @"uid": UserHelper.loginer.uid,
                                   @"pid": taskModel.task._id,
                                   }.mutableCopy;
    [ZZHUD show];
    [ZZTasksServer signupWithParams:param.copy handler:^(ZZError *error, id data) {
        [ZZHUD dismiss];
        if (!error) {
            [ZZHUD showSuccessWithStatus:@"报名成功，请等待对方选择 "];
            [self taskStatusDidChanged:taskModel atIndex:indexPath action:taskActionSignUp];
        }
        else {
            [ZZHUD showErrorWithStatus:error.message];
        }
    }];
}

/**
 点赞
 */
- (void)like:(ZZTaskModel *)taskModel indexPath:(NSIndexPath *)indexPath {
    NSDictionary *param = @{
                            @"uid": UserHelper.loginer.uid,
                            @"pid": taskModel.task._id,
                            };
    [ZZHUD show];
    [ZZTasksServer likeWithParams:param
                          handler:^(ZZError *error, id data) {
                              [ZZHUD dismiss];
                              if (!error) {
                                  [ZZHUD showSuccessWithStatus:@"点赞成功"];
                                  [self taskStatusDidChanged:taskModel atIndex:indexPath action:taskActionLike];
                              }
                              else {
                                  [ZZHUD showErrorWithStatus:error.message];
                              }
                          }];
}

/**
 新版取消任务
 */
- (void)newCancelTask:(ZZTaskModel *)taskModel indexPath:(NSIndexPath *)indexPath {
    [ZZHUD show];
    [ZZTasksServer newCancelWithTaskID:taskModel.task._id taskType:_taskType handler:^(ZZError *error, id data) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [_tableView reloadData];
            [ZZHUD showSuccessWithStatus:@"任务已取消"];
            [self taskStatusDidChanged:taskModel atIndex:indexPath action:taskActionCancel];
        }
        _temppedToCancelTasksIndexPath = nil;
        _temppedToCancelTask = nil;
    }];
}

/**
 取消任务
 */
- (void)cancelTask:(ZZTaskModel *)taskModel indexPath:(NSIndexPath *)indexPath {
    [ZZHUD show];
    [ZZTasksServer cancelWithTaskID:taskModel.task._id taskType:_taskType handler:^(ZZError *error, id data) {
        [ZZHUD dismiss];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [self taskStatusDidChanged:taskModel atIndex:indexPath action:taskActionCancel];
            if (_taskType == TaskFree) {
                [ZZHUD showSuccessWithStatus:@"活动取消成功"];
            }
            else {
                [ZZHUD showSuccessWithStatus:@"任务已取消"];
            }
        }
        _temppedToCancelTasksIndexPath = nil;
        _temppedToCancelTask = nil;
    }];
}

/**
 结束报名
 */
- (void)closeTask:(ZZTaskModel *)taskModel indexPath:(NSIndexPath *)indexPath {
    [ZZHUD show];
    [ZZTasksServer closeWithParams:@{
                                     @"pid": taskModel.task._id,
                                     @"uid": UserHelper.loginer.uid
                                     }
                           handler:^(ZZError *error, id data) {
                               [ZZHUD dismiss];
                               if (error) {
                                   [ZZHUD showErrorWithStatus:error.message];
                               }
                               else {
                                   [self taskStatusDidChanged:taskModel atIndex:indexPath action:taskActionClose];
                                   [ZZHUD showSuccessWithStatus:@"任务已结束报名"];
                               }
                           }];
}

/**
 获取未读的消息
 */
- (void)fetchUnreadTasks {
    [ZZUser getUserUnread:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            ZZUserUnread *userUnread = [[ZZUserUnread alloc] initWithDictionary:data error:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_TaskUnreadCountDidChanged object:nil userInfo:@{@"unreadCounts": @(userUnread.pd_receive)}];
        }
    }];
}

/**
 打招呼状态
 */
- (void)fetchSayHiStatusTask:(ZZTaskModel *)taskModel handler:(void(^)(id data))hander {
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/say_hi_status",taskModel.from.uid ] params:@{@"sayhi_type": @"3.7.0"} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
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

/**
    判断活动两个人是否已经发生了关系,有关系则不需要显示发送的聊天框
 */
- (void)fetchTaskFreeTaskStatue:(ZZTaskModel *)taskModel completion:(void(^)(BOOL shouldShowActionView))completion {
    [ZZRequest method:@"GET"
                 path:@"/api/pdg/getPdgBeUser"
               params:@{
                        @"from" : [ZZUserHelper shareInstance].loginer.uid,
                        @"to"   : taskModel.from.uid,
                        @"pdgid": taskModel.task._id
                        }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        BOOL shouldShow = YES;
        if (!error && data) {
            NSArray *dataArr = (NSArray *)data;
            if (dataArr.count > 0) {
                shouldShow = NO;
            }
        }
        if (completion) {
            completion(shouldShow);
        }
    }];
}

/**
 * 埋点 活动的查看微信和私信
 */
- (void)checkWechatOrChatTaskID:(NSString *)taskID taskAction:(TaskAction)action {
    if (isNullString(UserHelper.loginer.uid) || isNullString(taskID)) {
        return;
    }
    NSMutableDictionary *param = @{
                            @"pdgid" : taskID,
                            @"from"  : UserHelper.loginer.uid,
                            }.mutableCopy;
    NSString *actionStr = nil;
    if (action == taskActionChat) {
        actionStr = @"chat";
    }
    else if (action == taskActionCheckWechat) {
        actionStr = @"wechat";
    }
    param[@"type"] = actionStr;
    
    [ZZTasksServer checkWechatOrChat:param.copy handler:nil];
}

#pragma mark - TableView Config
/**
 创建视图
 */
- (void)createCells {
    __block NSMutableArray<NSArray *> *sectionsArray = @[].mutableCopy;
    if (_taskResponeModel.tasksArray.count == 0) {
        
        NSString *title = nil, *icon = nil;
        if (_taskType == TaskNormal) {
            icon = @"picQuesheng";
            title = _currentType == ListAll ? @"一大波通告正在来的路上 等会再来" : @"你还没发布过通告，不能再低调了";
        }
        else {
            icon  = _currentType == ListAll ? @"picDefaultQuanbuhuodong" : @"picDefault";
            title = _currentType == ListAll ? @"一大波活动正在来的路上，等会再来。" : @"您还没有发布过活动";
        }
        TaskEmptyItem *item = [[TaskEmptyItem alloc] initWithEmptyTitle:title];
        item.icon = icon;
        [sectionsArray addObject:@[item]];
    }
    else {
        [_taskResponeModel.tasksArray enumerateObjectsUsingBlock:^(ZZTaskModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *itemsArray = [self createCellFor:obj idx:idx];
            [sectionsArray addObject:itemsArray];
        }];
    }
    
    _itemsArray = sectionsArray.copy;
    [_tableView reloadData];
}

/**
 创建单个视图
 */
- (NSArray<TaskItem *> *)createCellFor:(ZZTaskModel *)task idx:(NSInteger)idx {
    NSMutableArray<TaskItem *> *itemsArray = @[].mutableCopy;
    
    if (_taskType == TaskFree) {
        NSInteger row = 0;
        TaskActivityUserInfoItem *userInfoItem = [[TaskActivityUserInfoItem alloc] initWithTaksModel:task];
        userInfoItem.listType = _currentType;
        userInfoItem.indexPath = [NSIndexPath indexPathForRow:row inSection:idx];
        userInfoItem.taskType = _taskType;
        [itemsArray addObject:userInfoItem];
        row++;
        
        // 任务信息
        TaskActivityInfoItem *taskInfoItem = [[TaskActivityInfoItem alloc] initWithTaksModel:task];
        taskInfoItem.listType = _currentType;
        taskInfoItem.indexPath = [NSIndexPath indexPathForRow:row inSection:idx];
        taskInfoItem.taskType = _taskType;
        [itemsArray addObject:taskInfoItem];
        row++;
        
        // 图片
        if ([task.task canShowImage:_currentType == ListAll]) {
            TaskPhotoItem *taskPhotoItem = [[TaskPhotoItem alloc] initWithTaksModel:task];
            taskPhotoItem.listType = _currentType;
            taskPhotoItem.indexPath = [NSIndexPath indexPathForRow:row inSection:idx];
            taskPhotoItem.taskType = _taskType;
            [itemsArray addObject:taskPhotoItem];
            row++;
        }
        
        if (!task.task.isMine) {
            // 操作
            TaskActivityActionsItem *actionItem = [[TaskActivityActionsItem alloc] initWithTaksModel:task];
            actionItem.listType = _currentType;
            actionItem.indexPath = [NSIndexPath indexPathForRow:row inSection:idx];
            actionItem.taskType = _taskType;
            [itemsArray addObject:actionItem];
        }
    }
    else {
        // 用户信息
        TaskUserInfoItem *userInfoItem = [[TaskUserInfoItem alloc] initWithTaksModel:task];
        userInfoItem.listType = _currentType;
        userInfoItem.indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
        userInfoItem.taskType = _taskType;
        [itemsArray addObject:userInfoItem];
        
        // 任务信息
        TaskInfoItem *taskInfoItem = [[TaskInfoItem alloc] initWithTaksModel:task];
        taskInfoItem.listType = _currentType;
        taskInfoItem.indexPath = [NSIndexPath indexPathForRow:1 inSection:idx];
        taskInfoItem.taskType = _taskType;
        [itemsArray addObject:taskInfoItem];
        
        // 图片
        if ([task.task canShowImage:_currentType == ListAll]) {
            TaskPhotoItem *taskPhotoItem = [[TaskPhotoItem alloc] initWithTaksModel:task];
            taskPhotoItem.listType = _currentType;
            taskPhotoItem.indexPath = [NSIndexPath indexPathForRow:2 inSection:idx];
            taskPhotoItem.taskType = _taskType;
            [itemsArray addObject:taskPhotoItem];
        }
        
        // 操作
        TaskActionsItem *actionItem = [[TaskActionsItem alloc] initWithTaksModel:task];
        actionItem.listType = _currentType;
        actionItem.indexPath = [NSIndexPath indexPathForRow:3 inSection:idx];
        actionItem.taskType = _taskType;
        [itemsArray addObject:actionItem];
    }
    
    return itemsArray.copy;
}

/**
 注册cell
 */
- (void)registerTableViewCell {
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [self refreshing];
    }];
    
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
    
    [_tableView registerClass:[ZZEmptySignuperTableViewCell class]
       forCellReuseIdentifier:[ZZEmptySignuperTableViewCell cellIdentifier]];
    
    [_tableView registerClass:[ZZActivityUserInfoCell class]
       forCellReuseIdentifier:[ZZActivityUserInfoCell cellIdentifier]];
    
    [_tableView registerClass:[ZZTaskActivityInfoCell class]
       forCellReuseIdentifier:[ZZTaskActivityInfoCell cellIdentifier]];
    
    [_tableView registerClass:[ZZTaskActivityActionCell class]
       forCellReuseIdentifier:[ZZTaskActivityActionCell cellIdentifier]];
}

@end

#pragma mark - TaskItem
@interface TaskItem ()

@end

@implementation TaskItem

- (TaskItemType)type {
    return taskNone;
}

- (NSString *)identifier {
    return @"PostTaskItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

@end

#pragma mark - TaskUserInfoItem
@interface TaskUserInfoItem ()

@end

@implementation TaskUserInfoItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel {
    self = [super init];
    if (self) {
        self.task = taskModel;
    }
    return self;
}

- (TaskItemType)type {
    return taskUserInfo;
}

- (NSString *)identifier {
    return @"TaskUserInfoItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (CGFloat)cellHeight {
    return 83.5;
}

@end

#pragma mark - TaskActivityUserInfoItem
@interface TaskActivityUserInfoItem ()

@end

@implementation TaskActivityUserInfoItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel {
    self = [super init];
    if (self) {
        self.task = taskModel;
    }
    return self;
}

- (TaskItemType)type {
    return taskActivityUserInfo;
}

- (NSString *)identifier {
    return @"TaskActivityUserInfoItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (CGFloat)cellHeight {
    return 83;
}

@end

#pragma mark - TaskInfoItem
@interface TaskInfoItem ()

@end

@implementation TaskInfoItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel {
    self = [super init];
    if (self) {
        self.task = taskModel;
    }
    return self;
}

- (TaskItemType)type {
    return taskInfo;
}

- (NSString *)identifier {
    return @"TaskInfoItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

- (CGFloat)cellHeight {
    return UITableViewAutomaticDimension;
}

@end

#pragma mark - TaskActivityInfoItem
@interface TaskActivityInfoItem ()

@end

@implementation TaskActivityInfoItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel {
    self = [super init];
    if (self) {
        self.task = taskModel;
    }
    return self;
}

- (TaskItemType)type {
    return taskActivityInfo;
}

- (NSString *)identifier {
    return @"TaskActivityInfoItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

- (CGFloat)cellHeight {
    return UITableViewAutomaticDimension;
}

@end

#pragma mark - TaskPhotoItem
@interface TaskPhotoItem()

@end

@implementation TaskPhotoItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel {
    self = [super init];
    if (self) {
        self.task = taskModel;
    }
    return self;
}

- (TaskItemType)type {
    return taskPhotos;
}

- (NSString *)identifier {
    return @"TaskPhotoItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

- (CGFloat)cellHeight {
    return UITableViewAutomaticDimension;
}

@end

#pragma mark - TaskActionsItem
@interface TaskActionsItem()

@end

@implementation TaskActionsItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel {
    self = [super init];
    if (self) {
        self.task = taskModel;
    }
    return self;
}

- (TaskItemType)type {
    return taskActions;
}

- (NSString *)identifier {
    return @"TaskActionsItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

- (CGFloat)cellHeight {
    return 60.0;
}

@end

#pragma mark - TaskActivityActionsItem
@interface TaskActivityActionsItem()

@end

@implementation TaskActivityActionsItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel {
    self = [super init];
    if (self) {
        self.task = taskModel;
    }
    return self;
}

- (TaskItemType)type {
    return taskActivityAction;
}

- (NSString *)identifier {
    return @"TaskActivityActionsItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

- (CGFloat)cellHeight {
    return 88.0;
}

@end

#pragma mark - TaskLikesItem
@interface TaskLikesItem()

@end

@implementation TaskLikesItem

- (instancetype)initWithTaksModel:(ZZTaskModel *)taskModel {
    self = [super init];
    if (self) {
        self.task = taskModel;
    }
    return self;
}

- (TaskItemType)type {
    return taskLikes;
}

- (NSString *)identifier {
    return @"TaskActionsItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

- (CGFloat)cellHeight {
    return 104.0;
}

@end

#pragma mark - TaskLikesListItem
@interface TaskLikesListItem ()

@end

@implementation TaskLikesListItem

- (instancetype)initWithLikeModel:(ZZTaskLikeModel *)likeModel {
    self = [super init];
    if (self) {
        self.likeModel = likeModel;
    }
    return self;
}

- (TaskItemType)type {
    return taskLikesList;
}

- (NSString *)identifier {
    return @"TaskLikesListItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

@end

#pragma mark - TaskSignuperItem
@interface TaskSignuperItem()

@end

@implementation TaskSignuperItem

- (instancetype)initWithSignUper:(ZZTaskSignuperModel *)signUper {
    self = [super init];
    if (self) {
        self.signUper = signUper;
    }
    return self;
}

- (TaskItemType)type {
    return taskSignUper;
}

- (NSString *)identifier {
    return @"TaskSignuperItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

- (CGFloat)cellHeight {
    return 131.0;
}

@end

#pragma mark - TaskEmptyItem
@interface TaskEmptyItem()

@end

@implementation TaskEmptyItem

- (instancetype)initWithEmptyTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (TaskItemType)type {
    return taskEmpty;
}

- (NSString *)identifier {
    return @"TaskEmptyItem";
}

- (UITableViewCellAccessoryType)accessoryType {
    return UITableViewCellAccessoryNone;
}

- (CGFloat)cellHeight {
    return 240.0;
}

@end



