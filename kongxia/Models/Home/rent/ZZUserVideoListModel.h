//
//  ZZUserVideListModel.h
//  zuwome
//
//  Created by angBiu on 2016/12/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZSKModel.h"
#import "ZZCommentModel.h"

@interface ZZUserVideoListModel : JSONModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) ZZMMDModel *mmd;
@property (nonatomic, strong) ZZSKModel *sk;
@property (nonatomic, assign) BOOL like_status;
@property (nonatomic, strong) NSMutableArray<ZZMMDTipsModel> *mmd_tips;//悬赏榜（3个人）
@property (nonatomic, strong) NSMutableArray<ZZMMDTipsModel> *sk_tips;//悬赏榜（3个人）
@property (nonatomic, strong) NSString *sort_value;

@property (nonatomic, strong) NSString *content;//用户个人页的内容 （"回答了1个么么答,获得打赏30元"）
@property (nonatomic, strong) NSMutableArray<ZZCommentModel> *mmd_replies;//么么答评论
/**
 个人中心的视频列表
 */
+ (void)getUserVideoList:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;
/**
 用户个人页的视频列表
 */
+ (void)getUserPageVideoList:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;

@end
