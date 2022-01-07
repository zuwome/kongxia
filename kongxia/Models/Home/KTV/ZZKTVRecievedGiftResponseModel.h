//
//  ZZKTVRecievedGiftResponseModel.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/16.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZKTVConfig.h"

@class ZZKTVReceivedGiftModel;
@interface ZZKTVRecievedGiftResponseModel : NSObject

@property (nonatomic, assign) double gift_rate;

@property (nonatomic,   copy) NSArray<ZZKTVReceivedGiftModel *> *songList;

@end

@interface ZZKTVReceivedGiftModel : NSObject

@property (nonatomic, strong) ZZUser *from;

@property (nonatomic,   copy) NSString *to;

@property (nonatomic,   copy) NSString *content;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic,   copy) NSString *gift_recording;

@property (nonatomic, strong) ZZKTVModel *pd_song;

@property (nonatomic, strong) ZZKTVSongModel *song_list;

@property (nonatomic,   copy) NSString *created_at;

@property (nonatomic, assign) BOOL isSongPlaying;

@end
