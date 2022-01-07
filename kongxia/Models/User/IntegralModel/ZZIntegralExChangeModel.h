//
//  ZZIntegralExChangeModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZIntegralExChangeDetailModel.h"
@protocol ZZIntegralExChangeDetailModel
@end
/**
 积分兑换的列表
 */
@interface ZZIntegralExChangeModel : JSONModel

/**
 总的积分
 */
@property (nonatomic,assign) NSInteger integral;

/**
 积分兑换比例
 */
@property (nonatomic,assign) int scale;

@property (nonatomic,strong) NSArray <ZZIntegralExChangeDetailModel>*list;


/**
 当前选中的分数
 */
@property(nonatomic,strong)NSString <Optional> *selectIntegral;
@end
