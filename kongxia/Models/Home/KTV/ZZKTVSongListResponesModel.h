//
//  ZZKTVSongModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/31.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZKTVSongModel;
@class ZZKTVSongTypeModel;
@interface ZZKTVSongListResponesModel : NSObject

@property (nonatomic, copy) NSArray<ZZKTVSongModel *> *songList;

@property (nonatomic, copy) NSArray<ZZKTVSongTypeModel *> *typeList;

@end


@interface ZZKTVSongModel : NSObject

@property (nonatomic,   copy) NSString  *_id;

@property (nonatomic,   copy) NSString  *content;

@property (nonatomic,   copy) NSString  *created_at;

@property (nonatomic,   copy) NSString  *name;

@property (nonatomic, assign) NSInteger song_num;

@property (nonatomic,   copy) NSString  *song_type;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *auth;

@end


@interface ZZKTVSongTypeModel : NSObject

@property (nonatomic,   copy) NSString  *_id;

@property (nonatomic,   copy) NSString  *created_at;

@property (nonatomic,   copy) NSString  *name;

@property (nonatomic, assign) NSInteger status;

@end
