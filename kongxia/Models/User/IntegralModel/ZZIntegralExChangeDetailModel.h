//
//  ZZIntegralExChangeDetailModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/21.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 积分兑换的详细model
 */
@interface ZZIntegralExChangeDetailModel : JSONModel

/**
 积分数
 */
@property (nonatomic,assign) NSInteger integral;

/**
 兑换的么币数
 */
@property (nonatomic,assign) NSInteger mcoin;

@end
