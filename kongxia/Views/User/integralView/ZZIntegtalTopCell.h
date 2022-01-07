//
//  ZZIntegtalTopCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZIntegralModel.h"

/**
 我的积分的顶部cell
 */
@interface ZZIntegtalTopCell : UITableViewCell

@property (nonatomic,strong) ZZIntegralModel *model;
/**
 总的积分
 */
@property (nonatomic,strong) UILabel *integralLab;
/**
 规则说明的点击事件
 */
@property(nonatomic,copy)  dispatch_block_t  ruleBlock;
/**
签到成功的返回
 */
@property(nonatomic,copy)  void(^signInBlock)(ZZIntegralModel *model);
@end
