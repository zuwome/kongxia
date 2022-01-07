//
//  ZZTaskTimeView.h
//  zuwome
//
//  Created by angBiu on 2017/8/5.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTaskTimeView;

@protocol ZZTaskTimeViewDelegate <NSObject>

/*
 *  selectedSting   具体时间
 *  hour            小时
 *  selectDate      今天、明天、后天
 */
- (void)timeView:(ZZTaskTimeView *)timeView didSelectedString:(NSString *)selectedSting hour:(NSInteger)hour selectDate:(NSString *)selectDate;

@end

@interface ZZTaskTimeView : UIView

@property (nonatomic, assign) BOOL showDate;
@property (nonatomic, weak) id<ZZTaskTimeViewDelegate>delegate;

- (void)showDatePickerWithDate:(NSDate *)date hour:(NSInteger)hourCount;

@end
