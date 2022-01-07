//
//  ZZOrderRefuseReasonCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderARBaseCell.h"

/**
 达人拒绝退款的理由
 */
@interface ZZOrderRefuseReasonCell : ZZOrderARBaseCell
/**
 选中的点击事件
 */
@property (nonatomic,copy)  void(^selecetBlock)(ZZOrderRefuseReasonCell *cell) ;
@property (nonatomic,strong) UITextView *textView;

@end
