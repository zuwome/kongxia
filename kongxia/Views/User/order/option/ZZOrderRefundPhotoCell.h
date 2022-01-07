//
//  ZZOrderRefundPhotoCell.h
//  zuwome
//
//  Created by angBiu on 16/9/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  订单退款 --- 选择图片cell
 */
@interface ZZOrderRefundPhotoCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) void(^touchImage)(NSInteger index);
@property (nonatomic, copy) dispatch_block_t touchAdd;

- (void)setData:(NSMutableArray *)imgArray;

@end
