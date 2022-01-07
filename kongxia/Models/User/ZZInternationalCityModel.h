//
//  ZZInternationalCityModel.h
//  zuwome
//
//  Created by angBiu on 2016/11/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZInternationalCityModel : JSONModel

@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;

+ (void)getInternationalCityList:(requestCallback)next;

@end
