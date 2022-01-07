//
//  ZZCity.h
//  zuwome
//
//  Created by wlsy on 16/1/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ZZRequest.h"
#import <MapKit/MapKit.h>

@interface ZZCity : JSONModel

@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *province; //!< 省/直辖市
@property (nonatomic, strong) NSString *name;     //!< 市
@property (nonatomic, strong) NSString *code; //!< 城市编码
@property (nonatomic, strong) NSString *center; //!< 城市编码
@property (nonatomic, assign) BOOL hot;
@property (nonatomic, strong) NSString *pinyinName;

- (void)list:(requestCallback)next;
@end
