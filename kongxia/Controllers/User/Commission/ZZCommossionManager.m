//
//  ZZCommossionManager.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZCommossionManager.h"

#import "ZZCommissionListModel.h"
#import "ZZCommissionIncomModel.h"
#import "ZZCommissionInviteUserModel.h"
#import "ZZCommissionModel.h"

#import "ZZInfoToastView.h"

static dispatch_once_t ZZCommossionManagerOnce = 0;
__strong static id _commissionSharedManager = nil;

@implementation ZZCommossionManager

+ (ZZCommossionManager *)manager {
    dispatch_once(&ZZCommossionManagerOnce, ^{
        _commissionSharedManager = [[self alloc] init];
    });
    return _commissionSharedManager;
}


#pragma mark - 获取邀请吗等数据
/*
 获取邀请吗等数据
 */
- (void)fetchInviteCodeInfos:(void (^)(BOOL, ZZCommissionModel *))block {
    [ZZRequest method:@"GET" path:@"/api/getUserInviteCode" params:@{@"id": [ZZUserHelper shareInstance].loginer.uid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (block) {
                block(NO, nil);
            }
        }
        else {
            ZZCommissionModel *infoModel = [ZZCommissionModel yy_modelWithDictionary:data];
            if (block) {
                block(YES, infoModel);
            }
        }
    }];
}


#pragma mark - 获取所有数据
/*
 获取所有数据
 */
- (void)fetchDatasWithCompletBlock:(void (^)(BOOL, ZZCommissionListModel *, NSArray<ZZCommissionIncomModel *> *, ZZCommissionInviteUserModel *))block {
    
    __block ZZCommissionListModel *fetchlistModel = nil;
    __block NSArray<ZZCommissionIncomModel *> *fetchincomeModelArr = nil;
    __block ZZCommissionInviteUserModel *invitedUserModel = nil;
    
        [self fetchListsWithPageIndex:1 completBlock:^(BOOL isSuccess, ZZCommissionListModel *listModel) {
            if (isSuccess) {
                fetchlistModel = listModel;
            }
            
            [self fetchIncomesWithPageIndex:1 completBlock:^(BOOL isSuccess, NSArray<ZZCommissionIncomModel *> *incomModelsArr) {
                if (isSuccess) {
                    fetchincomeModelArr = incomModelsArr;
                }
                
                [self fetchInviteWithPageIndex:1 completBlock:^(BOOL isSuccess, ZZCommissionInviteUserModel *listModel) {
                        if (isSuccess) {
                            invitedUserModel = listModel;
                        }
                    
                        if (block) {
                            block(YES, fetchlistModel, fetchincomeModelArr, invitedUserModel);
                        }
                    }];
            }];
        }];
}


#pragma mark - 获取详细的和邀请的人数据
/*
 获取详细的和邀请的人数据
 */
- (void)fetchListsWithPageIndex:(NSInteger)pageIndex completBlock:(void (^)(BOOL, ZZCommissionListModel *))block {
    [ZZRequest method:@"GET"
                 path:@"/api/getInviteUserList"
               params:@{
                   @"uid": [ZZUserHelper shareInstance].loginer.uid,
                   @"pageIndex" : @(pageIndex),
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (block) {
                block(NO, nil);
            }
        }
        else {
            ZZCommissionListModel *listModel = [ZZCommissionListModel yy_modelWithDictionary:data];
            if (block) {
                block(YES, listModel);
            }
        }
    }];
}


#pragma mark - 获取邀请人的列表
/*
 获取邀请人的列表
 */
- (void)fetchInviteWithPageIndex:(NSInteger)pageIndex completBlock:(void (^)(BOOL, ZZCommissionInviteUserModel *))block {
    [ZZRequest method:@"GET"
                 path:@"/api/getInviteUserList2"
               params:@{
                   @"uid": [ZZUserHelper shareInstance].loginer.uid,
                   @"pageIndex" : @(pageIndex),
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (block) {
                block(NO, nil);
            }
        }
        else {
            ZZCommissionInviteUserModel *invitedUser = [ZZCommissionInviteUserModel yy_modelWithDictionary:data];
            if (block) {
                block(YES, invitedUser);
            }
        }
    }];
}


