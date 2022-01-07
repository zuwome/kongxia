//
//  ZZReportTitleCell.h
//  zuwome
//
//  Created by angBiu on 2016/12/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZReportTitleCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *lineView;

- (void)setIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index array:(NSArray *)array;

@end
