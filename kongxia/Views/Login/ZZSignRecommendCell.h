//
//  ZZSignRecommendCell.h
//  zuwome
//
//  Created by angBiu on 2017/6/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZSignRecommendCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *coverView;

- (void)setData:(ZZUser *)user;

@end
