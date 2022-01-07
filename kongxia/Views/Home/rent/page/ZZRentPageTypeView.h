//
//  ZZRentPageTypeView.h
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  他人页类别
 */
@interface ZZRentPageTypeView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;//底下那条线
@property (nonatomic, assign) NSInteger videoCount;
@property (nonatomic, copy) void(^selectType)(NSInteger index);

- (void)setSelectIndex:(NSInteger)index;
- (void)setLineOffset:(CGFloat)offset;

@end
