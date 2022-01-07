//
//  ZZRecordLabelModel.m
//  zuwome
//
//  Created by angBiu on 2016/12/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRecordLabelModel.h"

@implementation ZZRecordLabelModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"labelId"
                                                       }];
}

+ (void)getLabelList:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/sk/groups2" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
