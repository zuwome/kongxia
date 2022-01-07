//
//  ZZSignUpCityViewController.h
//  zuwome
//
//  Created by angBiu on 2016/11/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  注册-----选择城市
 */
@interface ZZInternationalCityViewController : ZZViewController

@property (nonatomic, copy) void(^selectedCode)(NSString *code);

@end
