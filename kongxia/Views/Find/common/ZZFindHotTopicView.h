//
//  ZZFindHotTopicView.h
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZTopicModel.h"

@interface ZZFindHotTopicView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) dispatch_block_t touchMore;
@property (nonatomic, copy) void(^selectItem)(ZZTopicModel *model);
@property (nonatomic, copy) dispatch_block_t didEndScroll;
@property (nonatomic, copy) dispatch_block_t didStartScroll;

@end
