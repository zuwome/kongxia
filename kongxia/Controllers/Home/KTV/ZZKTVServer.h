//
//  ZZKTVManager.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZKTVModel;
@class ZZKTVSongListResponesModel;
@class ZZKTVDetailsModel;
@class ZZKTVRecievedGiftResponseModel;

@interface ZZKTVServer : NSObject

/*
 获取点唱任务
 */
+ (void)fetchKTVTasksListsWithPage:(NSInteger)page
                   completeHandler:(void(^)(BOOL isSuccess, NSArray<ZZKTVModel *> *list))completeHandler;

/*
 获取达人领唱
 */
+ (void)fetchKTVLeadSingingListWithPage:(NSInteger)page
                        completeHandler:(void(^)(BOOL isSuccess, NSArray *list))completeHandler;

/*
 获取我发起的点唱任务
 */
+ (void)fetchKTVMyTasksListsWithPage:(NSInteger)page
                     completeHandler:(void(^)(BOOL isSuccess, NSArray *list))completeHandler;

/*
 获取收到的礼物
 */
+ (void)fetchKTVReceivedGiftsListWithPage:(NSInteger)page
                          completeHandler:(void(^)(BOOL isSuccess, ZZKTVRecievedGiftResponseModel *responeModel))completeHandler;


/*
 创建唱歌任务
*/
+ (void)createSingingTask:(ZZKTVModel *)model
          completeHandler:(void(^)(BOOL isSuccess))completeHandler;


/*
 获取歌曲列表
*/
+ (void)fetchSongListWithSongType:(NSString *)songType
                        pageIndex:(NSInteger)pageIndex
                  completeHandler:(void(^)(BOOL isSuccess, ZZKTVSongListResponesModel *responseModel))completeHandler;

/*
 获取详情
*/
+ (void)fetchTaskDetailsWithTaskID:(NSString *)taskID
                   completeHandler:(void(^)(BOOL isSuccess, ZZKTVDetailsModel *taskDetailsModel))completeHandler;


/*
 唱完歌,上传
*/
+ (void)uploadTaskID:(NSString *)taskID
                 sid:(NSString *)songID
             songURL:(NSString *)songURL
     completeHandler:(void(^)(BOOL isSuccess, NSInteger errorCode, NSString *errorMsg))completeHandler;

@end

