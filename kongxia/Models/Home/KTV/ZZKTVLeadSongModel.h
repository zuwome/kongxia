//
//  ZZKTVLeadSongModel.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/13.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZKTVSongListResponesModel.h"

@interface ZZKTVLeadSongModel : NSObject

@property (nonatomic, copy) NSString *from;

@property (nonatomic, strong) ZZUser *to;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *gift_recording;

@property (nonatomic, copy) NSString *pd_song;

@property (nonatomic, strong) ZZKTVSongModel *song;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, assign) BOOL isSongPlaying;

@end

