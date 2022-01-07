//
//  ZZColorCycleView.h
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZColorCycleView : UIView

@property (nonatomic, strong) CAShapeLayer *grayLayer;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat startProgress;
@property (nonatomic, assign) BOOL isColor;
@property (nonatomic, assign) BOOL animate;

@end
