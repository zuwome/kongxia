//
//  ZZKTVSongModel.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVSongListResponesModel.h"

@implementation ZZKTVSongListResponesModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"songList" : [ZZKTVSongModel class],
             @"typeList" : [ZZKTVSongTypeModel class],
             };
}

@end

@implementation ZZKTVSongModel

@end

@implementation ZZKTVSongTypeModel


@end
