//
//  ZZKTVRecievedGiftResponseModel.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/16.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVRecievedGiftResponseModel.h"

@implementation ZZKTVRecievedGiftResponseModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"songList" : [ZZKTVReceivedGiftModel class],
             };
}

@end

@implementation ZZKTVReceivedGiftModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"from" : [ZZUser class],
             @"pd_song": [ZZKTVModel class],
             @"song_list": [ZZKTVSongModel class],
             };
}

@end
