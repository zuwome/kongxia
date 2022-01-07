//
//  ZZWeakTimer.h
//  zuwome
//
//  Created by angBiu on 2017/7/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZWeakTimer : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer* timer;

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

@end
