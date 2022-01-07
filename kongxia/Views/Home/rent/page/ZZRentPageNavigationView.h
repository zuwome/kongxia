//
//  ZZRentPageNavigationView.h
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  他人页导航栏
 */
@interface ZZRentPageNavigationView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) UIViewController *ctl;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, copy) dispatch_block_t touchLeftBtn;
@property (nonatomic, copy) dispatch_block_t touchRightBtn;

@end
