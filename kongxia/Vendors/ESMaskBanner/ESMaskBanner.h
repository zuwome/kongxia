//
//  ESMaskBanner.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCycleScroll.h"

/**
 *  仿转转首页banner
 */
@interface ESMaskBanner : UIView

@property (nonatomic, assign) CGFloat bannerMarginTop;              //轮播图据banner顶部距离

@property (nonatomic, assign) BOOL showPageControl;                 //是否显示pageControl

@property (nonatomic, strong) UIImage *pageControlSelectImage;      //pageControl选中时的图片

@property (nonatomic, strong) UIImage *pageControlUnselectImage;    //pageControl未选中时的图片

@property (nonatomic, strong) UIColor *pageControlSelectColor;      //pageControl选中颜色

@property (nonatomic, strong) UIColor *pageControlUnselectColor;    //pageControl未选择颜色

@property (nonatomic, copy) void(^didClickBannerAtIndex)(NSInteger index);  //点击banner

//目前还没做区分，默认无限轮播
@property (nonatomic, assign) BOOL isInfinity;                      //是否无限轮播
//datasource
@property (nonatomic, strong) NSArray *bannerArray;

@end
