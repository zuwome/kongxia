//
//  ZZNotNetEmptyView.h
//  zuwome
//
//  Created by 潘杨 on 2018/5/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 无网络的情况下的占位图,默认为隐藏
 */
@interface ZZNotNetEmptyView : UIView

/**
 用于没网情况下显示网络占位图的

 @param title 显示的文字
 @param imageName 显示的图片名
 @param frame 显示的frame
 @param viewController 当前的视图控制器
 */
+ (ZZNotNetEmptyView *)showNotNetWorKEmptyViewWithTitle:(NSString *)title imageName:(NSString *)imageName frame:(CGRect)frame viewController:(UIViewController *)viewController;
@end
