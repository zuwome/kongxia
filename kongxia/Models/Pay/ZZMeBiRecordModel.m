//
//  ZZMeBiRecordModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/10.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZMeBiRecordModel.h"

@implementation ZZMeBiRecordModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"meBiRecordId"}];
}

@end
