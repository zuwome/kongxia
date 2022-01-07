//
//  ZZOrderARSelectButtonCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZOrderOptionModel.h"
#import "ZZOrderARBaseCell.h"

@class ZZOrderARSelectButtonCell;
/**
 订单退款选择理由的界面
 */
@interface ZZOrderARSelectButtonCell : ZZOrderARBaseCell




@property(nonatomic,strong) ZZOrderOptionModel *model;
/**
 选中的点击事件
 */
@property (nonatomic,copy)  void(^selecetBlock)(ZZOrderARSelectButtonCell *cell) ;
@end
