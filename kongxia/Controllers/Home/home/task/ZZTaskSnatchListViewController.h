//
//  ZZTaskSnatchListViewController.h
//  zuwome
//
//  Created by angBiu on 2017/8/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZSnatchModel.h"

/**
 线下任务抢单人列表
 */
@interface ZZTaskSnatchListViewController : ZZViewController

@property (nonatomic, assign) BOOL fromPublish;
@property (nonatomic, strong) ZZSnatchDetailModel *snatchModel;

@property (nonatomic, assign) NSInteger validate_count;
@property (nonatomic, assign) NSInteger totalDuring;

@end
