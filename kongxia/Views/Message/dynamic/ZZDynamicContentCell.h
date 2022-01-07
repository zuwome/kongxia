//
//  ZZDynamicContentCell.h
//  zuwome
//
//  Created by angBiu on 2017/2/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMessageAttentDynamicModel.h"
#import "ZZDynamicRecomendView.h"

/**
 消息 --- 动态 关注的人或者么么答
 */
@interface ZZDynamicContentCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *statusImgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZZDynamicRecomendView *recommendView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) dispatch_block_t touchStatus;
@property (nonatomic, copy) dispatch_block_t touchHead;
@property (nonatomic, copy) void(^userSelectIndex)(NSInteger index);
@property (nonatomic, copy) void(^mmdSelectIndex)(NSInteger index);
@property (nonatomic, copy) void(^skSelectIndex)(NSInteger index);

- (void)setData:(ZZMessageAttentDynamicModel *)model;

@end
