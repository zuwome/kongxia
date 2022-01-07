//
//  ZZFindRecordProgressView.h
//  zuwome
//
//  Created by angBiu on 2017/5/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZRecordProgressView;

@protocol ZZRecordProgressViewDelegate <NSObject>

- (void)progressView:(ZZRecordProgressView *)progressView videoDurationLongEnough:(BOOL)enough;
- (void)videoReachMaxDuration;

@end

@interface ZZRecordProgressView : UIView

@property (nonatomic, assign) CGFloat maxDuration;//视频总得最长时长
@property (nonatomic, assign) CGFloat minDuration;//视频总得最短时长
@property (nonatomic, assign) CGFloat lastSumDuration;
@property (nonatomic, assign) CGFloat currentDuration;
@property (nonatomic, weak) id<ZZRecordProgressViewDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *timeArray;
/**
 隐藏
 
 @param isHiddenProgress YES 隐藏  NO  不隐藏
 */
- (void)isHiddenProgress:(BOOL)isHiddenProgress;
- (void)willRemoveLastVideo;
- (void)removeLastVideo;
- (void)removeAllVideo;

@end
