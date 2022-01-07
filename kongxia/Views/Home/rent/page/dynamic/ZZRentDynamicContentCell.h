//
//  ZZRentDynamicContentCell.h
//  zuwome
//
//  Created by angBiu on 2017/2/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMessageAttentDynamicModel.h"

@interface ZZRentDynamicContentCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *statusImgView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) dispatch_block_t touchStatus;
@property (nonatomic, copy) void(^userSelectIndex)(NSInteger index);
@property (nonatomic, copy) void(^mmdSelectIndex)(NSInteger index);
@property (nonatomic, copy) void(^skSelectIndex)(NSInteger index);

- (void)setData:(ZZMessageAttentDynamicModel *)model;

@end
