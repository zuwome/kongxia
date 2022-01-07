//
//  ZZApplyUploadView.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/29.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 上传图片
 */
@interface ZZApplyUploadView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 最多可选几张图片
 */
@property(nonatomic,assign) NSInteger selectMaxNumber;

@property (nonatomic, copy) void(^selectIndex)(NSInteger index);

@end
