//
//  ZZCapital.h
//  zuwome
//
//  Created by wlsy on 16/2/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZCapital : JSONModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *skill;
@property (strong, nonatomic) NSDate *created_at;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) NSString *content;

@end
