//
//  ZZSignEditViewController.h
//  zuwome
//
//  Created by angBiu on 16/5/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"

@class ZZSkillTag;
typedef NS_ENUM(NSInteger,SignEditType) {
    SignEditTypeSkill = 0,  //技能文字介绍
    SignEditTypeSign        //个人介绍
};

/**
 修改签名
 */
@interface ZZSignEditViewController : ZZViewController

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *valueString;
@property (nonatomic, assign) NSInteger limitNumber;
@property (nonatomic, assign) SignEditType signEditType;
@property (nonatomic, copy) void(^callBackBlock)(NSString *value, BOOL isTimeout, NSInteger errorCode);
@property (nonatomic, copy) void(^changeSkillsBlock)(NSArray<ZZSkillTag *> *skills);

@property (nonatomic, copy) NSString *sid;          //获取技能示例时需要
@property (nonatomic, copy) NSString *skillName;    //技能名称
@property (nonatomic, copy) NSArray<ZZSkillTag *>  *skills;

@end
