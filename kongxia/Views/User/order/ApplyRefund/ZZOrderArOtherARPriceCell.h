//
//  ZZOrderArOtherARPriceCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/29.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZOrderARBaseCell.h"
/**
 其他的退款理由
 */
@interface ZZOrderArOtherARPriceCell : ZZOrderARBaseCell

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,copy)  void(^selecetBlock)(ZZOrderArOtherARPriceCell *cell) ;

@end
