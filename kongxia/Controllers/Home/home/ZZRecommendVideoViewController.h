//
//  ZZRecommendVideoViewController.h
//  zuwome
//
//  Created by angBiu on 2017/3/22.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"

/**
 推荐视频
 */
@interface ZZRecommendVideoViewController : ZZViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^requestNewData)(NSMutableArray *array);
@property (nonatomic, copy) void(^didScroll)(CGFloat offset);
@property (nonatomic, copy) void(^didScrollStatus)(BOOL isShow);

@end
