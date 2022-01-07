//
//  ZZSkill.m
//  zuwome
//
//  Created by wlsy on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSkill.h"

@implementation ZZSkill

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
        if (self.detail == nil) {
            self.detail = [[ZZSkillDetail alloc] initIfNotfound];
        }
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"skillID": @"_id"
                                                                  }];
}

- (void)add:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    if (self.name) {
        [d setObject:self.name forKey:@"name"];
    }
    [ZZRequest method:@"POST" path:@"/api/skill" params:d next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

+ (void)syncWithParams:(NSDictionary *)params next:(requestCallback)next {
    [ZZRequest method:@"GET" path:@"/api/skills" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

- (void)setPrice:(NSString *)price {
    _price = price;
}

- (void)setSkillID:(NSString *)skillID {
    _skillID = skillID;
    _id = _skillID;
}

@end


@implementation ZZSkillDetail

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (instancetype)initIfNotfound {  //服务端未返回时,文字状态置为-1，防止与0：审核不通过 产生冲突。
    if (self = [super init]) {
        self.status = -1;
    }
    return self;
}

@end

@implementation ZZSkillTag

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
