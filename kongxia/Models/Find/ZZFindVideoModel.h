//
//  ZZFindVideoModel.h
//  zuwome
//
//  Created by angBiu on 2016/12/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZSKModel.h"
#import "ZZMemedaModel.h"
#import "ZZCommentModel.h"
#import "ZZTopicModel.h"

@interface ZZFindVideoModel : JSONModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) ZZSKModel *sk;//时刻，自己录制的视频
@property (nonatomic, strong) ZZMMDModel *mmd;//么么哒视频
@property (nonatomic, strong) ZZTopicGroupModel *group;
@property (nonatomic, strong) NSMutableArray<ZZMMDTipsModel> *mmd_tips;//悬赏榜（3个人
@property (nonatomic, strong) NSMutableArray<ZZCommentModel> *mmd_replies;//么么答评论
@property (nonatomic, strong) NSMutableArray<ZZMMDTipsModel> *sk_tips;//悬赏榜（3个人
@property (nonatomic, strong) NSMutableArray<ZZCommentModel> *sk_replies;//时刻评论
@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) NSString *sort_value1;
@property (nonatomic, strong) NSString *sort_value2;
@property (nonatomic, strong) NSString *current_type;
@property (nonatomic, assign) BOOL like_status;
@property (nonatomic, strong) NSString *distance;


/**
 用户的头像
  用于缓存判断防止重复下载
 */
@property(nonatomic,strong) UIImage *userHeaderImgIcon;


/**
 是否有视屏 yes(已经存在)
 */
@property(nonatomic,assign)  BOOL isHaveVideo;


+ (void)getFindVideoList:(NSDictionary *)param next:(requestCallback)next;

+ (void)getRecommendVideList:(NSDictionary *)param next:(requestCallback)next;

+ (void)getTopicVideoList:(NSDictionary *)param groupId:(NSString *)groupId next:(requestCallback)next;

@end
