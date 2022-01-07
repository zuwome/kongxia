//
//  ZZTopicNavigationView.h
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTopicDetailNavigationView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat percent;

@property (nonatomic, copy) dispatch_block_t touchLeft;
@property (nonatomic, copy) dispatch_block_t touchRight;

@end
