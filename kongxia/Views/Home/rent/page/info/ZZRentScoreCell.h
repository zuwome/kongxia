//
//  ZZRentScoreCell.h
//  zuwome
//
//  Created by angBiu on 2017/4/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZRentScoreCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UIView *gradientLineView;
@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat width;

@end
