//
//  ZZCornerRadiuImageView.h
//  zuwome
//
//  Created by 潘杨 on 2017/12/1.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//重写圆形加V头像

#import <UIKit/UIKit.h>

@interface ZZCornerRadiuImageView : UIView
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *vImgView;
@property (nonatomic, assign) BOOL isAnonymous;//匿名头像

@property (nonatomic, copy) dispatch_block_t touchHead;
- (instancetype)initWithFrame:(CGRect)frame headerImageWidth:(CGFloat)width;

- (void)setUser:(ZZUser *)user width:(CGFloat)width vWidth:(CGFloat)vWidth;
@end
