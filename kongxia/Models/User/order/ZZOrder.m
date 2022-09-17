//
//  ZZOrder.m
//  zuwome
//
//  Created by wlsy on 16/1/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrder.h"

#define UserInfoString(id) (id == nil ? @"" : id)

@implementation JSONValueTransformer(CGStructs)

//CGPoint
-(CLLocation *)CLLocationFromNSDictionary:(NSDictionary*)dic {
    double lat = [[dic objectForKey:@"lat"] doubleValue];
    double lng = [[dic objectForKey:@"lng"] doubleValue];
    if (lat && lng) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        return loc;
    } else {
        return nil;
    }
}

-(NSDictionary *)JSONObjectFromCLLocation:(CLLocation*)location {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setObject:@(location.coordinate.latitude) forKey:@"lat"];
    [d setObject:@(location.coordinate.longitude) forKey:@"lng"];
    return d;
}
@end

@implementation ZZOrderReport
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end

@implementation ZZOrderRefund
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end

@implementation ZZOrderRefundDepositModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end

@implementation ZZOrderAppeal
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end

@implementation ZZOrderMet
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end

@implementation ZZOrderLocation
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end

@implementation ZZOrder

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"from": [ZZUser class],
             @"to": [ZZUser class],
             @"skill": [ZZSkill class],
             @"city": [ZZCity class],
             @"loc": [ZZOrderLocation class],
             @"refund": [ZZOrderRefund class],
             @"appeal": [ZZOrderAppeal class],
             @"met": [ZZOrderMet class],
             @"report": [ZZOrderReport class],
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _xdf_price = @2;
    }
    return self;
}

- (NSString *)status_desc {
    return UserInfoString(_status_desc);
}

- (NSString *)dated_at_string {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return [formatter stringFromDate:self.dated_at];
    
}

// 不计额外费用(优享、下单费)
- (double)pureTotalPrice {
    if (_type == 3 || _type == 4) {
        return _totalPrice.doubleValue;
    }
    double totalPrice = [_price doubleValue] * _hours;
    if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:_from.uid]) {
        if (totalPrice <= 50.0f) {
            // 如果订单总金额小于50元，则抽佣固定 5 元
            totalPrice += 5.0f;
        }
        else {
            // 否则以服务端抽佣比例计算
            totalPrice = (1 + [ZZUserHelper shareInstance].configModel.yj.order_from) * totalPrice;
        }
        return totalPrice;
    }
    else {
        return totalPrice;
    }
}

- (BOOL)isNewTask {
    BOOL isNew = NO;
    if (_pd_version) {
        if ([ZZUtils compareVersionFrom:@"3.7.7" to:_pd_version] != NSOrderedDescending) {
            isNew = YES;
        }
    }
    return isNew;
}

#pragma mark - Request
- (void)add:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/user/%@/order", self.to.uid];
    [ZZRequest method:@"POST" path:path params:[self toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)addDeposit:(requestCallback)next {
    NSString *uid = self.to.uid;
    if (isNullString(self.to.uid)) {
        uid = self.to.uuid;
    }
    NSString *path = [NSString stringWithFormat:@"/api/user/%@/order_deposit", uid];
    NSMutableDictionary *dic = [self toDictionary].mutableCopy;
    if (dic[@"wechat_service"] && [dic[@"wechat_service"] boolValue]) {
        [dic removeObjectForKey:@"wechat_service"];
        dic[@"wechat_service"] = @"true";
    }
    
    if (!_wechat_service) {
        dic[@"xdf_price"] = _xdf_price;
    }
    else {
        [dic removeObjectForKey:@"xdf_price"];
    }
    
    if (![ZZUtils isEmpty:self.city.cityId] && [ZZUtils isEmpty:dic ]) {
        NSMutableDictionary *citym = [dic[@"city"] mutableCopy];
        citym[@"id"] = self.city.cityId;
        dic[@"city"] = citym.copy;
    }
    
    [ZZRequest method:@"POST" path:path params:dic.copy next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)update:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@", self.id];
    [ZZRequest method:@"POST" path:path params:[self toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)cancel:(NSString *)reason status:(NSString *)status next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/cancel?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:@{@"reason": reason} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)refuse:(NSString *)reason status:(NSString *)status next:(requestCallback)next{
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/refuse?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:@{@"reason": reason} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

//- (void)appeal:(NSString *)status next:(requestCallback)next{
//    NSString *path = [NSString stringWithFormat:@"/api/order/%@/appeal?order_status=%@", self.id,status];
//    [ZZRequest method:@"POST" path:path params:[self toDictionaryWithKeys:@[@"appeal"]] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
//}

- (void)accept:(NSString *)status next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/accept?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)pay:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/pay", self.id];
    [ZZRequest method:@"POST" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)met:(CLLocation *)location status:(NSString *)status next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/met?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:@{@"lat":[NSNumber numberWithFloat:location.coordinate.latitude],@"lng":[NSNumber numberWithFloat:location.coordinate.longitude]} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)refund:(NSString *)status next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/refund?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:[self toDictionaryWithKeys:@[@"refund"]] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)refundDeposit:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/order/%@/refund?order_status=%@",orderId,status] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)refundYes:(NSString *)status next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/refund/yes?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}
