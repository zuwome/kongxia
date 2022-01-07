//
//  QNUploadHelper.m
//  zuwome
//
//  Created by angBiu on 16/9/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "QNUploadHelper.h"

@implementation QNUploadHelper

// 单例
+ (id)shareInstance
{
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

@end
