//
//  ZZPublishModel.h
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZSnatchModel.h"

@interface ZZPublishModel : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) ZZUser *user;//抢单用户
@property (nonatomic, strong) ZZSnatchDetailModel *pd;
@property (nonatomic, assign) long remain_time_receiver;//女方剩余时间  (抢任务所剩时间)单位：毫秒  数值范围： 大于等于0的整数
@property (nonatomic, assign) long remain_time_sponsor;//男方剩余时间 （达人选择页面所剩时间）

@property (nonatomic, assign) BOOL selected;

+ (void)getPublishGraberList:(NSDictionary *)parm pId:(NSString *)pId next:(requestCallback)next;

+ (void)getRoomToken:(NSDictionary *)param next:(requestCallback)next;

+ (void)hideSnatchUser:(NSString *)uid next:(requestCallback)next;

+ (void)noCounting:(NSString *)pid next:(requestCallback)next;

@end
