//
//  ZZCommossionManager.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZCommissionListModel;
@class ZZCommissionIncomModel;
@class ZZCommissionInviteUserModel;
@class ZZCommissionModel;

@interface ZZCommossionManager : NSObject

+ (ZZCommossionManager *)manager;


#pragma mark - 获取邀请吗等数据
/*
 获取邀请吗等数据
 */
- (void)fetchInviteCodeInfos:(void(^)(BOOL isSuccess, ZZCommissionModel *commissionModel))block;


#pragma mark - 获取所有数据
/*
 获取所有数据
 */
- (void)fetchDatasWithCompletBlock:(void(^)(BOOL isSuccess, ZZCommissionListModel *listModel, NSArray<ZZCommissionIncomModel *> *incomModelsArr, ZZCommissionInviteUserModel *invitedUser))block;


#pragma mark - 获取详细的和邀请的人数据
/*
 获取详细的和邀请的人数据
 */
- (void)fetchListsWithPageIndex:(NSInteger)pageIndex completBlock:(void(^)(BOOL isSuccess, ZZCommissionListModel *listModel))block;


#pragma mark - 获取邀请人的列表
/*
 获取邀请人的列表
 */
- (void)fetchInviteWithPageIndex:(NSInteger)pageIndex completBlock:(void(^)(BOOL isSuccess, ZZCommissionInviteUserModel *listModel))block;


#pragma mark - 获取收入
/*
 获取收入
 */
- (void)fetchIncomesWithPageIndex:(NSInteger)pageIndex completBlock:(void(^)(BOOL isSuccess, NSArray<ZZCommissionIncomModel *> *incomModelsArr))block;


#pragma mark - 打开推送
/*
 打开推送
 */
- (void)enablePush:(BOOL)isEnable;


#pragma mark - 发送提醒
/*
 发送提醒
 */
- (void)remindUser:(NSInteger)remindType user:(ZZUser *)user complete:(void(^)(BOOL isComplete))completeHandler;


#pragma mark - 获取提醒的消息
/*
 获取提醒的消息
 */
- (void)fetchRemindStatusAction:(void(^)(NSInteger action))actionBlock;


#pragma mark - 已读了消息
/*
 已读了消息
 */
- (void)sendSeenStatue:(void(^)(BOOL isShowed))block;


#pragma mark - 显示弹窗
/*
 显示弹窗
 */
- (void)showRemindView:(NSDictionary *)userInfo action:(void(^)(NSInteger action))actionBlock;

@end


