//
//  ZZMeBiModel.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "JSONModel.h"

@interface ZZMeBiModel : JSONModel

/**
 产品id
 */
@property(nonatomic,strong)NSString *productId;
/**
么币
 */
@property(nonatomic,strong)NSString *meBi;
/**
么币的价格
 */
@property(nonatomic,strong)NSString *meBiPrice;

/**
    赠送的么币
 */
@property (nonatomic, assign) NSInteger give;

//获取内购列表（购买微信相关）
+ (void)getIAPWithWechatPayList:(requestCallback)next;

//使用么币购买微信（仅iOS端）
+ (void)buyWeChat:(NSString *)uid byMcoin:(NSString *)price next:(requestCallback)next;

+ (void)buyWeChat:(NSString *)uid byMcoin:(NSString *)price source:(NSString *)source next:(requestCallback)next;

// 使用么币购买证件照（仅iOS端）
+ (void)buyIDPhoto:(NSString *)uid byMcoin:(NSString *)price next:(requestCallback)next;

+ (void)fetchPriceList:(NSString *)type next:(requestCallback)next;

+ (void)fetchWeChat:(requestCallback)next;

+ (void)fetchIDPhoto:(requestCallback)next;

- (void)rechargeBy:(NSInteger )channelType model:(ZZMeBiModel *)model next:(void(^)(BOOL isSuccess))next;

// 获取充值么币的选项
+ (void)fetchRechargeMebiList:(requestCallback)next;

@end
