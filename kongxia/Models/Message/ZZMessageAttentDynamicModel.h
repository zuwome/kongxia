//
//  ZZMessageAttentDynamicModel.h
//  zuwome
//
//  Created by angBiu on 16/8/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZMemedaModel.h"
#import "ZZSKModel.h"

@interface ZZMessageAttentDynamicModel : JSONModel

@property (nonatomic, strong) NSString *sort_value;
@property (nonatomic, strong) NSString *created_at_text;
@property (nonatomic, strong) NSString *type;// "mmd_tip" => 么么答打赏 "following" => 关注 "mmd_like" =>点赞 "mmd_answer" =>回答么么答 "mmd_reply" => 评论么么答 "sk"时刻 "sk_reply"时刻评论  "sk_tip"时刻打赏 "sk_like" => 时刻赞 "rp_take" => 扫脸红包领取 "rp_add" => 扫脸红包添加 "sys_rp_add" => 系统扫脸红包添加 “city_change” =>改变城市
@property (nonatomic, strong) ZZUser *from;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray<ZZUser> *users;
@property (nonatomic, strong) NSMutableArray<ZZMMDModel> *mmds;
@property (nonatomic, strong) NSMutableArray<ZZSKModel> *sks;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger star;//0不显示推荐 1推荐  2...

/**
 *  动态－－关注人的动态
 *
 *  @param param 分页： 最后一个sort_value
 *  @param next  回调
 */
+ (void)getAttentDynamic:(NSDictionary *)param next:(requestCallback)next;

/**
 个人页视频
 */
+ (void)getUserPageDynamic:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next;

@end
