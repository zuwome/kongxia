//
//  ZZKTVLeadSongModel.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/13.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVLeadSongModel.h"

@implementation ZZKTVLeadSongModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"to" : [ZZUser class],
             @"from" : [ZZUser class],
             @"song_list" : [ZZKTVSongModel class],
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"song" : @"song_list",
    };
}

@end
