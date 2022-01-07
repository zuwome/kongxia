//
//  ZZCircleProgressView.h
//  zuwome
//
//  Created by angBiu on 2017/5/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBlock)(void);

/**
 仿支付宝 支付的圆形动画
 */
@interface ZZCircleProgressView : UIView

- (void)start;
- (void)success:(successBlock)success;
- (void)failure;

@end
