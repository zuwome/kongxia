//
//  ZZSnatchModel.h
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZSnatchDetailModel : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) ZZUser *from;
@property (nonatomic, assign) NSInteger type;//2线上、3线下
@property (nonatomic, strong) ZZSkill *skill;
@property (nonatomic, assign) NSInteger is_anonymous;   //1、不匿名 2、匿名
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *created_at_text;
@property (nonatomic, assign) NSInteger valid_duration;//过时总时长
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *address_lat;
@property (nonatomic, strong) NSString *address_lng;
@property (nonatomic, strong) NSString *dated_at_text;
@property (nonatomic, assign) long remain_time;
@property (nonatomic, assign) double price;

@end

@interface ZZSnatchModel : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) ZZSnatchDetailModel *pd;
@property (nonatomic, assign) NSInteger status;//0等待抢 1已抢(等对方选择) 2已被抢（过期 满额 连通其他人） 4不能抢 （满3单了）
@property (nonatomic, assign) long remain_time_receiver;//女方剩余时间  单位：毫秒  数值范围： 大于等于0的整数
@property (nonatomic, assign) long remain_time_sponsor;//男方剩余时间
@property (nonatomic, strong) NSString *price_text;

@end
