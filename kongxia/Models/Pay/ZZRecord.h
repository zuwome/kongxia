//
//  ZZRecord.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZRecord : JSONModel
@property (nonatomic, strong) NSString *sort_value;
/**
用途
 */
@property(nonatomic,strong) NSString *content;
/**
 用途的类型
 */
@property(nonatomic,strong) NSString *type;
/**
 产生时间
 */
@property(nonatomic,strong) NSString *created_at;
/**
 通道
 */
@property(nonatomic,strong) NSString *channel;
/**
 金钱的数额
 */
@property(nonatomic,strong) NSString *amount;

@property (nonatomic, strong) ZZUser *be_user;

@property (nonatomic, strong) NSString *gift_name;

+ (void)rechargeWithParam:(NSDictionary *)param next:(requestCallback)next;
@end
