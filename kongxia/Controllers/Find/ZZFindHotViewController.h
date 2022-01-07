//
//  ZZFindHotViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZFindVideoModel.h"
#import "XRWaterfallLayout.h"

/**
 *  发现最热
 */
@interface ZZFindHotViewController : ZZViewController

@property (nonatomic, strong) UICollectionView *collectionView;//显示视频的
//@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) XRWaterfallLayout *waterfall;
@property (nonatomic, assign) BOOL update;//是否需要更新
@property (nonatomic, copy) void(^didScroll)(CGFloat offset);
@property (nonatomic, copy) void(^didScrollStatus)(BOOL isShow);
@property (nonatomic, copy) dispatch_block_t pushCallBack;
@property (nonatomic, copy) void(^selectItem)(ZZTopicGroupModel *model);
@property (nonatomic, copy) dispatch_block_t didEndScroll;
@property (nonatomic, copy) dispatch_block_t didStartScroll;


@end
