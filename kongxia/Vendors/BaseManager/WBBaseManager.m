//
//  WBBaseManager.m
//  Whistle
//
//  Created by ZhangAo on 15/9/10.
//  Copyright (c) 2015年 BookSir. All rights reserved.
//

#import "WBBaseManager.h"

@implementation WBBaseManager

+ (instancetype)sharedInstance {
	return [self sharedInstance:YES];
}

static NSMutableDictionary *instances;
static NSLock *lock;
+ (instancetype)sharedInstance:(BOOL)createIfNotExists {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instances = [NSMutableDictionary dictionary];
		lock = [NSLock new];
	});
	
	@synchronized (lock) {
		NSString *key = NSStringFromClass([self class]);
		id object = instances[key];
		if (object == nil && createIfNotExists) {
			object = [self new];
			[instances setObject:object forKey:key];
		}
		
		return object;
	}
}

- (void)removeInstance {
	@synchronized (lock) {
		NSString *key = NSStringFromClass([self class]);
		WBBaseManager *manager = instances[key];
		[manager invalidate];
		[instances removeObjectForKey:key];
	}
}

- (void)invalidate {
	// ...
    [self clearAllBlocks];
}

@end
