//
//  ZZKTVReceiveUserModel.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/15.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVReceiveUserModel.h"

@implementation ZZKTVReceiveUserModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"to" : [ZZUser class],
             @"song": [ZZKTVSongModel class],
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"song" : @"song_list",
    };
}

@end
