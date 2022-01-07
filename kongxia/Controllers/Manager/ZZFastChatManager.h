//
//  ZZFastChatManager.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "WBBaseManager.h"
#import "ZZRequest.h"

@class ZZFastChatModel;
@class ZZCallRecordsModel;

@protocol WBFastChatManagerObserver <NSObject>

@optional

@end

#define GetFastChatManager()       ([ZZFastChatManager sharedInstance])

@interface ZZFastChatManager : WBBaseManager

/*
 *  异步获取闪聊列表用户
 */
- (void)asyncFetchFastChatListWithParam:(NSDictionary *)param completeBlock:(void (^)(ZZError *error, NSMutableArray<ZZFastChatModel *> *models, NSURLSessionDataTask *task))completed;

/*
 *  异步获取通话记录列表
 */
- (void)asyncFetchCallRecordsWithParam:(NSDictionary *)param completeBlock:(void (^)(ZZError *error, NSMutableArray<ZZCallRecordsModel *> *models, NSURLSessionDataTask *task))completed;

/*
 *  删除 通话记录
 */
- (void)asyncRemoveCallRecordsWithRid:(NSString *)rid completeBlock:(void (^)(ZZError *error, NSURLSessionDataTask *task))completed;


@end
