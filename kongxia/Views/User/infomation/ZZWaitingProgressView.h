//
//  ZZWaitingProgressView.h
//  zuwome
//
//  Created by YuTianLong on 2017/11/21.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZWaitingProgressView : UIView

@property (nonatomic, strong) CAShapeLayer *grayLayer;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat startProgress;
@property (nonatomic, assign) BOOL isColor;
@property (nonatomic, assign) BOOL animate;

@end
