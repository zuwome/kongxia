//
//  ZZVideoHelper.h
//  zuwome
//
//  Created by angBiu on 2017/7/29.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Authorized)(BOOL authorized);

@interface ZZVideoHelper : NSObject

+ (void)checkAuthority:(Authorized)authorized;
+ (void)checkCameraAuthority:(Authorized)authorized;
+ (void)checkAudioAuthority:(Authorized)authorized;

@end
