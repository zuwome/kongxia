//
//  ZZIntegralScoreList.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 签到积分列表,用于展示积分梯级的
 */
@interface ZZIntegralScoreList : JSONModel


/**
  积分梯度 数组
 */
@property(nonatomic,strong) NSArray *score_list;


/**
 连续签到天数
 */
@property(nonatomic,assign) NSNumber *day;
@end
