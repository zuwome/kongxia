//
//  ZZPayRecordCalendars.h
//  zuwome
//
//  Created by 潘杨 on 2018/1/3.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//钱包日历

#import <UIKit/UIKit.h>
@interface ZZPayRecordCalendars : UIView
singleton_interface(ZZPayRecordCalendars)


- (void)dissMiss;
+ (void)timeChoosePickerViewShowWithNSArray:(NSArray *)array showView:(UIView *)showView completionSureBlock:(void(^)(NSString *chooseTime,NSString *yearStr,NSString *monthStr))sureBlock completionCanceBlock:(void(^)(NSString *chooseTime))cancelBtnClick ;
@end
