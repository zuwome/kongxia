//
//  ZZRentTimeModel.h
//  zuwome
//
//  Created by angBiu on 2017/5/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZRentTimeModel : NSObject
//哪天的显示数据
@property (nonatomic, strong) NSString *dayString;
@property (nonatomic, strong) NSString *fullDayString;
@property (nonatomic, strong) NSString *weekString;
//具体时间段
@property (nonatomic, strong) NSString *showString;
@property (nonatomic, assign) int hour;
@property (nonatomic, assign) BOOL isQuick;
@end
