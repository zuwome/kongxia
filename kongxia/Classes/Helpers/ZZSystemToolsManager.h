//
//  ZZSystemToolsManager.h
//  zuwome
//
//  Created by YuTianLong on 2017/10/21.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "WBBaseManager.h"

#define GetSystemToolsManager()       ([ZZSystemToolsManager sharedInstance])

@interface ZZSystemToolsManager : WBBaseManager

// 系统通知是否已开启  NO:未开启
- (BOOL)isOpenSystemNotification;


// 是否有相册权限  NO:无权限
- (BOOL)isPhotoPermissions;


// 是否有相机权限  NO:无权限
- (BOOL)isCameraPermissions;


@end
