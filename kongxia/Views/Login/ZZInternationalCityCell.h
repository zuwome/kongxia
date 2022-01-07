//
//  ZZSignUpCityCell.h
//  zuwome
//
//  Created by angBiu on 2016/11/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZInternationalCityModel.h"

@interface ZZInternationalCityCell : UITableViewCell

@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *codeLabel;

- (void)setData:(ZZInternationalCityModel *)model;

@end
