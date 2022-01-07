//
//  ZZReportBottomView.h
//  zuwome
//
//  Created by angBiu on 2016/12/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZReportBottomView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;

/**
 最多可选几张图片
 */
@property(nonatomic,assign) NSInteger selectMaxNumber;

@property (nonatomic, copy) void(^selectIndex)(NSInteger index);

@end
