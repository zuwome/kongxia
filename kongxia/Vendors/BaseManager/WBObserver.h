//
//  WBObserver.h
//  Whistle
//
//  Created by ZhangAo on 16/7/6.
//  Copyright © 2016年 BookSir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBObserver : NSObject

// 观察者相关
- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

- (void)notifyObserversWithSelector:(SEL)selector withObject:(id)object;
- (void)notifyObserversWithSelector:(SEL)selector withObjectOne:(id)objectOne objectTwo:(id)objectTwo;
- (void)notifyObserversWithSelector:(SEL)selector withObjectOne:(id)objectOne objectTwo:(id)objectTwo objectThree:(id)objectThree;

// block 相关
- (void)addBlock:(id)block withKey:(NSString *)key;
- (NSMutableArray *)blocksWithKey:(NSString *)key;
- (void)clearBlocksForKey:(NSString *)key;
- (void)clearAllBlocks;

@end
