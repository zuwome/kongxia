//
//  ZZTotalContributionModel.m
//  zuwome
//
//  Created by angBiu on 2016/10/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTotalContributionModel.h"

@implementation ZZTotalTipListModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZTotalContributionModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)getContributionListWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/contribution",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
