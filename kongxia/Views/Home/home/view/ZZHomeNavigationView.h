//
//  ZZHomeNavigationView.h
//  zuwome
//
//  Created by angBiu on 16/7/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHomeTitleLabel.h"
#import "ZZHomeModel.h"
/**
 *  首页导航栏的view
 */
@interface ZZHomeNavigationView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *leftBgView;
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, assign) BOOL showRedPoint;

@property (nonatomic, copy) dispatch_block_t touchLeft;
@property (nonatomic, copy) dispatch_block_t touchRight;

@property (nonatomic, copy) void(^selctedIndex)(NSInteger index);

- (void)setCityName:(NSString *)cityName;

@end
