//
//  ZZRentDropdownCell.h
//  zuwome
//
//  Created by angBiu on 16/6/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZRentDropdownCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *clearImgView;
@property (nonatomic, strong) UIView *seperateLine;
@property (nonatomic, copy) dispatch_block_t touchClear;

@end
