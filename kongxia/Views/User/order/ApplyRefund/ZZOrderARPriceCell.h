//
//  ZZOrderARPriceCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZOrder.h"
@interface ZZOrderARPriceCell : UITableViewCell

/**
 最多退款
 */
@property(nonatomic,strong) UITextField *priceTF;


/**
 退款金的显示

 @param order 订单的详情
 @param showInput 是否显示自定义的输入
 @param responsible 责任人是否是用户本身
 @percent 佣金系数,退款的时候使用
 */
- (void)setOrder:(ZZOrder *)order showInputMoney:(BOOL) showInput  responsible:(BOOL)responsible percent:( double)percent;
@end
