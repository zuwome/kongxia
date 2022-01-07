//
//  ZZTaskConfig.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TaskType) {
    TaskNormal, // 通告
    TaskFree,   // 活动
};

/*
 发布活动步骤
 1.选择技能
 2.填写主题、介绍、图片
 3.选择时间、地点、其他
 */
typedef NS_ENUM(NSInteger, TaskActionStep) {
    TaskStep1, // 基本信息
    TaskStep2, //
    TaskStep3,
};

typedef NS_ENUM(NSInteger, TaskListType) {
    ListNone = 0,
    ListAll,
    ListMine,
};

typedef NS_ENUM(NSInteger, TaskItemType) {
    taskNone,        // 无
    taskEmpty,       // 无
    taskUserInfo,    // 用户信息
    taskInfo,        // 订单信息
    taskPhotos,      // 订单图片
    taskActions,     // 订单操作
    taskLikes,       // 点赞
    taskLikesList,   // 点赞列表
    taskSignUper,    // 报名
    
    taskActivityUserInfo, // 活动用户信息
    taskActivityInfo,     // 活动订单信息
    taskActivityAction,   // 活动订单操作
};

typedef NS_ENUM(NSInteger, TaskAction) {
    taskActionNone,    // 无
    taskActionLike,    // 点赞
    taskActionCancel,  // 取消订单
    taskActionClose,   // 关闭订单
    taskActionSignUp,  // 报名
    taskActionPick,    // 选人
    taskActionRent,    // 租人
    taskActionReport,  // 举报
    
    taskActionChat,        // 聊天
    taskActionTonggaoPay,  // 新-通告付完尾款
    
    taskActionCheckWechat, // 查看微信(未购买)
    taskActionBoughtWechat, // 查看微信(已购买)
};

typedef NS_ENUM(NSInteger, PostTaskItemType) {
    postNone,          // 无
    postTheme,         // 主题
    postCotent,        // 详情
    postGender,        // 性别
    postCity,          // 城市
    postLocation,      // 地点
    postTime,          // 时间
    postDuration,      // 时长
    postPrice,         // 金额
    postPhoto,         // 图片
    postOtherSetting,  // 其他设置
    postConfirmAction, // 确认按钮
    
    postThemeTag,    // 通告主题标签
    
    postBasicInfo,   // 地点 + 时间 + 时长
    postOtherInfo,   // 性别 + 钱
};

typedef NS_ENUM(NSInteger, TaskImageStatus) {
    ImageStatusSuccess, // 审核成功可以显示
    ImageStatusReview,  // 审核中
    ImageStatusFail,    // 审核失败
};

@interface ZZTaskConfig : NSObject

@end

NS_ASSUME_NONNULL_END