- (void)refundNo:(NSString *)status param:(NSDictionary *)param next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/refund/no?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)comments:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/comments", self.id];
    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)getPhone:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/phone", self.id];
    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)pay:(NSString *)channel status:(NSString *)status next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setObject:channel forKey:@"channel"];
    [d setObject:@"kxp" forKey:@"pingxxtype"];
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/pay?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)advancePay:(NSString *)channel status:(NSString *)status next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setObject:channel forKey:@"channel"];
    [d setObject:@"kxp" forKey:@"pingxxtype"];
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/pay_deposit?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)loadInfo:(NSString *)orderId next:(requestCallback)next {
    NSString *path = [NSString stringWithFormat:@"/api/order/%@", orderId];
    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)remindWithOrderId:(NSString *)orderId status:(NSString *)status next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/notify?order_status=%@", self.id,status];
    [ZZRequest method:@"POST" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
       next(error, data, task);
    }];
}

+ (void)cancelOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/cancel?order_status=%@", orderId,status];
    [ZZRequest method:@"POST" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)refuseOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/refuse?order_status=%@", orderId,status];
    [ZZRequest method:@"POST" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)refundOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/order/%@/refund?order_status=%@",orderId,status] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)pullAllWithStatus:(NSString *)status lt:(NSString *)lt next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setObject:status forKey:@"status"];
    if (lt) {
        [d setObject:lt forKey:@"lt"];
    }
    [ZZRequest method:@"GET" path:@"/api/user/orders" params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)latestWithUser:(NSString *)uid next:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    if (!isNullString(uid)) {
        [d setObject:uid forKey:@"user"];
    }
    
    [ZZRequest method:@"GET" path:@"/api/order/latest" params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)deleteOrderWithOrderId:(NSString *)orderId next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/order/%@/del",orderId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)revokeRefundOrder:(NSString *)orderId status:(NSString *)status next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/order/%@/refund/cancel?order_status=%@",orderId,status] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)editRefundOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/order/%@/refund/modify?order_status=%@",orderId,status] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)commentOrder:(NSDictionary *)param status:(NSString *)status orderId:(NSString *)orderId next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"/api/order/%@/comment?order_status=%@", orderId,status];
    [ZZRequest method:@"POST" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

#pragma mark - getters and setters
- (NSNumber *)totalPrice {
    if (_type == 3 || _type == 4) {
        return _totalPrice;
    }
    if (!(_hours && _price)) {
        return @0.0;
    }
    double tprice = [self pureTotalPrice];
    if (_wechat_service) {
        if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:_from.uid]) {
            tprice += self.wechat_price;
        }
    }
    else {
        if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:_from.uid]) {
            tprice += [_xdf_price doubleValue];
        }
    }
    return [NSNumber numberWithDouble:tprice];
}

- (NSNumber *)advancePrice {
    if (!(_hours && _price)) {
        return @0.0;
    }
    
    double tprice = [self pureTotalPrice];
    
    double advancePrice = 0;
    
    if (tprice < 10) {
        advancePrice = tprice;
    }
    else {
        // 意向金采取四舍五入的形式
        advancePrice = roundf(tprice * 0.05);
    }
    
    if (_wechat_service) {
        advancePrice += _wechat_price;
    }
    else {
        advancePrice += [_xdf_price doubleValue];
    }
    
    return [NSNumber numberWithDouble:advancePrice];
}

- (void)setXdf_price:(NSNumber *)xdf_price {
    _xdf_price = xdf_price;
}

@end
