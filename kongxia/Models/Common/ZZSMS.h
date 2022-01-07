//
//  ZZSMS.h
//  zuwome
//
//  Created by wlsy on 16/1/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZRequest.h"


@interface ZZSMS : NSObject

+ (void)sendCodeByPhone:(NSDictionary *)param next:(requestCallback)next;
+ (void)verifyPhone:(NSString *)phone code:(NSString *)code next:(requestCallback)next;

@end
