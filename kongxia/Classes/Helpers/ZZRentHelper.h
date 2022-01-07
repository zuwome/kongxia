//
//  ZZRentHelper.h
//  zuwome
//
//  Created by wlsy on 16/1/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZRequest.h"

@interface ZZRentHelper : NSObject
- (void)pullExploreWithParams:(NSMutableDictionary *)params next:(requestCallback)next;
- (void)pullExploreWithParamsAll:(NSMutableDictionary *)params lt:(NSDate *)lt next:(requestCallback)next;
- (void)pullWithParams:(NSMutableDictionary *)params lt:(NSDate *)lt next:(requestCallback)next;
@end
