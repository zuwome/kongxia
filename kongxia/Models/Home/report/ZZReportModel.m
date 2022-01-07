//
//  ReportModel.m
//  zuwome
//
//  Created by angBiu on 16/5/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZReportModel.h"
#import <QiniuSDK.h>

@implementation ZZReportModel

+ (void)reportWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/report",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error,data,task);
    }];
}

@end
