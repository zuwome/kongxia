//
//  PYCycleScrollView.h
//  testOne
//
//  Created by 潘杨 on 2017/12/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYCycleItemModel.h"
@class PYCycleScrollView ;

@protocol PYCycleScrollViewDelegate <NSObject>
@optional
/** 点击图片回调 */
- (void)cycleScrollView:(PYCycleScrollView *)cycleScrollView didSelectItemModel:(PYCycleItemModel *)model ;

@end
@interface PYCycleScrollView : UIView

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
/**是否无限循环轮播*/
@property (nonatomic, assign)  BOOL loop;
@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
/**
 服务器返回model的数组
 */
@property (nonatomic, strong) NSArray *modelArray;
/**轮播的数组*/
@property (nonatomic, strong) NSMutableArray *roastingArray;

/**自动轮播时间间隔，默认为0，0表示不开启自动轮播*/
@property (nonatomic, assign)  NSTimeInterval automaticallyScrollDuration;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame ;
//////////////////////  清除缓存API  //////////////////////

///** 清除图片缓存（此次升级后统一使用SDWebImage管理图片加载和缓存）  */
//+ (void)clearImagesCache;
/**代理*/
@property (weak, nonatomic) id<PYCycleScrollViewDelegate> delegate;
- (void)adjustWhenControllerViewWillAppera;

@end
