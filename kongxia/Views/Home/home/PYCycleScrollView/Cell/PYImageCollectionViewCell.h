//
//  PYImageCollectionViewCell.h
//  testOne
//
//  Created by 潘杨 on 2017/12/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYCycleItemModel.h"

/**
只有图片
 */
@interface PYImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) PYCycleItemModel *model;

@end
