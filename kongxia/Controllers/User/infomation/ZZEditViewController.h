//
//  ZZEditViewController.h
//  zuwome
//
//  Created by angBiu on 16/5/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

typedef NS_ENUM(NSInteger,EditType) {
    EditTypeName                = 0,
    EditTypeJob
};

/**
 修改用户名
 */
@interface ZZEditViewController : ZZViewController

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *valueString;
@property (nonatomic, assign) NSInteger limitNumber;
@property (nonatomic, assign) EditType editType;
@property (nonatomic, assign) BOOL updateName;
@property (nonatomic, copy) void(^callBackBlock)(NSString *value);

@end
