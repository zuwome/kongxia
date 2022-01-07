//
//  ZZKTVModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZKTVSongListResponesModel.h"
#import "ZZGiftModel.h"

@interface ZZKTVModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *_id;

@property (nonatomic, strong) ZZUser *from;

@property (nonatomic, strong) ZZGiftModel *gift;

// 歌曲
@property (nonatomic, copy) NSArray<ZZKTVSongModel *> *song_list;

@property (nonatomic, copy) NSString *created_at;
// 
@property (nonatomic, assign) NSInteger status;


@property (nonatomic, assign) NSInteger gift_count;


@property (nonatomic, assign) NSInteger gift_last_count;

// 性别 1:男 2:女
@property (nonatomic, assign) NSInteger gender;

// 匿名 1: 不匿名 2:匿名
@property (nonatomic, assign) NSInteger is_anonymous;

@property (nonatomic, copy) NSString *anonymous_avatar;

@property (nonatomic, copy) NSString *anonymous_nickName;

// 我已经唱过了
@property (nonatomic, assign) BOOL alreadySang;

@property (nonatomic, copy) NSString *savedGiftID;

@property (nonatomic, copy) NSString *savedGiftName;

@end

