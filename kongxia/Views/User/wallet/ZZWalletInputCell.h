//
//  ZZWalletInputCell.h
//  zuwome
//
//  Created by angBiu on 16/10/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  提现 ， 充值 -- 输入框cell
 */
@interface ZZWalletInputCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) void(^moneyChanged)(NSString *money);

@end
