//
//  ZZRecordStickerModel.m
//  zuwome
//
//  Created by angBiu on 2016/12/16.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRecordStickerModel.h"

@implementation ZZRecordStickerModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                      @"id":@"stickerId"
                                                      }];
}

+ (void)getStickersList:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/system/stickers2" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
