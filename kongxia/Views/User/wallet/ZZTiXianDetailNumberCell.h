//
//  ZZTiXianDetailNumberCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZTiXianBaseCell.h"

/**
 提现的详细金额
 */
@interface ZZTiXianDetailNumberCell : ZZTiXianBaseCell

@property (nonatomic,strong)UITextField *tiXianTextField;

/**
 最多可提现额度
 */
@property (nonatomic,strong)NSString *maxMoneyNumber;

/**
 全部提现的点击事件
 */
@property (nonatomic,copy) dispatch_block_t allTiXianBlock;
@end

