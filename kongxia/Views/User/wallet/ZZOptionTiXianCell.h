//
//  ZZOptionTiXianCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZTiXianBaseCell.h"

/**
 选择提现方式
 */
@interface ZZOptionTiXianCell : ZZTiXianBaseCell

@property (nonatomic,strong) UIButton *lastSelectButton;

/**
 当前的用户选择的提现方式
 */
@property(nonatomic,copy) void  (^goTiXianBlock)(NSString *tiXianType);
@end
