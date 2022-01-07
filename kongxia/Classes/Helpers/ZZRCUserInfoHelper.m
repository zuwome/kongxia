//
//  ZZRCUserInfoHelper.m
//  zuwome
//
//  Created by angBiu on 16/9/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRCUserInfoHelper.h"

#import <RongIMKit/RongIMKit.h>

@implementation ZZRCUserInfoHelper

+ (void)setUserInfo:(ZZUser *)user
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = user.uid;
    userInfo.name = user.nickname;
    userInfo.portraitUri = user.avatar;
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:user.uid];
}

@end
