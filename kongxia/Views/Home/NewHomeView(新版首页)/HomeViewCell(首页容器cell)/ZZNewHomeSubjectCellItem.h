//
//  ZZNewHomeSubjectCellItem.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/21.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHomeModel.h"

@interface ZZNewHomeSubjectCellItem : UIView

@property (nonatomic, weak) ZZHomeSpecialTopicModel *model;

@property (nonatomic, assign) CGFloat cornerRadio;

@property (nonatomic, assign) BOOL showVideoIcon;

@property (nonatomic, assign) BOOL isPlaying;   //视频是否正在播放

@property (nonatomic, copy) void(^specialTopicCallback)(ZZHomeSpecialTopicModel *model);

- (BOOL)isVideo;

- (void)videoPlay;

- (void)videoStop;

@end
