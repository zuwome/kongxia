//
//  ZZCheckWXView.h
//  zuwome
//
//  Created by YuTianLong on 2017/10/19.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZCheckWXView : UIView

- (void)show:(BOOL)animated;

- (void)dismiss;

@property (nonatomic, copy) NSString *wxNumber; //微信号

@property (nonatomic, copy) void (^copyWXBlock)(void); //复制微信号操作

@property (nonatomic, copy) void (^doneBlock)(void);// 我知道了

@end
