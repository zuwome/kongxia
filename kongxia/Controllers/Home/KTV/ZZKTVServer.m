//
//  ZZKTVManager.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVServer.h"
#import "ZZKTVConfig.h"

@implementation ZZKTVServer

/*
获取点唱任务
*/
+ (void)fetchKTVTasksListsWithPage:(NSInteger)page
                   completeHandler:(void (^)(BOOL, NSArray<ZZKTVModel *> *))completeHandler {
    
    [ZZRequest method:@"GET"
                 path:@"/api/getPdSongList"
               params:@{
                   @"pageIndex": @(page)
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (completeHandler) {
                completeHandler(NO, nil);
            }
        }
        else {
            NSArray *tasksArr = [NSArray yy_modelArrayWithClass:[ZZKTVModel class] json:data[@"pd_list"]];
            if (completeHandler) {
                completeHandler(YES, tasksArr);
            }
        }
    }];
}

/*
 获取达人领唱
 */
+ (void)fetchKTVLeadSingingListWithPage:(NSInteger)page
                        completeHandler:(void(^)(BOOL isSuccess, NSArray *list))completeHandler {
    [ZZRequest method:@"GET"
                 path:@"/api/getPdSongReceiveList"
               params:@{
                   @"pageIndex": @(page)
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (completeHandler) {
                completeHandler(NO, nil);
            }
        }
        else {
            NSArray *tasksArr = [NSArray yy_modelArrayWithClass:[ZZKTVLeadSongModel class] json:data[@"songList"]];
            if (completeHandler) {
                completeHandler(YES, tasksArr);
            }
        }
    }];
}

/*
 获取我发起的点唱任务
 */
+ (void)fetchKTVMyTasksListsWithPage:(NSInteger)page
                     completeHandler:(void(^)(BOOL isSuccess, NSArray *list))completeHandler {
    [ZZRequest method:@"GET"
                 path:@"/api/getMyPdSongList"
               params:@{
                   @"pageIndex": @(page)
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (completeHandler) {
                completeHandler(NO, nil);
            }
        }
        else {
            NSArray *tasksArr = [NSArray yy_modelArrayWithClass:[ZZKTVModel class] json:data[@"pd_list"]];
            if (completeHandler) {
                completeHandler(YES, tasksArr);
            }
        }
    }];
}

/*
 获取收到的礼物
 */
+ (void)fetchKTVReceivedGiftsListWithPage:(NSInteger)page
                          completeHandler:(void (^)(BOOL, ZZKTVRecievedGiftResponseModel *))completeHandler {
    [ZZRequest method:@"GET"
                 path:@"/api/getMyPdSongReceiveList"
               params:@{
                   @"pageIndex": @(page)
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (completeHandler) {
                completeHandler(NO, nil);
            }
        }
        else {
            ZZKTVRecievedGiftResponseModel *responeModel = [ZZKTVRecievedGiftResponseModel yy_modelWithDictionary:data];
            if (completeHandler) {
                completeHandler(YES, responeModel);
            }
        }
    }];
}

/*
 创建唱歌任务
*/
+ (void)createSingingTask:(ZZKTVModel *)model
          completeHandler:(void(^)(BOOL isSuccess))completeHandler {
    
    NSMutableArray *idsArr = @[].mutableCopy;
    [model.song_list enumerateObjectsUsingBlock:^(ZZKTVSongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [idsArr addObject:obj._id];
    }];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:idsArr.copy options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    
    NSDictionary *param = @{
        @"gid": model.gift._id,
        @"gcount": @(model.gift_count),
        @"songlist": jsonStr,
        @"is_anonymous": @(model.is_anonymous),
        @"gender": @(model.gender),
    };
    
    [ZZRequest method:@"POST"
                 path:@"/api/addPdSong"
               params:param
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
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

/*
 获取歌曲列表
*/
+ (void)fetchSongListWithSongType:(NSString *)songType
                        pageIndex:(NSInteger)pageIndex
                  completeHandler:(void (^)(BOOL, ZZKTVSongListResponesModel *))completeHandler {
    
    NSMutableDictionary *param = @{
        @"pageIndex": @(pageIndex),
    }.mutableCopy;
    
    if (!isNullString(songType)) {
        param[@"songType"] = songType;
    }
    
    [ZZRequest method:@"GET"
                 path:@"/api/getSongList"
               params:param
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (completeHandler) {
                completeHandler(NO, nil);
            }
        }
        else {
            ZZKTVSongListResponesModel *model = [ZZKTVSongListResponesModel yy_modelWithDictionary:data];
            if (completeHandler) {
                completeHandler(YES, model);
            }
        }
    }];
}

/*
 获取详情
*/
+ (void)fetchTaskDetailsWithTaskID:(NSString *)taskID completeHandler:(void (^)(BOOL, ZZKTVDetailsModel *))completeHandler {
    [ZZRequest method:@"GET"
                 path:@"/api/getPdSongDetail"
               params:@{
                   @"pid": taskID,
               }
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (completeHandler) {
                completeHandler(NO, nil);
            }
        }
        else {
            ZZKTVDetailsModel *taskDetailsModel = [ZZKTVDetailsModel yy_modelWithDictionary:data];
            if (completeHandler) {
                completeHandler(YES, taskDetailsModel);
            }
        }
        
    }];
}

/*
 唱完歌,上传
*/
+ (void)uploadTaskID:(NSString *)taskID
                 sid:(NSString *)songID
             songURL:(NSString *)songURL
     completeHandler:(void (^)(BOOL, NSInteger, NSString *))completeHandler {
    
    NSDictionary *param = @{
        @"content": [NSString stringWithFormat:@"%@", songURL],
        @"pid": taskID,
        @"sid": songID,
    };
    [ZZRequest method:@"POST"
                 path:@"/api/completePdSong"
               params:param
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (completeHandler) {
                completeHandler(NO, error.code, error.message);
            }
        }
        else {
            if (completeHandler) {
                completeHandler(YES, -1, nil);
            }
        }
    }];
}
@end
