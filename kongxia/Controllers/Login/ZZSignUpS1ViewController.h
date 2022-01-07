//
//  ZZSignUpS1ViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZSignUpS1ViewController : ZZViewController

@property (strong, nonatomic) ZZUser *user;
@property (strong, nonatomic) NSString *phoneString;
@property (strong, nonatomic) NSString *codeString;
@property (assign, nonatomic) BOOL isUpdatePhone;//是否是公众号手机更新接口
@property (nonatomic, assign) BOOL isFromAliAuthen;
@end
