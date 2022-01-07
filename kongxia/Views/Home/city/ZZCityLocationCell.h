//
//  ZZCityLocationCell.h
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  首页城市 定位
 */
@interface ZZCityLocationCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) dispatch_block_t selectCity;

@end
