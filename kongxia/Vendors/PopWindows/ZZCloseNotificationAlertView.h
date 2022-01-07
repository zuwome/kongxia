//
//  ZZCloseNotificationAlertView.h
//  zuwome
//
//  Created by YuTianLong on 2017/11/23.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZCloseNotificationAlertView : UIView

@property (nonatomic, copy) void (^doneBlock)(void);
@property (nonatomic, copy) void (^cancelBlock)(void);

@end
