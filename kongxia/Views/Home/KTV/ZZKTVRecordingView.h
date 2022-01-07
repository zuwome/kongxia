//
//  ZZKTVRecordingView.h
//  kongxia
//
//  Created by qiming xiao on 2020/1/10.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZKTVModel;
@class ZZKTVRecordingView;

@protocol ZZKTVRecordingViewDelegate<NSObject>

- (void)view:(ZZKTVRecordingView *)view recogniteComplete:(NSString *)pcmFile fileDuration:(NSTimeInterval)duration;

@end


@interface ZZKTVRecordingView : UIView

@property (nonatomic, weak) id<ZZKTVRecordingViewDelegate> delegate;

- (instancetype)initWithTaskModel:(ZZKTVModel *)model selectedSong:(NSInteger)index;

- (void)singingAction;

@end