#pragma mark - 获取收入
/*
 获取收入
 */
- (void)fetchIncomesWithPageIndex:(NSInteger)pageIndex completBlock:(void (^)(BOOL, NSArray<ZZCommissionIncomModel *> *))block {
    [ZZRequest method:@"GET"
                        path:@"/api/getInviteTotalDetail"
                      params:@{
                          @"uid": [ZZUserHelper shareInstance].loginer.uid,
                          @"pageIndex" : @(pageIndex),
                      }
                        next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
               
               if (error) {
                   [ZZHUD showErrorWithStatus:error.message];
                   if (block) {
                       block(NO, nil);
                   }
               }
               else {
                   NSArray<ZZCommissionIncomModel *> *incomeModels = [NSArray yy_modelArrayWithClass:[ZZCommissionIncomModel class] json:data];
                   if (block) {
                       block(YES, incomeModels);
                   }
               }
           }];
}


#pragma mark - 打开推送
/*
 打开推送
 */
- (void)enablePush:(BOOL)isEnable {
    [ZZRequest method:@"POST"
                 path:@"/api/openInvitePush"
               params:@{
                   @"status": isEnable ? @0 : @1
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            NSLog(@"%@", error.message);
        }
        else {
            
        }
    }];
}

#pragma mark - 发送提醒
/*
 发送提醒
 */
- (void)remindUser:(NSInteger)remindType user:(ZZUser *)user complete:(void (^)(BOOL))completeHandler {
    [ZZRequest method:@"POST"
                 path:@"/api/remindUser"
               params:@{
                   @"type": remindType == 0 ? @"rent" : @"wechat",
                   @"uid" : user.uuid
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            NSLog(@"%@", error.message);
            if (completeHandler) {
                completeHandler(NO);
            }
        }
        else {
            if (completeHandler) {
                completeHandler(YES);
            }
        }
    }];
}


#pragma mark - 获取提醒的状态
/*
 获取提醒的状态
 */
- (void)fetchRemindStatusAction:(void(^)(NSInteger action))actionBlock {
    if (![[ZZUserHelper shareInstance] isLogin]) {
        return;
    }
    
    [ZZRequest method:@"GET"
                 path:@"/api/getExistsRemind"
               params:nil
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            NSLog(@"%@", error.message);
        }
        else {
            if (isNullString(data[@"msg"])) {
                return ;
            }
            
            ToastType type = ToastUnknow;
            if ([data[@"type"] isEqualToString: @"rent"]) {
                type = ToastRemindRent;
            }
            else if ([data[@"type"] isEqualToString: @"wechat"]) {
                type = ToastRemindWechat;
            }
            
            if (type != ToastUnknow) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZZInfoToastView showWithType:type title:@"2" subTitle:data[@"msg"] action:^(NSInteger actionIndex, ToastType type) {
                        if (actionBlock) {
                            actionBlock(type == ToastRemindRent ? 0 : 1);
                        }
                    }];
                });
            }
            
            [self sendSeenStatue:nil];
        }
    }];
}


#pragma mark - 已读了消息
/*
 已读了消息
 */
- (void)sendSeenStatue:(void(^)(BOOL isShowed))block {
    if (![[ZZUserHelper shareInstance] isLogin]) {
        return;
    }
    
    [ZZRequest method:@"POST"
                 path:@"/api/readInviteRemind"
               params:nil
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            NSLog(@"%@", error.message);
        }
    }];
}


#pragma mark - 显示弹窗
/*
 显示弹窗
 */
- (void)showRemindView:(NSDictionary *)userInfo action:(void(^)(NSInteger action))actionBlock {
    [self fetchRemindStatusAction:actionBlock];
}

@end
