//
//  ZZChatBaseModel.h
//  zuwome
//
//  Created by angBiu on 16/10/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>

@interface ZZChatBaseModel : NSObject

@property (nonatomic, strong) RCMessage *message;//数据
@property (nonatomic, assign) BOOL showTime;//是否显示时间
@property (nonatomic, assign) NSInteger count;//阅后即焚倒计时
@property (nonatomic, assign) float cellHeight;//当前的cell的高度

// 本地自定义的cell
@property (nonatomic, copy) NSString *userModifyIdentifer;

@property (nonatomic, strong) id info;

- (BOOL)isPassRevokeTime;

@end
