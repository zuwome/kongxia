//
//  ZZUpdateModel.m
//  zuwome
//
//  Created by angBiu on 16/5/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUpdateModel.h"

@implementation ZZUpdateModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"newVersion":@"version",
                                                       @"haveNewVersion":@"haveNewVersion"
                                                       }];
}

@end

@implementation ZZVersionModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end
