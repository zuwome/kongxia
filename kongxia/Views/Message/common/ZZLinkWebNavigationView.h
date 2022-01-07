//
//  ZZLinkWebNavigationView.h
//  zuwome
//
//  Created by angBiu on 2017/3/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLinkWebNavigationView : UIView

@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIImageView *rightImgView;

@property (nonatomic, copy) dispatch_block_t touchLeft;
@property (nonatomic, copy) dispatch_block_t touchRight;

- (void)setViewAlphaScale:(CGFloat)scale;

@end
