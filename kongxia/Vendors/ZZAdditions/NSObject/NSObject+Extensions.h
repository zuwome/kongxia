//
//  NSObject+Extensions.h
//  AirMonitor
//
//  Created by 余天龙 on 2017/1/9.
//  Copyright © 2017年 http://blog.csdn.net/yutianlong9306/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extensions)

+ (void)asyncWaitingWithTime:(CGFloat)duration_time
               completeBlock:(void (^)(void))completed;

@end
