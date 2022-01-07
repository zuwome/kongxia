//
//  ZZMemedaQuestionModel.m
//  zuwome
//
//  Created by angBiu on 16/8/30.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMemedaQuestionModel.h"

@implementation ZZMemedaQuestionModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"questionID"
                                                       }];
}

+ (void)getMemedaQuestions:(NSDictionary *)param next:(requestCallback)next
{
    [ZZRequest method:@"GET" path:@"/mmd/sys_questions" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
