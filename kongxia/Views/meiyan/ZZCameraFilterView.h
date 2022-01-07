//
//  ZZFilterView.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSlider.h"
#import "ZZBeautyManager.h"

@class CameraFilterView;
@class ZZCameraFilterView;


@protocol ZZCameraFilterViewDelegate <NSObject>

- (void)view:(ZZCameraFilterView *)view fileterType:(FilterType)type value:(CGFloat)value;

- (void)view:(ZZCameraFilterView *)view filterOptions:(AgoraBeautyOptions *)options;
@end

@interface ZZCameraFilterView : UIView

@property (nonatomic, weak) id<ZZCameraFilterViewDelegate> delegate;

+ (instancetype)show;

- (void)hide;
@end

@interface CameraFilterView : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel     *titleLabel;

@property (nonatomic, strong) UIImageView *whiteningwImageView;

@property (nonatomic, strong) UILabel     *whiteningLabel;

@property (nonatomic, strong) UIImageView *mopiImageview;

@property (nonatomic, strong) UILabel     *mopiLabel;

@property (nonatomic, strong) UIImageView *rosyImageView;

@property (nonatomic, strong) UILabel     *rosyLabel;

@property (nonatomic, strong) ZZSlider *whiteningSlider;

@property (nonatomic, strong) ZZSlider *mopiSlider;

@property (nonatomic, strong) ZZSlider *rosySlider;
@end
