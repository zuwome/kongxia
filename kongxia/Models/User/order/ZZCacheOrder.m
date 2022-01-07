//
//  ZZCacheOrder.m
//  zuwome
//
//  Created by angBiu on 16/9/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZCacheOrder.h"

@implementation ZZCacheOrder

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.dated_at = [aDecoder decodeObjectForKey:@"dated_at"];
        self.hours = [[aDecoder decodeObjectForKey:@"hours"] intValue];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.remarks = [aDecoder decodeObjectForKey:@"remarks"];
        self.currentDate = [aDecoder decodeObjectForKey:@"currentDate"];
        self.loc = [aDecoder decodeObjectForKey:@"loc"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.isQuickTime = [[aDecoder decodeObjectForKey:@"isQuickTime"] boolValue];
        self.checkWeChat = [[aDecoder decodeObjectForKey:@"checkWeChat"] boolValue];
        self.wechat_service = [aDecoder decodeObjectForKey:@"wechat_service"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.dated_at forKey:@"dated_at"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.hours] forKey:@"hours"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.remarks forKey:@"remarks"];
    [aCoder encodeObject:self.currentDate forKey:@"currentDate"];
    [aCoder encodeObject:self.loc forKey:@"loc"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isQuickTime] forKey:@"isQuickTime"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.checkWeChat] forKey:@"checkWeChat"];
    [aCoder encodeObject:self.wechat_service forKey:@"wechat_service"];
}

@end
