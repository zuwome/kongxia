//
//  ZZDayTaskCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZIntegralModel.h"

/**
  日常任务
 */
@interface ZZDayTaskCell : UITableViewCell
@property (nonatomic,strong) ZZIntegralModel *model;
@property (nonatomic,copy) void(^gotoComplete)(ZZIntegralTaskModel *cellModel);


@end
