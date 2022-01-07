//
//  ZZPasswordSetViewController.h
//  zuwome
//
//  Created by angBiu on 2016/11/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  设置设置登录密码
 */
@interface ZZPasswordSetViewController : ZZViewController

@property (strong, nonatomic) ZZUser *user;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *countryCode;
@property (assign, nonatomic) BOOL isUpdatePhone;//是否是公众号手机更新接口
@property (assign, nonatomic) BOOL fromSignUp;//注册过来
@property (assign, nonatomic) BOOL isQuickLogin;//快速登录过来
@property (strong, nonatomic) NSString *quickLoginToken;

@property (nonatomic, assign) BOOL isFromAliAuthen;

@end
