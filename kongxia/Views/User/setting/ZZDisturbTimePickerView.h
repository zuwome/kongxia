//
//  ZZDisturbTimePickerView.h
//  zuwome
//
//  Created by angBiu on 2017/5/16.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZDisturbTimePickerView : UIView

- (void)show:(NSString *)timeString;

@property (nonatomic, copy) void(^chooseTime)(NSString *showString);

@end
