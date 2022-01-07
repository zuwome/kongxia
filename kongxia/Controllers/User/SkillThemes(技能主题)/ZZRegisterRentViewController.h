//
//  ZZRegisterRentViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

typedef NS_ENUM(NSInteger, RentType) {
    RentTypeRegister = 0,   //申请出租入口
    RentTypeComplete        //申请出租完成
};

/**
 *  出租达人申请、申请完成界面
 */
@interface ZZRegisterRentViewController : ZZViewController

@property (nonatomic, copy) void(^registerRentCallback)(NSDictionary *iDict);
@property (nonatomic, assign) RentType type;
@property (nonatomic, copy) NSString *addType;  //申请完成类型 ‘apply’ 申请达人， ‘add’ 添加主题，‘edit’ 编辑主题


@end
