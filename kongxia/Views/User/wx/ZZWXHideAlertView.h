//
//  ZZWXHideAlertView.h
//  zuwome
//
//  Created by angBiu on 2017/6/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 隐藏微信的弹窗
 */
@interface ZZWXHideAlertView : UIView

@property (nonatomic, copy) dispatch_block_t touchSure;
@property (nonatomic, copy) dispatch_block_t touchEidt;

@end
