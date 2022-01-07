//
//  ZZTasksServer.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/15.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTasksServer.h"

@implementation ZZTasksServer

#pragma mark - public Method
#pragma mark Post
/**
 发布邀约
 */
+ (void)postTaskWithParams:(NSDictionary *)params
                  taskType:(TaskType)taskType
                   handler:(void(^)(ZZError *error, id data))handler {
    if (taskType == TaskNormal) {
        [self postNormalTaskWithParams:params handler:handler];
    }
    else if (taskType == TaskFree) {
        [self postFreeTaskWithParams:params handler:handler];
    }
}

/**
 普通发布邀约
 */
+ (void)postNormalTaskWithParams:(NSDictionary *)params
                         handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pd/addTask"
           params:params
          handler: handler];
}

/**
 特别有空邀约
 */
+ (void)postFreeTaskWithParams:(NSDictionary *)params
                          handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pdg/addTask"
           params:params
          handler: handler];
}

#pragma mark fetch Index Task
/**
 获取首页推荐
 */
+ (void)fetchIndexTaskWithParams:(NSDictionary *)params
                         handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"GET"
              api:@"/pd/GetHomePdOne"
           params:params
          handler: handler];
}

#pragma mark fetch Index Activities Task
/**
 获取首页活动推荐
 */
+ (void)fetchIndexActivitiesWithParams:(NSDictionary *)params
                               handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"GET"
              api:@"/pdg/getHomePagepdg"
           params:params
          handler: handler];
}

#pragma mark All TaskList
/**
 获取全部列表
 */
+ (void)fetchTasksListWithParams:(NSDictionary *)params
                      taskType:(TaskType)taskType
                         handler:(void (^)(ZZError *, id))handler {
    if (taskType == TaskNormal) {
        [self fetchNormalTaskListWithParams:params handler:handler];
    }
    else if (taskType == TaskFree) {
        [self fetchFreeTaskListWithParams:params handler:handler];
    }
}

/**
 获取全部列表
 */
+ (void)fetchNormalTaskListWithParams:(NSDictionary *)params
                              handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"GET"
              api:@"/api/pd/getTasksList2"
           params:params
          handler: handler];
}

/**
 获取有空全部列表
 */
+ (void)fetchFreeTaskListWithParams:(NSDictionary *)params
                               handler:(void(^)(ZZError *error, id data))handler {
    
    [self request:@"GET"
              api:@"/api/pdg/getTasksList"
           params:params
          handler: handler];
}

#pragma mark My TaskList
/**
 获取我的列表
 */
+ (void)fetchMyTasksListWithParams:(NSDictionary *)params
                           handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"GET"
              api:@"/api/pd/getMyPdTasksList"
           params:params
          handler: handler];
}

/**
 获取我的列表
 */
+ (void)fetchMyTasksListWithParams:(NSDictionary *)params
                          taskType:(TaskType)taskType
                           handler:(void(^)(ZZError *error, id data))handler {
    if (taskType == TaskNormal) {
        [self fetchNormalMyTasksListWithParams:params handler:handler];
    }
    else if (taskType == TaskFree) {
        [self fetchFreeMyTasksListWithParams:params handler:handler];
    }
}

/**
 获取普通我的列表
 */
+ (void)fetchNormalMyTasksListWithParams:(NSDictionary *)params
                                 handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"GET"
              api:@"/api/pd/getMyPdTasksList"
           params:params
          handler: handler];
}

/**
 获取有空我的列表
 */
+ (void)fetchFreeMyTasksListWithParams:(NSDictionary *)params
                               handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"GET"
              api:@"/api/pdg/getMyPdTasksList"
           params:params
          handler: handler];
}

#pragma mark Details
/**
 获取订单详情
 */
+ (void)fetchTaskDetailsWithParams:(NSDictionary *)params
                           handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"GET"
              api:@"/api/pd/getTaskDetail2"
           params:params
          handler: handler];
}

#pragma mark Like Lists
/**
 获取点赞列表
 */
