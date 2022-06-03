//
//  ZZEarnedCoinView.h
//  zuwome
//
//  Created by qiming xiao on 2019/6/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZZEarnedCoinView : UIView

+ (ZZEarnedCoinView *)createViewWithTotalIncome:(NSString *)income;

- (instancetype)initWithFrame:(CGRect)frame textWidth:(CGFloat)textWidth income:(NSString *)income;

- (void)earnedIncom:(NSString *)income;

- (void)stopAnimation;

- (void)startAnimation;

@end
