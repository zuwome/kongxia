//
//  ZZFillBankCell.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZTiXianBaseCell.h"

/**
 填写银行卡的cell
 */
@interface ZZFillBankCell : ZZTiXianBaseCell
@property (nonatomic,strong) UITextField *carNumberTextField;//银行卡详情输入框

/**
 持卡人姓名
 */
@property(nonatomic,strong) NSString *userName;
/**
 查看详情
 */
@property(nonatomic,strong) void (^detailClickBlock)(UIButton *sender);
@end
