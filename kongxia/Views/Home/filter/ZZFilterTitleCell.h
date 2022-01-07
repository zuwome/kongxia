//
//  ZZFilterTitleCell.h
//  zuwome
//
//  Created by angBiu on 16/8/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZFilterModel;

@interface ZZFilterTitleCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setData:(ZZFilterModel *)model indexPath:(NSIndexPath *)indexPath;

@end
