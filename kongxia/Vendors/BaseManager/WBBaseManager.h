//
//  WBBaseManager.h
//  Whistle
//
//  Created by ZhangAo on 15/9/10.
//  Copyright (c) 2015年 BookSir. All rights reserved.
//

#import "WBObserver.h"

@interface WBBaseManager : WBObserver

+ (instancetype)sharedInstance;

+ (instancetype)sharedInstance:(BOOL)createIfNotExists;

- (void)removeInstance;

// 清理资源
- (void)invalidate;

@end
