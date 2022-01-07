//
//  ZZRentMemedaViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZMemedaModel.h"
/**
 *  他的么么答界面
 */
@interface ZZRentMemedaViewController : ZZViewController

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) NSInteger popIndex;//1、个人页 2、查看视频 3、聊天
@property (nonatomic, assign) BOOL isPrivate;
@property (nonatomic, assign) BOOL fromChat;

@property (nonatomic, copy) void(^askCallBack)(NSString *content,NSString *mid,BOOL inYellow);

@end
