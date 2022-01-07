//
//  ZZOrderCountDownView.h
//  zuwome
//
//  Created by angBiu on 2017/7/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZOrderCountDownView : UIView

@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;

@property (nonatomic, assign) long time;
@property (nonatomic, strong) UIColor *color;

@end
