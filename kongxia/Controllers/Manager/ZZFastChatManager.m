//
//  ZZFastChatManager.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZFastChatManager.h"
#import "ZZFastChatModel.h"
#import "ZZCallRecordsModel.h"

@interface ZZFastChatManager ()

@end

@implementation ZZFastChatManager

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)invalidate {
    [super invalidate];
}

- (void)removeInstance {
    [super removeInstance];
}

- (void)asyncFetchFastChatListWithParam:(NSDictionary *)param
                          completeBlock:(void (^)(ZZError *error, NSMutableArray<ZZFastChatModel *> *models, NSURLSessionDataTask *task))completed {
    
    NSString *path = @"/api/qchat/users";
    if (![ZZUserHelper shareInstance].isLogin) {
        path = @"/qchat/users";
    }
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            BLOCK_SAFE_CALLS(completed, error, [NSMutableArray new], task);
        } else {
            NSMutableArray<ZZFastChatModel *> *array = [ZZFastChatModel arrayOfModelsFromDictionaries:data error:nil];
            BLOCK_SAFE_CALLS(completed, error, array, task);
        }
    }];
}

- (void)asyncFetchCallRecordsWithParam:(NSDictionary *)param completeBlock:(void (^)(ZZError *error, NSMutableArray<ZZCallRecordsModel *> *models, NSURLSessionDataTask *task))completed {
    
    NSString *path = @"/api/user/rooms";
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            BLOCK_SAFE_CALLS(completed, error, [NSMutableArray new], task);
        } else {
            NSMutableArray<ZZCallRecordsModel *> *array = [ZZCallRecordsModel arrayOfModelsFromDictionaries:data error:nil];
            BLOCK_SAFE_CALLS(completed, error, array, task);
        }
    }];
}

- (void)asyncRemoveCallRecordsWithRid:(NSString *)rid completeBlock:(void (^)(ZZError *error, NSURLSessionDataTask *task))completed {
    
    NSString *path = [NSString stringWithFormat:@"/api/user/room/%@/del", rid];
    [ZZRequest method:@"POST" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            BLOCK_SAFE_CALLS(completed, error, task);
        } else {
            BLOCK_SAFE_CALLS(completed, nil, task);
        }
    }];
}
@end
