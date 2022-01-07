//
//  ZZIntegralNewCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZIntegralTaskModel.h"
/**
 新手任务的cell
 */
@interface ZZIntegralNewCell : UICollectionViewCell
@property (nonatomic,strong) ZZIntegralTaskModel *model;
@property (nonatomic,copy) void(^goToComplete)(ZZIntegralNewCell *cell) ;
/**
 更新完成状态
 */
- (void)updateStateWithState:(int) state;
@end
