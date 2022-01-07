//
//  ZZDayTaskDetailCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/21.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZIntegralTaskModel.h"
/**
 每日账号详情
 */
@interface ZZDayTaskDetailCell : UITableViewCell

/**
 每日任务
 */
@property (nonatomic,strong) ZZIntegralTaskModel *dayTaskModel;

/**
 去完成任务的点击事件
 */
@property(nonatomic,copy) void(^gotoCompleteBlock)(ZZIntegralTaskModel *cellModel);


@end
