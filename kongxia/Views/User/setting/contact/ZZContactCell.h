//
//  ZZContactCell.h
//  zuwome
//
//  Created by angBiu on 2016/10/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  设置 --- 屏蔽联系人 cell
 */
@interface ZZContactCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) dispatch_block_t touchStatus;

@end
