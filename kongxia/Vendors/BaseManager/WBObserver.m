//
//  WBObserver.m
//  Whistle
//
//  Created by ZhangAo on 16/7/6.
//  Copyright © 2016年 BookSir. All rights reserved.
//

#import "WBObserver.h"
#import <objc/message.h>

@interface WBObserver ()

@property (nonatomic, strong) NSHashTable *observers;
@property (nonatomic, strong) NSMutableDictionary *blocksDict;

@end

@implementation WBObserver

- (NSHashTable *)observers {
	if (_observers == nil) {
		_observers = [NSHashTable weakObjectsHashTable];
	}
	
	return _observers;
}

- (NSMutableDictionary *)blocksDict {
	if (_blocksDict == nil) {
		_blocksDict = [NSMutableDictionary dictionary];
	}
	
	return _blocksDict;
}

- (void)addObserver:(id)observer {
	[self.observers addObject:observer];
}

- (void)notifyObserversWithSelector:(SEL)selector withObject:(id)object {
	[self notifyObserversWithSelector:selector withObjectOne:object objectTwo:nil];
}

- (void)notifyObserversWithSelector:(SEL)selector withObjectOne:(id)objectOne objectTwo:(id)objectTwo {
	[self notifyObserversWithSelector:selector withObjectOne:objectOne objectTwo:objectTwo objectThree:nil];
}

- (void)notifyObserversWithSelector:(SEL)selector withObjectOne:(id)objectOne objectTwo:(id)objectTwo objectThree:(id)objectThree {
	if (self.observers.count > 0) {
		dispatch_async(dispatch_get_main_queue(), ^{
			for (id observer in [self.observers copy]) {
				if([observer respondsToSelector:selector]) {
					void (*callFuntion)(id, SEL, id, id, id) = (void(*)(id, SEL, id, id, id))objc_msgSend;
					callFuntion(observer, selector, objectOne, objectTwo, objectThree);
				}
			}
		});
	}
}

- (void)removeObserver:(id)observer {
	[self.observers removeObject:observer];
}

- (void)addBlock:(id)block withKey:(NSString *)key {
	if (block == nil) {
		return;
	}
	NSMutableArray *blocksInKey = self.blocksDict[key];
	if (blocksInKey == nil) {
		blocksInKey = [NSMutableArray arrayWithCapacity:3];
		[self.blocksDict setObject:blocksInKey forKey:key];
	}
	[blocksInKey addObject:block];
}

- (NSMutableArray *)blocksWithKey:(NSString *)key {
	return self.blocksDict[key];
}

- (void)clearBlocksForKey:(NSString *)key {
	[self.blocksDict[key] removeAllObjects];
}

- (void)clearAllBlocks {
	[self.blocksDict removeAllObjects];
}

@end

