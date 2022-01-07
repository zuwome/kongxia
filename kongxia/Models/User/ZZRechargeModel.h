//
//  ZZRechargeModel.h
//  zuwome
//
//  Created by angBiu on 2016/10/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ZZRechargeModel : JSONModel

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *rechargeID;

- (void)rechargeWithParam:(NSDictionary *)param next:(requestCallback)next;

@end
