//
//  ZZRentDynamicContributionView.h
//  zuwome
//
//  Created by angBiu on 16/8/9.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSKModel.h"
/**
 *  他人页动态悬赏贡献榜
 */
@interface ZZRentDynamicContributionView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIImageView *firImgView;
@property (nonatomic, strong) UIImageView *secImgView;
@property (nonatomic, strong) UIImageView *thiImgView;
@property (nonatomic, copy) dispatch_block_t touchContribution;

- (void)setTips:(NSArray *)array;

@end
