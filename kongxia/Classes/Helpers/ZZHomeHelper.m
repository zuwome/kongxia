//
//  ZZHomeHelper.m
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeHelper.h"

@implementation ZZHomeHelper

- (void)getHomeListWithParam:(NSDictionary *)param next:(requestCallback)next {
    
    NSString *path = @"/rents_bycate";
    if ([ZZUserHelper shareInstance].isLogin) {
        path = @"/api/rents_bycate";
    }
    
    if ([param[@"cate"] isEqualToString:@"new"] && [ZZUserHelper shareInstance].configModel.open_new_rent) {
        path = @"/new_rents_bycate";
    }
    
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

- (void)fetchHomeListRecommendListWithoutLoginWithParam:(NSDictionary *)param next:(requestCallback)next {
    NSString *path = @"/rents_bycate2";
    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

@end
