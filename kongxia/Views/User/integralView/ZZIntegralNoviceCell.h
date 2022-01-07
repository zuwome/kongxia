//
//  ZZIntegralNoviceCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZIntegralModel.h"
#import "ZZIntegralNewCell.h"

/**
  积分 - 新手任务
 */
@interface ZZIntegralNoviceCell : UITableViewCell

@property (nonatomic,strong) ZZIntegralModel *model;
@property (nonatomic,copy) void(^goToComplete)(ZZIntegralTaskModel *modelCell,ZZIntegralNewCell *currentCell) ;

@end
