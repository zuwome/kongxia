//
//  ZZHomeStatusView.h
//  zuwome
//
//  Created by angBiu on 16/9/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 首页 -- 飞机 新人标志
 */
@interface ZZHomeStatusView : UIView

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *statusImgView;

- (void)setUser:(ZZUser *)user type:(NSInteger)type;

@end
