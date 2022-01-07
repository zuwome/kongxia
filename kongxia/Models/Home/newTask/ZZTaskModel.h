//
//  ZZTaskModel.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <Foundation/Foundation.h>
#import "ZZTaskLikeModel.h"
#import "ZZTaskSignuperModel.h"

typedef NS_ENUM(NSInteger, TaskStatus) {
    TaskReviewing,  // 审核中
    TaskReviewFail, // 审核失败
    TaskOngoing,    // 正在进行中
    TaskCancel,     // 已经取消
    TaskClose,      // 结束报名
    TaskFinish,     // 订单结束
    TaskExpired,    // 过期
    TaskReported,   // 举报
    TaskNone,       // 无
};

@class ZZTaskModel;
@class ZZTask;

@protocol ZZTaskModel;
@protocol ZZSkill;

@interface ZZTaskReponseModel: JSONModel

@property (nonatomic,   copy) NSArray<ZZTaskModel *><ZZTaskModel> *tasksArray;

// 最远报名距离
@property (nonatomic, assign) NSInteger enterDisNum;

@property (nonatomic, assign) NSInteger typeStatus;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic,   copy) NSString  *tipText;

- (void)addMoreTasks:(ZZTaskReponseModel *)taskResponseModel;

- (void)addTasks:(NSArray<ZZTaskModel *> *)tasksArray;

- (void)configureMyTaskModels:(NSArray<ZZTask *> *)taskArray;

- (void)addMoreMyTasks:(NSArray<ZZTask *> *)taskArray;

- (void)filterCanDisplayTask;

@end

@interface ZZTaskModel : JSONModel

@property (nonatomic, strong) ZZTask *task;

@property (nonatomic, strong) ZZUser *from;

@property (nonatomic, assign) BOOL isChatDidSend;

@end

@interface ZZTask : JSONModel

@property (nonatomic, assign) TaskStatus taskStatus;

@property (nonatomic, assign) BOOL isTaskFinished;

@property (nonatomic, assign) BOOL isMine;

@property (nonatomic, assign) BOOL taskIsMine;

// 不完整
@property (nonatomic, strong) ZZUser *from;

@property (nonatomic, strong) NSDictionary *skill;

@property (nonatomic, strong) ZZSkill *skillModel;

@property (nonatomic, copy) NSString *orderID;

//匿名头像的字端
@property (nonatomic, copy) NSString *anonymous_avatar;

// 这个字端是距离的意思
@property (nonatomic, copy) NSString *address_city_name;

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, assign) NSInteger hours;

@property (nonatomic, copy) NSString *agency_price;

@property (nonatomic, copy) NSString *to_price;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, assign) NSInteger dated_at_type;

@property (nonatomic, copy) NSString *dated_at;

@property (nonatomic, assign) double address_lat;

@property (nonatomic, assign) double address_lng;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *city_name;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, assign) NSInteger is_anonymous;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger __v;

@property (nonatomic, copy) NSString *chargeId_deposit;

@property (nonatomic, copy) NSString *paid_deposit_channel;

@property (nonatomic, copy) NSString *paid_deposit_at;

@property (nonatomic, copy) NSString *push_job_at;

@property (nonatomic, copy) NSString *pd_nin_uids;

@property (nonatomic, copy) NSString *pd_version;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSArray *selected_rids;

@property (nonatomic, assign) NSInteger order_type;

// 1为报名，-1没报名
@property (nonatomic, assign) NSInteger push_count;

// 1为点赞，-1没点
@property (nonatomic, assign) NSInteger selected_count;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger paid_status;

// 0:进行中 1:过期 2:已取消 3:已选择 
@property (nonatomic, assign) NSInteger status;

// 0:进行中 1:正常结束
@property (nonatomic, assign) NSInteger order_end;

@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, assign) NSInteger expand_auto;

@property (nonatomic, copy) NSArray *imgs;

// 判断图片是否可以显示
@property (nonatomic, copy) NSArray *imgs_status;

// 图片状态
@property (nonatomic, copy) NSArray *imgsStatus;

@property (nonatomic, copy) NSArray *display_imgs;

@property (nonatomic, assign) BOOL canShowImgs;

@property (nonatomic, copy) NSArray *location;

@property (nonatomic, assign) NSInteger like;

@property (nonatomic, copy) NSArray<ZZTaskLikeModel *> *likedUsers;

@property (nonatomic, copy) NSArray<ZZTaskSignuperModel *> *signupers;

// 已选择的人
@property (nonatomic, copy) NSArray *selected_users;

// 用来判断可不可以显示 小于等于:可以 大于:不可以
@property (nonatomic, assign) NSInteger shield_num;

// 我选的人
@property (nonatomic, copy) NSArray<ZZTaskSignuperModel *> *pickSignupersArr;

// 活动的内容
@property (nonatomic, copy) NSString *brief_text;

// 标签
@property (nonatomic, copy) NSArray<NSString *> *tags;

- (BOOL)canShowImage:(BOOL)isInListAll;

- (NSArray *)displayImages:(BOOL)isInListAll;

/*
 3.7.7之后 是否超过30分钟
 */
- (BOOL)isPassLimitedTime;

/*
 判断版本 分割线是3.7.7
 */
- (BOOL)isNewTask;

- (BOOL)didUserPicked:(NSString *)userID;

@end

