//
//  ZZRealname.m
//  zuwome
//
//  Created by wlsy on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRealname.h"

@implementation ZZRealnamePic
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
@end

@implementation ZZRealname
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)putParam:(NSDictionary *)param next:(requestCallback)next {
    [ZZRequest method:@"POST" path:@"/api/user/realname" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        next(error, data, task);
    }];
}

@end
