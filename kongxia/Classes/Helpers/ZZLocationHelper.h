//
//  ZZLocationHelper.h
//  zuwome
//
//  Created by angBiu on 2017/1/12.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZLocationHelper : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *LocationManager;
@property (nonatomic, assign) BOOL haveGetLocation;

+ (instancetype)shareInstance;

- (void)getLocation;

@end
