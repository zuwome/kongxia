//
//  ZZRentDynamicTextCell.h
//  zuwome
//
//  Created by angBiu on 2017/2/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMessageAttentDynamicModel.h"

@interface ZZRentDynamicTextCell : UITableViewCell

@property (nonatomic, strong) UIImageView *typeImgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)setData:(ZZMessageAttentDynamicModel *)model;

@end
