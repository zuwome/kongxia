//
//  ZZDatePicker.h
//  zuwome
//
//  Created by angBiu on 16/5/31.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZDatePicker;
/**
 *  预约 时间选择器
 */
@interface ZZDateModel : NSObject

@property (nonatomic, strong) NSString *timeString;//实际时间
@property (nonatomic, strong) NSString *showString;//展示的string 例:今天、明天 et；

@end

@protocol ZZDatePickerDelegate <NSObject>

- (void)ZZDatePicker:(ZZDatePicker *)pickView didSelectedString:(NSString *)selectedSting selectDate:(NSString *)selectDate index:(NSInteger)index;

@end

@interface ZZDatePicker : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

- (void)showDatePickerWithDate:(NSDate *)date;

@property (nonatomic, assign) BOOL showDate;
@property (nonatomic, weak) id<ZZDatePickerDelegate>delegate;

@end
