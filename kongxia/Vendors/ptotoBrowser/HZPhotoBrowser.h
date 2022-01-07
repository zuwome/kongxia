//
//  HZPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HZButton, HZPhotoBrowser;

@protocol HZPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

- (void)photoBrowser:(HZPhotoBrowser *)browser currentIndex:(NSInteger)index;

@end


@interface HZPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) UIView *currentView;
@property (nonatomic, weak) UIView *currentSuperView;
@property (nonatomic, assign) BOOL showAnimation;//超出显示范围不做动画渐渐消失

@property (nonatomic, weak) id<HZPhotoBrowserDelegate> delegate;

- (void)show;

@end
