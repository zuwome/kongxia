//
//  ZZTaskChooseViewController.h
//  zuwome
//
//  Created by angBiu on 2017/8/5.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZTaskChooseViewController : ZZViewController

@property (nonatomic, strong) NSString *skillId;
@property (nonatomic, copy) void(^selectedTask)(ZZSkill *skill);

@property (nonatomic, copy) void (^dismissBlock)(void);
@end
