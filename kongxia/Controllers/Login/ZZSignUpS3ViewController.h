//
//  ZZSignUpS3ViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZSignUpS3ViewController : ZZViewController

@property (strong, nonatomic) ZZUser *user;
@property (strong, nonatomic) NSString *code;// 密码
@property (strong, nonatomic) NSString *countryCode;// 手机区号 +86
@property (strong, nonatomic) NSMutableArray *faces;// 人脸识别返回的 bestImage、envImage
@property (assign, nonatomic) BOOL isPush;//跳转动作是否是push
@property (assign, nonatomic) BOOL isUpdatePhone;//是否是公众号手机更新接口
@property (assign, nonatomic) BOOL isSkipRecognition;//是否跳过人脸识别

@property (assign, nonatomic) BOOL isQuickLogin;//快速登录过来
@property (strong, nonatomic) NSString *quickLoginToken;
@property (assign, nonatomic) BOOL fromSignUp;//注册过来

@end
