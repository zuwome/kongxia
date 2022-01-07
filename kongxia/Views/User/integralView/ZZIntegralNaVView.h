//
//  ZZIntegralNaVView.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/14.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 积分自定义导航
 */
@interface ZZIntegralNaVView : UIView

/**
 左侧的导航点击事件
 */
@property (nonatomic,copy) dispatch_block_t leftNavClickBlock;
/**
 右侧的导航点击事件
 */
@property (nonatomic,copy) dispatch_block_t rightNavClickBlock;


/**
 创建含有右侧导航点击事件的导航

 注* 默认含有左侧导航
 @param titleNavLabTitile 导航的name
 @param rightTitle 右侧的name
 */
- (instancetype)initWithFrame:(CGRect)frame  titleNavLabTitile:(NSString *)titleNavLabTitile rightTitle:(NSString *)rightTitle ;
@end
