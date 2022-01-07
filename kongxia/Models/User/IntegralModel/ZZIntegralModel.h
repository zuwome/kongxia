//
//  ZZIntegralModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZIntegralScoreList.h"
#import "ZZIntegralTaskModel.h"
@protocol ZZIntegralTaskModel
@end
/**
 我的积分
 */
@interface ZZIntegralModel : JSONModel

/**
 总积分
 */
@property(nonatomic,assign) NSInteger integral;

/**
 积分梯度
 */
@property(nonatomic,strong) ZZIntegralScoreList *sign_task;

/**
 新手任务
 */
@property(nonatomic,strong) NSArray <ZZIntegralTaskModel>*rookie_task;

/**
 每日任务
 */
@property(nonatomic,strong) NSArray <ZZIntegralTaskModel>*day_task;


/**
 是否签到
 注 *true已签到 false未签到
 */
@property(nonatomic,assign) BOOL is_sign;

@end
