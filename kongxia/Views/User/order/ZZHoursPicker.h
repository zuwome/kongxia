//
//  ZZHoursPicker.h
//  zuwome
//
//  Created by angBiu on 2017/2/27.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZHoursPicker;

@protocol ZZHoursPickerDelegate <NSObject>

- (void)ZZHoursPicker:(ZZHoursPicker *)pickView didSelectedString:(NSString *)selectedSting index:(NSInteger)index;

@end

/**
 *  预约 小时选择器
 */
@interface ZZHoursPicker : UIView

@property (nonatomic, weak) id<ZZHoursPickerDelegate>delegate;

- (void)showViews:(NSInteger)index;

@end
