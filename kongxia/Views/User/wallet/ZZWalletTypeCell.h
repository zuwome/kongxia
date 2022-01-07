//
//  ZZWalletTypeCell.h
//  zuwome
//
//  Created by angBiu on 16/10/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  提现，充值 方式 cell
 */
@interface ZZWalletTypeCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *wxBtn;
@property (nonatomic, strong) UIButton *zfbBtn;

- (void)setViewToRight;

@property (nonatomic, copy) void(^selectedIndex)(NSInteger index);

@end
