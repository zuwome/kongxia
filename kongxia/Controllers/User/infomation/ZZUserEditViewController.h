//
//  ZZUserEditViewController.h
//  zuwome
//
//  Created by angBiu on 2017/3/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"

/**
 资料编辑页
 */
@interface ZZUserEditViewController : ZZViewController

@property (nonatomic, assign) BOOL gotoRootCtl;//pop时 是否回到 我 页面
@property (nonatomic, assign) BOOL gotoUserPage;//pop 时 是否回到 我的个人详情页
@property (nonatomic, assign) ShowHUDType showType;
@property (nonatomic, copy) dispatch_block_t editCallBack;

@end
