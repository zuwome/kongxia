//
//  ZZCodeSignViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  验证码登录
 */
@interface ZZCodeSignViewController : ZZViewController

@property (strong, nonatomic) NSString *phoneString;
@property (strong, nonatomic) NSString *codeString;
@property (assign, nonatomic) BOOL showInfo;
@property (nonatomic, assign) BOOL isFromAliAuthen;
@end
