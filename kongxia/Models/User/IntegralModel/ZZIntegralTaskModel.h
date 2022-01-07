//
//  ZZIntegralTaskModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 积分任务  
 */
@interface ZZIntegralTaskModel : JSONModel

/**
 活动类型
 */
@property (nonatomic,strong) NSNumber *type;

/**
 活动内容
 */
@property (nonatomic,strong) NSString *taskname;

/**
 活动状态
 */
@property (nonatomic,strong) NSNumber *status;
/**
 活动分数
 */
@property (nonatomic,strong) NSString *score;
/**
 活动指示语
 */
@property (nonatomic,strong) NSString *action;

/**
 图片对应的名
 */
@property (nonatomic,strong) NSString *imageName;
@end
