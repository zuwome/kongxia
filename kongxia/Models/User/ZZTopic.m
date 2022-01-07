//
//  ZZTopic.m
//  zuwome
//
//  Created by wlsy on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTopic.h"

@implementation ZZTopic
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (NSString *)title {
    NSMutableArray *s = [NSMutableArray array];
    [self.skills enumerateObjectsUsingBlock:^(ZZSkill *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [s addObject:obj.name];
    }];
    return [s componentsJoinedByString:@"、"];
}

- (void)setPriceWithNSNumber:(NSNumber *)number {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    f.maximumFractionDigits = 2;
    self.price = [f stringFromNumber:number];
}

@end
