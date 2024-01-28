//
//  ZZKTVSongsSelectedVIew.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/9.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZKTVSongsSelectedVIew.h"
#import "ZZKTVSongListView.h"

#import "ZZKTVConfig.h"

@interface ZZKTVSongsSelectedVIew () <ZZKTVSongListViewDelegate>

@property (nonatomic, copy) NSArray<ZZKTVSongModel *> *songsArr;

@property (nonatomic, copy) NSArray<ZZKTVSongListView *> *songViews;

@end

@implementation ZZKTVSongsSelectedVIew

- (instancetype)initWithSongs:(NSArray<ZZKTVSongModel *> *)songs {
    self = [super init];
    if (self) {
        _songsArr = songs;
        [self layout];
    }
    return self;
}

#pragma mark - ZZKTVSongListViewDelegate
- (void)view:(ZZKTVSongListView *)view addSong:(ZZKTVSongModel *)songModel {
    NSMutableArray<ZZKTVSongModel *> *songsM = _songsArr.mutableCopy;
    NSMutableArray<ZZKTVSongListView *> *songsViewsM = _songViews.mutableCopy;
    
    if (songsM.count != 0) {
        __block BOOL didSelecteSong = NO;
        __block NSInteger index = -1;
        [songsM enumerateObjectsUsingBlock:^(ZZKTVSongModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj._id isEqualToString:songModel._id]) {
                didSelecteSong = YES;
                index = idx;
                *stop = YES;
            }
        }];

        if (didSelecteSong) {
            ZZKTVSongModel *song = songsM[index];
            song.isSelected = NO;
            [songsM removeObjectAtIndex:index];

            ZZKTVSongListView *view = songsViewsM[index];
            [songsViewsM removeObjectAtIndex:index];
            _songsArr = songsM.copy;
            _songViews = songsViewsM.copy;

            if (songsViewsM.count == 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewClearAll:)]) {
                    [self.delegate viewClearAll:self];
                }
            }
            else {
                [view removeFromSuperview];
                [self relayout];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(view:editSong:)]) {
                    [self.delegate view:self editSong:songModel];
                }
            }

        }
    }
}


#pragma mark - Layout
- (void)layout {
    [self createSongsView];
    
}

- (void)createSongsView {
    self.backgroundColor = UIColor.whiteColor;
    
    NSMutableArray<ZZKTVSongListView *> *views = @[].mutableCopy;
    __block ZZKTVSongListView *lastView = nil;
    for (NSInteger i = 0; i < _songsArr.count; i++) {
        ZZKTVSongModel *song = _songsArr[i];
        
        ZZKTVSongListView *view = [[ZZKTVSongListView alloc] init];
        view.delegate = self;
        [view setDidSelect:YES];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            if (i == 0) {
                make.top.equalTo(self);
            }
            else {
                make.top.equalTo(lastView.mas_bottom);
            }
            
            
            if (i == _songsArr.count - 1) {
                make.bottom.equalTo(self);
            }
        }];
        view.songModel = song;
        lastView = view;
        [views addObject:view];
    }
    
    _songViews = views;
}

- (void)relayout {
    __block ZZKTVSongListView *lastView = nil;
    for (NSInteger i = 0; i < _songViews.count; i++) {
        ZZKTVSongListView *view = _songViews[i];
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(self);
            }
            else {
                make.top.equalTo(lastView.mas_bottom);
            }
            
            if (i == _songsArr.count - 1) {
                make.bottom.equalTo(self);
            }
        }];
        lastView = view;
        
        
    }
}


#pragma mark - getters and setters

@end
