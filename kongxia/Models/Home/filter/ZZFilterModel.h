//
//  ZZFilterModel.h
//  zuwome
//
//  Created by angBiu on 16/8/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZFilterModel : JSONModel

@property (nonatomic, strong) NSString *sexTypeStr;
@property (nonatomic, strong) NSString *ageStr;
@property (nonatomic, strong) NSString *heightStr;
@property (nonatomic, strong) NSString *weightStr;
@property (nonatomic, strong) NSString *moneyStr;
@property (nonatomic, strong) NSMutableArray *timeArray;

@end
