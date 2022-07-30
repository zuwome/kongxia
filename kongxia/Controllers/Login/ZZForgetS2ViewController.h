//
//  ZZForgetS2ViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZForgetS2ViewController : ZZViewController

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *codeString;

@property (nonatomic, assign) BOOL shouldVerifyFace;

- (instancetype)initWithShouldVerifyFace:(BOOL)shouldVerifyFace;

@end
