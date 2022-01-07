//
//  ZZTasksServer.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/15.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTaskConfig.h"

@interface ZZTasksServer : NSObject

#pragma mark - public Method

#pragma mark Post
/**
 发布邀约
 */
+ (void)postTaskWithParams:(NSDictionary *)params
                 taskType:(TaskType)taskType
                   handler:(void(^)(ZZError *error, id data))handler;

/**
 普通发布邀约
 */
+ (void)postNormalTaskWithParams:(NSDictionary *)params
                   handler:(void(^)(ZZError *error, id data))handler;

/**
 特别发布邀约
 */
+ (void)postFreeTaskWithParams:(NSDictionary *)params
                   handler:(void(^)(ZZError *error, id data))handler;

#pragma mark fetch Index Task
/**
 获取首页推荐
 */
+ (void)fetchIndexTaskWithParams:(NSDictionary *)params
                         handler:(void(^)(ZZError *error, id data))handler;

#pragma mark fetch Index Activities Task
/**
 获取首页活动推荐
 */
+ (void)fetchIndexActivitiesWithParams:(NSDictionary *)params
                         handler:(void(^)(ZZError *error, id data))handler;

#pragma mark All TaskList
/**
 获取全部列表
 */
+ (void)fetchTasksListWithParams:(NSDictionary *)params
                       taskType:(TaskType)taskType
                         handler:(void(^)(ZZError *error, id data))handler;

/**
 获取普通全部列表
 */
+ (void)fetchNormalTaskListWithParams:(NSDictionary *)params
                         handler:(void(^)(ZZError *error, id data))handler;

/**
 获取有空全部列表
 */
+ (void)fetchFreeTaskListWithParams:(NSDictionary *)params
                           handler:(void(^)(ZZError *error, id data))handler;

#pragma mark My TaskList
/**
 获取我的列表
 */
+ (void)fetchMyTasksListWithParams:(NSDictionary *)params
                        taskType:(TaskType)taskType
                         handler:(void(^)(ZZError *error, id data))handler;

/**
 获取普通我的列表
 */
+ (void)fetchNormalMyTasksListWithParams:(NSDictionary *)params
                              handler:(void(^)(ZZError *error, id data))handler;

/**
 获取有空我的列表
 */
+ (void)fetchFreeMyTasksListWithParams:(NSDictionary *)params
                            handler:(void(^)(ZZError *error, id data))handler;
#pragma mark Details
/**
 获取订单详情
 */
+ (void)fetchTaskDetailsWithParams:(NSDictionary *)params
                           handler:(void(^)(ZZError *error, id data))handler;

#pragma mark Like Lists
/**
 获取点赞列表
 */
+ (void)fetchLikesListWithParame:(NSDictionary *)params
                         handler:(void(^)(ZZError *error, id data))handler;

#pragma mark Task Signuper
/**
 报名
 */
+ (void)signupWithParams:(NSDictionary *)params
                 handler:(void(^)(ZZError *error, id data))handler;

#pragma mark Task Like
/**
 点赞
 */
+ (void)likeWithParams:(NSDictionary *)params
               handler:(void(^)(ZZError *error, id data))handler;

#pragma mark Task Pick
/**
 选人
 */
+ (void)pickWithParams:(NSDictionary *)params
               handler:(void(^)(ZZError *error, id data))handler;

#pragma mark Task Cancel
/**
 新版取消任务
 */
+ (void)newCancelWithTaskID:(NSString *)taskID
                   taskType:(TaskType)taskType
                    handler:(void(^)(ZZError *error, id data))handler;

/**
 取消任务
 */
+ (void)cancelWithTaskID:(NSString *)taskID
               taskType:(TaskType)taskType
                 handler:(void(^)(ZZError *error, id data))handler;

/**
 取消普通任务
 */
+ (void)cancelNormalTaskWithTaskID:(NSString *)taskID
                         handler:(void(^)(ZZError *error, id data))handler;

/**
 取消有空任务
 */
+ (void)cancelFreeTaskWithTaskID:(NSString *)taskID
                          handler:(void(^)(ZZError *error, id data))handler;

#pragma mark Task Close
/**
 结束报名
 */
+ (void)closeWithParams:(NSDictionary *)params
                handler:(void(^)(ZZError *error, id data))handler;

#pragma mark Task Report
/**
 举报任务
 */
+ (void)reportTaskWithParams:(NSDictionary *)params
                taskType:(TaskType)taskType
                 handler:(void(^)(ZZError *error, id data))handler;

/**
 举报普通任务
 */
+ (void)reportNormalTaskWithParams:(NSDictionary *)params
                           handler:(void(^)(ZZError *error, id data))handler;

/**
 举报有空任务
 */
+ (void)reportFreeTaskWithParams:(NSDictionary *)params
                         handler:(void(^)(ZZError *error, id data))handler;

#pragma mark Task Free Pay Complete
/**
 用户通过派单租达人成单后回调
 */
+ (void)taskFreePayCompleteWithParams:(NSDictionary *)params
                              handler:(void(^)(ZZError *error, id data))handler;

#pragma mark new task check can pay
/**
 用户通过派单租达人成单后回调
 */
+ (void)checkIfCanSelectAndPay:(NSDictionary *)params
                              handler:(void(^)(ZZError *error, id data))handler;

#pragma mark check wechat or chat
/**
 * 埋点 活动的查看微信和私信
 */
+ (void)checkWechatOrChat:(NSDictionary *)params
                  handler:(void(^)(ZZError *error, id data))handler;
@end

