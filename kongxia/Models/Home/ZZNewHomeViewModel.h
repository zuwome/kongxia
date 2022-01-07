//
//  ZZNewHomeViewModel.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZNewHomeTableView.h"
#import "ZZHomeModel.h"
#import "ZZCity.h"

typedef NS_ENUM(NSInteger, HomeCellType) {
    HomeCellTypeBanner,           // 轮播图
    HomeCellTypeIntro,            // 介绍
    HomeCellTypeCate,             // 分类
    HomeCellTypeTasks,            // 通告
    HomeCellTypePostTask,         // 发布通告
    HomeCellTypeVideoChat,        // 闪聊, 全部通告
    HomeCellTypeChatsAndRanks,    // 闪聊, 全部通告, 土豪榜, 人气
    HomeCellTypeLists,            // 列表
};

@interface ZZNewHomeViewModel : NSObject

@property (nonatomic, copy) void(^ctlsBindBlock)(NSArray *ctls);
@property (nonatomic, copy) void(^gotoUserPage)(ZZUser *user, UIImageView *imgView);    //跳转他人资料页
@property (nonatomic, copy) void(^tapShowActivity)(void); // 显示活动列表
@property (nonatomic, copy) void(^gotoFastChat)(void);                                  //跳转视频咨询
@property (nonatomic, copy) void(^gotoShanzu)(void);                                    //闪租任务
@property (nonatomic, copy) void(^gotoRanks)(void);                                    //排行榜
@property (nonatomic, copy) void(^gotoPopularityRanks)(void);                          //人气排行榜
@property (nonatomic, copy) void(^gotoTopicClassify)(ZZHomeCatalogModel *topic);        //跳转技能分类展示
@property (nonatomic, copy) void(^gotoSpecialTopic)(ZZHomeSpecialTopicModel *model);    //跳转技能分类展示
@property (nonatomic, copy) void(^bannerClick)(ZZHomeBannerModel *bannerModel);         //点击banner动态跳转

@property (nonatomic, copy) void(^signupCallback)(ZZTask *task);
@property (nonatomic, copy) void(^showLocationsCallback)(ZZTask *task);
@property (nonatomic, copy) void(^postTaskCallback)(void);
// 快捷出租入口
@property (nonatomic, copy) void(^showRent)(void);

// 活动入口
@property (nonatomic, copy) void(^showTaskFree)(void);

// 去创建活动入口
@property (nonatomic, copy) void(^showGoPublicTaskFree)(void);

//props
@property (nonatomic, copy) NSString *cityName; //城市名
@property (nonatomic, strong) ZZCity *city; // 城市
@property (nonatomic, strong) NSDictionary *filterDict; //筛选配置数据
@property (nonatomic, assign) BOOL haveGetLocation; //是否已获取定位信息

- (void)registerTableView:(ZZNewHomeTableView *)tableView;
- (void)updateCityAndFilter;    //城市或筛选器条件改变时刷新推荐等列表
- (void)requestData;    //刷新首页数据
- (void)getTask;
- (void)subTableDidScrollToTop;
@end
