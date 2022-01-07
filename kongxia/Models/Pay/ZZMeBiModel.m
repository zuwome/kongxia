//
//  ZZMeBiModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//@property(nonatomic,strong)NSString *productId;
/**
// 么币
// */
//@property(nonatomic,strong)NSString *meBi;
///**
// 么币的价格
// */
//@property(nonatomic,strong)NSString *meBiPrice;



#import "ZZMeBiModel.h"
#import "Pingpp.h"
@interface ZZMeBiModel()


@end

@implementation ZZMeBiModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"mcoin":@"meBi",@"money":@"meBiPrice",@"production_id":@"productId"}];
}

+ (void)getIAPWithWechatPayList:(requestCallback)next {   //获取内购列表（购买微信相关）
    // 租我么: list_pay_wechat
    // 空虾: list_pay_wechatkx
    [ZZRequest method:@"GET" path:@"/system/in_app_purchase/list_pay_wechatkx" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)buyWeChat:(NSString *)uid
          byMcoin:(NSString *)price
           source:(NSString *)source
             next:(requestCallback)next {
    

    NSString *path = [NSString stringWithFormat:@"/api/user/%@/wechat/pay_by_mcoin",uid];
    
//    NSString *newPath = [NSString stringWithFormat:@"/api/user/%@/wechat/new/pay_by_mcoin",uid];
    NSDictionary *params = @{
                             @"price":price,
                             @"channel":@"pay_for_wechat",
                             @"action_by": source,
                             };
    [ZZRequest method:@"POST" path:path params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)buyWeChat:(NSString *)uid byMcoin:(NSString *)price next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/user/%@/wechat/pay_by_mcoin",uid];
    NSDictionary *params = @{
                             @"price":price,
                             @"channel":@"pay_for_wechat",
                             };
    [ZZRequest method:@"POST" path:path params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)buyIDPhoto:(NSString *)uid byMcoin:(NSString *)price next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/user/%@/id_photo/pay_by_mcoin",uid];
    NSDictionary *params = @{
                             @"price":price,
                             @"channel":@"pay_for_idphoto",
                             };
    [ZZRequest method:@"POST" path:path params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)fetchPriceList:(NSString *)type next:(requestCallback)next {
    [self fetchPriceWithType:type next:next];
}

+ (void)fetchWeChat:(requestCallback)next {
    [self fetchPriceWithType:@"wechat" next:next];
}

+ (void)fetchIDPhoto:(requestCallback)next {
    [self fetchPriceWithType:@"id_photo" next:next];
}

+ (void)fetchPriceWithType:(NSString *)type next:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/system/in_app_purchase/mcoin_list_android" params:@{@"type": type} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
       next(error, data, task);
    }];
}

+ (void)fetchRechargeMebiList:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/system/in_app_purchase/listkx" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)rechargeBy:(NSInteger)channelType model:(ZZMeBiModel *)model next:(void (^)(BOOL))next {
    NSString *channel = nil;
    if (channelType == 1) {
        channel = @"wx";
    }
    else if (channelType == 2) {
        channel = @"alipay";
    }
    [self fetchMid:model.meBi next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (!error) {
            if ([data isKindOfClass:[NSDictionary class]] && [(NSDictionary *)data objectForKey: @"mid"] ) {
                [self fetchOrderData:channel mid:[(NSDictionary *)data objectForKey: @"mid"] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (!error) {
                        
                        NSDictionary *paymentData = @{@"id":data[@"id"], @"type":@(999), @"pingxxtype": @"kxp",};
                        [ZZUserDefaultsHelper setObject:paymentData forDestKey:kPaymentData];
                        [Pingpp createPayment:data
                               viewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                 appURLScheme:@"kongxia"
                               withCompletion:^(NSString *result, PingppError *error) {
                                   if ([result isEqualToString:@"success"]) {
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           if (next) {
                                               next(YES);
                                           }
                                           [ZZHUD showSuccessWithStatus:@"充值成功"];
                                       });
                                   } else {
                                       // 支付失败或取消
                                       [ZZHUD showErrorWithStatus:@"支付失败"];
                                       NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                                   }
                               }];
                    }
                }];
            }
        }
    }];
}

- (void)fetchMid:(NSString *)price next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/api/user/mcoin/recharge/add" params:@{@"mcoin": price} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus: error.message];
        }
        else {
            if (next) {
                next(error, data, task);
            }
        }
    }];
}

- (void)fetchOrderData:(NSString *)channel mid:(NSString *)mid next:(requestCallback)next {
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/mcoin/%@/pay",mid] params:@{@"channel": channel} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus: error.message];
        }
        else {
            if (next) {
                next(error, data, task);
            }
        }
    }];
}
@end
