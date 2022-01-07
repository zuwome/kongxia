//
//  ZZKTVSongListView.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZKTVSongModel;
@class ZZKTVSongListView;

@protocol ZZKTVSongListViewDelegate <NSObject>

- (void)view:(ZZKTVSongListView *)view addSong:(ZZKTVSongModel *)songModel;

@end

@interface ZZKTVSongListView : UIView

@property (nonatomic, weak) id<ZZKTVSongListViewDelegate> delegate;

@property (nonatomic, strong) ZZKTVSongModel *songModel;

- (void)setDidSelect:(BOOL)isSelect;

@end

