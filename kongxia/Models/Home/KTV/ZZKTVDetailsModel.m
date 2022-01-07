//
//  ZZKTVDetailsModel.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/15.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVDetailsModel.h"

@implementation ZZKTVDetailsModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"task" : [ZZKTVModel class],
             @"receiveList" : [ZZKTVReceiveUserModel class],
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"task" : @"pdSong",
    };
}


- (BOOL)areGiftsAllCollected {
    return _task.gift_last_count == 0;
}

@end
