//
//  ZZHomeTypeViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZHomeModel.h"
#import "ZZTasks.h"
/**
 *  首页 - 推荐页面
 */
@interface ZZHomeTypeViewController : ZZViewController

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSDictionary *filterDict;
@property (nonatomic, assign) BOOL update;//是否需要更新
@property (nonatomic, assign) BOOL haveGetLocation;

@property (nonatomic, copy) void(^didScroll)(CGFloat offset);
@property (nonatomic, copy) void(^didScrollStatus)(BOOL isShow);
@property (nonatomic, copy) dispatch_block_t callBack;
@property (nonatomic, copy) void(^tapCell)(ZZUser *user,UIImageView *imgView);
// 显示活动列表
@property (nonatomic, copy) void(^tapShowActivity)(void);
// 显示发布页面
@property (nonatomic, copy) void(^tapShowPublish)(void);
@property (nonatomic, copy) dispatch_block_t gotoRefreshTab;
@property (nonatomic, copy) void(^touchCancel)(NSString *uid);
@property (nonatomic, copy) dispatch_block_t showRefreshInfoView;
@property (nonatomic, copy) dispatch_block_t touchLivestream;
@property (nonatomic, copy) void (^touchRecordVideo)(void);
@property (nonatomic, copy) void(^fastChatBlock)(void);

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSDictionary *activitityDic;

// 快捷出租入口
@property (nonatomic, copy) void(^showRent)(void);

// 活动入口
@property (nonatomic, copy) void(^showTaskFree)(void);

// 去创建活动入口
@property (nonatomic, copy) void(^showGoPublicTaskFree)(void);

- (void)updateData;
- (void)refresh;
- (void)refreshCancel:(NSString *)uid;

@end
