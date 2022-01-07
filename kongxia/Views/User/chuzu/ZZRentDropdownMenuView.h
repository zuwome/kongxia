//
//  ZZRentDropdownMenuView.h
//  zuwome
//
//  Created by angBiu on 16/6/15.
//  Copyright © 2016年 zz. All rights reserved.
//
/**
 *  选择地址下拉历史列表
 */
#import <UIKit/UIKit.h>
@class ZZRentDropdownModel;

@protocol ZZRentDropdownMenuDelegate <NSObject>

- (void)selectLocation:(ZZRentDropdownModel *)model;

@end

@interface ZZRentDropdownMenuView : UIView 

@property (nonatomic, weak) id<ZZRentDropdownMenuDelegate>delegate;

@property (nonatomic, strong) ZZUser *user;

- (instancetype)initWithFrame:(CGRect)frame user:(ZZUser *)user;

@end

@interface ZZRentDropdownMyLocationView : UIView

@property (nonatomic, assign) double totalWidth;

- (void)configureTitle:(NSString *)title distance:(double)distance;

@end