+ (void)fetchLikesListWithParame:(NSDictionary *)params
                         handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"GET"
              api:@"/api/pd/getPdLikeList"
           params:params
          handler: handler];
}

#pragma mark - Task Actions
/**
 报名
 */
+ (void)signupWithParams:(NSDictionary *)params
                 handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pd/enterForTasks"
           params:params
          handler: handler];
}

/**
 点赞
 */
+ (void)likeWithParams:(NSDictionary *)params
               handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pd/likesPd"
           params:params
          handler: handler];
}

/**
 选人
 */
+ (void)pickWithParams:(NSDictionary *)params
               handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pd/confirmDaren"
           params:params
          handler: handler];
}

#pragma mark Task Cancel
/**
 新版取消任务
 */
+ (void)newCancelWithTaskID:(NSString *)taskID
                   taskType:(TaskType)taskType
                    handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pd4/offPd"
           params:@{
                    @"uid": UserHelper.loginer.uid,
                    @"pid": taskID,
                    }
          handler: handler];
}

/**
 取消任务
 */
+ (void)cancelWithTaskID:(NSString *)taskID
                taskType:(TaskType)taskType
                 handler:(void(^)(ZZError *error, id data))handler {
    if (taskType == TaskNormal) {
        [self cancelNormalTaskWithTaskID:taskID handler:handler];
    }
    else if (taskType == TaskFree) {
        [self cancelFreeTaskWithTaskID:taskID handler:handler];
    }
}

/**
 取消普通任务
 */
+ (void)cancelNormalTaskWithTaskID:(NSString *)taskID
                           handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:[NSString stringWithFormat:@"/api/pd/%@/cancel",taskID]
           params:nil
          handler: handler];
}

/**
 取消有空任务
 */
+ (void)cancelFreeTaskWithTaskID:(NSString *)taskID
                         handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pdg/offPdg"
           params:@{
                    @"pdgid": taskID,
                    @"uid": UserHelper.loginer.uid
                    }
          handler: handler];
}

#pragma mark Task Close
/**
 结束报名
 */
+ (void)closeWithParams:(NSDictionary *)params
                handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pd/endPdTask"
           params:params
          handler: handler];
}

#pragma mark Task Report
/**
 举报任务
 */
+ (void)reportTaskWithParams:(NSDictionary *)params
                    taskType:(TaskType)taskType
                     handler:(void(^)(ZZError *error, id data))handler {
    if (taskType == TaskNormal) {
        [self reportNormalTaskWithParams:params handler:handler];
    }
    else if (taskType == TaskFree) {
        [self reportFreeTaskWithParams:params handler:handler];
    }
}

/**
 举报普通任务
 */
+ (void)reportNormalTaskWithParams:(NSDictionary *)params
                           handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pd/reportPd"
           params:params
          handler: handler];
}

/**
 举报有空任务
 */
+ (void)reportFreeTaskWithParams:(NSDictionary *)params
                         handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pdg/reportPdg"
           params:params
          handler: handler];
}

#pragma mark Task Free Pay Complete
/**
 用户通过派单租达人成单后回调
 */
+ (void)taskFreePayCompleteWithParams:(NSDictionary *)params
                              handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pdg/beSelected"
           params:params
          handler: handler];
    
}

/**
 用户通过派单租达人成单后回调
 */
+ (void)checkIfCanSelectAndPay:(NSDictionary *)params
                       handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pd4/pdSelectedUser"
           params:params
          handler: handler];
}

#pragma mark check wechat or chat
/**
 * 埋点 活动的查看微信和私信
 */
+ (void)checkWechatOrChat:(NSDictionary *)params
                  handler:(void(^)(ZZError *error, id data))handler {
    [self request:@"POST"
              api:@"/api/pdg/pdgClickWechatBtn"
           params:params
          handler:handler];
}

#pragma mark - private method
+ (void)request:(NSString *)method api:(NSString *)api params:(NSDictionary *)params handler:(void(^)(ZZError *error, id data))handler {
    [ZZRequest method:method
                 path:api
               params:params
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                     if (handler) {
                         handler(error, data);
                     }
                 }];
}



@end
