//
//  ZZSkillModel.h
//  zuwome
//
//  Created by angBiu on 2017/7/25.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZSkillModel : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, copy) NSString *ad;
@property (nonatomic, assign) NSInteger begin_price;//开始每个单位多少钱，比如 第一分钟5元
@property (nonatomic, assign) NSInteger extra_price;//之后每个单位多少钱，每分钟2元

@end
