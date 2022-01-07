//
//  ZZCommentModel.m
//  zuwome
//
//  Created by angBiu on 16/8/16.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZCommentModel.h"

@implementation ZZReplyModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"replyId"
                                                       }];
}

@end

@implementation ZZCommentModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end
