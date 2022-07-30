//
//  ZZForgetS1ViewController.h
//  zuwome
//
//  Created by wlsy on 16/1/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZForgetS1ViewController : ZZViewController

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) BOOL shouldVerifyFace;

- (instancetype)initWithShouldVerifyFace:(BOOL)shouldVerifyFace;

@end
