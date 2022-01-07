//
//  ZZHomeModel.h
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZRequest.h"
#import "ZZUser.h"
#import "PYCycleItemModel.h"
#import "ZZTaskModel.h"
#import "kongxia-Swift.h"

@protocol ZZHomeAdModel
@end
@interface ZZHomeAdModel : JSONModel

@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL need_login;//当前banner是否需要登录

@end

@protocol ZZHomeRecommendDetailModel
@end

@interface ZZHomeRecommendDetailModel : JSONModel

@property (nonatomic, strong) NSString *current_star;
@property (nonatomic, strong) NSString *sortValue;
@property (nonatomic, strong) ZZUser *user;

// 0: 推荐的用户 1: 活动入口 2: 快捷出租的入口
@property (nonatomic, assign) NSInteger modelType;

@end
@protocol PYCycleItemModel
@end
@interface ZZHomeRecommendModel : JSONModel

@property (nonatomic, strong) NSArray <PYCycleItemModel > *story;

@property (nonatomic, strong) ZZHomeAdModel *ad; // 3.2.0之前使用banner
@property (nonatomic, strong) NSMutableArray<ZZHomeRecommendDetailModel> *hot;
@property (nonatomic, strong) NSMutableArray<ZZHomeRecommendDetailModel> *recommend;

@property (nonatomic, strong) NSMutableArray<ZZHomeAdModel> *ads;

@end

@interface ZZHomeNearbyModel : JSONModel

@property (nonatomic, strong) NSString *sortValue;
@property (nonatomic, strong) NSString *current_star;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) ZZUser *user;

@end

@protocol ZZHomeSpecialTopicModel
@end
@interface ZZHomeSpecialTopicModel : JSONModel

@property (nonatomic, assign) NSInteger status;     //1、显示 2隐藏 后台控制返回数据用，前端不用管
@property (nonatomic, copy) NSString *content;      //专题内容
@property (nonatomic, assign) NSInteger position;   //排序位置，后台返回时已排好序
@property (nonatomic, copy) NSString *id;           //专题id
@property (nonatomic, assign) NSInteger type;       // 1、h5 ;2、图片；3、视频
@property (nonatomic, copy) NSString *cover;        //封面图
@property (nonatomic, copy) NSString *name;         //专题名称
@property (nonatomic, copy) NSString *url;          //专题url

@end

@interface ZZUserUnderSkillModel : JSONModel
@property (nonatomic, strong) ZZSkill *skill;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, copy) NSString *sortValue;
@property (nonatomic, assign) double disNum;
@property (nonatomic, copy) NSString *city;
@end

@protocol ZZHomeCatalogModel
@end
@interface ZZHomeCatalogModel : JSONModel

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *id;       //主题id
@property (nonatomic, copy) NSString *content;  //主题内容
@property (nonatomic, copy) NSString *name;     //主题名称
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, copy) NSString *url;      //主题图片url
@property (nonatomic, copy) NSString *indexUrl; //首页主题图标
@property (nonatomic, copy) NSString *summary;      //首页全部分类的技能概述

@end

@protocol ZZHomeBannerModel
@end
@interface ZZHomeBannerModel : JSONModel

@property (nonatomic, copy) NSString *id;           //banner id
@property (nonatomic, copy) NSString *img;          //banner图片url
@property (nonatomic, assign) BOOL need_login;      //是否需要登录
@property (nonatomic, copy) NSString *url;          //banner点击跳转标识
@property (nonatomic, copy) NSString *background;   //背景图片url

@end

@interface ZZHomeChatModel : JSONModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL hide;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content_user;

@end

@protocol ZZHomeIntroduceItemModel
@end
@interface ZZHomeIntroduceItemModel : JSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@end

@interface ZZHomeIntroduceModel : JSONModel
@property (nonatomic, assign) BOOL hide;
@property (nonatomic, strong) NSArray<ZZHomeIntroduceItemModel> *list;
@end

@interface PdModel: JSONModel
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@end

@interface ZZHomeModel : JSONModel

@property (nonatomic, strong) NSString *typeID;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *content_en;//查询要传的值
@property (nonatomic, strong) NSNumber *layout;//区分布局 1、大图 (例:推荐) 2、一列多行（例:附近） 3、多列多行（例子：其他）

//新版首页数据
@property (nonatomic, strong) ZZHomeChatModel *q_rent;                              //首页出租配置项
@property (nonatomic, strong) ZZHomeChatModel *q_chat;                              //首页闪聊配置项
@property (nonatomic, strong) ZZHomeIntroduceModel *introduce;                      //平台介绍
@property (nonatomic, strong) PdModel *pd_add;
@property (nonatomic, assign) BOOL hide_special_topic;                              //是否隐藏精选专题
@property (nonatomic, strong) NSArray<ZZHomeSpecialTopicModel> *special_topic_list; //精选专题数据
@property (nonatomic, strong) NSArray<ZZHomeCatalogModel> *catalog;                 //主题数据
@property (nonatomic, strong) NSArray<ZZHomeBannerModel> *banner;                   //banner数据
@property (nonatomic, strong) ZZTask *taskModel;
@property (nonatomic, strong) ZZRankResponeModel *rankResponeModel; // 排行榜数据
@property (nonatomic, copy) NSArray<ZZUser *> *popularityRanksArr; // 排行榜数据
@property (nonatomic, copy) NSArray<ZZTask *> *activitiesArray;

- (void)getSearchType:(requestCallback)next;

+ (void)refreshCancel:(NSString *)uid next:(requestCallback)next;

+ (void)adCancel:(NSString *)aid next:(requestCallback)next;

+ (void)getSpecialTopic:(requestCallback)next;  //获取精选专题

//主题类型下的用户
+ (void)getUserUnderSkill:(NSString *)catalogId withSortValue:(NSString *)sortValue pageIndex:(NSInteger)pageIndex next:(requestCallback)next;

//获取首页数据
+ (void)getIndexPageData:(requestCallback)next;

//获取最便宜的技能和价格
+ (ZZSkill *)getMostCheapSkill:(NSArray<ZZTopic *> *)topics;
+ (NSString *)getMostCheapSkillPrice:(NSArray<ZZTopic *> *)topics;
@end
